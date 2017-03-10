package org.eclipse.m2m.atl.atlgt.examples;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

/**
 * This will allow the user to unzip the Class2Relational example.
 */
public class Class2RelationalExampleWizard extends AbstractExampleWizard {

	@Override
	protected Collection<ProjectDescriptor> getProjectDescriptors() {
		List<ProjectDescriptor> projects = new ArrayList<ProjectDescriptor>(2);
		projects.add(new ProjectDescriptor("org.eclipse.m2m.atl.atlgt.examples", "examples/org.eclipse.m2m.atl.atlgt.examples.simpleclass2relational.zip", "org.eclipse.m2m.atl.atlgt.examples.simpleclass2relational"));
		return projects;
	}

}
