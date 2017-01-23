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
import org.eclipse.emf.ecore.xmi.impl.XMIResourceFactoryImpl;
import org.eclipse.m2m.atl.emftvm.EmftvmFactory;
import org.eclipse.m2m.atl.emftvm.ExecEnv;
import org.eclipse.m2m.atl.emftvm.Model;
import org.eclipse.m2m.atl.emftvm.impl.resource.EMFTVMResourceFactoryImpl;
import org.eclipse.m2m.atl.emftvm.util.DefaultModuleResolver;
import org.eclipse.m2m.atl.emftvm.util.ModuleResolver;
import org.eclipse.m2m.atl.emftvm.util.TimingData;
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
        Resource.Factory.Registry.INSTANCE.getExtensionToFactoryMap().put("xmi", new XMIResourceFactoryImpl());
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
     * Transforms a {@code source} model to another, using an ATL {@code module}.
     *
     * @param source          the model to transform
     * @param target          the result of the transformation
     * @param sourceMetamodel the metamodel of the {@code source}
     * @param targetMetamodel the metamodel of the {@code target}
     * @param directory       the module directory
     * @param module          the ATL module used to the transformation
     */
    public static void transform(URI source, URI target, URI sourceMetamodel, URI targetMetamodel, URI directory, String module) {
        if (!Objects.equals(source.fileExtension(), "xmi") || !Objects.equals(target.fileExtension(), "xmi")) {
            throw new IllegalArgumentException("Only XMI models can be transformed");
        }

        System.out.println("Transformation of '" + source + "' to '" + target + "' by using the module '" + module + "' @ " + directory);

        EmftvmFactory factory = EmftvmFactory.eINSTANCE;
        ExecEnv env = factory.createExecEnv();

        ResourceSet resourceSet = new ResourceSetImpl();
        resourceSet.getResourceFactoryRegistry().getExtensionToFactoryMap().put("xmi", new XMIResourceFactoryImpl());
		
        resourceSet.getResourceFactoryRegistry().getExtensionToFactoryMap().put("emftvm", new EMFTVMResourceFactoryImpl());
        resourceSet.getResourceFactoryRegistry().getExtensionToFactoryMap().put("ecore", new EcoreResourceFactoryImpl());
		
        // Load metamodels
        // TODO Dynamically find the name of the metamodel
        org.eclipse.m2m.atl.emftvm.Metamodel inMetamodel = factory.createMetamodel();
        inMetamodel.setResource(resourceSet.getResource(sourceMetamodel, true));
        env.registerMetaModel("ClassDiagram", inMetamodel);

        org.eclipse.m2m.atl.emftvm.Metamodel outMetamodel = factory.createMetamodel();
        outMetamodel.setResource(resourceSet.getResource(targetMetamodel, true));
        env.registerMetaModel("Relational", outMetamodel);
        
        Resource r = resourceSet.getResource(sourceMetamodel, true);
        for( EObject eObject : r.getContents()){
        	 if (eObject instanceof EPackage) {
     	        EPackage p = (EPackage)eObject;

     	        EPackage.Registry.INSTANCE.put(p.getNsURI(), p);
     	        
     	    }
        }
	   
	    // please check
        Resource r2 = resourceSet.getResource(targetMetamodel, true);
        for( EObject eObject : r2.getContents()){
        	 if (eObject instanceof EPackage) {
     	        EPackage p = (EPackage)eObject;

     	        EPackage.Registry.INSTANCE.put(p.getNsURI(), p);
     	        
     	    }
        }
	    
        

        // TODO If needed

        // Load models

        Model inModel = factory.createModel();
        inModel.setResource(resourceSet.getResource(source, true));
        env.registerInputModel("IN", inModel);

        Model outModel = factory.createModel();
        outModel.setResource(resourceSet.createResource(target));
        env.registerOutputModel("OUT", outModel);

        // Run transformation

        ModuleResolver moduleResolver = new DefaultModuleResolver(directory.toString() + "/", resourceSet);
        TimingData td = new TimingData();
        env.loadModule(moduleResolver, module);
        td.finishLoading();
        env.run(td);
        td.finish();

        try {
            outModel.getResource().save(Collections.emptyMap());
        }
        catch (IOException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    
	private String lazyMetamodelRegistration(String metamodelPath){
		
		Resource.Factory.Registry.INSTANCE.getExtensionToFactoryMap().put("ecore", new EcoreResourceFactoryImpl());
   	
	    ResourceSet rs = new ResourceSetImpl();
	    // Enables extended meta-data, weird we have to do this but well...
	    final ExtendedMetaData extendedMetaData = new BasicExtendedMetaData(EPackage.Registry.INSTANCE);
	    rs.getLoadOptions().put(XMLResource.OPTION_EXTENDED_META_DATA, extendedMetaData);
	
	    Resource r = rs.getResource(URI.createFileURI(metamodelPath), true);
	    EObject eObject = r.getContents().get(0);
	    // A meta-model might have multiple packages we assume the main package is the first one listed
	    if (eObject instanceof EPackage) {
	        EPackage p = (EPackage)eObject;
	        System.out.println(p.getNsURI());
	        EPackage.Registry.INSTANCE.put(p.getNsURI(), p);
	        return p.getNsURI();
	    }
	    return null;
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
