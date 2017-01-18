package org.eclipse.m2m.atlgt.launcher.ui;

import org.eclipse.core.runtime.CoreException;
import org.eclipse.debug.core.ILaunchConfiguration;
import org.eclipse.debug.core.ILaunchConfigurationWorkingCopy;
import org.eclipse.debug.ui.AbstractLaunchConfigurationTab;
import org.eclipse.m2m.atlgt.launcher.AtlGtLauncherConstant;
import org.eclipse.swt.SWT;
import org.eclipse.swt.custom.ScrolledComposite;
import org.eclipse.swt.events.SelectionAdapter;
import org.eclipse.swt.events.SelectionEvent;
import org.eclipse.swt.layout.GridData;
import org.eclipse.swt.layout.GridLayout;
import org.eclipse.swt.widgets.Button;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Group;

public class LauncherTab extends AbstractLaunchConfigurationTab {

    private Button forward;
    private Button backward;

    @Override
    public void createControl(Composite parent) {
        ScrolledComposite scrollContainer = new ScrolledComposite(parent, SWT.H_SCROLL | SWT.V_SCROLL);
        scrollContainer.setExpandHorizontal(true);
        scrollContainer.setExpandVertical(true);

        Composite rootContainer = new Composite(scrollContainer, SWT.NULL);
        rootContainer.setLayout(new GridLayout());
        scrollContainer.setContent(rootContainer);

        Group parameterGroup = new Group(rootContainer, SWT.NULL);
        parameterGroup.setLayoutData(new GridData(GridData.FILL_HORIZONTAL));
        parameterGroup.setLayout(new GridLayout(2, false));
        parameterGroup.setText("Tranformation_Direction");

        forward = new Button(parameterGroup, SWT.RADIO);
        forward.setText(AtlGtLauncherConstant.FORWARD);
        forward.addSelectionListener(new SelectionAdapter() {
            @Override
            public void widgetSelected(SelectionEvent e) {
                updateLaunchConfigurationDialog();
            }
        });

        backward = new Button(parameterGroup, SWT.RADIO);
        backward.setText(AtlGtLauncherConstant.BACKWARD);
        backward.addSelectionListener(new SelectionAdapter() {
            @Override
            public void widgetSelected(SelectionEvent e) {
                updateLaunchConfigurationDialog();
            }
        });

        setControl(scrollContainer);
    }

    @Override
    public void setDefaults(ILaunchConfigurationWorkingCopy configuration) {
        configuration.setAttribute(AtlGtLauncherConstant.FORWARD, true);
        configuration.setAttribute(AtlGtLauncherConstant.BACKWARD, false);
    }

    @Override
    public void initializeFrom(ILaunchConfiguration configuration) {
        try {
            forward.setSelection(configuration.getAttribute(AtlGtLauncherConstant.FORWARD, true));
            backward.setSelection(configuration.getAttribute(AtlGtLauncherConstant.BACKWARD, false));
        }
        catch (CoreException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void performApply(ILaunchConfigurationWorkingCopy configuration) {
        configuration.setAttribute(AtlGtLauncherConstant.FORWARD, forward.getSelection());
        configuration.setAttribute(AtlGtLauncherConstant.BACKWARD, backward.getSelection());
    }

    @Override
    public String getName() {
        return "Tranformation_Direction";
    }
}
