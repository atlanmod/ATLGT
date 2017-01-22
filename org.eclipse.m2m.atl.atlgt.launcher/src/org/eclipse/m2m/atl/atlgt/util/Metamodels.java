package org.eclipse.m2m.atl.atlgt.util;

import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.ENamedElement;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.EPackage;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.emf.ecore.resource.ResourceSet;
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl;
import org.eclipse.emf.ecore.util.BasicExtendedMetaData;
import org.eclipse.emf.ecore.util.ExtendedMetaData;
import org.eclipse.emf.ecore.xmi.XMLResource;
import org.eclipse.emf.ecore.xmi.impl.EcoreResourceFactoryImpl;

import java.io.IOException;
import java.util.Collections;
import java.util.stream.Collectors;
import java.util.stream.StreamSupport;

import static java.util.Objects.isNull;

/**
 * Utility methods for working with Ecore metamodels.
 */
public final class Metamodels {

    private Metamodels() {
        throw new IllegalStateException("This class should not be initialized");
    }

    /**
     * Registers a metamodel to the {@link EPackage.Registry}.
     *
     * @param metamodel the metamodel to register
     */
    public static void registerPackage(URI metamodel) {
        Resource resource = getResourceFrom(metamodel);

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

        System.out.println("Registered metamodel: " + metamodel);
    }

    /**
     * ???
     *
     * @param metamodel the metamodel to read
     *
     * @return ???
     */
    public static Iterable<EPackage> readEcore(URI metamodel) {
        Resource resource = getResourceFrom(metamodel);

        Iterable<EPackage> packages = resource.getContents().stream()
                .filter(EPackage.class::isInstance)
                .map(eObject -> (EPackage) eObject)
                .collect(Collectors.toList());

        System.out.println("EPackages in '" + metamodel + "': " +
                StreamSupport.stream(packages.spliterator(), false)
                        .map(ENamedElement::getName)
                        .collect(Collectors.joining(", ", "[", "]")));

        return packages;
    }

    /**
     * ???
     *
     * @param packages        ???
     * @param outputDirectory the output directory
     * @param metamodel       the metamodel to relax
     *
     * @return the path of the relaxed metamodel
     *
     * @throws IOException if a I/O error occurs
     */
    public static URI relax(Iterable<EPackage> packages, URI outputDirectory, URI metamodel) throws IOException {
        URI outputFile = outputDirectory.appendSegment(metamodel.lastSegment().replace(".ecore", "-relaxed.ecore"));

        Resource resource = createResourceFrom(outputFile);

        StreamSupport.stream(packages.spliterator(), false)
                .peek(ePackage -> ePackage.getEClassifiers().stream()
                        .filter(EClass.class::isInstance)
                        .map(eClassifier -> (EClass) eClassifier)
                        .forEach(eClass -> eClass.getEAllStructuralFeatures()
                                .forEach(sf -> sf.setLowerBound(0))))
                .forEach(ePackage -> resource.getContents().add(ePackage));

        resource.save(Collections.emptyMap());

        System.out.println("Relaxed metamodel of '" + metamodel + "' in " + outputFile);

        return outputFile;
    }

    /**
     * Returns the first {@link EPackage} instance of an Ecore {@code metamodel}.
     *
     * @param metamodel the Ecore metamodel
     *
     * @return the first {@link EPackage} of the {@code metamodel}
     *
     * @throws IllegalArgumentException if the first element if not an {@link EPackage}
     */
    public static EPackage firstPackage(URI metamodel) {
        EObject eObject = getResourceFrom(metamodel).getContents().get(0);
        if (EPackage.class.isInstance(eObject)) {
            return (EPackage) eObject;
        }
        else {
            throw new IllegalArgumentException("The first element is not an EPackage");
        }
    }

    private static Resource getResourceFrom(URI uri) {
        return newResourceSet().getResource(uri, true);
    }

    private static Resource createResourceFrom(URI uri) {
        return newResourceSet().createResource(uri);
    }

    private static ResourceSet newResourceSet() {
        Resource.Factory.Registry.INSTANCE.getExtensionToFactoryMap().put("ecore", new EcoreResourceFactoryImpl());

        final ResourceSet resourceSet = new ResourceSetImpl();

        // Enables extended meta-data, for EMFTVM.
        final ExtendedMetaData extendedMetaData = new BasicExtendedMetaData(EPackage.Registry.INSTANCE);
        resourceSet.getLoadOptions().put(XMLResource.OPTION_EXTENDED_META_DATA, extendedMetaData);

        return resourceSet;
    }
}
