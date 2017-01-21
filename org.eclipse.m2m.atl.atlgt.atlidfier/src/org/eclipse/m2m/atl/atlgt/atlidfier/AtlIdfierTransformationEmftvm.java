package org.eclipse.m2m.atl.atlgt.atlidfier;

import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.resource.ResourceSet;
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl;
import org.eclipse.emf.ecore.xmi.impl.EcoreResourceFactoryImpl;
import org.eclipse.emf.ecore.xmi.impl.XMIResourceFactoryImpl;
import org.eclipse.m2m.atl.common.ATL.ATLPackage;
import org.eclipse.m2m.atl.core.ATLCoreException;
import org.eclipse.m2m.atl.emftvm.EmftvmFactory;
import org.eclipse.m2m.atl.emftvm.ExecEnv;
import org.eclipse.m2m.atl.emftvm.Metamodel;
import org.eclipse.m2m.atl.emftvm.Model;
import org.eclipse.m2m.atl.emftvm.impl.resource.EMFTVMResourceFactoryImpl;
import org.eclipse.m2m.atl.emftvm.util.DefaultModuleResolver;
import org.eclipse.m2m.atl.emftvm.util.ModuleResolver;
import org.eclipse.m2m.atl.emftvm.util.TimingData;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.Collections;

public class AtlIdfierTransformationEmftvm implements AtlIdfierTransformation {

    private static final String BUNDLE_SYMBOLIC_NAME = "org.eclipse.m2m.atl.atlgt.atlidfier";

    private static final String MODULE_NAME = "ATLIDfier";

    @Override
    public String transform(String outputDirectory, String module) throws ATLCoreException, IOException {
        ExecEnv env = EmftvmFactory.eINSTANCE.createExecEnv();

        // TODO Find a dynamic way to have this URI
        String resourcesPath = "platform:/plugin/" + BUNDLE_SYMBOLIC_NAME + "/resources/";

        ResourceSet resourceSet = new ResourceSetImpl();
        resourceSet.getResourceFactoryRegistry().getExtensionToFactoryMap().put("ecore", new EcoreResourceFactoryImpl());
        resourceSet.getResourceFactoryRegistry().getExtensionToFactoryMap().put("xmi", new XMIResourceFactoryImpl());
        resourceSet.getResourceFactoryRegistry().getExtensionToFactoryMap().put("emftvm", new EMFTVMResourceFactoryImpl());

        // Load models (turn ATL file into model)
        String outputXmi = module + ".xmi";

        Model inOutModel = EmftvmFactory.eINSTANCE.createModel();
        inOutModel.setResource(resourceSet.getResource(URI.createURI(module, true), true));
        env.registerInOutModel("IN", inOutModel);
        
        // Load metamodels
        final Metamodel atlMetamodel = EmftvmFactory.eINSTANCE.createMetamodel();
        atlMetamodel.setResource(ATLPackage.eINSTANCE.eResource());
        env.registerMetaModel("ATL", atlMetamodel);
        
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

        String outputIds = Paths.get(outputDirectory).resolve(new File(module).getName().replace(".atl", "-ids.atl")).toString();

        // TODO Complete the extraction

        return outputIds;
    }
}
