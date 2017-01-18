package org.eclipse.m2m.atl.atlgt.ecore2km3;

import java.io.IOException;
import java.io.InputStream;
import java.util.Collections;

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

public class Ecore2KM3 {
		
	private final String workspacePath;
	private final String metamodelPath;
	private final String pluginPath;
	
	public Ecore2KM3(String pluginPath, String workspacePath, String metamodelPath) {
		this.workspacePath = workspacePath;
		this.metamodelPath = metamodelPath;
		this.pluginPath = pluginPath;
				
		try {
			this.transform();
		} catch (ATLCoreException | IOException e) {
			e.printStackTrace();
		}
	}

	public void transform() throws ATLCoreException, IOException {
		IInjector injector = new EMFInjector();
		IExtractor extractor = new EMFExtractor();
		ModelFactory modelFactory = new EMFModelFactory();
		
		// Load metamodels
		IReferenceModel ecoreMetamodel = modelFactory.getMetametamodel();

		IReferenceModel km3Metamodel = modelFactory.newReferenceModel();
		try (InputStream stream = Ecore2KM3.class.getResourceAsStream("/KM3.ecore")) {
			injector.inject(km3Metamodel, stream, Collections.emptyMap());
		}
		
		// Load models and run transformation
		IModel inModel = modelFactory.newModel(ecoreMetamodel);
		injector.inject(ecoreMetamodel, this.metamodelPath);
		IModel outModel = modelFactory.newModel(km3Metamodel);

		ILauncher launcher = new EMFVMLauncher();
		launcher.initialize(Collections.emptyMap());
		launcher.addInModel(inModel, "IN", "MOF");
		launcher.addOutModel(outModel, "OUT", "KM3");
		
		try (InputStream stream = Ecore2KM3.class.getResourceAsStream("/EMF2KM3.asm")) {
			launcher.launch(ILauncher.RUN_MODE, new NullProgressMonitor(), Collections.emptyMap(), stream);
		}
		
		extractor.extract(outModel, URI.createFileURI(workspacePath + metamodelPath.replace(".ecore", "-km3.ecore")).toString());
	}
}
