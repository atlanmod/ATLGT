package org.eclipse.m2m.atl.atlgt.launcher;

import org.eclipse.core.resources.ResourcesPlugin;
import org.eclipse.core.runtime.CoreException;
import org.eclipse.core.runtime.IProgressMonitor;
import org.eclipse.debug.core.ILaunch;
import org.eclipse.debug.core.ILaunchConfiguration;
import org.eclipse.debug.core.model.ILaunchConfigurationDelegate;
import org.eclipse.m2m.atl.atlgt.ecore2km3.Ecore2KM3;
import org.eclipse.m2m.atl.atlgt.metamodel.MetamodelHelpers;

import java.io.File;
import java.util.Collection;
import java.util.Map;

public class AtlGtLauncher implements ILaunchConfigurationDelegate {

    private static final String KEY_METAMODELS = "Metamodels";
    private static final String KEY_MODULE_NAME = "Module Name";
    private static final String KEY_MODULE_PATH = "Module Path";
    private static final String KEY_IN_MODELS = "Input Models";
    private static final String KEY_OUT_MODELS = "Output Models";

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

    @SuppressWarnings("unchecked")
    private void extractConfiguration(ILaunchConfiguration configuration) throws Exception {
        final Map<String, Object> attributes = configuration.getAttributes();

        isForward = Boolean.valueOf(attributes.get(AtlGtLauncherConstant.FORWARD).toString());

        metamodelsPaths = ((Map<String, String>) attributes.get(KEY_METAMODELS)).values();

        // register metamodel in MMPaths
        for (String metamodel : metamodelsPaths) {
            MetamodelHelpers.registerPackage(metamodel);
            System.out.println("Registered metamodel: " + metamodel);
        }

        moduleName = attributes.get(KEY_MODULE_NAME).toString();
        modulePath = attributes.get(KEY_MODULE_PATH).toString();

        sourcesPaths = ((Map<String, String>) attributes.get(KEY_IN_MODELS)).values();
        targetsPaths = ((Map<String, String>) attributes.get(KEY_OUT_MODELS)).values();
    }

    @Override
    public void launch(ILaunchConfiguration configuration, String mode, ILaunch launch, IProgressMonitor monitor) throws CoreException {
        try {
            File workspaceDirectory = ResourcesPlugin.getWorkspace().getRoot().getLocation().toFile();

            extractConfiguration(configuration);

            // A. Metamodel processing
            // A.1 Ecore2KM3
            for (String mmpath : metamodelsPaths) {
                Ecore2KM3 ecoreTx = new Ecore2KM3(workspaceDirectory.getAbsolutePath(), mmpath);
                ecoreTx.transform();
            }

            // A.2 Ecore Relaxation

            // A.3 RelaxedEcore2RelaxedKM3

            // B. Transformation processing
            // B.1 ATLIDfier

            System.out.println("ATL GT - Executed!!" + sourcesPaths.toString() + metamodelsPaths.toString());
        }
        catch (Exception e) {
            e.printStackTrace();
        }
    }
}
