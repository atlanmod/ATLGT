/**
 */
package km3;


/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Enum Literal</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link km3.EnumLiteral#getEnum <em>Enum</em>}</li>
 * </ul>
 *
 * @see km3.Km3Package#getEnumLiteral()
 * @model
 * @generated
 */
public interface EnumLiteral extends ModelElement {
	/**
	 * Returns the value of the '<em><b>Enum</b></em>' reference.
	 * It is bidirectional and its opposite is '{@link km3.Enumeration#getLiterals <em>Literals</em>}'.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Enum</em>' reference isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Enum</em>' reference.
	 * @see #setEnum(Enumeration)
	 * @see km3.Km3Package#getEnumLiteral_Enum()
	 * @see km3.Enumeration#getLiterals
	 * @model opposite="literals" ordered="false"
	 * @generated
	 */
	Enumeration getEnum();

	/**
	 * Sets the value of the '{@link km3.EnumLiteral#getEnum <em>Enum</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Enum</em>' reference.
	 * @see #getEnum()
	 * @generated
	 */
	void setEnum(Enumeration value);

} // EnumLiteral
