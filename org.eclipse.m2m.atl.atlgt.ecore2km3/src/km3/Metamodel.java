/**
 */
package km3;

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
 *   <li>{@link km3.Metamodel#getContents <em>Contents</em>}</li>
 * </ul>
 *
 * @see km3.KM3Package#getMetamodel()
 * @model
 * @generated
 */
public interface Metamodel extends LocatedElement {
	/**
	 * Returns the value of the '<em><b>Contents</b></em>' reference list.
	 * The list contents are of type {@link km3.Package}.
	 * It is bidirectional and its opposite is '{@link km3.Package#getMetamodel <em>Metamodel</em>}'.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Contents</em>' reference list isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Contents</em>' reference list.
	 * @see km3.KM3Package#getMetamodel_Contents()
	 * @see km3.Package#getMetamodel
	 * @model opposite="metamodel"
	 * @generated
	 */
	EList<km3.Package> getContents();

} // Metamodel
