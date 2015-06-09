package org.eclipse.m2m.atl.atlgt.launcher;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.net.URL;
import java.util.Collections;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;

import org.eclipse.core.resources.IWorkspace;
import org.eclipse.core.resources.ResourcesPlugin;
import org.eclipse.core.runtime.FileLocator;
import org.eclipse.core.runtime.IProgressMonitor;
import org.eclipse.core.runtime.Path;
import org.eclipse.core.runtime.Platform;
import org.eclipse.emf.common.ui.URIEditorInput;
import org.eclipse.emf.common.util.EList;
import org.eclipse.emf.common.util.TreeIterator;
import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.EFactory;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.EPackage;
import org.eclipse.emf.ecore.EStructuralFeature;
import org.eclipse.emf.ecore.presentation.EcoreEditor;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.m2m.atl.core.IModel;
import org.eclipse.m2m.atl.core.emf.EMFModel;
import org.eclipse.m2m.atl.engine.emfvm.launch.EMFVMLauncher;
import org.eclipse.m2m.atl.reactive.EMFVMLazyTransformation;
import org.eclipse.m2m.atl.reactive.IncrementalEagerProgapationAdapter;
import org.eclipse.m2m.atl.reactive.ReactiveTransformationLauncher;
import org.eclipse.m2m.atl.reactive.model.LazyModelDynamicEObjectImpl;
import org.eclipse.m2m.atl.reactive.model.LazyModelFactory;
import org.eclipse.swt.widgets.Display;
import org.eclipse.ui.IEditorPart;
import org.eclipse.ui.IWorkbenchPage;
import org.eclipse.ui.PartInitException;
import org.eclipse.ui.PlatformUI;
import org.eclipse.ui.ide.IDE;

/**
 */
public class ATLGTLauncher extends EMFVMLauncher {
	ReactiveTransformationLauncher launcher = new ReactiveTransformationLauncher();

	private EMFModel sourceModel;

	private Resource sourceResource;

	private String sourceMetaModelName;

	private EMFModel targetModel;

	private Resource targetResource;

	private String targetMetaModelName;

	/**
	 * {@inheritDoc}
	 * 
	 * @see org.eclipse.m2m.atl.core.launch.ILauncher#addInModel(org.eclipse.m2m.atl.core.IModel,
	 *      java.lang.String, java.lang.String)
	 */
	public void addInModel(IModel model, String name, String referenceModelName) {
		model.setIsTarget(false);
		if (this.sourceModel == null) {
			this.sourceModel = (EMFModel)model;
			this.sourceResource = sourceModel.getResource();
		}
		if (this.sourceMetaModelName == null)
			this.sourceMetaModelName = referenceModelName;
		addModel(model, name, referenceModelName);
	}

	/**
	 * {@inheritDoc}
	 * 
	 * @see org.eclipse.m2m.atl.core.launch.ILauncher#addOutModel(org.eclipse.m2m.atl.core.IModel,
	 *      java.lang.String, java.lang.String)
	 */
	public void addOutModel(IModel model, String name, String referenceModelName) {
		model.setIsTarget(true);
		if (this.targetModel == null) {
			this.targetModel = (EMFModel)model;
			this.targetResource = targetModel.getResource();
		}
		if (this.targetMetaModelName == null)
			this.targetMetaModelName = referenceModelName;
		addModel(model, name, referenceModelName);
	}

	private void registerPackage(EPackage p) {
		System.out.println(p);
		String nsURI = p.getNsURI();
		if (nsURI == null) {
			nsURI = p.getName();
			p.setNsURI(nsURI);
		}
		EPackage.Registry.INSTANCE.put(nsURI, p);
	}

	private Set<EObject> getElementsByType(Resource extent, String type) {
		Set<EObject> ret = new HashSet<EObject>();
		for (Iterator<?> i = extent.getAllContents(); i.hasNext();) {
			EObject eo = (EObject)i.next();
			if (eo.eClass().getName().equals(type)) {
				ret.add(eo);
			}
		}
		return ret;
	}

	public Object launch(final String mode, final IProgressMonitor monitor,
			final Map<String, Object> options, final Object... modules) {
		try {
			// PATHS
			IWorkspace workspace = ResourcesPlugin.getWorkspace();
			File workspaceDirectory = workspace.getRoot().getLocation().toFile();

			URL atlgt = FileLocator.resolve(FileLocator.find(
					Platform.getBundle("org.eclipse.m2m.atl.atlgt.launcher"), new Path("lib" + File.separator
							+ "ATL-GT" + File.separator + "src"), Collections.EMPTY_MAP));

			URL groundtram = FileLocator.resolve(FileLocator.find(
					Platform.getBundle("org.eclipse.m2m.atl.atlgt.launcher"), new Path("lib" + File.separator
							+ "ground_tram-0.9.5" + File.separator + "src"), Collections.EMPTY_MAP));

			String atlFilePath = workspaceDirectory.getAbsolutePath() + options.get("ATL_FILE").toString();
			String asmFilePath = atlFilePath.substring(0, atlFilePath.length() - 4) + ".asm";
			String unqlFilePath = atlFilePath.substring(0, atlFilePath.length() - 4) + ".unql";

			String sourceXMIFilePath = workspaceDirectory.getAbsolutePath()
					+ ((EMFModel)this.sourceModel).getResource().getURI().toPlatformString(true);
			String sourceOriginalDOTFilePath = sourceXMIFilePath.substring(0, sourceXMIFilePath.length() - 4)
					+ "_org.dot";
			String sourceDOTFilePath = sourceXMIFilePath.substring(0, sourceXMIFilePath.length() - 4)
					+ ".dot";

			String targetXMIFilePath = atlFilePath.substring(0, atlFilePath.length() - 4) + "-target.xmi";
			String targetUpdatedXMIFilePath = atlFilePath.substring(0, atlFilePath.length() - 4) + "-updated.xmi";

			String targetDOTFilePath = targetXMIFilePath.substring(0, targetXMIFilePath.length() - 4)
					+ ".dot";
			String targetXGFilePath = targetXMIFilePath.substring(0, targetXMIFilePath.length() - 4) + ".xg";
			String targetEIFilePath = targetXMIFilePath.substring(0, targetXMIFilePath.length() - 4) + ".ei";

			// registering lazy model factory
			TreeIterator<EObject> ti = targetModel.getReferenceModel().getResource().getAllContents();
			EObject current;

			while (ti.hasNext()) {
				current = ti.next();
				if (current instanceof EPackage)
					((EPackage)current).setEFactoryInstance(new LazyModelFactory());
			}

			for (Iterator<EObject> it = getElementsByType(sourceModel.getReferenceModel().getResource(),
					"EPackage").iterator(); it.hasNext();) { //$NON-NLS-1$
				EPackage p = (EPackage)it.next();
				registerPackage(p);
			}
			
			for (Iterator<EObject> it = getElementsByType(targetModel.getReferenceModel().getResource(),
					"EPackage").iterator(); it.hasNext();) { //$NON-NLS-1$
				EPackage p = (EPackage)it.next();
				registerPackage(p);
			}

			// Initialization steps
			
			// A. Metamodel processing
			// A.1 Ecore2KM3
			// A.2 Ecore Relaxation
			// A.3 RelaxedEcore2RelaxedKM3

			// B. Transformation processing
			// B.1 ATLIDfier

			// B.2 ATL2UNQL
			File atlFilePathAbst = new File(atlFilePath);
			String idfiedatlFilePath = atlFilePath.substring(0, atlFilePath.length() - 4) + "-ids.atl";
			String examplePath = atlFilePathAbst.getParentFile().getAbsolutePath();
			String sourceKm3Path = examplePath + File.separator + sourceMetaModelName + File.separator + sourceMetaModelName + ".km3";
			String targetKm3Path = examplePath + File.separator + targetMetaModelName + File.separator + targetMetaModelName + "-relaxed.km3"; 
			String atl2unql_commandline = 
			atlgt.getPath() + "atl2unql -atl " + idfiedatlFilePath
			+ " -uq " + unqlFilePath 
			+ " -ikm3 " + sourceKm3Path
			+ " -ipkg " + sourceMetaModelName 
			+ " -okm3 " + targetKm3Path
			+ " -opkg " + targetMetaModelName;

			Runtime.getRuntime().exec(
				atl2unql_commandline
			  );

			// C. Editors
			Display.getDefault().syncExec(new Runnable() {
				public void run() {
					try {
						String atlFileRelativePath = options.get("ATL_FILE").toString();
						String targetXMIFilePath = "platform:/resource"
								+ atlFileRelativePath.substring(0, atlFileRelativePath.length() - 4)
								+ "-target.xmi";
						URI uri = URI.createURI(targetXMIFilePath);
						IWorkbenchPage page = PlatformUI.getWorkbench().getActiveWorkbenchWindow()
								.getActivePage();
						IEditorPart sourceEditor = IDE.openEditor(page, new URIEditorInput(
								((EMFModel)sourceModel).getResource().getURI()),
								"org.eclipse.emf.ecore.presentation.ReflectiveEditorID");
						IEditorPart targetEditor = IDE.openEditor(page, new URIEditorInput(uri),
								"org.eclipse.emf.ecore.presentation.ReflectiveEditorID");

						// extracting resources from editors
						sourceResource = ((EcoreEditor)sourceEditor).getEditingDomain().getResourceSet()
								.getResources().get(0);
						targetResource = ((EcoreEditor)targetEditor).getEditingDomain().getResourceSet()
								.getResources().get(0);
						sourceModel.setResource(sourceResource);
						targetModel.setResource(targetResource);

					} catch (PartInitException e) {
						e.printStackTrace();
					}
				}
			});

			// 
			
			// 1. XMI2DOT (think about shell interpreter, we choose the first package name but we support
			// only
			// one package)
			String xmi2dot_commandline = atlgt.getPath() + "xmi2dot_generic_command"
			+ " -xmi " + sourceXMIFilePath 
			+ " -dot " + sourceOriginalDOTFilePath
			+ " -km3 " + sourceKm3Path
			+ " -pkg " + sourceMetaModelName;
			Runtime.getRuntime().exec(
						  xmi2dot_commandline
					);
			
			// 2. Forward UnCAL
			String fwd_uncal_commandline = groundtram.getPath() + "fwd_uncal -ge -sb -cl -zn -fi -np -sa -t -rw -as"
			    + " -db "  + sourceOriginalDOTFilePath
			    + " -uq "  + unqlFilePath 
			    + " -dot " + targetDOTFilePath
			    + " -xg "  + targetXGFilePath 
			    + " -ei "  + targetEIFilePath;
			Runtime.getRuntime().exec(
				 fwd_uncal_commandline 
							);

			// 2.1 Normalize (up-to isomorphism)
			String targetDOTNormalFilePath = targetDOTFilePath.substring(0, targetDOTFilePath.length() - 4)
					+ "-normal.dot";
			String bx_contract_commandline = groundtram.getPath() + "bx_contract -batch"
			    + " -src " + targetDOTFilePath
			    + " -dst " + targetDOTNormalFilePath;
			Runtime.getRuntime().exec(
						  bx_contract_commandline						  
					);

			// 2.2 DOT2XMI
			// {DOT2XMI} -km3 ${KM3SRC} -pkg ${KM3PKG} -xmi ${XMI}  -dot ${DOT} ${OPT}
			String dot2xmi_commandline = atlgt.getPath() + "dot2xmi_command"

			+ " -dot " + targetDOTNormalFilePath
			+ " -xmi " + targetXMIFilePath
			+ " -km3 " + targetKm3Path
			+ " -pkg " + targetMetaModelName;
			Runtime.getRuntime().exec(
						  dot2xmi_commandline
					);

			// 3. Forward ATL

			launcher.initialize("ClassDiagram", "Relational", sourceModel, targetModel, asmFilePath);
			traverseContainment(launcher.getInitialTargetElement());

			// Add the listener to the target model

			IncrementalEagerProgapationAdapter inc = new IncrementalEagerProgapationAdapter(
					(EMFVMLazyTransformation)launcher.getTransformation());
			inc.setHandleCustomNotification(false);
			launcher.getInitialTargetElement().eAdapters().add(inc);
			inc.setHandleCustomNotification(true);

			launcher.getInitialTargetElement()
					.eAdapters()
					.add(new ATLGTTargetAdapter((EMFVMLazyTransformation)launcher.getTransformation(), targetUpdatedXMIFilePath,
							launcher.getInitialTargetElement()));
			
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		return null;
	}

	@SuppressWarnings("unchecked")
	public void test() {

		// Initial elements
		EObject classRoot = launcher.getInitialSourceElement();
		LazyModelDynamicEObjectImpl relationalRoot = launcher.getInitialTargetElement();

		// We get the target elements on-demand
		System.out.println("The lazily-computed elements of the Relational model are:");
		traverseContainment(relationalRoot);

		// Now, we add a package to the class diagram. This invalidates the
		// corresponding features of the relational model so that
		// they will be read again in the next access
		EStructuralFeature packages = classRoot.eClass().getEStructuralFeature("packages");
		EFactory f = classRoot.eClass().getEPackage().getEFactoryInstance();
		EClass packageClass = (EClass)classRoot.eClass().getEPackage().getEClassifier("Package");

		EObject newPackage = f.create(packageClass);
		newPackage.eSet(newPackage.eClass().getEStructuralFeature("name"), "p2");
		((EList<EObject>)classRoot.eGet(packages)).add(newPackage);

		// We get again the target elements on-demand
		System.out
				.println("After adding another package to the Class model, the elements of the Relational model are:");
		traverseContainment(relationalRoot);

	}

	private void traverseContainment(LazyModelDynamicEObjectImpl e) {
		System.out.println("Instance of " + e.eClass().getName());
		for (EStructuralFeature a : e.eClass().getEAllStructuralFeatures()) {
			System.out.println(a.getName() + ":" + e.eGet(a));
		}
		for (EObject o : e.eContents())
			traverseContainment((LazyModelDynamicEObjectImpl)o);
	}

}
