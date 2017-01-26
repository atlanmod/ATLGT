package org.eclipse.m2m.atl.atlgt.example.simpleclass2relational;

import org.eclipse.jface.viewers.IStructuredSelection;
import org.eclipse.jface.wizard.Wizard;
import org.eclipse.ui.INewWizard;
import org.eclipse.ui.IWorkbench;

/**
 *
 */
public class ClassDiagram2RelationalWizard extends Wizard implements INewWizard {

    @Override
    public boolean performFinish() {
        return false;
    }

    @Override
    public void init(IWorkbench workbench, IStructuredSelection selection) {
        // TODO Initialize wizard with workbench and the current selection
        System.out.println("I'm launching the new wizard!");
    }
}
