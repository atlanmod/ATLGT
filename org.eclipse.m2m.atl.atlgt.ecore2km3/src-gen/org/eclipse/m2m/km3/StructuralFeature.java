/**
 */
package org.eclipse.m2m.km3;

import org.eclipse.emf.common.util.EList;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Structural Feature</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link org.eclipse.m2m.km3.StructuralFeature#getOwner <em>Owner</em>}</li>
 *   <li>{@link org.eclipse.m2m.km3.StructuralFeature#getSubsetOf <em>Subset Of</em>}</li>
 *   <li>{@link org.eclipse.m2m.km3.StructuralFeature#getDerivedFrom <em>Derived From</em>}</li>
 * </ul>
 *
 * @see org.eclipse.m2m.km3.Km3Package#getStructuralFeature()
 * @model
 * @generated
 */
public interface StructuralFeature extends TypedElement {
	/**
	 * Returns the value of the '<em><b>Owner</b></em>' container reference.
	 * It is bidirectional and its opposite is '{@link org.eclipse.m2m.km3.Class#getStructuralFeatures <em>Structural Features</em>}'.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Owner</em>' container reference isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Owner</em>' container reference.
	 * @see #setOwner(org.eclipse.m2m.km3.Class)
	 * @see org.eclipse.m2m.km3.Km3Package#getStructuralFeature_Owner()
	 * @see org.eclipse.m2m.km3.Class#getStructuralFeatures
	 * @model opposite="structuralFeatures" transient="false" ordered="false"
	 * @generated
	 */
	org.eclipse.m2m.km3.Class getOwner();

	/**
	 * Sets the value of the '{@link org.eclipse.m2m.km3.StructuralFeature#getOwner <em>Owner</em>}' container reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Owner</em>' container reference.
	 * @see #getOwner()
	 * @generated
	 */
	void setOwner(org.eclipse.m2m.km3.Class value);

	/**
	 * Returns the value of the '<em><b>Subset Of</b></em>' reference list.
	 * The list contents are of type {@link org.eclipse.m2m.km3.StructuralFeature}.
	 * It is bidirectional and its opposite is '{@link org.eclipse.m2m.km3.StructuralFeature#getDerivedFrom <em>Derived From</em>}'.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Subset Of</em>' reference list isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Subset Of</em>' reference list.
	 * @see org.eclipse.m2m.km3.Km3Package#getStructuralFeature_SubsetOf()
	 * @see org.eclipse.m2m.km3.StructuralFeature#getDerivedFrom
	 * @model opposite="derivedFrom" ordered="false"
	 * @generated
	 */
	EList<StructuralFeature> getSubsetOf();

	/**
	 * Returns the value of the '<em><b>Derived From</b></em>' reference list.
	 * The list contents are of type {@link org.eclipse.m2m.km3.StructuralFeature}.
	 * It is bidirectional and its opposite is '{@link org.eclipse.m2m.km3.StructuralFeature#getSubsetOf <em>Subset Of</em>}'.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Derived From</em>' reference list isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Derived From</em>' reference list.
	 * @see org.eclipse.m2m.km3.Km3Package#getStructuralFeature_DerivedFrom()
	 * @see org.eclipse.m2m.km3.StructuralFeature#getSubsetOf
	 * @model opposite="subsetOf" ordered="false"
	 * @generated
	 */
	EList<StructuralFeature> getDerivedFrom();

} // StructuralFeature