/**
 */
package org.eclipse.m2m.km3.primitives;

import org.eclipse.emf.ecore.EFactory;

/**
 * <!-- begin-user-doc -->
 * The <b>Factory</b> for the model.
 * It provides a create method for each non-abstract class of the model.
 * <!-- end-user-doc -->
 * @see org.eclipse.m2m.km3.primitives.Km3PrimitivesPackage
 * @generated
 */
public interface Km3PrimitivesFactory extends EFactory {
	/**
	 * The singleton instance of the factory.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	Km3PrimitivesFactory eINSTANCE = org.eclipse.m2m.km3.primitives.impl.Km3PrimitivesFactoryImpl.init();

	/**
	 * Returns the package supported by this factory.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the package supported by this factory.
	 * @generated
	 */
	Km3PrimitivesPackage getKm3PrimitivesPackage();

} //Km3PrimitivesFactory
