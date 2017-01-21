/**
 */
package org.eclipse.m2m.km3.impl;

import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.EPackage;

import org.eclipse.emf.ecore.impl.EFactoryImpl;

import org.eclipse.emf.ecore.plugin.EcorePlugin;

import org.eclipse.m2m.km3.Attribute;
import org.eclipse.m2m.km3.Classifier;
import org.eclipse.m2m.km3.DataType;
import org.eclipse.m2m.km3.EnumLiteral;
import org.eclipse.m2m.km3.Enumeration;
import org.eclipse.m2m.km3.Km3Factory;
import org.eclipse.m2m.km3.Km3Package;
import org.eclipse.m2m.km3.Metamodel;
import org.eclipse.m2m.km3.Operation;
import org.eclipse.m2m.km3.Parameter;
import org.eclipse.m2m.km3.Reference;
import org.eclipse.m2m.km3.StructuralFeature;
import org.eclipse.m2m.km3.TemplateParameter;
import org.eclipse.m2m.km3.TypedElement;

/**
 * <!-- begin-user-doc -->
 * An implementation of the model <b>Factory</b>.
 * <!-- end-user-doc -->
 * @generated
 */
public class Km3FactoryImpl extends EFactoryImpl implements Km3Factory {
	/**
	 * Creates the default factory implementation.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public static Km3Factory init() {
		try {
			Km3Factory theKm3Factory = (Km3Factory)EPackage.Registry.INSTANCE.getEFactory(Km3Package.eNS_URI);
			if (theKm3Factory != null) {
				return theKm3Factory;
			}
		}
		catch (Exception exception) {
			EcorePlugin.INSTANCE.log(exception);
		}
		return new Km3FactoryImpl();
	}

	/**
	 * Creates an instance of the factory.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public Km3FactoryImpl() {
		super();
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public EObject create(EClass eClass) {
		switch (eClass.getClassifierID()) {
			case Km3Package.CLASSIFIER: return createClassifier();
			case Km3Package.DATA_TYPE: return createDataType();
			case Km3Package.ENUMERATION: return createEnumeration();
			case Km3Package.ENUM_LITERAL: return createEnumLiteral();
			case Km3Package.TEMPLATE_PARAMETER: return createTemplateParameter();
			case Km3Package.CLASS: return createClass();
			case Km3Package.TYPED_ELEMENT: return createTypedElement();
			case Km3Package.STRUCTURAL_FEATURE: return createStructuralFeature();
			case Km3Package.ATTRIBUTE: return createAttribute();
			case Km3Package.REFERENCE: return createReference();
			case Km3Package.OPERATION: return createOperation();
			case Km3Package.PARAMETER: return createParameter();
			case Km3Package.PACKAGE: return createPackage();
			case Km3Package.METAMODEL: return createMetamodel();
			default:
				throw new IllegalArgumentException("The class '" + eClass.getName() + "' is not a valid classifier");
		}
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public Classifier createClassifier() {
		ClassifierImpl classifier = new ClassifierImpl();
		return classifier;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public DataType createDataType() {
		DataTypeImpl dataType = new DataTypeImpl();
		return dataType;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public Enumeration createEnumeration() {
		EnumerationImpl enumeration = new EnumerationImpl();
		return enumeration;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EnumLiteral createEnumLiteral() {
		EnumLiteralImpl enumLiteral = new EnumLiteralImpl();
		return enumLiteral;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public TemplateParameter createTemplateParameter() {
		TemplateParameterImpl templateParameter = new TemplateParameterImpl();
		return templateParameter;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public org.eclipse.m2m.km3.Class createClass() {
		ClassImpl class_ = new ClassImpl();
		return class_;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public TypedElement createTypedElement() {
		TypedElementImpl typedElement = new TypedElementImpl();
		return typedElement;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public StructuralFeature createStructuralFeature() {
		StructuralFeatureImpl structuralFeature = new StructuralFeatureImpl();
		return structuralFeature;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public Attribute createAttribute() {
		AttributeImpl attribute = new AttributeImpl();
		return attribute;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public Reference createReference() {
		ReferenceImpl reference = new ReferenceImpl();
		return reference;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public Operation createOperation() {
		OperationImpl operation = new OperationImpl();
		return operation;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public Parameter createParameter() {
		ParameterImpl parameter = new ParameterImpl();
		return parameter;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public org.eclipse.m2m.km3.Package createPackage() {
		PackageImpl package_ = new PackageImpl();
		return package_;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public Metamodel createMetamodel() {
		MetamodelImpl metamodel = new MetamodelImpl();
		return metamodel;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public Km3Package getKm3Package() {
		return (Km3Package)getEPackage();
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @deprecated
	 * @generated
	 */
	@Deprecated
	public static Km3Package getPackage() {
		return Km3Package.eINSTANCE;
	}

} //Km3FactoryImpl
