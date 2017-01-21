/**
 */
package org.eclipse.m2m.km3;

import org.eclipse.emf.common.util.EList;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Package</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link org.eclipse.m2m.km3.Package#getContents <em>Contents</em>}</li>
 *   <li>{@link org.eclipse.m2m.km3.Package#getMetamodel <em>Metamodel</em>}</li>
 * </ul>
 *
 * @see org.eclipse.m2m.km3.Km3Package#getPackage()
 * @model
 * @generated
 */
public interface Package extends ModelElement {
	/**
	 * Returns the value of the '<em><b>Contents</b></em>' containment reference list.
	 * The list contents are of type {@link org.eclipse.m2m.km3.ModelElement}.
	 * It is bidirectional and its opposite is '{@link org.eclipse.m2m.km3.ModelElement#getPackage <em>Package</em>}'.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Contents</em>' containment reference list isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Contents</em>' containment reference list.
	 * @see org.eclipse.m2m.km3.Km3Package#getPackage_Contents()
	 * @see org.eclipse.m2m.km3.ModelElement#getPackage
	 * @model opposite="package" containment="true"
	 * @generated
	 */
	EList<ModelElement> getContents();

	/**
	 * Returns the value of the '<em><b>Metamodel</b></em>' container reference.
	 * It is bidirectional and its opposite is '{@link org.eclipse.m2m.km3.Metamodel#getContents <em>Contents</em>}'.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Metamodel</em>' container reference isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Metamodel</em>' container reference.
	 * @see #setMetamodel(Metamodel)
	 * @see org.eclipse.m2m.km3.Km3Package#getPackage_Metamodel()
	 * @see org.eclipse.m2m.km3.Metamodel#getContents
	 * @model opposite="contents" transient="false" ordered="false"
	 * @generated
	 */
	Metamodel getMetamodel();

	/**
	 * Sets the value of the '{@link org.eclipse.m2m.km3.Package#getMetamodel <em>Metamodel</em>}' container reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Metamodel</em>' container reference.
	 * @see #getMetamodel()
	 * @generated
	 */
	void setMetamodel(Metamodel value);

} // Package
