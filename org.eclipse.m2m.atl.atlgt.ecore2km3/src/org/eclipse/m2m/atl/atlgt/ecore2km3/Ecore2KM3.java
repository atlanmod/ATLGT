package org.eclipse.m2m.atl.atlgt.ecore2km3;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

import org.eclipse.core.resources.IWorkspace;
import org.eclipse.core.resources.ResourcesPlugin;
import org.eclipse.core.runtime.IProgressMonitor;
import org.eclipse.core.runtime.NullProgressMonitor;
import org.eclipse.core.runtime.Platform;
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
import org.eclipse.m2m.atl.core.service.LauncherService;
import org.eclipse.m2m.atl.engine.emfvm.launch.EMFVMLauncher;

public class Ecore2KM3 {
		
	private ILauncher launcher;
	private IProgressMonitor ip;
	
	private String workspacePath;
	private String metamodelPath;
	
	private final String EMF2KM3_TRANSF = getLocation() + "resources/EMF2KM3.asm";
	private final String ECORE_METAMODEL_PATH = getLocation() + "resources/Ecore.ecore";
	private final String KM3_METAMODEL_PATH = getLocation() + "resources/KM3.ecore";
	
	public Ecore2KM3(String workspacePath, String metamodelPath) {
		this.launcher = new EMFVMLauncher();
		this.ip = new NullProgressMonitor();
		
		this.workspacePath = workspacePath;
		this.metamodelPath = metamodelPath;
		
		try {
			this.transform();
		} catch (ATLCoreException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	private static String getLocation() {
		return Platform.getBundle(Activator.PLUGIN_ID).getLocation().replaceFirst("reference:", "");
	}
	
	public void transform() throws ATLCoreException, IOException {
		this.launcher = new EMFVMLauncher();
		this.ip = new NullProgressMonitor();
		
//		Map<String,String> inModels = new HashMap<String,String>();
//		inModels.put("IN", "MOF");
//		Map<String,String> outModels = new HashMap<String,String>();
//		outModels.put("OUT", "KM3");
//		
//		Map<String,String> paths = new HashMap<String,String>();
//		paths.put("IN", URI.createFileURI(this.workspacePath  + this.metamodelPath).toString());
//		paths.put("OUT", URI.createFileURI(this.workspacePath + this.metamodelPath.replace(".ecore", "-km3.ecore")).toString());
//		
//		paths.put("MOF", ECORE_METAMODEL_PATH);
//		paths.put("KM3", KM3_METAMODEL_PATH);
//		
//		Map<String, Object> options = new HashMap<String, Object>();
//
//		URL transformationASM  = Ecore2KM3.class.getResource(EMF2KM3_TRANSF);
//		
//		LauncherService.launch(
//				ILauncher.RUN_MODE, 
//				ip, 
//				launcher, 
//				inModels,
//				Collections.<String, String> emptyMap(), 
//				outModels,
//				paths, 
//				options, 
//				Collections.<String, InputStream> emptyMap(), 
//				transformationASM.openStream()
//		);
		
		IInjector injector = new EMFInjector();
		IExtractor extractor = new EMFExtractor();
		ModelFactory modelFactory = new EMFModelFactory();
		/*
		 * Load metamodels
		 */
		IReferenceModel ecoreMetamodel = modelFactory.newReferenceModel();
		injector.inject(ecoreMetamodel, ECORE_METAMODEL_PATH);
		
		
		
		IReferenceModel km3Metamodel = modelFactory.newReferenceModel();
		injector.inject(km3Metamodel, KM3_METAMODEL_PATH);
		
		/*
		 * Load models and run transformation
		 */
		IModel inModel = modelFactory.newModel(ecoreMetamodel);
		injector.inject(ecoreMetamodel, this.metamodelPath);
		IModel outModel = modelFactory.newModel(km3Metamodel);
		
		this.launcher.initialize(new HashMap<String,Object>());
		this.launcher.addInModel(inModel, "IN", "MOF");
		this.launcher.addOutModel(outModel, "OUT", "KM3");
		URL transformationASM  = Ecore2KM3.class.getResource(URI.createFileURI(EMF2KM3_TRANSF).toString());
		this.launcher.launch(ILauncher.RUN_MODE, new NullProgressMonitor(), new HashMap<String,Object>(), transformationASM.openStream());
		
		extractor.extract(outModel, URI.createFileURI(this.workspacePath + this.metamodelPath.replace(".ecore", "-km3.ecore")).toString());
		
	}

}
