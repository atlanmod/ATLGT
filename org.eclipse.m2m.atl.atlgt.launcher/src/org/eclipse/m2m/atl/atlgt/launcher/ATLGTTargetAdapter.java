package org.eclipse.m2m.atl.atlgt.launcher;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.URL;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

import org.eclipse.core.resources.IWorkspace;
import org.eclipse.core.resources.ResourcesPlugin;
import org.eclipse.core.runtime.FileLocator;
import org.eclipse.core.runtime.Path;
import org.eclipse.core.runtime.Platform;
import org.eclipse.emf.common.notify.Notification;
import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.util.EContentAdapter;
import org.eclipse.emf.ecore.xmi.XMLResource;
import org.eclipse.m2m.atl.reactive.EMFVMLazyTransformation;
import org.eclipse.m2m.atl.reactive.model.LazyModelDynamicEObjectImpl;
import org.eclipse.m2m.atl.reactive.model.LazyModelNotification;

/**
 * Target Reactive Adapter handles notification events produced by Lazy Model
 * {@link LazyModelDynamicEObjectImpl} elements, such as GET and FLAG_CHANGE events. Then, a given running
 * reactive transformation is used to react to such events, namely, launching the needed rules and bindings to
 * get the target element.
 * 
 * @author Salvador Martínez
 */
public class ATLGTTargetAdapter extends EContentAdapter {

	EMFVMLazyTransformation transformation;

	private boolean handleCustomNotification = true;

	private Map<String, Object> saveOptions = new HashMap<String, Object>();

	String updatedXMILocation;

	XMLResource.URIHandler uriHandler = new XMLResource.URIHandler() {

		public URI deresolve(URI uri) {
			// URI u = URI.createURI("");
			URI u = URI.createURI('#' + uri.fragment());
			return u;
		}

		public URI resolve(URI uri) {
			return null;
		}

		public void setBaseURI(URI uri) {
		}
	};

	public ATLGTTargetAdapter(EMFVMLazyTransformation transformation, String updatedXMILocation, EObject root) {
		super();
		this.transformation = transformation;
		saveOptions.put(XMLResource.OPTION_URI_HANDLER, uriHandler);
		this.updatedXMILocation = updatedXMILocation;
	}

	public void notifyChanged(Notification notification) {
		super.notifyChanged(notification);
		int eventType = notification.getEventType();
		LazyModelDynamicEObjectImpl notifier = null;
		switch (eventType) {
			case LazyModelNotification.SET:
				if (isHandleCustomNotification()) {
					// 4.1 Save Model: <TransformationName>-updated.xmi
					notifier = (LazyModelDynamicEObjectImpl)notification.getNotifier();
					setHandleCustomNotification(false);
					try {
						notifier.eResource().save(new FileOutputStream(new File(updatedXMILocation)),
								saveOptions);
					} catch (IOException e) {
						e.printStackTrace();
					}
					setHandleCustomNotification(true);

					try {
					// PATHS
					IWorkspace workspace = ResourcesPlugin.getWorkspace();
					// 	File workspaceDirectory = workspace.getRoot().getLocation().toFile();

					URL atlgt = FileLocator.resolve(FileLocator.find(
					      Platform.getBundle("org.eclipse.m2m.atl.atlgt.launcher"), new Path("lib" + File.separator
						+ "ATL-GT" + File.separator + "src"), Collections.EMPTY_MAP));

					URL groundtram = FileLocator.resolve(FileLocator.find(
					       Platform.getBundle("org.eclipse.m2m.atl.atlgt.launcher"), new Path("lib" + File.separator
						+ "ground_tram-0.9.5" + File.separator + "src"), Collections.EMPTY_MAP));

					// 	String atlFilePath = workspaceDirectory.getAbsolutePath() + options.get("ATL_FILE").toString();
					// 	String sourceXMIFilePath = workspaceDirectory.getAbsolutePath()
					// 		+ ((EMFModel)this.sourceModel).getResource().getURI().toPlatformString(true);
					// 	String sourceOriginalDOTFilePath = sourceXMIFilePath.substring(0, sourceXMIFilePath.length() - 4)
					// 		+ "_org.dot";
					// 	String sourceDOTFilePath = sourceXMIFilePath.substring(0, sourceXMIFilePath.length() - 4)
					// 		+ ".dot";
					// 	String sourceUpdatedDOTFilePath = sourceXMIFilePath.substring(0, sourceXMIFilePath.length() - 4)
					// 			+ "-updated.dot";
					// 	String targetXMIFilePath = atlFilePath.substring(0, atlFilePath.length() - 4) + "-target.xmi";
					// 	String targetUpdatedXMIFilePath = atlFilePath.substring(0, atlFilePath.length() - 4) + "-updated.xmi";

					// 	String targetDOTFilePath = targetXMIFilePath.substring(0, targetXMIFilePath.length() - 4)
					// 		+ ".dot";
					// 	String targetUpdatedDOTFilePath = atlFilePath.substring(0, atlFilePath.length() - 4) + "-updated.dot";
					// 	String targetDOTNormalFilePath = targetDOTFilePath.substring(0, targetDOTFilePath.length() - 4)
					// 		+ "-normal.dot";
					// 	String targetUpdatedNormalDOTFilePath = targetDOTFilePath.substring(0, targetDOTFilePath.length() - 4)
					// 		+ "-updated-normal.dot";
					// 	String targetXGFilePath = targetXMIFilePath.substring(0, targetXMIFilePath.length() - 4) + ".xg";
					// 	String targetEIFilePath = targetXMIFilePath.substring(0, targetXMIFilePath.length() - 4) + ".ei";
					// 	String targetMetaModelName = "Relational";   // FIXME! It should be obtained algorithmically
					// 	String sourceMetaModelName = "ClassDiagram"; // FIXME! It should be obtained algorithmically
					// 	File atlFilePathAbst = new File(atlFilePath);
					// 	String examplePath = atlFilePathAbst.getParentFile().getAbsolutePath();
					// 	String sourceKm3Path = examplePath + File.separator + sourceMetaModelName + File.separator + sourceMetaModelName + ".km3";
					// 	String targetKm3Path = examplePath + File.separator + targetMetaModelName + File.separator + targetMetaModelName + "-relaxed.km3";
						
					// // 4.2 XMI2DOT (inputs: <TransformationName>-updated.xmi, <TransformationName>-target.dot)
					// // -> <TransformationName>-updated.dot
					// 	String xmi2dot_commandline = atlgt.getPath() + "xmi2dot_generic_command"
					// 		+ " -xmi " + targetUpdatedXMIFilePath
					// 		+ " -dot " + targetUpdatedNormalDOTFilePath
					// 		+ " -odot " + targetDOTNormalFilePath
					// 		+ " -km3 " + targetKm3Path
					// 		+ " -pkg " + targetMetaModelName;
					// 	Runtime.getRuntime().exec(
					// 	  xmi2dot_commandline
					//     );

					// // 4.3 Denormalization
					// 	String bx_contract_commandline = groundtram.getPath() + "bx_contract -batch"
					// 		+ " -src "  + targetDOTFilePath
					// 		+ " -dst "  + targetUpdatedNormalDOTFilePath
					// 	    + " -usrc " + targetUpdatedDOTFilePath;
					// 	Runtime.getRuntime().exec(
					// 	  bx_contract_commandline						  
					// 							  );

					// // 5. Backward UnCAL
					// 	String bwd_uncal_commandline = groundtram.getPath() + "bwd_uncal -t"
					// 		+ " -db "  + sourceOriginalDOTFilePath
					// 		+ " -udot "  + sourceUpdatedDOTFilePath
					// 		+ " -dot " + targetUpdatedDOTFilePath
					// 		+ " -xg "  + targetXGFilePath 
					// 		+ " -ei "  + targetEIFilePath;
					// 	Runtime.getRuntime().exec(
					// 							  bwd_uncal_commandline 
					// 							  );

					// // 6. DOT2XMI
					// 	String dot2xmi_commandline = atlgt.getPath() + "dot2xmi_command"
					// 		+ " -dot " + sourceUpdatedDOTFilePath
					// 		+ " -xmi " + sourceXMIFilePath
					// 		+ " -km3 " + sourceKm3Path
					// 		+ " -pkg " + sourceMetaModelName;
					// 	Runtime.getRuntime().exec(
					// 	  dot2xmi_commandline
					// 							  );

						
					} catch (FileNotFoundException e) {
					    e.printStackTrace();
					} catch (IOException e) {
					    e.printStackTrace();
					}

				}

				break;
			default:
				break;
		}
	}

	public void setHandleCustomNotification(boolean handleCustomNotification) {
		this.handleCustomNotification = handleCustomNotification;
	}

	public boolean isHandleCustomNotification() {
		return handleCustomNotification;
	}
}
