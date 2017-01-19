package org.eclipse.m2m.atl.atlgt.launcher;

import org.eclipse.core.resources.ResourcesPlugin;
import org.eclipse.core.runtime.CoreException;
import org.eclipse.core.runtime.IProgressMonitor;
import org.eclipse.debug.core.ILaunch;
import org.eclipse.debug.core.ILaunchConfiguration;
import org.eclipse.debug.core.model.ILaunchConfigurationDelegate;
import org.eclipse.emf.ecore.EPackage;
import org.eclipse.m2m.atl.atlgt.ecore2km3.EcoreTransformation;
import org.eclipse.m2m.atl.atlgt.ecore2km3.EcoreTransformationFactory;
import org.eclipse.m2m.atl.atlgt.util.MetamodelHelpers;

import java.io.File;
import java.util.Collection;
import java.util.Map;

public class AtlGtLauncher implements ILaunchConfigurationDelegate {

    private static final String KEY_METAMODELS = "Metamodels";
    private static final String KEY_MODULE_NAME = "Module Name";
    private static final String KEY_MODULE_PATH = "Module Path";
    private static final String KEY_IN_MODELS = "Input Models";
    private static final String KEY_OUT_MODELS = "Output Models";
    
    private static final String KEY_HIDDEN_DIR = "/hidden/";
    
    /**
     * BX direction.
     */
    private boolean isForward;

    /**
     * Metamodel paths.
     */
    private Collection<String> metamodelsPaths;

    /**
     * Source models paths.
     */
    private Collection<String> sourcesPaths;

    /**
     * Target models paths.
     */
    private Collection<String> targetsPaths;

    /**
     * The name of the module.
     */
    private String moduleName;

    /**
     * The path of the module.
     */
    private String modulePath;
    
    /**
     * The hidden path of the BX project to store all generated files.
     */
    private String hiddenDir;
    
    

    @SuppressWarnings("unchecked")
    private void extractConfiguration(ILaunchConfiguration configuration) throws Exception {
        final Map<String, Object> attributes = configuration.getAttributes();

        isForward = Boolean.valueOf(attributes.get(AtlGtLauncherConstant.FORWARD).toString());

        metamodelsPaths = ((Map<String, String>) attributes.get(KEY_METAMODELS)).values();
        
        // register util in MMPaths
        for (String metamodel : metamodelsPaths) {
            MetamodelHelpers.registerPackage(metamodel);
            System.out.println("Registered metamodel: " + metamodel);
        }

        moduleName = attributes.get(KEY_MODULE_NAME).toString();
        modulePath = attributes.get(KEY_MODULE_PATH).toString();
        
        hiddenDir = modulePath.substring(0, modulePath.lastIndexOf("/") ) + KEY_HIDDEN_DIR;
        
        sourcesPaths = ((Map<String, String>) attributes.get(KEY_IN_MODELS)).values();
        targetsPaths = ((Map<String, String>) attributes.get(KEY_OUT_MODELS)).values();
    }

    @Override
    public void launch(ILaunchConfiguration configuration, String mode, ILaunch launch, IProgressMonitor monitor) throws CoreException {
        try {
            File workspaceDirectory = ResourcesPlugin.getWorkspace().getRoot().getLocation().toFile();

            extractConfiguration(configuration);

            // A. Metamodel processing
            // A.1 Ecore to KM3
            for (String mmpath : metamodelsPaths) {
                EcoreTransformation ecoreTx = EcoreTransformationFactory.withEmftvm();
                ecoreTx.transform(workspaceDirectory, mmpath);
            }

            // A.2 Ecore Relaxation
            for (String mmpath : metamodelsPaths) {
            	Iterable<EPackage> packages = MetamodelHelpers.readEcore(mmpath);
            	MetamodelHelpers.relax(packages, mmpath, hiddenDir);
            }
            
            // A.3 Relaxed Ecore to Relaxed KM3

            // B. Transformation processing
            // B.1 ATLIDfier

            System.out.println("ATL GT - Executed!!" + hiddenDir);
        }
        catch (Exception e) {
            e.printStackTrace();
        }
    }
}
