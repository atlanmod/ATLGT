/**
 */
package org.eclipse.m2m.km3.primitives.impl;

import org.eclipse.emf.ecore.EDataType;
import org.eclipse.emf.ecore.EPackage;

import org.eclipse.emf.ecore.impl.EPackageImpl;

import org.eclipse.m2m.km3.Km3Package;

import org.eclipse.m2m.km3.impl.Km3PackageImpl;

import org.eclipse.m2m.km3.primitives.Km3PrimitivesFactory;
import org.eclipse.m2m.km3.primitives.Km3PrimitivesPackage;

/**
 * <!-- begin-user-doc -->
 * An implementation of the model <b>Package</b>.
 * <!-- end-user-doc -->
 * @generated
 */
public class Km3PrimitivesPackageImpl extends EPackageImpl implements Km3PrimitivesPackage {
	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	private EDataType booleanEDataType = null;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	private EDataType integerEDataType = null;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	private EDataType stringEDataType = null;

	/**
	 * Creates an instance of the model <b>Package</b>, registered with
	 * {@link org.eclipse.emf.ecore.EPackage.Registry EPackage.Registry} by the package
	 * package URI value.
	 * <p>Note: the correct way to create the package is via the static
	 * factory method {@link #init init()}, which also performs
	 * initialization of the package, or returns the registered package,
	 * if one already exists.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see org.eclipse.emf.ecore.EPackage.Registry
	 * @see org.eclipse.m2m.km3.primitives.Km3PrimitivesPackage#eNS_URI
	 * @see #init()
	 * @generated
	 */
	private Km3PrimitivesPackageImpl() {
		super(eNS_URI, Km3PrimitivesFactory.eINSTANCE);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	private static boolean isInited = false;

	/**
	 * Creates, registers, and initializes the <b>Package</b> for this model, and for any others upon which it depends.
	 * 
	 * <p>This method is used to initialize {@link Km3PrimitivesPackage#eINSTANCE} when that field is accessed.
	 * Clients should not invoke it directly. Instead, they should simply access that field to obtain the package.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #eNS_URI
	 * @see #createPackageContents()
	 * @see #initializePackageContents()
	 * @generated
	 */
	public static Km3PrimitivesPackage init() {
		if (isInited) return (Km3PrimitivesPackage)EPackage.Registry.INSTANCE.getEPackage(Km3PrimitivesPackage.eNS_URI);

		// Obtain or create and register package
		Km3PrimitivesPackageImpl theKm3PrimitivesPackage = (Km3PrimitivesPackageImpl)(EPackage.Registry.INSTANCE.get(eNS_URI) instanceof Km3PrimitivesPackageImpl ? EPackage.Registry.INSTANCE.get(eNS_URI) : new Km3PrimitivesPackageImpl());

		isInited = true;

		// Obtain or create and register interdependencies
		Km3PackageImpl theKm3Package = (Km3PackageImpl)(EPackage.Registry.INSTANCE.getEPackage(Km3Package.eNS_URI) instanceof Km3PackageImpl ? EPackage.Registry.INSTANCE.getEPackage(Km3Package.eNS_URI) : Km3Package.eINSTANCE);

		// Create package meta-data objects
		theKm3PrimitivesPackage.createPackageContents();
		theKm3Package.createPackageContents();

		// Initialize created meta-data
		theKm3PrimitivesPackage.initializePackageContents();
		theKm3Package.initializePackageContents();

		// Mark meta-data to indicate it can't be changed
		theKm3PrimitivesPackage.freeze();

  
		// Update the registry and return the package
		EPackage.Registry.INSTANCE.put(Km3PrimitivesPackage.eNS_URI, theKm3PrimitivesPackage);
		return theKm3PrimitivesPackage;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EDataType getBoolean() {
		return booleanEDataType;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EDataType getInteger() {
		return integerEDataType;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EDataType getString() {
		return stringEDataType;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public Km3PrimitivesFactory getKm3PrimitivesFactory() {
		return (Km3PrimitivesFactory)getEFactoryInstance();
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	private boolean isCreated = false;

	/**
	 * Creates the meta-model objects for the package.  This method is
	 * guarded to have no affect on any invocation but its first.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public void createPackageContents() {
		if (isCreated) return;
		isCreated = true;

		// Create data types
		booleanEDataType = createEDataType(BOOLEAN);
		integerEDataType = createEDataType(INTEGER);
		stringEDataType = createEDataType(STRING);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	private boolean isInitialized = false;

	/**
	 * Complete the initialization of the package and its meta-model.  This
	 * method is guarded to have no affect on any invocation but its first.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public void initializePackageContents() {
		if (isInitialized) return;
		isInitialized = true;

		// Initialize package
		setName(eNAME);
		setNsPrefix(eNS_PREFIX);
		setNsURI(eNS_URI);

		// Initialize data types
		initEDataType(booleanEDataType, Boolean.class, "Boolean", IS_SERIALIZABLE, !IS_GENERATED_INSTANCE_CLASS);
		initEDataType(integerEDataType, Integer.class, "Integer", IS_SERIALIZABLE, !IS_GENERATED_INSTANCE_CLASS);
		initEDataType(stringEDataType, String.class, "String", IS_SERIALIZABLE, !IS_GENERATED_INSTANCE_CLASS);

		// Create resource
		createResource(eNS_URI);
	}

} //Km3PrimitivesPackageImpl
