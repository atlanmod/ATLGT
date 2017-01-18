package org.eclipse.m2m.atl.atlgt.ecore2km3;

import java.io.IOException;
import java.net.URL;
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
	
	private final String emf2Km3Transformation;
	private final String km3MetamodelPath;
	
	public Ecore2KM3(String pluginPath, String workspacePath, String metamodelPath) {
		this.workspacePath = workspacePath;
		this.metamodelPath = metamodelPath;
		this.pluginPath = pluginPath;
				
		this.emf2Km3Transformation = getLocation() + "resources/EMF2KM3.asm";
		this.km3MetamodelPath = getLocation() + "resources/KM3.ecore";
		
		try {
			this.transform();
		} catch (ATLCoreException | IOException e) {
			e.printStackTrace();
		}
	}

	private String getLocation() {
		return pluginPath.replaceFirst("reference:", "");
	}
	
	public void transform() throws ATLCoreException, IOException {
		IInjector injector = new EMFInjector();
		IExtractor extractor = new EMFExtractor();
		ModelFactory modelFactory = new EMFModelFactory();
		/*
		 * Load metamodels
		 */
		IReferenceModel ecoreMetamodel = modelFactory.getMetametamodel();

		IReferenceModel km3Metamodel = modelFactory.newReferenceModel();
		injector.inject(km3Metamodel, km3MetamodelPath);
		
		/*
		 * Load models and run transformation
		 */
		IModel inModel = modelFactory.newModel(ecoreMetamodel);
		injector.inject(ecoreMetamodel, this.metamodelPath);
		IModel outModel = modelFactory.newModel(km3Metamodel);

		ILauncher launcher = new EMFVMLauncher();
		launcher.initialize(Collections.emptyMap());
		launcher.addInModel(inModel, "IN", "MOF");
		launcher.addOutModel(outModel, "OUT", "KM3");
		URL transformationASM  = Ecore2KM3.class.getResource(URI.createFileURI(emf2Km3Transformation).toString());
		launcher.launch(ILauncher.RUN_MODE, new NullProgressMonitor(), Collections.emptyMap(), transformationASM.openStream());
		
		extractor.extract(outModel, URI.createFileURI(workspacePath + metamodelPath.replace(".ecore", "-km3.ecore")).toString());
	}
}
