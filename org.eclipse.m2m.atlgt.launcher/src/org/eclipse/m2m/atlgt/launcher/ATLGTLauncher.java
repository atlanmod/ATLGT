package org.eclipse.m2m.atlgt.launcher;

import java.util.Map;

import org.eclipse.core.runtime.CoreException;
import org.eclipse.core.runtime.IProgressMonitor;
import org.eclipse.debug.core.ILaunch;
import org.eclipse.debug.core.ILaunchConfiguration;
import org.eclipse.debug.core.model.ILaunchConfigurationDelegate;


/**
 */
public class ATLGTLauncher implements ILaunchConfigurationDelegate {





	@Override
	public void launch(ILaunchConfiguration configuration, String mode, ILaunch launch, IProgressMonitor monitor)
			throws CoreException {
		 System.out.println("ATL GT - Executed!!");
		
	}


}
