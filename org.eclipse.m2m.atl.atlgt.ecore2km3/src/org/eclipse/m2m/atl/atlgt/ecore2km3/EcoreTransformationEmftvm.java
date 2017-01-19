package org.eclipse.m2m.atl.atlgt.ecore2km3;

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

import java.io.File;
import java.io.IOException;
import java.util.Collections;

public class EcoreTransformationEmftvm implements EcoreTransformation {

    @Override
    public void transform(File directory, String metamodelPath) throws ATLCoreException, IOException {
        ExecEnv env = EmftvmFactory.eINSTANCE.createExecEnv();
        ResourceSet resourceSet = new ResourceSetImpl();

        final Metamodel ecoreMetamodel = EmftvmFactory.eINSTANCE.createMetamodel();
        ecoreMetamodel.setResource(EcorePackage.eINSTANCE.eResource());

        // TODO Link dynamically, according to the parameters given in the launcher
//        Metamodel inMetamodel = EmftvmFactory.eINSTANCE.createMetamodel();
//        inMetamodel.setResource(resourceSet.getResource(URI.createURI(EcoreTransformationEmftvm.class.getResource("./ClassDiagram/ClassDiagram.ecore").toString()), true));
//        env.registerMetaModel("Ecore", inMetamodel);
//
//        Metamodel outMetamodel = EmftvmFactory.eINSTANCE.createMetamodel();
//        outMetamodel.setResource(resourceSet.getResource(URI.createURI(EcoreTransformationEmftvm.class.getResource("./Relational/.Relational.ecore").toString()), true));
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

        // TODO Where is the module ?
        ModuleResolver mr = new DefaultModuleResolver("./", resourceSet);
        TimingData td = new TimingData();
        env.loadModule(mr, "org.eclipse.m2m.atl.atlgt.ecore2km3");
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
