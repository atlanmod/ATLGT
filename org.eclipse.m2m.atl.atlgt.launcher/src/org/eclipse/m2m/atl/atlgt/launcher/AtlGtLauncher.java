package org.eclipse.m2m.atl.atlgt.launcher;

import org.eclipse.core.runtime.CoreException;
import org.eclipse.core.runtime.IProgressMonitor;
import org.eclipse.debug.core.ILaunch;
import org.eclipse.debug.core.ILaunchConfiguration;
import org.eclipse.debug.core.model.ILaunchConfigurationDelegate;
import org.eclipse.emf.ecore.EPackage;
import org.eclipse.m2m.atl.atlgt.ecore2km3.EmfToKm3TransformationFactory;
import org.eclipse.m2m.atl.atlgt.util.MetamodelHelpers;
import org.eclipse.m2m.atl.core.ATLCoreException;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.List;


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

            System.out.println("ATL-GT - Executed!! " + context.getPath());
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
            EmfToKm3TransformationFactory.withEmftvm().transform(context.getPath(), metamodel);
        }

        List<String> relaxedMetamodels = new ArrayList<>();

        // A.2 Ecore Relaxation
        for (String metamodel : context.getMetamodels()) {
            Iterable<EPackage> packages = MetamodelHelpers.readEcore(metamodel);
            String relaxedMetamodel = MetamodelHelpers.relax(packages, context.getPath(), metamodel);
            relaxedMetamodels.add(relaxedMetamodel);
        }

        // A.3 Relaxed Ecore to Relaxed KM3
        for (String relaxedMetamodel : relaxedMetamodels) {
            EmfToKm3TransformationFactory.withEmftvm().transform(context.getPath(), relaxedMetamodel);
        }
    }

    /**
     * Transformation processing. (Step B)
     */
    private void processTransformation() throws ATLCoreException, IOException {
        // B.1 ATLIDfier
    	//create a copy of the atl file
 	
    	Path src = Paths.get("./"+context.getModulePath());
    	Path dst = Paths.get(context.getPath().replace("platform:/resource/", "./")+"/");
        Files.copy(src, dst, StandardCopyOption.REPLACE_EXISTING);
    	
    	//run inplace transformation
    	//EmfToKm3TransformationFactory.withEmftvm().transform(context.getPath(), );
    }
}
