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

    private static final String MOF = "MOF";
    private static final String KM3 = "KM3";
    private static final String IN = "IN";
    private static final String OUT = "OUT";

    private static final String KM3_EXT = "km3";
    private static final String ECORE_EXT = "ecore";
    private static final String XMI_EXT = "xmi";
    private static final String EMFTVM_EXT = "emftvm";

    private static final String KM3_METAMODEL = KM3 + "." + ECORE_EXT;

    private static final String MODULE_NAME = "EMF2KM3";

    private static final EmftvmFactory FACTORY = EmftvmFactory.eINSTANCE;

    @Override
    public URI transform(URI outputDirectory, URI metamodel) {
        if (!Objects.equals(metamodel.fileExtension(), "ecore")) {
            throw new IllegalArgumentException("Only *.ecore files can be transformed.");
        }

        if (outputDirectory.isFile()) {
            throw new IllegalArgumentException("The 'outputDirectory' is not a directory.");
        }

        URI resourcesDirectory = URI.createPlatformPluginURI(BUNDLE_SYMBOLIC_NAME, false).appendSegment("resources");
        URI outputEcore = outputDirectory.appendSegment(metamodel.lastSegment().replace("." + ECORE_EXT, "-" + KM3_EXT + "." + ECORE_EXT));
        System.out.println("Transformation of '" + metamodel + "' to '" + outputEcore + "'");

        ExecEnv env = FACTORY.createExecEnv();

        ResourceSet resourceSet = new ResourceSetImpl();
        resourceSet.getResourceFactoryRegistry().getExtensionToFactoryMap().put(ECORE_EXT, new EcoreResourceFactoryImpl());
        resourceSet.getResourceFactoryRegistry().getExtensionToFactoryMap().put(XMI_EXT, new XMIResourceFactoryImpl());
        resourceSet.getResourceFactoryRegistry().getExtensionToFactoryMap().put(EMFTVM_EXT, new EMFTVMResourceFactoryImpl());

        // Load metamodels

        final Metamodel ecoreMetamodel = FACTORY.createMetamodel();
        ecoreMetamodel.setResource(EcorePackage.eINSTANCE.eResource());
        env.registerMetaModel(MOF, ecoreMetamodel);

        final Metamodel km3Metamodel = FACTORY.createMetamodel();
        km3Metamodel.setResource(resourceSet.getResource(resourcesDirectory.appendSegment(KM3_METAMODEL), true));
        env.registerMetaModel(KM3, km3Metamodel);

        // Load models

        Model inModel = FACTORY.createModel();
        inModel.setResource(resourceSet.getResource(metamodel, true));
        env.registerInputModel(IN, inModel);

        Model outModel = FACTORY.createModel();
        outModel.setResource(resourceSet.createResource(outputEcore));
        env.registerOutputModel(OUT, outModel);

        // Run transformation

        ModuleResolver moduleResolver = new DefaultModuleResolver(resourcesDirectory.toString() + "/", resourceSet);
        TimingData td = new TimingData();
        env.loadModule(moduleResolver, MODULE_NAME);
        td.finishLoading();
        env.run(td);
        td.finish();

        try {
            outModel.getResource().save(Collections.emptyMap());
        } catch (IOException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }

        // Extract

        URI outputKm3 = outputDirectory.appendSegment(metamodel.lastSegment().replace("." + ECORE_EXT, "." + KM3_EXT));
        System.out.println("Extraction of '" + outputEcore + "' to '" + outputKm3 + "'");

        // TODO Complete the extraction

        return outputKm3;
    }
}
