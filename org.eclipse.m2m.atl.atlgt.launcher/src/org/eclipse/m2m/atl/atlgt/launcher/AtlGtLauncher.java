package org.eclipse.m2m.atl.atlgt.launcher;

import org.eclipse.core.runtime.IProgressMonitor;
import org.eclipse.debug.core.ILaunch;
import org.eclipse.debug.core.ILaunchConfiguration;
import org.eclipse.debug.core.model.ILaunchConfigurationDelegate;
import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.EPackage;
import org.eclipse.m2m.atl.atlgt.atlidfier.AtlIdfierTransformationFactory;
import org.eclipse.m2m.atl.atlgt.ecore2km3.EmfToKm3TransformationFactory;
import org.eclipse.m2m.atl.atlgt.tools.Commands;
import org.eclipse.m2m.atl.atlgt.util.Metamodels;
import org.eclipse.m2m.atl.atlgt.util.URIs;
import org.eclipse.m2m.atl.core.ATLCoreException;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.StreamSupport;

public class AtlGtLauncher implements ILaunchConfigurationDelegate {

    private Context context;

    @Override
    public void launch(ILaunchConfiguration launchConfiguration, String mode, ILaunch launch, IProgressMonitor monitor) {
        try {
            /*
             * Initialization
             */

            // Loads the current context
            context = Context.from(launchConfiguration);

            // Copy the original metamodels to the temporary directory
            Iterable<URI> metamodels = StreamSupport.stream(context.metamodels().spliterator(), false)
                    .peek(uri -> URIs.copy(uri, context.tempDirectory().appendSegment(uri.lastSegment())))
                    .collect(Collectors.toList());

            // Register all metamodels
            metamodels.forEach(Metamodels::registerPackage);

            /*
             * Step A: Metamodel processing
             */

            // A.1 Ecore to KM3
            transformMetamodelsToKm3(metamodels);

            // A.2 Ecore Relaxation
            List<URI> relaxedMetamodels = new ArrayList<>();
            for (URI metamodel : metamodels) {
                Iterable<EPackage> packages = Metamodels.readEcore(metamodel);
                URI relaxedMetamodel = Metamodels.relax(packages, context.tempDirectory(), metamodel);
                relaxedMetamodels.add(relaxedMetamodel);
            }

            // A.3 Relaxed Ecore to Relaxed KM3
            transformMetamodelsToKm3(relaxedMetamodels);

            // A.4 KM3 to KM3 with IDs
            // Adding an optional attribute with name __xmiID__ and type String to each class
            // TODO

            // A.5 Relaxed KM3 to Relaxed KM3 with IDs
            // TODO
            
            /*
             * Step B: Transformation processing
             */

            // B.1 ATLIDfier
            URI idfiedAtlModule = transformModule(context.module());

            // B.2 ATL2UNQL
            // TODO Improve URIs resolution
            Commands.atlGt().atlToUnql().execute(
                    "-atl", URIs.absolutePath(idfiedAtlModule), // hidden/ClassDiagram2Relational.atl
                    "-uq", URIs.absolutePath(context.tempDirectory().appendSegment(URIs.filename(idfiedAtlModule, ".unql"))), // hidden/ClassDiagram2Relational.unql
                    "-ikm3", URIs.absolutePath(context.tempDirectory().appendSegment(URIs.filename(context.inMetamodel(), ".km3"))), // hidden/ClassDiagram.km3
                    "-ipkg", Metamodels.firstPackage(context.inMetamodel()).getName(), // ClassDiagram
                    "-okm3", URIs.absolutePath(context.tempDirectory().appendSegment(URIs.filename(context.outMetamodel(), "-relaxed.km3"))), // hidden/Relational-relaxed.km3
                    "-opkg", Metamodels.firstPackage(context.outMetamodel()).getName()); // Relational

            /*
             * Step C: Forward transformation
             */

            // C.1 XMI2DOT (we choose the first package name but we support only one package)
            Commands.atlGt().xmiToDot().execute(
                    "-xmi", URIs.absolutePath(context.inModel()), // ClassDiagram/Sample-ClassDiagram.xmi
                    "-dot", URIs.absolutePath(context.tempDirectory().appendSegment(URIs.filename(context.inModel(), ".dot"))), // hidden/Sample-ClassDiagram.dot
                    "-km3", URIs.absolutePath(context.tempDirectory().appendSegment(URIs.filename(context.inMetamodel(), ".km3"))), // hidden/ClassDiagram.km3
                    "-pkg", Metamodels.firstPackage(context.inMetamodel()).getName());// ClassDiagram

            // C.2 Forward UnCAL
            Commands.gRoundTram().fwdUncal().execute(
                    "-ge", "-sb", "-cl", "-zn", "-fi", "-np", "-sa", "-t", "-rw", "-as",
                    "-db", URIs.absolutePath(context.tempDirectory().appendSegment(URIs.filename(context.inModel(), ".dot"))), // hidden/Sample-ClassDiagram.dot
                    "-uq", URIs.absolutePath(context.tempDirectory().appendSegment(URIs.filename(idfiedAtlModule, ".unql"))), // hidden/ClassDiagram2Relational.unql
                    "-dot", URIs.absolutePath(context.tempDirectory().appendSegment(URIs.filename(idfiedAtlModule, "-target.dot"))), // hidden/ClassDiagram2Relational-target.dot
                    "-xg", URIs.absolutePath(context.tempDirectory().appendSegment(URIs.filename(idfiedAtlModule, ".xg"))), // hidden/ClassDiagram2Relational.xg
                    "-ei", URIs.absolutePath(context.tempDirectory().appendSegment(URIs.filename(idfiedAtlModule, ".ei")))); // hidden/ClassDiagram2Relational.ei

            // C.2.1 Normalize (up-to isomorphism)
            Commands.gRoundTram().bxContract().execute(
                    "-batch",
                    "-src", URIs.absolutePath(context.tempDirectory().appendSegment(URIs.filename(idfiedAtlModule, "-target.dot"))), // hidden/ClassDiagram2Relational-target.dot
                    "-dst", URIs.absolutePath(context.tempDirectory().appendSegment(URIs.filename(idfiedAtlModule, "-target-normal.dot")))); // hidden/ClassDiagram2Relational-target-normal.dot

            // C.2.2 DOT2XMI
            Commands.atlGt().dotToXmi().execute(
                    "-dot", URIs.absolutePath(context.tempDirectory().appendSegment(URIs.filename(idfiedAtlModule, "-target-normal.dot"))), // hidden/ClassDiagram2Relational-target-normal.dot
                    "-xmi", URIs.absolutePath(context.tempDirectory().appendSegment(URIs.filename(idfiedAtlModule, "-target-normal.xmi"))), // hidden/ClassDiagram2Relational-target-normal.xmi
                    "-km3", URIs.absolutePath(context.tempDirectory().appendSegment(URIs.filename(context.outMetamodel(), "-relaxed.km3"))), // hidden/Relational-relaxed.km3
                    "-pkg", Metamodels.firstPackage(context.outMetamodel()).getName(), // http://example.org/Relational
                    "-uri", Metamodels.firstPackage(context.outMetamodel()).getNsURI()); // Relational

            // C.3 Execution of ATL with IDs
            // TODO

            System.out.println("ATL-GT: Successfully executed");
            System.out.println(context.tempDirectory());
        }
        catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * Transforms Ecore {@code metamodels} to KM3 metamodels.
     *
     * @param metamodels the Ecore metamodels to transform
     *
     * @return the created KM3 metamodels
     */
    private Iterable<URI> transformMetamodelsToKm3(Iterable<URI> metamodels) {
        return StreamSupport
                .stream(metamodels.spliterator(), false)
                .peek(metamodel -> EmfToKm3TransformationFactory.withEmftvm().transform(context.tempDirectory(), metamodel))
                .collect(Collectors.toList());
    }

    /**
     * Adds identifier to the given {@code module}.
     *
     * @return the created module, with identifiers
     */
    private URI transformModule(URI module) throws ATLCoreException, IOException {
        // Create a copy of the atl file
        URI atlModule = module.appendFileExtension("atl");
        URI idfiedAtlModule = context.tempDirectory().appendSegment(module.appendFileExtension("atl").lastSegment());
        URIs.copy(atlModule, idfiedAtlModule);

        // Run in-place transformation
        return AtlIdfierTransformationFactory.withEmftvm().transform(context.tempDirectory(), idfiedAtlModule);
    }
}
