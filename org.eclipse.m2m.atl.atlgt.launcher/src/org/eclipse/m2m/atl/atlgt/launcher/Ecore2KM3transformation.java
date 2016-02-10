package org.eclipse.m2m.atl.atlgt.launcher;

import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

import org.eclipse.core.runtime.IProgressMonitor;
import org.eclipse.core.runtime.NullProgressMonitor;
import org.eclipse.core.runtime.Platform;
import org.eclipse.emf.common.util.URI;
import org.eclipse.m2m.atl.core.ATLCoreException;
import org.eclipse.m2m.atl.core.launch.ILauncher;
import org.eclipse.m2m.atl.core.service.LauncherService;
import org.eclipse.m2m.atl.engine.emfvm.launch.EMFVMLauncher;

public class Ecore2KM3transformation {
		
	private ILauncher launcher;
	private IProgressMonitor ip;
	
	private static final String bundleName = "org.eclipse.m2m.atl.atlgt.launcher"; 
	
	private String sourceEcoreMetamodelPath = getLocation() + "transformation/ecore2km3/" + "Sample.ecore";
	private String targetKM3MetamodelPath = getLocation() + "transformation/ecore2km3/" + "Sample.km3";
	private final String ECORE_METAMODEL_PATH = "http://www.eclipse.org/emf/2002/Ecore";
	private final String KM3_METAMODEL_PATH = getLocation() + "transformation/KM3.ecore";
	private static final String EMF2KM3_TRANSF = "/transformation/ecore2km3/EMF2KM3.asm";
	
	public Ecore2KM3transformation() {
		this.launcher = new EMFVMLauncher();
		this.ip = new NullProgressMonitor();
	}
	
	public static final String getLocation() {	
		return Platform.getBundle(bundleName).getLocation().replaceFirst("reference:", "");
	}
	
	public void transform() throws ATLCoreException, IOException {
		Map<String,String> inModels = new HashMap<String,String>();
		inModels.put("IN", "MOF");
		Map<String,String> outModels = new HashMap<String,String>();
		outModels.put("OUT", "KM3");
		
		Map<String,String> paths = new HashMap<String,String>();
		paths.put("IN", URI.createFileURI(sourceEcoreMetamodelPath).toString());
		paths.put("OUT", URI.createFileURI(targetKM3MetamodelPath).toString());
		
		paths.put("MOF", ECORE_METAMODEL_PATH);
		paths.put("KM3", KM3_METAMODEL_PATH);
		
		Map<String, Object> options = new HashMap<String, Object>();
		
		URL transformation  = Ecore2KM3transformation.class.getResource(EMF2KM3_TRANSF);
		
		LauncherService.launch(
				ILauncher.RUN_MODE, 
				ip, 
				launcher, 
				inModels,
				Collections.<String, String> emptyMap(), 
				outModels,
				paths, 
				options, 
				Collections.<String, InputStream> emptyMap(), 
				transformation.openStream()
		);
		
	}

}
