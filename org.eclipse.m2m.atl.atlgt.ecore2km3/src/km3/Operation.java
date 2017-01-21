/**
 */
package km3;

import org.eclipse.emf.common.util.EList;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Operation</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link km3.Operation#getOwner <em>Owner</em>}</li>
 *   <li>{@link km3.Operation#getParameters <em>Parameters</em>}</li>
 * </ul>
 *
 * @see km3.KM3Package#getOperation()
 * @model
 * @generated
 */
public interface Operation extends TypedElement {
	/**
	 * Returns the value of the '<em><b>Owner</b></em>' reference.
	 * It is bidirectional and its opposite is '{@link km3.Class#getOperations <em>Operations</em>}'.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Owner</em>' reference isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Owner</em>' reference.
	 * @see #setOwner(km3.Class)
	 * @see km3.KM3Package#getOperation_Owner()
	 * @see km3.Class#getOperations
	 * @model opposite="operations" ordered="false"
	 * @generated
	 */
	km3.Class getOwner();

	/**
	 * Sets the value of the '{@link km3.Operation#getOwner <em>Owner</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Owner</em>' reference.
	 * @see #getOwner()
	 * @generated
	 */
	void setOwner(km3.Class value);

	/**
	 * Returns the value of the '<em><b>Parameters</b></em>' reference list.
	 * The list contents are of type {@link km3.Parameter}.
	 * It is bidirectional and its opposite is '{@link km3.Parameter#getOwner <em>Owner</em>}'.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Parameters</em>' reference list isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Parameters</em>' reference list.
	 * @see km3.KM3Package#getOperation_Parameters()
	 * @see km3.Parameter#getOwner
	 * @model opposite="owner"
	 * @generated
	 */
	EList<Parameter> getParameters();

} // Operation
