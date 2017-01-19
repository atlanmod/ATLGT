package org.eclipse.m2m.atl.atlgt.ecore2km3;

import org.eclipse.core.runtime.Platform;
import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.EcorePackage;
import org.eclipse.emf.ecore.resource.ResourceSet;
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl;
import org.eclipse.emf.ecore.xmi.impl.XMIResourceFactoryImpl;
import org.eclipse.m2m.atl.core.ATLCoreException;
import org.eclipse.m2m.atl.emftvm.EmftvmFactory;
import org.eclipse.m2m.atl.emftvm.ExecEnv;
import org.eclipse.m2m.atl.emftvm.Metamodel;
import org.eclipse.m2m.atl.emftvm.Model;
import org.eclipse.m2m.atl.emftvm.impl.resource.EMFTVMResourceFactoryImpl;
import org.eclipse.m2m.atl.emftvm.util.DefaultModuleResolver;
import org.eclipse.m2m.atl.emftvm.util.ModuleResolver;
import org.eclipse.m2m.atl.emftvm.util.TimingData;
import org.osgi.framework.Bundle;

import java.io.File;
import java.io.IOException;
import java.util.Collections;

public class EcoreTransformationEmftvm implements EcoreTransformation {

    @Override
    public void transform(File directory, String metamodelPath) throws ATLCoreException, IOException {
        ExecEnv env = EmftvmFactory.eINSTANCE.createExecEnv();
        ResourceSet resourceSet = new ResourceSetImpl();

        Bundle bundle = Platform.getBundle("org.eclipse.m2m.atl.atlgt.ecore2km3");

        // TODO Improve path resolver, string resolution is clearly not ideal
        String resourcesPath = (bundle.getLocation() + "resources/").replace("reference:", "");

        System.out.println(resourcesPath);

        final Metamodel ecoreMetamodel = EmftvmFactory.eINSTANCE.createMetamodel();
        ecoreMetamodel.setResource(EcorePackage.eINSTANCE.eResource());

        // TODO Link dynamically, according to the parameters given in the launcher
//        Metamodel inMetamodel = EmftvmFactory.eINSTANCE.createMetamodel();
//        inMetamodel.setResource(resourceSet.getResource(URI.createURI(null), true)); // FIXME
//        env.registerMetaModel("Ecore", inMetamodel);
//
//        Metamodel outMetamodel = EmftvmFactory.eINSTANCE.createMetamodel();
//        outMetamodel.setResource(resourceSet.getResource(URI.createURI(null), true)); // FIXME
//        env.registerMetaModel("KM3", outMetamodel);

        resourceSet.getResourceFactoryRegistry().getExtensionToFactoryMap().put("xmi", new XMIResourceFactoryImpl());
        resourceSet.getResourceFactoryRegistry().getExtensionToFactoryMap().put("emftvm", new EMFTVMResourceFactoryImpl());

        // Load models
        Model inModel = EmftvmFactory.eINSTANCE.createModel();
        inModel.setResource(resourceSet.getResource(URI.createURI(metamodelPath, true), true));
        env.registerInputModel("IN", inModel);

        Model outModel = EmftvmFactory.eINSTANCE.createModel();
        outModel.setResource(resourceSet.createResource(URI.createURI(directory.getAbsolutePath() + metamodelPath.replace(".ecore", "-km3.ecore"))));
        env.registerOutputModel("OUT", outModel);

        ModuleResolver mr = new DefaultModuleResolver(resourcesPath, resourceSet);
        TimingData td = new TimingData();
        env.loadModule(mr, "EMF2KM3");
        td.finishLoading();
        env.run(td);
        td.finish();

        try {
            outModel.getResource().save(Collections.emptyMap());
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
