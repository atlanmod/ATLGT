/**
 */
package km3;

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
 *   <li>{@link km3.StructuralFeature#getOwner <em>Owner</em>}</li>
 *   <li>{@link km3.StructuralFeature#getSubsetOf <em>Subset Of</em>}</li>
 *   <li>{@link km3.StructuralFeature#getDerivedFrom <em>Derived From</em>}</li>
 * </ul>
 *
 * @see km3.KM3Package#getStructuralFeature()
 * @model
 * @generated
 */
public interface StructuralFeature extends TypedElement {
	/**
	 * Returns the value of the '<em><b>Owner</b></em>' reference.
	 * It is bidirectional and its opposite is '{@link km3.Class#getStructuralFeatures <em>Structural Features</em>}'.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Owner</em>' reference isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Owner</em>' reference.
	 * @see #setOwner(km3.Class)
	 * @see km3.KM3Package#getStructuralFeature_Owner()
	 * @see km3.Class#getStructuralFeatures
	 * @model opposite="structuralFeatures" ordered="false"
	 * @generated
	 */
	km3.Class getOwner();

	/**
	 * Sets the value of the '{@link km3.StructuralFeature#getOwner <em>Owner</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Owner</em>' reference.
	 * @see #getOwner()
	 * @generated
	 */
	void setOwner(km3.Class value);

	/**
	 * Returns the value of the '<em><b>Subset Of</b></em>' reference list.
	 * The list contents are of type {@link km3.StructuralFeature}.
	 * It is bidirectional and its opposite is '{@link km3.StructuralFeature#getDerivedFrom <em>Derived From</em>}'.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Subset Of</em>' reference list isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Subset Of</em>' reference list.
	 * @see km3.KM3Package#getStructuralFeature_SubsetOf()
	 * @see km3.StructuralFeature#getDerivedFrom
	 * @model opposite="derivedFrom" ordered="false"
	 * @generated
	 */
	EList<StructuralFeature> getSubsetOf();

	/**
	 * Returns the value of the '<em><b>Derived From</b></em>' reference list.
	 * The list contents are of type {@link km3.StructuralFeature}.
	 * It is bidirectional and its opposite is '{@link km3.StructuralFeature#getSubsetOf <em>Subset Of</em>}'.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Derived From</em>' reference list isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Derived From</em>' reference list.
	 * @see km3.KM3Package#getStructuralFeature_DerivedFrom()
	 * @see km3.StructuralFeature#getSubsetOf
	 * @model opposite="subsetOf" ordered="false"
	 * @generated
	 */
	EList<StructuralFeature> getDerivedFrom();

} // StructuralFeature
