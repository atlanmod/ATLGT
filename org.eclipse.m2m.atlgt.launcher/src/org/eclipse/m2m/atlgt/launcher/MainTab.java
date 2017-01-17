package org.eclipse.m2m.atlgt.launcher;

import org.eclipse.core.runtime.CoreException;
import org.eclipse.debug.core.ILaunchConfiguration;
import org.eclipse.debug.core.ILaunchConfigurationWorkingCopy;
import org.eclipse.debug.ui.AbstractLaunchConfigurationTab;
import org.eclipse.swt.SWT;
import org.eclipse.swt.custom.ScrolledComposite;
import org.eclipse.swt.events.SelectionAdapter;
import org.eclipse.swt.events.SelectionEvent;
import org.eclipse.swt.layout.*;
import org.eclipse.swt.widgets.*;

public class MainTab extends AbstractLaunchConfigurationTab {



	private ScrolledComposite scrollContainer;
	private Composite rootContainer;
	private Group parameterGroup;
	private Button forward;
	private Button backward;

	
	
	
	
	@Override
	public void createControl(Composite parent) {
		scrollContainer = new ScrolledComposite(parent, SWT.H_SCROLL | SWT.V_SCROLL);
		scrollContainer.setExpandHorizontal(true);
		scrollContainer.setExpandVertical(true);

		rootContainer = new Composite(scrollContainer, SWT.NULL);
		rootContainer.setLayout(new GridLayout());
		scrollContainer.setContent(rootContainer);

		parameterGroup = new Group(rootContainer, SWT.NULL);
		parameterGroup.setLayoutData(new GridData(GridData.FILL_HORIZONTAL));
		parameterGroup.setLayout(new GridLayout(2, false));
		parameterGroup.setText("Tranformation_Direction");

		forward = new Button(parameterGroup, SWT.RADIO);
		forward.setText(ATLGTLauncherConstant.FORWARD);
		forward.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				updateLaunchConfigurationDialog();
			}
		});

		backward = new Button(parameterGroup, SWT.RADIO);
		backward.setText(ATLGTLauncherConstant.BACKWARD);
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
		configuration.setAttribute(ATLGTLauncherConstant.FORWARD, true);
		configuration.setAttribute(ATLGTLauncherConstant.BACKWARD, false);

	}

	@Override
	public void initializeFrom(ILaunchConfiguration configuration) {
		try {
			forward.setSelection(configuration.getAttribute(ATLGTLauncherConstant.FORWARD, true));
			backward.setSelection(configuration.getAttribute(ATLGTLauncherConstant.BACKWARD, false));

		} catch (CoreException e) {
			e.printStackTrace();
		}

	}

	@Override
	public void performApply(ILaunchConfigurationWorkingCopy configuration) {
		configuration.setAttribute(ATLGTLauncherConstant.FORWARD, forward.getSelection());
		configuration.setAttribute(ATLGTLauncherConstant.BACKWARD, backward.getSelection());

	}

	@Override
	public String getName() {
		return "Tranformation_Direction";
	}

}
