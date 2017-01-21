package org.eclipse.m2m.atl.atlgt.atlidfier;

import java.io.IOException;
import java.util.Collections;

import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.resource.ResourceSet;
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl;
import org.eclipse.m2m.atl.common.ATL.ATLPackage;
import org.eclipse.m2m.atl.core.ATLCoreException;
import org.eclipse.m2m.atl.emftvm.EmftvmFactory;
import org.eclipse.m2m.atl.emftvm.ExecEnv;
import org.eclipse.m2m.atl.emftvm.Metamodel;
import org.eclipse.m2m.atl.emftvm.Model;
import org.eclipse.m2m.atl.emftvm.util.DefaultModuleResolver;
import org.eclipse.m2m.atl.emftvm.util.ModuleResolver;
import org.eclipse.m2m.atl.emftvm.util.TimingData;

public class AtlIdfierTransformationEmftvm implements AtlIdfierTransformation {

    private static final String BUNDLE_SYMBOLIC_NAME = "org.eclipse.m2m.atl.atlgt.atlidfier";

    private static final String MODULE_NAME = "ATLIDfier";

    @Override
    public String transform(String outputDirectory, String module) throws ATLCoreException, IOException {
        ExecEnv env = EmftvmFactory.eINSTANCE.createExecEnv();

        // TODO Find a dynamic way to have this URI
        String resourcesPath = "platform:/plugin/" + BUNDLE_SYMBOLIC_NAME + "/resources/";

        ResourceSet resourceSet = new ResourceSetImpl();
        
        // Load ATL metamodel
        final Metamodel atlMetamodel = EmftvmFactory.eINSTANCE.createMetamodel();
        atlMetamodel.setResource(ATLPackage.eINSTANCE.eResource());
        env.registerMetaModel("ATL", atlMetamodel);
        
        // Load ATL model from file
        Model inOutModel = EmftvmFactory.eINSTANCE.createModel();
        inOutModel.setResource(resourceSet.getResource(URI.createURI(module, true), true));
        env.registerInOutModel("IN", inOutModel);
        
        // Run transformation

        ModuleResolver moduleResolver = new DefaultModuleResolver(resourcesPath, resourceSet);
        TimingData td = new TimingData();
        env.loadModule(moduleResolver, MODULE_NAME);
        td.finishLoading();
        env.run(td);
        td.finish();
        System.out.println(td);

        // Extract
        
        try {
            inOutModel.getResource().save(Collections.emptyMap());
        }
        catch (IOException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }

        return module;
    }
}
