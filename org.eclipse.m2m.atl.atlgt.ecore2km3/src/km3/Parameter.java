/**
 */
package km3;


/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Parameter</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link km3.Parameter#getOwner <em>Owner</em>}</li>
 * </ul>
 *
 * @see km3.Km3Package#getParameter()
 * @model
 * @generated
 */
public interface Parameter extends TypedElement {
	/**
	 * Returns the value of the '<em><b>Owner</b></em>' reference.
	 * It is bidirectional and its opposite is '{@link km3.Operation#getParameters <em>Parameters</em>}'.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Owner</em>' reference isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Owner</em>' reference.
	 * @see #setOwner(Operation)
	 * @see km3.Km3Package#getParameter_Owner()
	 * @see km3.Operation#getParameters
	 * @model opposite="parameters" ordered="false"
	 * @generated
	 */
	Operation getOwner();

	/**
	 * Sets the value of the '{@link km3.Parameter#getOwner <em>Owner</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Owner</em>' reference.
	 * @see #getOwner()
	 * @generated
	 */
	void setOwner(Operation value);

} // Parameter
