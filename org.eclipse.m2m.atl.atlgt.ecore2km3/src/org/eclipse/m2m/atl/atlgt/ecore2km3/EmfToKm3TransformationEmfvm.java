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

import java.io.IOException;
import java.io.InputStream;
import java.util.Collections;
import java.util.Objects;

/**
 * A {@link EmfToKm3Transformation} that is executed on a 'EMFTVM' virtual machine.
 *
 * @deprecated use {@link EmfToKm3TransformationEmftvm} instead.
 */
@Deprecated
public class EmfToKm3TransformationEmfvm implements EmfToKm3Transformation {

    @Override
    public URI transform(URI source, URI target) {
        if (!Objects.equals(source.fileExtension(), "ecore")) {
            throw new IllegalArgumentException("Only *.ecore files can be transformed.");
        }

        ModelFactory modelFactory = new EMFModelFactory();

        // Load metamodels

        IReferenceModel ecoreMetamodel = modelFactory.getMetametamodel();

        IInjector injector = new EMFInjector();

        try {
            IReferenceModel km3Metamodel = modelFactory.newReferenceModel();
            try (InputStream stream = EmfToKm3TransformationEmfvm.class.getResourceAsStream("/KM3.ecore")) {
                injector.inject(km3Metamodel, stream, Collections.emptyMap());
            }

            // Load models

            IModel inModel = modelFactory.newModel(ecoreMetamodel);
            injector.inject(ecoreMetamodel, source.toString());
            IModel outModel = modelFactory.newModel(km3Metamodel);

            ILauncher launcher = new EMFVMLauncher();
            launcher.initialize(Collections.emptyMap());
            launcher.addInModel(inModel, "IN", "MOF");
            launcher.addOutModel(outModel, "OUT", "KM3");

            // Run transformation

            try (InputStream stream = EmfToKm3TransformationEmfvm.class.getResourceAsStream("/EMF2KM3.asm")) {
                launcher.launch(ILauncher.RUN_MODE, new NullProgressMonitor(), Collections.emptyMap(), stream);
            }

            // Extract

            IExtractor extractor = new EMFExtractor();
            extractor.extract(outModel, target.toString());

            return target;
        }
        catch (IOException | ATLCoreException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }
}
