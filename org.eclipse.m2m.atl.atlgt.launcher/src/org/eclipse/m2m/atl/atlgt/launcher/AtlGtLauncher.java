package org.eclipse.m2m.atl.atlgt.launcher;

import org.eclipse.core.runtime.CoreException;
import org.eclipse.core.runtime.IProgressMonitor;
import org.eclipse.debug.core.ILaunch;
import org.eclipse.debug.core.ILaunchConfiguration;
import org.eclipse.debug.core.model.ILaunchConfigurationDelegate;
import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.EPackage;
import org.eclipse.m2m.atl.atlgt.atlidfier.AtlIdfierTransformationFactory;
import org.eclipse.m2m.atl.atlgt.ecore2km3.EmfToKm3TransformationFactory;
import org.eclipse.m2m.atl.atlgt.tools.Commands;
import org.eclipse.m2m.atl.atlgt.util.MetamodelHelpers;
import org.eclipse.m2m.atl.atlgt.util.URIHelpers;
import org.eclipse.m2m.atl.core.ATLCoreException;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.StreamSupport;

public class AtlGtLauncher implements ILaunchConfigurationDelegate {

    private AtlGtContext context;

    @Override
    public void launch(ILaunchConfiguration launchConfiguration, String mode, ILaunch launch, IProgressMonitor monitor) throws CoreException {
        try {
            // Loads the current context
            context = AtlGtContext.from(launchConfiguration);

            // Copy the original metamodels to the temporary directory
            Iterable<URI> metamodels = StreamSupport.stream(context.getMetamodels().spliterator(), false)
                    .peek(uri -> URIHelpers.copy(uri, context.getTempDirectory().appendSegment(uri.lastSegment())))
                    .collect(Collectors.toList());

            // Register all metamodels
            metamodels.forEach(MetamodelHelpers::registerPackage);

            /*
             * Step A: Metamodel processing
             */

            // A.1 Ecore to KM3
            transformMetamodelsToKm3(metamodels);

            // A.2 Ecore Relaxation
            List<URI> relaxedMetamodels = new ArrayList<>();
            for (URI metamodel :metamodels) {
                Iterable<EPackage> packages = MetamodelHelpers.readEcore(metamodel);
                URI relaxedMetamodel = MetamodelHelpers.relax(packages, context.getTempDirectory(), metamodel);
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
            URI idfiedAtlModule = transformModule(context.getModule());

            // B.2 ATL2UNQL
            // TODO Improve URIs resolution
            Commands.atlGt().atlToUnql().execute(
                    "-atl", URIHelpers.toAbsolutePath(idfiedAtlModule), // hidden/ClassDiagram2Relational.atl
                    "-uq", URIHelpers.toAbsolutePath(context.getTempDirectory().appendSegment(idfiedAtlModule.lastSegment().replace(".atl", ".unql"))), // hidden/ClassDiagram2Relational.unql
                    "-ikm3", URIHelpers.toAbsolutePath(context.getTempDirectory().appendSegment(context.getInMetamodel().lastSegment().replace(".ecore", ".km3"))), // hidden/ClassDiagram.km3
                    "-ipkg", MetamodelHelpers.firstPackage(context.getInMetamodel()), // ClassDiagram
                    "-okm3", URIHelpers.toAbsolutePath(context.getTempDirectory().appendSegment(context.getOutMetamodel().lastSegment().replace(".ecore", "-relaxed.km3"))), // hidden/Relational-relaxed.km3
                    "-opkg", MetamodelHelpers.firstPackage(context.getOutMetamodel())); // Relational

            /*
             * Step C: Forward transformation
             */

            // C.1 XMI2DOT (we choose the first package name but we support only one package)
            Commands.atlGt().xmiToDot().execute(
                    "-xmi", URIHelpers.toAbsolutePath(context.getInModel()), // ClassDiagram/Sample-ClassDiagram.xmi
                    "-dot", URIHelpers.toAbsolutePath(context.getTempDirectory().appendSegment(context.getInModel().lastSegment().replace(".xmi", ".dot"))), // hidden/Sample-ClassDiagram.dot
                    "-km3", URIHelpers.toAbsolutePath(context.getTempDirectory().appendSegment(context.getInMetamodel().lastSegment().replace(".ecore", ".km3"))), // hidden/ClassDiagram.km3
                    "-pkg", MetamodelHelpers.firstPackage(context.getInMetamodel()));// ClassDiagram

            // C.2 Forward UnCAL
            Commands.gRoundTram().fwdUncal().execute(
                    "-ge", "-sb", "-cl", "-zn", "-fi", "-np", "-sa", "-t", "-rw", "-as",
                    "-db", URIHelpers.toAbsolutePath(context.getTempDirectory().appendSegment(context.getInModel().lastSegment().replace(".xmi", ".dot"))), // hidden/Sample-ClassDiagram.dot
                    "-uq", URIHelpers.toAbsolutePath(context.getTempDirectory().appendSegment(idfiedAtlModule.lastSegment().replace(".atl", ".unql"))), // hidden/ClassDiagram2Relational.unql
                    "-dot", URIHelpers.toAbsolutePath(context.getTempDirectory().appendSegment(idfiedAtlModule.lastSegment().replace(".atl", "-target.dot"))), // hidden/ClassDiagram2Relational-target.dot
                    "-xg", URIHelpers.toAbsolutePath(context.getTempDirectory().appendSegment(idfiedAtlModule.lastSegment().replace(".atl", ".xg"))), // hidden/ClassDiagram2Relational.xg
                    "-ei", URIHelpers.toAbsolutePath(context.getTempDirectory().appendSegment(idfiedAtlModule.lastSegment().replace(".atl", ".ei")))); // hidden/ClassDiagram2Relational.ei

            // C.2.1 Normalize (up-to isomorphism)
            Commands.gRoundTram().bxContract().execute(
                    "-batch",
                    "-src", URIHelpers.toAbsolutePath(context.getTempDirectory().appendSegment(idfiedAtlModule.lastSegment().replace(".atl", "-target.dot"))), // hidden/ClassDiagram2Relational-target.dot
                    "-dst", URIHelpers.toAbsolutePath(context.getTempDirectory().appendSegment(idfiedAtlModule.lastSegment().replace(".atl", "-target-normal.dot")))); // hidden/ClassDiagram2Relational-target-normal.dot

            // C.2.2 DOT2XMI
            Commands.atlGt().dotToXmi().execute(
                    "-dot", URIHelpers.toAbsolutePath(context.getTempDirectory().appendSegment(idfiedAtlModule.lastSegment().replace(".atl", "-target-normal.dot"))), // hidden/ClassDiagram2Relational-target-normal.dot
                    "-xmi", URIHelpers.toAbsolutePath(context.getTempDirectory().appendSegment(idfiedAtlModule.lastSegment().replace(".atl", "-target-normal.xmi"))), // hidden/ClassDiagram2Relational-target-normal.xmi
                    "-km3", URIHelpers.toAbsolutePath(context.getTempDirectory().appendSegment(context.getOutMetamodel().lastSegment().replace(".ecore", "-relaxed.km3"))), // hidden/Relational-relaxed.km3
                    "-pkg", MetamodelHelpers.firstPackage(context.getOutMetamodel())); // Relational

            // C.3 Execution of ATL with IDs
            // TODO

            System.out.println("ATL-GT: Successfully executed");
            System.out.println(context.getTempDirectory());
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
                .peek(metamodel -> EmfToKm3TransformationFactory.withEmftvm().transform(context.getTempDirectory(), metamodel))
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
        URI idfiedAtlModule = context.getTempDirectory().appendSegment(module.appendFileExtension("atl").lastSegment());
        URIHelpers.copy(atlModule, idfiedAtlModule);

        // Run in-place transformation
        return AtlIdfierTransformationFactory.withEmftvm().transform(context.getTempDirectory(), idfiedAtlModule);
    }
}
