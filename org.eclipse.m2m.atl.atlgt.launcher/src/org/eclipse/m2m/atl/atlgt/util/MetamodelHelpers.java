package org.eclipse.m2m.atl.atlgt.util;

import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.EPackage;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.emf.ecore.resource.ResourceSet;
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl;
import org.eclipse.emf.ecore.util.BasicExtendedMetaData;
import org.eclipse.emf.ecore.util.ExtendedMetaData;
import org.eclipse.emf.ecore.xmi.XMLResource;
import org.eclipse.emf.ecore.xmi.impl.EcoreResourceFactoryImpl;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.stream.StreamSupport;

import static java.util.Objects.isNull;

public class MetamodelHelpers {

    private static final String ECORE = "ecore";

    public static void registerPackage(String metamodelPath) {
        Resource resource = getResourceFrom(URI.createURI(metamodelPath));

        EObject eObject = resource.getContents().get(0);
        if (EPackage.class.isInstance(eObject)) {
            EPackage ePackage = (EPackage) eObject;

            // Register EPackage
            String nsURI = ePackage.getNsURI();
            if (isNull(nsURI)) {
                nsURI = ePackage.getName();
                ePackage.setNsURI(nsURI);
            }
            EPackage.Registry.INSTANCE.put(nsURI, ePackage);
        }

        System.out.println("Registered metamodel: " + metamodelPath);
    }

    public static Iterable<EPackage> readEcore(String metamodelPath) {
        List<EPackage> packages = new ArrayList<>();

        Resource resource = getResourceFrom(URI.createURI(metamodelPath));

        resource.getContents().stream()
                .filter(EPackage.class::isInstance)
                .map(eObject -> (EPackage) eObject)
                .forEach(packages::add);

        return packages;
    }

    public static void relax(Iterable<EPackage> packages, String outputDirectory, String metamodelPath) throws IOException {
    	String outputName = new File(metamodelPath).getName();
    	if(outputName.lastIndexOf(".") != -1){
    		outputName = outputName.substring(0, outputName.lastIndexOf("."));
    	}
    	
        String outputFile = outputDirectory + outputName + "-relaxed.ecore";

        Resource resource = createResourceFrom(URI.createURI(outputFile));

        StreamSupport.stream(packages.spliterator(), false)
                .peek(ePackage -> ePackage.getEClassifiers().stream()
                        .filter(EClass.class::isInstance)
                        .map(eClassifier -> (EClass) eClassifier)
                        .forEach(eClass -> eClass.getEAllStructuralFeatures()
                                .forEach(sf -> sf.setLowerBound(0))))
                .forEach(ePackage -> resource.getContents().add(ePackage));

        resource.save(Collections.emptyMap());
    }

    private static Resource getResourceFrom(URI uri) {
        return newResourceSet().getResource(uri, true);
    }

    private static Resource createResourceFrom(URI uri) {
        return newResourceSet().createResource(uri);
    }

    private static ResourceSet newResourceSet() {
        Resource.Factory.Registry.INSTANCE.getExtensionToFactoryMap().put(ECORE, new EcoreResourceFactoryImpl());

        final ResourceSet resourceSet = new ResourceSetImpl();

        // Enables extended meta-data, for EMFTVM.
        final ExtendedMetaData extendedMetaData = new BasicExtendedMetaData(EPackage.Registry.INSTANCE);
        resourceSet.getLoadOptions().put(XMLResource.OPTION_EXTENDED_META_DATA, extendedMetaData);

        resourceSet.getResourceFactoryRegistry().getExtensionToFactoryMap().put(ECORE, new EcoreResourceFactoryImpl());
        return resourceSet;
    }
}
