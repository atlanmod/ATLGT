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
import org.eclipse.m2m.km3.Attribute;
import org.eclipse.m2m.km3.Class;
import org.eclipse.m2m.km3.DataType;
import org.eclipse.m2m.km3.Km3Factory;
import org.eclipse.m2m.km3.Metamodel;
import org.eclipse.m2m.km3.primitives.Km3PrimitivesPackage;

import java.io.IOException;
import java.util.Collections;
import java.util.Objects;
import java.util.Optional;
import java.util.stream.Collectors;
import java.util.stream.StreamSupport;

import static java.util.Objects.isNull;

/**
 * Utility methods for working with Ecore metamodels.
 */
public final class Metamodels {

    static {
        Resource.Factory.Registry.INSTANCE.getExtensionToFactoryMap().put("ecore", new EcoreResourceFactoryImpl());
    }

    private Metamodels() {
        throw new IllegalStateException("This class should not be initialized");
    }

    /**
     * Registers a metamodel to the {@link EPackage.Registry}.
     *
     * @param metamodel the metamodel to register
     */
    public static void register(URI metamodel) {
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
     * @return the {@code target} URI
     */
    public static URI relax(URI source, URI target) {
        if (!Objects.equals(source.fileExtension(), "ecore")) {
            throw new IllegalArgumentException("Only Ecore metamodels can be relaxed");
        }

        // Retreive all packages
        Iterable<EPackage> allPackages = getResourceFrom(source).getContents().stream()
                .filter(EPackage.class::isInstance)
                .map(eObject -> (EPackage) eObject)
                .collect(Collectors.toList());

        Resource resource = createResourceFrom(target);

        // Define the lowerBound to 0 for each feature
        StreamSupport.stream(allPackages.spliterator(), false)
                .peek(ePackage -> ePackage.getEClassifiers().stream()
                        .filter(EClass.class::isInstance)
                        .map(eClassifier -> (EClass) eClassifier)
                        .forEach(eClass -> eClass.getEAllStructuralFeatures()
                                .forEach(feature -> feature.setLowerBound(0))))
                .forEach(ePackage -> resource.getContents().add(ePackage));

        try {
            resource.save(Collections.emptyMap());
        }
        catch (IOException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }

        System.out.println("Relaxed metamodel of '" + source + "' in " + target);

        return target;
    }

    /**
     * Defines the {@code __xmiID__} attribute in each class of the given KM3 {@code metamodel}.
     *
     * @param metamodel the KM3 metamodel
     */
    public static void identify(URI metamodel) {
        if (!Objects.equals(metamodel.fileExtension(), "km3")) {
            throw new IllegalArgumentException("Only KM3 metamodels can be identified");
        }

        Resource resource = getResourceFrom(metamodel);

        Iterable<EObject> allContents = ((Metamodel) resource.getContents().get(0))::eAllContents;

        // Retreive the 'String' datatype
        final Optional<DataType> dataType = StreamSupport.stream(allContents.spliterator(), false)
                .filter(DataType.class::isInstance)
                .map(DataType.class::cast)
                .filter(datatype -> Objects.equals(datatype.getName(), Km3PrimitivesPackage.Literals.STRING.getName()))
                .findFirst();

        if (!dataType.isPresent()) {
            throw new NullPointerException(
                    "Unable to find the '" + Km3PrimitivesPackage.Literals.STRING.getName() + "' datatype");
        }

        // Add the '__xmiID__' attribute in each class
        StreamSupport.stream(allContents.spliterator(), false)
                .filter(Class.class::isInstance)
                .map(Class.class::cast)
                .forEach(clazz -> {
                    Attribute attr = Km3Factory.eINSTANCE.createAttribute();
                    attr.setName("__xmiID__");
                    attr.setType(dataType.get());
                    attr.setLower(0);
                    attr.setUpper(1);
                    clazz.getStructuralFeatures().add(attr);
                });

        try {
            resource.save(Collections.emptyMap());
        }
        catch (IOException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }

        System.out.println("Identified metamodel of '" + metamodel);
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

    /**
     * Returns the {@link Resource} resolved by the {@code uri}.
     *
     * @param uri the URI to resolve
     *
     * @return the {@link Resource} resolved by the URI, or {@code null} if there isn't one and it's not being demand
     * loaded
     */
    private static Resource getResourceFrom(URI uri) {
        return newResourceSet().getResource(uri, true);
    }

    /**
     * Creates a new {@link Resource}, of the appropriate type, and returns it.
     *
     * @param uri the URI of the resource to create
     *
     * @return a new {@link Resource}, or {@code null} if no factory is registered
     */
    private static Resource createResourceFrom(URI uri) {
        return newResourceSet().createResource(uri);
    }

    /**
     * Creates a new initialized {@link ResourceSet}.
     *
     * @return a new {@link ResourceSet}
     */
    private static ResourceSet newResourceSet() {
        final ResourceSet resourceSet = new ResourceSetImpl();

        // Enables extended meta-data, for EMFTVM.
        final ExtendedMetaData extendedMetaData = new BasicExtendedMetaData(EPackage.Registry.INSTANCE);
        resourceSet.getLoadOptions().put(XMLResource.OPTION_EXTENDED_META_DATA, extendedMetaData);

        return resourceSet;
    }
}
