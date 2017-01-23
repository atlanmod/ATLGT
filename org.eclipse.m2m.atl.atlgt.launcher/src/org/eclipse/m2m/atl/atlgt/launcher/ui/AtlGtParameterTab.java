package org.eclipse.m2m.atl.atlgt.launcher.ui;

import org.eclipse.core.runtime.CoreException;
import org.eclipse.debug.core.ILaunchConfiguration;
import org.eclipse.debug.core.ILaunchConfigurationWorkingCopy;
import org.eclipse.debug.ui.AbstractLaunchConfigurationTab;
import org.eclipse.m2m.atl.atlgt.launcher.Context.Direction;
import org.eclipse.swt.SWT;
import org.eclipse.swt.custom.ScrolledComposite;
import org.eclipse.swt.events.SelectionAdapter;
import org.eclipse.swt.events.SelectionEvent;
import org.eclipse.swt.graphics.Image;
import org.eclipse.swt.layout.GridData;
import org.eclipse.swt.layout.GridLayout;
import org.eclipse.swt.widgets.Button;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Group;

public class AtlGtParameterTab extends AbstractLaunchConfigurationTab {

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
        parameterGroup.setText("Transformation Direction");

        forward = new Button(parameterGroup, SWT.RADIO);
        forward.setText(Direction.FORWARD.getName());
        forward.addSelectionListener(new SelectionAdapter() {
            @Override
            public void widgetSelected(SelectionEvent e) {
                updateLaunchConfigurationDialog();
            }
        });

        backward = new Button(parameterGroup, SWT.RADIO);
        backward.setText(Direction.BACKWARD.getName());
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
        configuration.setAttribute(Direction.FORWARD.getName(), true);
        configuration.setAttribute(Direction.BACKWARD.getName(), false);
    }

    @Override
    public void initializeFrom(ILaunchConfiguration configuration) {
        try {
            forward.setSelection(configuration.getAttribute(Direction.FORWARD.getName(), true));
            backward.setSelection(configuration.getAttribute(Direction.BACKWARD.getName(), false));
        }
        catch (CoreException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void performApply(ILaunchConfigurationWorkingCopy configuration) {
        configuration.setAttribute(Direction.FORWARD.getName(), forward.getSelection());
        configuration.setAttribute(Direction.BACKWARD.getName(), backward.getSelection());
    }

    @Override
    public String getName() {
        return "ATL-GT Parameters";
    }

    @Override
    // TODO Set the tab icon
    public Image getImage() {
        return super.getImage();
//        return ImageDescriptor.createFromURL();
    }
}
