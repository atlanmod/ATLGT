package org.eclipse.m2m.atlgt.launcher;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Map;

import org.eclipse.core.runtime.CoreException;
import org.eclipse.core.runtime.IProgressMonitor;
import org.eclipse.debug.core.ILaunch;
import org.eclipse.debug.core.ILaunchConfiguration;
import org.eclipse.debug.core.model.ILaunchConfigurationDelegate;


/**
 */
public class ATLGTLauncher implements ILaunchConfigurationDelegate {

	static Map<String, Object> config ;	// whole configuration map
	boolean isForward;	// BX direction
	Collection<String> MMPaths ;		// metamodel paths

	Collection<String> srcsPaths;		// src models paths
	Collection<String> trgsPaths;		// trg models paths
	
	String module;
	String modulePath;
	
	
	
	public void extractConfiguration(ILaunchConfiguration configuration) throws CoreException{
		config = configuration.getAttributes();
		
		isForward = config.get("Forward").toString().equals("true");
		
		MMPaths = ( (Map<String, String>) config.get("Metamodels") ).values();
		
		// register metamodel in MMPaths
		
		module = config.get("Module Name").toString();
		modulePath = config.get("Module Path").toString();
		
		srcsPaths =  ( (Map<String, String>) config.get("Input Models") ).values();
		trgsPaths =  ( (Map<String, String>) config.get("Output Models") ).values();
		
	}
	


	@Override
	public void launch(ILaunchConfiguration configuration, String mode, ILaunch launch, IProgressMonitor monitor)
			throws CoreException {
		
		extractConfiguration(configuration);
		
		
		
		
		
		
		 System.out.println("ATL GT - Executed!!" + srcsPaths.toString() + MMPaths.toString());
		
	}


}
