package org.eclipse.m2m.atl.atlgt.launcher.ui;

import org.eclipse.debug.ui.AbstractLaunchConfigurationTabGroup;
import org.eclipse.debug.ui.CommonTab;
import org.eclipse.debug.ui.ILaunchConfigurationDialog;
import org.eclipse.debug.ui.ILaunchConfigurationTab;
import org.eclipse.m2m.atl.emftvm.launcher.MainEMFTVMTab;

public class AtlGtTabGroup extends AbstractLaunchConfigurationTabGroup {

    @Override
    public void createTabs(ILaunchConfigurationDialog dialog, String mode) {
        final ILaunchConfigurationTab mainTab = new MainEMFTVMTab();
        final ILaunchConfigurationTab parameterTab = new AtlGtParameterTab();
        final ILaunchConfigurationTab common = new CommonTab();

        setTabs(new ILaunchConfigurationTab[]{
                mainTab,
                parameterTab,
                common
        });
    }
}
