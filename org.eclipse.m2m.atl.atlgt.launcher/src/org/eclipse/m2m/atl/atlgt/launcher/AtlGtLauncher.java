package org.eclipse.m2m.atl.atlgt.launcher;

import org.eclipse.core.runtime.IProgressMonitor;
import org.eclipse.debug.core.ILaunch;
import org.eclipse.debug.core.ILaunchConfiguration;
import org.eclipse.debug.core.model.ILaunchConfigurationDelegate;
import org.eclipse.m2m.atl.atlgt.core.Context;
import org.eclipse.m2m.atl.atlgt.core.Direction;
import org.eclipse.m2m.atl.atlgt.core.Tasks;
import org.eclipse.m2m.atl.atlgt.util.Metamodels;

public class AtlGtLauncher implements ILaunchConfigurationDelegate {

    @Override
    public void launch(ILaunchConfiguration launchConfiguration, String mode, ILaunch launch, IProgressMonitor monitor) {

        // Loads the current context
        Context context = Context.from(launchConfiguration, monitor);

        // Register all metamodels
        context.metamodels().forEach(Metamodels::register);

        // Run transformation
        if (context.direction() == Direction.FORWARD) {
            Tasks.metamodelProcessing()
                    .andThen(Tasks.transformationProcessing())
                    .andThen(Tasks.forwardTransformation())
                    .apply(context);
        }
        else if (context.direction() == Direction.BACKWARD) {
            Tasks.backwardTransformation()
                    .apply(context);
        }
        else {
            throw new IllegalStateException("Unknown direction");
        }

        System.out.println("ATL-GT: Successfully executed");
    }
}
