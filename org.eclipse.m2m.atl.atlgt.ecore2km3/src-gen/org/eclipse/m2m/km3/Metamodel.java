/**
 */
package org.eclipse.m2m.km3;

import org.eclipse.emf.common.util.EList;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Metamodel</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link org.eclipse.m2m.km3.Metamodel#getContents <em>Contents</em>}</li>
 * </ul>
 *
 * @see org.eclipse.m2m.km3.Km3Package#getMetamodel()
 * @model
 * @generated
 */
public interface Metamodel extends LocatedElement {
	/**
	 * Returns the value of the '<em><b>Contents</b></em>' containment reference list.
	 * The list contents are of type {@link org.eclipse.m2m.km3.Package}.
	 * It is bidirectional and its opposite is '{@link org.eclipse.m2m.km3.Package#getMetamodel <em>Metamodel</em>}'.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Contents</em>' containment reference list isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Contents</em>' containment reference list.
	 * @see org.eclipse.m2m.km3.Km3Package#getMetamodel_Contents()
	 * @see org.eclipse.m2m.km3.Package#getMetamodel
	 * @model opposite="metamodel" containment="true"
	 * @generated
	 */
	EList<org.eclipse.m2m.km3.Package> getContents();

} // Metamodel
