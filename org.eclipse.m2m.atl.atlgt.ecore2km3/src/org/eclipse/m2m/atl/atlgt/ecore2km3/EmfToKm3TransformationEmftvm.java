package org.eclipse.m2m.atl.atlgt.ecore2km3;

import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.EcorePackage;
import org.eclipse.emf.ecore.resource.ResourceSet;
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl;
import org.eclipse.m2m.atl.emftvm.EmftvmFactory;
import org.eclipse.m2m.atl.emftvm.ExecEnv;
import org.eclipse.m2m.atl.emftvm.Metamodel;
import org.eclipse.m2m.atl.emftvm.Model;
import org.eclipse.m2m.atl.emftvm.util.DefaultModuleResolver;
import org.eclipse.m2m.atl.emftvm.util.ModuleResolver;
import org.eclipse.m2m.atl.emftvm.util.TimingData;
import org.eclipse.m2m.km3.Km3Package;

import java.io.IOException;
import java.util.Collections;
import java.util.Objects;

/**
 * A {@link EmfToKm3Transformation} that is executed on a 'EMFTVM' virtual machine.
 */
public class EmfToKm3TransformationEmftvm implements EmfToKm3Transformation {

    private static final String BUNDLE_SYMBOLIC_NAME = "org.eclipse.m2m.atl.atlgt.ecore2km3";

    private static final EmftvmFactory FACTORY = EmftvmFactory.eINSTANCE;

    @Override
    public URI transform(URI source, URI target) {
        if (!Objects.equals(source.fileExtension(), "ecore")) {
            throw new IllegalArgumentException("Only *.ecore files can be transformed");
        }

        if (!Objects.equals(target.fileExtension(), "km3")) {
            throw new IllegalArgumentException("The target file must be a *.km3 file");
        }

        URI resourcesDirectory = URI.createPlatformPluginURI(BUNDLE_SYMBOLIC_NAME, false).appendSegment("resources");

        System.out.println("Transformation of '" + source + "' to '" + target + "'");

        ExecEnv env = FACTORY.createExecEnv();

        ResourceSet resourceSet = new ResourceSetImpl();

        // Load metamodels

        final Metamodel ecoreMetamodel = FACTORY.createMetamodel();
        ecoreMetamodel.setResource(EcorePackage.eINSTANCE.eResource());
        env.registerMetaModel("MOF", ecoreMetamodel);

        final Metamodel km3Metamodel = FACTORY.createMetamodel();
        km3Metamodel.setResource(Km3Package.eINSTANCE.eResource());
        env.registerMetaModel("KM3", km3Metamodel);

        // Load models

        Model inModel = FACTORY.createModel();
        inModel.setResource(resourceSet.getResource(source, true));
        env.registerInputModel("IN", inModel);

        Model outModel = FACTORY.createModel();
        outModel.setResource(resourceSet.createResource(target));
        env.registerOutputModel("OUT", outModel);

        // Run transformation

        ModuleResolver moduleResolver = new DefaultModuleResolver(resourcesDirectory.toString() + "/", resourceSet);
        TimingData td = new TimingData();
        env.loadModule(moduleResolver, MODULE);
        td.finishLoading();
        env.run(td);
        td.finish();

        try {
            outModel.getResource().save(Collections.emptyMap());
        }
        catch (IOException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }

        return target;
    }
}
