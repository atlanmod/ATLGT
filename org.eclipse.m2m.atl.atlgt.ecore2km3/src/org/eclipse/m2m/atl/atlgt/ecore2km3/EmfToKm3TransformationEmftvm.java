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

import java.io.IOException;
import java.util.Collections;
import java.util.Objects;

public class EmfToKm3TransformationEmftvm implements EmfToKm3Transformation {

    private static final String BUNDLE_SYMBOLIC_NAME = "org.eclipse.m2m.atl.atlgt.ecore2km3";

    private static final String KM3_METAMODEL = "KM3.ecore";

    private static final String MODULE_NAME = "EMF2KM3";

    @Override
    public URI transform(URI outputDirectory, URI metamodel) {
        if (!Objects.equals(metamodel.fileExtension(), "ecore")) {
            throw new IllegalArgumentException("Only *.ecore files can be transformed.");
        }

        URI outputEcore = outputDirectory.appendSegment(metamodel.lastSegment().replace(".ecore", "-km3.ecore"));
        System.out.println("Transformation of '" + metamodel + "' to '" + outputEcore + "'");

        ExecEnv env = EmftvmFactory.eINSTANCE.createExecEnv();

        URI resourcesDirectory = URI.createPlatformPluginURI(BUNDLE_SYMBOLIC_NAME + "/resources/", false);

        ResourceSet resourceSet = new ResourceSetImpl();
        resourceSet.getResourceFactoryRegistry().getExtensionToFactoryMap().put("ecore", new EcoreResourceFactoryImpl());
        resourceSet.getResourceFactoryRegistry().getExtensionToFactoryMap().put("xmi", new XMIResourceFactoryImpl());
        resourceSet.getResourceFactoryRegistry().getExtensionToFactoryMap().put("emftvm", new EMFTVMResourceFactoryImpl());

        // Load metamodels

        final Metamodel ecoreMetamodel = EmftvmFactory.eINSTANCE.createMetamodel();
        ecoreMetamodel.setResource(EcorePackage.eINSTANCE.eResource());
        env.registerMetaModel("MOF", ecoreMetamodel);

        final Metamodel km3Metamodel = EmftvmFactory.eINSTANCE.createMetamodel();
        km3Metamodel.setResource(resourceSet.getResource(resourcesDirectory.appendSegment(KM3_METAMODEL), true));
        env.registerMetaModel("KM3", km3Metamodel);

        // Load models

        Model inModel = EmftvmFactory.eINSTANCE.createModel();
        inModel.setResource(resourceSet.getResource(metamodel, true));
        env.registerInputModel("IN", inModel);

        Model outModel = EmftvmFactory.eINSTANCE.createModel();
        outModel.setResource(resourceSet.createResource(outputEcore));
        env.registerOutputModel("OUT", outModel);

        // Run transformation

        ModuleResolver moduleResolver = new DefaultModuleResolver(resourcesDirectory.toString(), resourceSet);
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

        URI outputKm3 = outputDirectory.appendSegment(metamodel.lastSegment().replace(".ecore", ".km3"));
        System.out.println("Extraction of '" + outputEcore + "' to '" + outputKm3 + "'");

        // TODO Complete the extraction

        return outputKm3;
    }
}
