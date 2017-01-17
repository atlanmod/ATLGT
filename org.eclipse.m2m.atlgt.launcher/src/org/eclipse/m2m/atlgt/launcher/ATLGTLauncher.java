package org.eclipse.m2m.atlgt.launcher;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Map;

import org.eclipse.core.internal.resources.File;
import org.eclipse.core.resources.IWorkspace;
import org.eclipse.core.resources.ResourcesPlugin;
import org.eclipse.core.runtime.CoreException;
import org.eclipse.core.runtime.IProgressMonitor;
import org.eclipse.core.runtime.Platform;
import org.eclipse.debug.core.ILaunch;
import org.eclipse.debug.core.ILaunchConfiguration;
import org.eclipse.debug.core.model.ILaunchConfigurationDelegate;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.EPackage;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.emf.ecore.resource.ResourceSet;
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl;
import org.eclipse.emf.ecore.xmi.impl.EcoreResourceFactoryImpl;
import org.eclipse.m2m.atl.atlgt.ecore2km3.Ecore2KM3;
import org.eclipse.m2m.atlgt.metamodel.MetamodelHelpers;


/**
 */
public class ATLGTLauncher implements ILaunchConfigurationDelegate {

	static Map<String, Object> config ;	// whole configuration map
	static IWorkspace workspace;
	static boolean isForward;	// BX direction
	static Collection<String> MMPaths ;		// metamodel paths

	static Collection<String> srcsPaths;		// src models paths
	static Collection<String> trgsPaths;		// trg models paths
	
	static String module;
	static String modulePath;
	
	
	
	public void extractConfiguration(ILaunchConfiguration configuration) throws Exception{
		config = configuration.getAttributes();
		
		isForward = config.get("Forward").toString().equals("true");
		
		MMPaths = ( (Map<String, String>) config.get("Metamodels") ).values();
		
		// register metamodel in MMPaths
		for(String mmpath : MMPaths){
			MetamodelHelpers.registerPackage(mmpath);
			System.out.println("metamodel register - Executed!!");
		}
		
		
		module = config.get("Module Name").toString();
		modulePath = config.get("Module Path").toString();
		
		srcsPaths =  ( (Map<String, String>) config.get("Input Models") ).values();
		trgsPaths =  ( (Map<String, String>) config.get("Output Models") ).values();
		
	}
	



	@Override
	public void launch(ILaunchConfiguration configuration, String mode, ILaunch launch, IProgressMonitor monitor)
			throws CoreException {
		
		try {
			workspace = ResourcesPlugin.getWorkspace();
			java.io.File workspaceDirectory = workspace.getRoot().getLocation().toFile();
			
			extractConfiguration(configuration);
			
			// A. Metamodel processing
			// A.1 Ecore2KM3
			
			for(String mmpath : MMPaths){
				Ecore2KM3 ecoreTx = new Ecore2KM3(workspaceDirectory.getAbsolutePath(), mmpath);
				ecoreTx.transform();
			}
			
			// A.2 Ecore Relaxation
			
			// A.3 RelaxedEcore2RelaxedKM3

			// B. Transformation processing
			// B.1 ATLIDfier
			
			
			System.out.println("ATL GT - Executed!!" + srcsPaths.toString() + MMPaths.toString());
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		

	}


}
