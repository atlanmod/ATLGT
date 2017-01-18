package org.eclipse.m2m.atl.atlgt.metamodel;

import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.EPackage;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.emf.ecore.resource.ResourceSet;
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl;
import org.eclipse.emf.ecore.xmi.impl.EcoreResourceFactoryImpl;

import static java.util.Objects.isNull;

public class MetamodelHelpers {

    public static void registerPackage(String metamodelPath) throws Exception {

        // Load metamodels
        ResourceSet resourceSet = new ResourceSetImpl();
        resourceSet.getResourceFactoryRegistry().getExtensionToFactoryMap().put("ecore", new EcoreResourceFactoryImpl());

        //Metamodel metaModel = EmftvmFactory.eINSTANCE.createMetamodel();
        //metaModel.setResource(resourceSet.getResource(URI.createURI(metamodelPath), true));

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
}
