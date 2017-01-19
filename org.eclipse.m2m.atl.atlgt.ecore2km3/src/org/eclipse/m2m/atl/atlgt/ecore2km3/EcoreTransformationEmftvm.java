package org.eclipse.m2m.atl.atlgt.ecore2km3;

import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.EcorePackage;
import org.eclipse.emf.ecore.resource.ResourceSet;
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl;
import org.eclipse.emf.ecore.xmi.impl.EcoreResourceFactoryImpl;
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

import java.io.File;
import java.io.IOException;
import java.util.Collections;

public class EcoreTransformationEmftvm implements EcoreTransformation {

    public static final String BUNDLE_SYMBOLIC_NAME = "org.eclipse.m2m.atl.atlgt.ecore2km3";

    @Override
    public void transform(File directory, String metamodelPath) throws ATLCoreException, IOException {
        ExecEnv env = EmftvmFactory.eINSTANCE.createExecEnv();
        ResourceSet resourceSet = new ResourceSetImpl();
        resourceSet.getResourceFactoryRegistry().getExtensionToFactoryMap().put("ecore", new EcoreResourceFactoryImpl());

        // TODO Find a dynamic way to have this URI
        String resourcesPath = "platform:/plugin/" + BUNDLE_SYMBOLIC_NAME + "/resources/";

        final Metamodel ecoreMetamodel = EmftvmFactory.eINSTANCE.createMetamodel();
        ecoreMetamodel.setResource(EcorePackage.eINSTANCE.eResource());
        env.registerMetaModel("Ecore", ecoreMetamodel);

        final Metamodel km3Metamodel = EmftvmFactory.eINSTANCE.createMetamodel();
        km3Metamodel.setResource(resourceSet.getResource(URI.createURI(resourcesPath + "/KM3.ecore"), true));
        env.registerMetaModel("KM3", km3Metamodel);

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
