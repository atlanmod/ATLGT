package org.eclipse.m2m.atl.atlgt.launcher;

import org.eclipse.core.runtime.CoreException;
import org.eclipse.core.runtime.IProgressMonitor;
import org.eclipse.debug.core.ILaunch;
import org.eclipse.debug.core.ILaunchConfiguration;
import org.eclipse.debug.core.model.ILaunchConfigurationDelegate;
import org.eclipse.emf.ecore.EPackage;
import org.eclipse.m2m.atl.atlgt.ecore2km3.TransformationFactory;
import org.eclipse.m2m.atl.atlgt.util.MetamodelHelpers;
import org.eclipse.m2m.atl.core.ATLCoreException;

import java.io.IOException;

public class AtlGtLauncher implements ILaunchConfigurationDelegate {

    private AtlGtContext context;

    @Override
    public void launch(ILaunchConfiguration launchConfiguration, String mode, ILaunch launch, IProgressMonitor monitor) throws CoreException {
        try {
            context = AtlGtContext.from(launchConfiguration);

            // Register all metamodels
            context.getMetamodels().forEach(MetamodelHelpers::registerPackage);

            // Step A: Metamodel processing
            processMetamodels();

            // Step B: Transformation processing
            processTransformation();

            System.out.println("ATL GT - Executed!! " + context.getPath());
        }
        catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * Metamodel processing. (Step A)
     */
    private void processMetamodels() throws IOException, ATLCoreException {
        // A.1 Ecore to KM3
        for (String metamodel : context.getMetamodels()) {
            TransformationFactory.withEmftvm().transform(context.getPath(), metamodel);
        }

        // A.2 Ecore Relaxation
        for (String metamodel : context.getMetamodels()) {
            Iterable<EPackage> packages = MetamodelHelpers.readEcore(metamodel);
            MetamodelHelpers.relax(packages, context.getPath(), metamodel);
        }

        // A.3 Relaxed Ecore to Relaxed KM3
    }

    /**
     * Transformation processing. (Step B)
     */
    private void processTransformation() {
        // B.1 ATLIDfier
    }
}
