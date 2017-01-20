package org.eclipse.m2m.atl.atlgt.ecore2km3;

import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.EcorePackage;
import org.eclipse.emf.ecore.resource.ResourceSet;
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl;
import org.eclipse.emf.ecore.xmi.impl.EcoreResourceFactoryImpl;
import org.eclipse.emf.ecore.xmi.impl.XMIResourceFactoryImpl;
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

public class EmfToKm3TransformationEmftvm implements EmfToKm3Transformation {

    public static final String BUNDLE_SYMBOLIC_NAME = "org.eclipse.m2m.atl.atlgt.ecore2km3";

    private static final String KM3_METAMODEL = "KM3.ecore";

    private static final String MODULE_NAME = "EMF2KM3";

    @Override
    public String transform(String outputDirectory, String metamodel) {
        if (!metamodel.endsWith(".ecore")) {
            throw new IllegalArgumentException("Only *.ecore files can be transformed.");
        }

        String outputEcore = Paths.get(outputDirectory).resolve(new File(metamodel).getName().replace(".ecore", "-km3.ecore")).toString();
        System.out.println("Transformation of '" + metamodel + "' to " + outputEcore);

        ExecEnv env = EmftvmFactory.eINSTANCE.createExecEnv();

        // TODO Find a dynamic way to have this URI
        String resourcesPath = "platform:/plugin/" + BUNDLE_SYMBOLIC_NAME + "/resources/";

        ResourceSet resourceSet = new ResourceSetImpl();
        resourceSet.getResourceFactoryRegistry().getExtensionToFactoryMap().put("ecore", new EcoreResourceFactoryImpl());
        resourceSet.getResourceFactoryRegistry().getExtensionToFactoryMap().put("xmi", new XMIResourceFactoryImpl());
        resourceSet.getResourceFactoryRegistry().getExtensionToFactoryMap().put("emftvm", new EMFTVMResourceFactoryImpl());

        // Load metamodels

        final Metamodel ecoreMetamodel = EmftvmFactory.eINSTANCE.createMetamodel();
        ecoreMetamodel.setResource(EcorePackage.eINSTANCE.eResource());
        env.registerMetaModel("MOF", ecoreMetamodel);

        final Metamodel km3Metamodel = EmftvmFactory.eINSTANCE.createMetamodel();
        km3Metamodel.setResource(resourceSet.getResource(URI.createURI(resourcesPath + "/" + KM3_METAMODEL), true));
        env.registerMetaModel("KM3", km3Metamodel);

        // Load models

        Model inModel = EmftvmFactory.eINSTANCE.createModel();
        inModel.setResource(resourceSet.getResource(URI.createURI(metamodel, true), true));
        env.registerInputModel("IN", inModel);

        Model outModel = EmftvmFactory.eINSTANCE.createModel();
        outModel.setResource(resourceSet.createResource(URI.createFileURI(outputEcore)));
        env.registerOutputModel("OUT", outModel);

        // Run transformation

        ModuleResolver moduleResolver = new DefaultModuleResolver(resourcesPath, resourceSet);
        TimingData td = new TimingData();
        env.loadModule(moduleResolver, MODULE_NAME);
        td.finishLoading();
        env.run(td);
        td.finish();

        try {
            outModel.getResource().save(Collections.emptyMap());
        } catch (IOException e) {
            e.printStackTrace();
        }

        // Extract

        String outputKm3 = Paths.get(outputDirectory).resolve(new File(metamodel).getName().replace(".ecore", ".km3")).toString();
        System.out.println("Extraction of '" + outputEcore + "' to '" + outputKm3 + "'");

        // TODO Complete the extraction

        return outputEcore;
    }
}