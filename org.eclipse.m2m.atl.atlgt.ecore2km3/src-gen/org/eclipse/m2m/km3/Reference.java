/**
 */
package org.eclipse.m2m.km3;


/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Reference</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link org.eclipse.m2m.km3.Reference#getIsContainer <em>Is Container</em>}</li>
 *   <li>{@link org.eclipse.m2m.km3.Reference#getOpposite <em>Opposite</em>}</li>
 * </ul>
 *
 * @see org.eclipse.m2m.km3.Km3Package#getReference()
 * @model
 * @generated
 */
public interface Reference extends StructuralFeature {
	/**
	 * Returns the value of the '<em><b>Is Container</b></em>' attribute.
	 * The default value is <code>"false"</code>.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Is Container</em>' attribute isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Is Container</em>' attribute.
	 * @see #setIsContainer(Boolean)
	 * @see org.eclipse.m2m.km3.Km3Package#getReference_IsContainer()
	 * @model default="false" dataType="org.eclipse.m2m.km3.primitives.Boolean" required="true" ordered="false"
	 * @generated
	 */
	Boolean getIsContainer();

	/**
	 * Sets the value of the '{@link org.eclipse.m2m.km3.Reference#getIsContainer <em>Is Container</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Is Container</em>' attribute.
	 * @see #getIsContainer()
	 * @generated
	 */
	void setIsContainer(Boolean value);

	/**
	 * Returns the value of the '<em><b>Opposite</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Opposite</em>' reference isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Opposite</em>' reference.
	 * @see #setOpposite(Reference)
	 * @see org.eclipse.m2m.km3.Km3Package#getReference_Opposite()
	 * @model ordered="false"
	 * @generated
	 */
	Reference getOpposite();

	/**
	 * Sets the value of the '{@link org.eclipse.m2m.km3.Reference#getOpposite <em>Opposite</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Opposite</em>' reference.
	 * @see #getOpposite()
	 * @generated
	 */
	void setOpposite(Reference value);

} // Reference