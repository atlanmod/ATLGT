package org.eclipse.m2m.atlgt.launcher;

import org.eclipse.debug.ui.AbstractLaunchConfigurationTabGroup;
import org.eclipse.debug.ui.CommonTab;
import org.eclipse.debug.ui.ILaunchConfigurationDialog;
import org.eclipse.debug.ui.ILaunchConfigurationTab;
import org.eclipse.m2m.atl.emftvm.launcher.*;

public class ATLGTTabGroups extends AbstractLaunchConfigurationTabGroup {

	public ATLGTTabGroups() {
		super();
	}

	@Override
	public void createTabs(ILaunchConfigurationDialog dialog, String mode) {
		final ILaunchConfigurationTab mainTab = new MainEMFTVMTab();
		final ILaunchConfigurationTab parameterTab = new MainTab();

		setTabs(new ILaunchConfigurationTab[]{mainTab, parameterTab});
	}

}
