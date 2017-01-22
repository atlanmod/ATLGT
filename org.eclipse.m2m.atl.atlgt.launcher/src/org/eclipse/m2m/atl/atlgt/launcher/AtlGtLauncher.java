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

            // Register all metamodels
            context.getMetamodels().forEach(MetamodelHelpers::registerPackage);

            /*
             * Step A: Metamodel processing
             */

            // A.1 Ecore to KM3
            Iterable<URI> km3Metamodels = transformMetamodelsToKm3(context.getMetamodels());

            // A.2 Ecore Relaxation
            List<URI> relaxedMetamodels = new ArrayList<>();
            for (URI metamodel : context.getMetamodels()) {
                Iterable<EPackage> packages = MetamodelHelpers.readEcore(metamodel);
                URI relaxedMetamodel = MetamodelHelpers.relax(packages, context.getTempDirectory(), metamodel);
                relaxedMetamodels.add(relaxedMetamodel);
            }

            // A.3 Relaxed Ecore to Relaxed KM3
            Iterable<URI> km3RelaxedMetamodels = transformMetamodelsToKm3(relaxedMetamodels);

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
            // TODO '-ipkg' and '-opkg' expect a package name (which can be different from filename)
            Commands.atlGt().atlToUnql().execute(
                    "-atl", URIHelpers.toAbsolutePath(idfiedAtlModule), // hidden/ClassDiagram2Relational.atl
                    "-uq", URIHelpers.toAbsolutePath(context.getTempDirectory().appendSegment(idfiedAtlModule.lastSegment().replace(".atl", ".unql"))), // hidden/ClassDiagram2Relational.unql
                    "-ikm3", URIHelpers.toAbsolutePath(context.getTempDirectory().appendSegment(context.getInMetamodel().lastSegment().replace(".ecore", ".km3"))), // hidden/ClassDiagram.km3
                    "-ipkg", context.getInMetamodel().lastSegment().replace(".ecore", ""), // ClassDiagram
                    "-okm3", URIHelpers.toAbsolutePath(context.getTempDirectory().appendSegment(context.getOutMetamodel().lastSegment().replace(".ecore", "-relaxed.km3"))), // hidden/Relational-relaxed.km3
                    "-opkg", context.getOutMetamodel().lastSegment().replace(".ecore", "")); // Relational

            /*
             * Step C: Forward transformation
             */

            // C.1 XMI2DOT (we choose the first package name but we support only one package)
            // TODO Fill args
            Commands.atlGt().xmiToDot().execute(
                    "-xmi", "",
                    "-dot", "",
                    "-km3", "",
                    "-pkg", "");

            // C.2 Forward UnCAL
            // TODO Fill args
            Commands.gRoundTram().fwdUncal().execute(
                    "-ge", "-sb", "-cl", "-zn", "-fi", "-np", "-sa", "-t", "-rw", "-as",
                    " -db", "",
                    " -uq", "",
                    " -dot", "",
                    " -xg", "",
                    " -ei", "");

            // C.2.1 Normalize (up-to isomorphism)
            // TODO Fill args
            Commands.gRoundTram().bxContract().execute(
                    "-batch",
                    "-src", "",
                    "-dst", "");

            // C.2.2 DOT2XMI
            // TODO Fill args
            Commands.atlGt().dotToXmi().execute(
                    "-dot", "",
                    "-xmi", "",
                    "-km3", "",
                    "-pkg", "");
            
            // C.3 Execution of ATL with IDs

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
