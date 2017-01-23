package org.eclipse.m2m.atl.atlgt.launcher;

import org.eclipse.core.runtime.IProgressMonitor;
import org.eclipse.debug.core.ILaunch;
import org.eclipse.debug.core.ILaunchConfiguration;
import org.eclipse.debug.core.model.ILaunchConfigurationDelegate;
import org.eclipse.emf.common.util.URI;
import org.eclipse.m2m.atl.atlgt.atlidfier.AtlIdfierTransformationFactory;
import org.eclipse.m2m.atl.atlgt.core.Context;
import org.eclipse.m2m.atl.atlgt.core.Direction;
import org.eclipse.m2m.atl.atlgt.ecore2km3.EmfToKm3TransformationFactory;
import org.eclipse.m2m.atl.atlgt.tools.Commands;
import org.eclipse.m2m.atl.atlgt.util.Metamodels;
import org.eclipse.m2m.atl.atlgt.util.URIs;

import java.io.IOException;
import java.util.function.Function;
import java.util.stream.Collectors;
import java.util.stream.StreamSupport;

public class AtlGtLauncher implements ILaunchConfigurationDelegate {

    @Override
    public void launch(ILaunchConfiguration launchConfiguration, String mode, ILaunch launch, IProgressMonitor monitor) {
        // Loads the current context
        Context context = Context.from(launchConfiguration);

        // Register all metamodels
        context.metamodels().forEach(Metamodels::register);

        // Run transformation
        try {
            if (context.direction() == Direction.FORWARD) {
                forwardTransformation(context);
            }
            else {
                throw new UnsupportedOperationException("Backward transformation is not supported yet");
            }
        }
        catch (IOException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }

        System.out.println("ATL-GT: Successfully executed");
        System.out.println(context.tempDirectory());
    }

    public void forwardTransformation(Context context) throws IOException {

        /*
         * Step A: Metamodel processing
         */
        Function<Context, Void> metamodelProcessing = c -> {
            // A.1 Ecore to KM3
            Iterable<URI> km3Metamodels = StreamSupport.stream(c.metamodels().spliterator(), false)
                    .map(metamodel -> EmfToKm3TransformationFactory.withEmftvm().transform(metamodel, c.tempDirectory().appendSegment(URIs.filename(metamodel, ".km3"))))
                    .collect(Collectors.toList());

            // A.2 Ecore Relaxation
            Iterable<URI> relaxedMetamodels = StreamSupport.stream(c.metamodels().spliterator(), false)
                    .map(metamodel -> Metamodels.relax(metamodel, c.tempDirectory().appendSegment(URIs.filename(metamodel, "-relaxed.ecore"))))
                    .collect(Collectors.toList());

            // A.3 Relaxed Ecore to Relaxed KM3
            Iterable<URI> km3RelaxedMetamodels = StreamSupport.stream(relaxedMetamodels.spliterator(), false)
                    .map(metamodel -> EmfToKm3TransformationFactory.withEmftvm().transform(metamodel, c.tempDirectory().appendSegment(URIs.filename(metamodel, ".km3"))))
                    .collect(Collectors.toList());

            // A.4 KM3 to KM3 with IDs
            // Adding an optional attribute with name __xmiID__ and type String to each class
            km3Metamodels.forEach(Metamodels::identify);

            // A.5 Relaxed KM3 to Relaxed KM3 with IDs
            km3RelaxedMetamodels.forEach(Metamodels::identify);

            return null;
        };

        /*
         * Step B: Transformation processing.
         */
        Function<Context, Void> transformationProcessing = c -> {
            // B.1 ATLIDfier
            // Create a copy of the atl file
            URI atlModule = c.module().appendFileExtension("atl");
            URI idfiedAtlModule = c.tempDirectory().appendSegment(atlModule.lastSegment());
            URIs.copy(atlModule, idfiedAtlModule);

            // Run in-place transformation
            AtlIdfierTransformationFactory.withEmftvm().transform(idfiedAtlModule);

            // B.2 ATL2UNQL
            // TODO Improve URIs resolution
            Commands.atlGt().atlToUnql().execute(
                    "-atl", URIs.absolutePath(idfiedAtlModule), // hidden/ClassDiagram2Relational.atl
                    "-uq", URIs.absolutePath(c.tempDirectory().appendSegment(URIs.filename(c.module(), ".unql"))), // hidden/ClassDiagram2Relational.unql
                    "-ikm3", URIs.absolutePath(c.tempDirectory().appendSegment(URIs.filename(c.inMetamodel(), ".km3"))), // hidden/ClassDiagram.km3
                    "-ipkg", Metamodels.firstPackage(c.inMetamodel()).getName(), // ClassDiagram
                    "-okm3", URIs.absolutePath(c.tempDirectory().appendSegment(URIs.filename(c.outMetamodel(), "-relaxed.km3"))), // hidden/Relational-relaxed.km3
                    "-opkg", Metamodels.firstPackage(c.outMetamodel()).getName()); // Relational

            return null;
        };

        /*
         * Step C: Forward transformation
         */
        Function<Context, Void> forwardTransformation = c -> {
            // C.1 XMI2DOT (we choose the first package name but we support only one package)
            Commands.atlGt().xmiToDot().execute(
                    "-xmi", URIs.absolutePath(c.inModel()), // ClassDiagram/Sample-ClassDiagram.xmi
                    "-dot", URIs.absolutePath(c.tempDirectory().appendSegment(URIs.filename(c.inModel(), ".dot"))), // hidden/Sample-ClassDiagram.dot
                    "-km3", URIs.absolutePath(c.tempDirectory().appendSegment(URIs.filename(c.inMetamodel(), ".km3"))), // hidden/ClassDiagram.km3
                    "-pkg", Metamodels.firstPackage(c.inMetamodel()).getName());// ClassDiagram

            // C.2 Forward UnCAL
            Commands.gRoundTram().fwdUncal().execute(
                    "-ge", "-sb", "-cl", "-zn", "-fi", "-np", "-sa", "-t", "-rw", "-as",
                    "-db", URIs.absolutePath(c.tempDirectory().appendSegment(URIs.filename(c.inModel(), ".dot"))), // hidden/Sample-ClassDiagram.dot
                    "-uq", URIs.absolutePath(c.tempDirectory().appendSegment(URIs.filename(c.module(), ".unql"))), // hidden/ClassDiagram2Relational.unql
                    "-dot", URIs.absolutePath(c.tempDirectory().appendSegment(URIs.filename(c.module(), "-target.dot"))), // hidden/ClassDiagram2Relational-target.dot
                    "-xg", URIs.absolutePath(c.tempDirectory().appendSegment(URIs.filename(c.module(), ".xg"))), // hidden/ClassDiagram2Relational.xg
                    "-ei", URIs.absolutePath(c.tempDirectory().appendSegment(URIs.filename(c.module(), ".ei")))); // hidden/ClassDiagram2Relational.ei

            // C.2.1 Normalize (up-to isomorphism)
            Commands.gRoundTram().bxContract().execute(
                    "-batch",
                    "-src", URIs.absolutePath(c.tempDirectory().appendSegment(URIs.filename(c.module(), "-target.dot"))), // hidden/ClassDiagram2Relational-target.dot
                    "-dst", URIs.absolutePath(c.tempDirectory().appendSegment(URIs.filename(c.module(), "-target-normal.dot")))); // hidden/ClassDiagram2Relational-target-normal.dot

            // C.2.2 DOT2XMI
            Commands.atlGt().dotToXmi().execute(
                    "-dot", URIs.absolutePath(c.tempDirectory().appendSegment(URIs.filename(c.module(), "-target-normal.dot"))), // hidden/ClassDiagram2Relational-target-normal.dot
                    "-xmi", URIs.absolutePath(c.tempDirectory().appendSegment(URIs.filename(c.module(), "-target-normal.xmi"))), // hidden/ClassDiagram2Relational-target-normal.xmi
                    "-km3", URIs.absolutePath(c.tempDirectory().appendSegment(URIs.filename(c.outMetamodel(), "-relaxed.km3"))), // hidden/Relational-relaxed.km3
                    "-pkg", Metamodels.firstPackage(c.outMetamodel()).getName(), // http://example.org/Relational
                    "-uri", Metamodels.firstPackage(c.outMetamodel()).getNsURI()); // Relational

            // C.3 Execution of ATL with IDs
            // TODO

            return null;
        };

        metamodelProcessing.apply(context);
        transformationProcessing.apply(context);
        forwardTransformation.apply(context);
    }
}
