package org.eclipse.m2m.atl.atlgt.metamodel;

import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.EClassifier;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.EPackage;
import org.eclipse.emf.ecore.EStructuralFeature;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.emf.ecore.resource.ResourceSet;
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl;
import org.eclipse.emf.ecore.util.EcoreUtil;
import org.eclipse.emf.ecore.xmi.impl.EcoreResourceFactoryImpl;

import static java.util.Objects.isNull;

import java.util.ArrayList;
import java.util.List;

public class MetamodelHelpers {

    public static void registerPackage(String metamodelPath) throws Exception {

        // Load metamodels
        ResourceSet resourceSet = new ResourceSetImpl();
        resourceSet.getResourceFactoryRegistry().getExtensionToFactoryMap().put("ecore", new EcoreResourceFactoryImpl());

        Resource resource = resourceSet.getResource(URI.createURI(metamodelPath), true);
        EObject eObject = resource.getContents().get(0);
        if (eObject instanceof EPackage) {
            EPackage ePackage = (EPackage) eObject;

            // Register EPackage
            String nsURI = ePackage.getNsURI();
            if (isNull(nsURI)) {
                nsURI = ePackage.getName();
                ePackage.setNsURI(nsURI);
            }
            EPackage.Registry.INSTANCE.put(nsURI, ePackage);
        }
    }
    
	public static List<EPackage> readEcore(String metamodelPath) throws Exception{

		 ArrayList<EPackage> rtn =  new ArrayList<EPackage>();
		// Load metamodels
		ResourceSet rs = new ResourceSetImpl();
		rs.getResourceFactoryRegistry().getExtensionToFactoryMap().put("ecore", new EcoreResourceFactoryImpl());
		
		Resource r = rs.getResource(URI.createURI(metamodelPath), true);

		
		for(EObject o : r.getContents()){
			if (o instanceof EPackage) {
			    EPackage p = (EPackage) o;
			    rtn.add(p);
			}
		}
		
		
		
		return rtn;
		
	}
    
	public static void relax(List<EPackage> packages, String metamodelPath, String saveDir) throws Exception {
		String mmName = metamodelPath.substring(metamodelPath.lastIndexOf("/"), metamodelPath.length());
		String savePath = saveDir + mmName;
		
		URI uri = URI.createURI(savePath);
		ResourceSet rs = new ResourceSetImpl();
		rs.getResourceFactoryRegistry().getExtensionToFactoryMap().put("ecore", new EcoreResourceFactoryImpl());
		Resource xmiResource = rs.createResource(uri.appendFileExtension("relax"));
		
		for(EPackage p : packages){
			for (EClassifier cl : p.getEClassifiers()) {

				if (cl instanceof EClass) {
					EClass clazz = (EClass) cl;

					for (EStructuralFeature sf : clazz.getEAllStructuralFeatures()) {
						sf.setLowerBound(0);
					}
				}

			}
			
			ArrayList newPackageContainer = new ArrayList();
			newPackageContainer.add(p);
			xmiResource.getContents().addAll(newPackageContainer);
						
		}
		
		xmiResource.save(null);
		
	}
    
}
