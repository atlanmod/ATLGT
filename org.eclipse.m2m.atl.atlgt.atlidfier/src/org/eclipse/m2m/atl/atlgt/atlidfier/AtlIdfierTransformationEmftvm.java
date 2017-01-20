package org.eclipse.m2m.atl.atlgt.atlidfier;

import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.resource.ResourceSet;
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl;
import org.eclipse.emf.ecore.xmi.impl.EcoreResourceFactoryImpl;
import org.eclipse.emf.ecore.xmi.impl.XMIResourceFactoryImpl;
import org.eclipse.m2m.atl.atlgt.atlidfier.helper.ATLHelpers;
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

    public static final String BUNDLE_SYMBOLIC_NAME = "org.eclipse.m2m.atl.atlgt.atlidfier";

    private static final String ATL_METAMODEL = "ATL.ecore";

    private static final String MODULE_NAME = "ATLIDfier";

    @Override
    public String transform(String outputDirectory, String atlPath) throws ATLCoreException, IOException {
        ExecEnv env = EmftvmFactory.eINSTANCE.createExecEnv();

        // TODO Find a dynamic way to have this URI
        String resourcesPath = "platform:/plugin/" + BUNDLE_SYMBOLIC_NAME + "/resources/";

        ResourceSet resourceSet = new ResourceSetImpl();
        resourceSet.getResourceFactoryRegistry().getExtensionToFactoryMap().put("ecore", new EcoreResourceFactoryImpl());
        resourceSet.getResourceFactoryRegistry().getExtensionToFactoryMap().put("xmi", new XMIResourceFactoryImpl());
        resourceSet.getResourceFactoryRegistry().getExtensionToFactoryMap().put("emftvm", new EMFTVMResourceFactoryImpl());

        // Load metamodels
        final Metamodel atlMetamodel = EmftvmFactory.eINSTANCE.createMetamodel();
        atlMetamodel.setResource(resourceSet.getResource(URI.createURI(resourcesPath + "/" + ATL_METAMODEL), true));
        env.registerMetaModel("ATL", atlMetamodel);

        // Load models
        // turn atl file into model
        String atlModelPath = atlPath+".xmi";
        
        try {
			ATLHelpers.extract2emf(atlPath, atlModelPath);
		} catch (Exception e) {
			e.printStackTrace();
		}
        
        Model inOutModel = EmftvmFactory.eINSTANCE.createModel();
        inOutModel.setResource(resourceSet.getResource(URI.createURI(atlModelPath, true), true));
        env.registerInOutModel("IN", inOutModel);


        // Run transformation

        ModuleResolver moduleResolver = new DefaultModuleResolver(resourcesPath, resourceSet);
        TimingData td = new TimingData();
        env.loadModule(moduleResolver, MODULE_NAME);
        td.finishLoading();
        env.run(td);
        td.finish();
        System.out.println(td);
        
        try {
        	inOutModel.getResource().save(Collections.emptyMap());
        } catch (IOException e) {
            e.printStackTrace();
        }

        // Extract

        String outputKm3 = Paths.get(outputDirectory).resolve(new File(atlPath).getName().replace(".atl", "-ids.atl")).toString();

        // TODO Complete the extraction

        return atlModelPath;

        //throw new UnsupportedOperationException("Not implemented yet.");
    }
}
