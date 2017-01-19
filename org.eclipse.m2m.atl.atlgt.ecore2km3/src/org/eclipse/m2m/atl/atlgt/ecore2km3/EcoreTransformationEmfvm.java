package org.eclipse.m2m.atl.atlgt.ecore2km3;

import org.eclipse.core.runtime.NullProgressMonitor;
import org.eclipse.emf.common.util.URI;
import org.eclipse.m2m.atl.core.ATLCoreException;
import org.eclipse.m2m.atl.core.IExtractor;
import org.eclipse.m2m.atl.core.IInjector;
import org.eclipse.m2m.atl.core.IModel;
import org.eclipse.m2m.atl.core.IReferenceModel;
import org.eclipse.m2m.atl.core.ModelFactory;
import org.eclipse.m2m.atl.core.emf.EMFExtractor;
import org.eclipse.m2m.atl.core.emf.EMFInjector;
import org.eclipse.m2m.atl.core.emf.EMFModelFactory;
import org.eclipse.m2m.atl.core.launch.ILauncher;
import org.eclipse.m2m.atl.engine.emfvm.launch.EMFVMLauncher;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.util.Collections;

/**
 * ???
 * <p>
 * For now, it does not work; use {@link EcoreTransformationEmftvm} instead.
 */
public class EcoreTransformationEmfvm implements EcoreTransformation {

    @Override
    public void transform(File directory, String metamodelPath) throws ATLCoreException, IOException {
        ModelFactory modelFactory = new EMFModelFactory();

        // Load metamodels
        IReferenceModel ecoreMetamodel = modelFactory.getMetametamodel();

        IInjector injector = new EMFInjector();

        IReferenceModel km3Metamodel = modelFactory.newReferenceModel();
        try (InputStream stream = EcoreTransformationEmfvm.class.getResourceAsStream("/KM3.ecore")) {
            injector.inject(km3Metamodel, stream, Collections.emptyMap());
        }

        // Load models and run transformation
        IModel inModel = modelFactory.newModel(ecoreMetamodel);
        injector.inject(ecoreMetamodel, metamodelPath);
        IModel outModel = modelFactory.newModel(km3Metamodel);

        ILauncher launcher = new EMFVMLauncher();
        launcher.initialize(Collections.emptyMap());
        launcher.addInModel(inModel, "IN", "MOF");
        launcher.addOutModel(outModel, "OUT", "KM3");

        try (InputStream stream = EcoreTransformationEmfvm.class.getResourceAsStream("/EMF2KM3.asm")) {
            launcher.launch(ILauncher.RUN_MODE, new NullProgressMonitor(), Collections.emptyMap(), stream);
        }

        IExtractor extractor = new EMFExtractor();
        extractor.extract(outModel, URI.createFileURI(directory.getAbsolutePath() + metamodelPath.replace(".ecore", "-km3.ecore")).toString());
    }
}
