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
        Context context = Context.from(launchConfiguration);

        // Register all metamodels
        context.metamodels().forEach(Metamodels::register);

        // Run transformation
        if (context.direction() == Direction.FORWARD) {
            Tasks.metamodelProcessing()
                    .andThen(Tasks.transformationProcessing())
                    .andThen(Tasks.forwardTransformation())
                    .apply(context);
        }
        else {
            throw new UnsupportedOperationException("Backward transformation is not supported yet");
            
			// D.1 XMI2DOT 
			// 	String xmi2dot_commandline = atlgt.getPath() + "xmi2dot_generic_command"
			// 		+ " -xmi " + targetUpdatedXMIFilePath e.g. test/myRelational.xmi
			// 		+ " -dot " + targetUpdatedNormalDOTFilePath e.g. test/myClassDiagram2myRelational-trace/ClassDiagram2Relational-target-normal-updated.dot
			// 		+ " -odot " + targetDOTNormalFilePath e.g. test/myClassDiagram2myRelational-trace/ClassDiagram2Relational-target-normal.dot
			// 		+ " -km3 " + targetKm3Path e.g. test/myClassDiagram2myRelational-trace/Relational.km3
			// 		+ " -pkg " + targetMetaModelName; e.g. Relational
			// 	Runtime.getRuntime().exec(
			// 	  xmi2dot_commandline
			//     );

			// D.2 Denormalization
			// 	String bx_contract_commandline = groundtram.getPath() + "bx_contract -batch"
			// 		+ " -src "  + targetDOTFilePath e.g. test/myClassDiagram2myRelational-trace/ClassDiagram2Relational-target.dot
			// 		+ " -dst "  + targetUpdatedNormalDOTFilePath e.g. test/myClassDiagram2myRelational-trace/ClassDiagram2Relational-target-normal-updated.dot
			// 	    + " -usrc " + targetUpdatedDOTFilePath; test/myClassDiagram2myRelational-trace/ClassDiagram2Relational-target-updated.dot
			// 	Runtime.getRuntime().exec(
			// 	  bx_contract_commandline						  
			// 							  );

			// E.1 Backward UnCAL
			// 	String bwd_uncal_commandline = groundtram.getPath() + "bwd_uncal -t"
			// 		+ " -db "  + sourceOriginalDOTFilePath e.g. test/myClassDiagram2myRelational-trace/myClassDiagram.dot
			// 		+ " -udot "  + sourceUpdatedDOTFilePath e.g. test/myClassDiagram2myRelational-trace/myClassDiagram-updated.dot
			// 		+ " -dot " + targetUpdatedDOTFilePath e.g. test/myClassDiagram2myRelational-trace/ClassDiagram2Relational-target-updated.dot
			// 		+ " -xg "  + targetXGFilePath e.g. test/myClassDiagram2myRelational-trace/ClassDiagram2Relational.xg
			// 		+ " -ei "  + targetEIFilePath; e.g. test/myClassDiagram2myRelational-trace/ClassDiagram2Relational.ei
			// 	Runtime.getRuntime().exec(
			// 							  bwd_uncal_commandline 
			// 							  );

			// F.1 DOT2XMI
			// 	String dot2xmi_commandline = atlgt.getPath() + "dot2xmi_command"
			// 		+ " -dot " + sourceUpdatedDOTFilePath e.g. test/myClassDiagram2myRelational-trace/myClassDiagram-updated.dot
			// 		+ " -xmi " + sourceXMIFilePath e.g. test/myClassDiagram.xmi
			// 		+ " -km3 " + sourceKm3Path e.g. test/myClassDiagram2myRelational-trace/ClassDiagram.km3
			// 		+ " -pkg " + sourceMetaModelName; ClassDiagram
			// 	Runtime.getRuntime().exec(
			// 	  dot2xmi_commandline
			// 							  );
            
        }

        System.out.println("ATL-GT: Successfully executed");
        System.out.println(context.tempDirectory());
    }
}
