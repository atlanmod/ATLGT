package org.eclipse.m2m.atlgt.metamodel;

import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.EPackage;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.emf.ecore.resource.ResourceSet;
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl;
import org.eclipse.emf.ecore.xmi.impl.EcoreResourceFactoryImpl;

public class MetamodelHelpers {
	public static void registerPackage(String metamodelPath) throws Exception{
		// Load metamodels
		ResourceSet rs = new ResourceSetImpl();
		rs.getResourceFactoryRegistry().getExtensionToFactoryMap().put("ecore", new EcoreResourceFactoryImpl());
	
		//Metamodel metaModel = EmftvmFactory.eINSTANCE.createMetamodel();
		//metaModel.setResource(rs.getResource(URI.createURI(metamodelPath), true));
		
		Resource r = rs.getResource(URI.createURI(metamodelPath), true);
		EObject eObject = r.getContents().get(0);
		if (eObject instanceof EPackage) {
		    EPackage p = (EPackage)eObject;
		    // register epackage
		    String nsURI = p.getNsURI();
			if (nsURI == null) {
				nsURI = p.getName();
				p.setNsURI(nsURI);
			}
			EPackage.Registry.INSTANCE.put(nsURI, p);
		}
		
	}
}
