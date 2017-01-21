/**
 */
package km3;

import org.eclipse.emf.common.util.EList;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Enumeration</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link km3.Enumeration#getLiterals <em>Literals</em>}</li>
 * </ul>
 *
 * @see km3.Km3Package#getEnumeration()
 * @model
 * @generated
 */
public interface Enumeration extends Classifier {
	/**
	 * Returns the value of the '<em><b>Literals</b></em>' reference list.
	 * The list contents are of type {@link km3.EnumLiteral}.
	 * It is bidirectional and its opposite is '{@link km3.EnumLiteral#getEnum <em>Enum</em>}'.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Literals</em>' reference list isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Literals</em>' reference list.
	 * @see km3.Km3Package#getEnumeration_Literals()
	 * @see km3.EnumLiteral#getEnum
	 * @model opposite="enum"
	 * @generated
	 */
	EList<EnumLiteral> getLiterals();

} // Enumeration
