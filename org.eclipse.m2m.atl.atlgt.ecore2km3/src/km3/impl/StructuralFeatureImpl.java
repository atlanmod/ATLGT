/**
 */
package km3.impl;

import java.util.Collection;

import km3.Km3Package;
import km3.StructuralFeature;

import org.eclipse.emf.common.notify.Notification;
import org.eclipse.emf.common.notify.NotificationChain;

import org.eclipse.emf.common.util.EList;

import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.InternalEObject;

import org.eclipse.emf.ecore.impl.ENotificationImpl;

import org.eclipse.emf.ecore.util.EObjectWithInverseResolvingEList;
import org.eclipse.emf.ecore.util.EcoreUtil;
import org.eclipse.emf.ecore.util.InternalEList;

/**
 * <!-- begin-user-doc -->
 * An implementation of the model object '<em><b>Structural Feature</b></em>'.
 * <!-- end-user-doc -->
 * <p>
 * The following features are implemented:
 * </p>
 * <ul>
 *   <li>{@link km3.impl.StructuralFeatureImpl#getOwner <em>Owner</em>}</li>
 *   <li>{@link km3.impl.StructuralFeatureImpl#getSubsetOf <em>Subset Of</em>}</li>
 *   <li>{@link km3.impl.StructuralFeatureImpl#getDerivedFrom <em>Derived From</em>}</li>
 * </ul>
 *
 * @generated
 */
public class StructuralFeatureImpl extends TypedElementImpl implements StructuralFeature {
	/**
	 * The cached value of the '{@link #getSubsetOf() <em>Subset Of</em>}' reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getSubsetOf()
	 * @generated
	 * @ordered
	 */
	protected EList<StructuralFeature> subsetOf;

	/**
	 * The cached value of the '{@link #getDerivedFrom() <em>Derived From</em>}' reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getDerivedFrom()
	 * @generated
	 * @ordered
	 */
	protected EList<StructuralFeature> derivedFrom;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected StructuralFeatureImpl() {
		super();
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	protected EClass eStaticClass() {
		return Km3Package.Literals.STRUCTURAL_FEATURE;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public km3.Class getOwner() {
		if (eContainerFeatureID() != Km3Package.STRUCTURAL_FEATURE__OWNER) return null;
		return (km3.Class)eInternalContainer();
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public NotificationChain basicSetOwner(km3.Class newOwner, NotificationChain msgs) {
		msgs = eBasicSetContainer((InternalEObject)newOwner, Km3Package.STRUCTURAL_FEATURE__OWNER, msgs);
		return msgs;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public void setOwner(km3.Class newOwner) {
		if (newOwner != eInternalContainer() || (eContainerFeatureID() != Km3Package.STRUCTURAL_FEATURE__OWNER && newOwner != null)) {
			if (EcoreUtil.isAncestor(this, newOwner))
				throw new IllegalArgumentException("Recursive containment not allowed for " + toString());
			NotificationChain msgs = null;
			if (eInternalContainer() != null)
				msgs = eBasicRemoveFromContainer(msgs);
			if (newOwner != null)
				msgs = ((InternalEObject)newOwner).eInverseAdd(this, Km3Package.CLASS__STRUCTURAL_FEATURES, km3.Class.class, msgs);
			msgs = basicSetOwner(newOwner, msgs);
			if (msgs != null) msgs.dispatch();
		}
		else if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, Km3Package.STRUCTURAL_FEATURE__OWNER, newOwner, newOwner));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EList<StructuralFeature> getSubsetOf() {
		if (subsetOf == null) {
			subsetOf = new EObjectWithInverseResolvingEList.ManyInverse<StructuralFeature>(StructuralFeature.class, this, Km3Package.STRUCTURAL_FEATURE__SUBSET_OF, Km3Package.STRUCTURAL_FEATURE__DERIVED_FROM);
		}
		return subsetOf;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EList<StructuralFeature> getDerivedFrom() {
		if (derivedFrom == null) {
			derivedFrom = new EObjectWithInverseResolvingEList.ManyInverse<StructuralFeature>(StructuralFeature.class, this, Km3Package.STRUCTURAL_FEATURE__DERIVED_FROM, Km3Package.STRUCTURAL_FEATURE__SUBSET_OF);
		}
		return derivedFrom;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@SuppressWarnings("unchecked")
	@Override
	public NotificationChain eInverseAdd(InternalEObject otherEnd, int featureID, NotificationChain msgs) {
		switch (featureID) {
			case Km3Package.STRUCTURAL_FEATURE__OWNER:
				if (eInternalContainer() != null)
					msgs = eBasicRemoveFromContainer(msgs);
				return basicSetOwner((km3.Class)otherEnd, msgs);
			case Km3Package.STRUCTURAL_FEATURE__SUBSET_OF:
				return ((InternalEList<InternalEObject>)(InternalEList<?>)getSubsetOf()).basicAdd(otherEnd, msgs);
			case Km3Package.STRUCTURAL_FEATURE__DERIVED_FROM:
				return ((InternalEList<InternalEObject>)(InternalEList<?>)getDerivedFrom()).basicAdd(otherEnd, msgs);
		}
		return super.eInverseAdd(otherEnd, featureID, msgs);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public NotificationChain eInverseRemove(InternalEObject otherEnd, int featureID, NotificationChain msgs) {
		switch (featureID) {
			case Km3Package.STRUCTURAL_FEATURE__OWNER:
				return basicSetOwner(null, msgs);
			case Km3Package.STRUCTURAL_FEATURE__SUBSET_OF:
				return ((InternalEList<?>)getSubsetOf()).basicRemove(otherEnd, msgs);
			case Km3Package.STRUCTURAL_FEATURE__DERIVED_FROM:
				return ((InternalEList<?>)getDerivedFrom()).basicRemove(otherEnd, msgs);
		}
		return super.eInverseRemove(otherEnd, featureID, msgs);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public NotificationChain eBasicRemoveFromContainerFeature(NotificationChain msgs) {
		switch (eContainerFeatureID()) {
			case Km3Package.STRUCTURAL_FEATURE__OWNER:
				return eInternalContainer().eInverseRemove(this, Km3Package.CLASS__STRUCTURAL_FEATURES, km3.Class.class, msgs);
		}
		return super.eBasicRemoveFromContainerFeature(msgs);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public Object eGet(int featureID, boolean resolve, boolean coreType) {
		switch (featureID) {
			case Km3Package.STRUCTURAL_FEATURE__OWNER:
				return getOwner();
			case Km3Package.STRUCTURAL_FEATURE__SUBSET_OF:
				return getSubsetOf();
			case Km3Package.STRUCTURAL_FEATURE__DERIVED_FROM:
				return getDerivedFrom();
		}
		return super.eGet(featureID, resolve, coreType);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@SuppressWarnings("unchecked")
	@Override
	public void eSet(int featureID, Object newValue) {
		switch (featureID) {
			case Km3Package.STRUCTURAL_FEATURE__OWNER:
				setOwner((km3.Class)newValue);
				return;
			case Km3Package.STRUCTURAL_FEATURE__SUBSET_OF:
				getSubsetOf().clear();
				getSubsetOf().addAll((Collection<? extends StructuralFeature>)newValue);
				return;
			case Km3Package.STRUCTURAL_FEATURE__DERIVED_FROM:
				getDerivedFrom().clear();
				getDerivedFrom().addAll((Collection<? extends StructuralFeature>)newValue);
				return;
		}
		super.eSet(featureID, newValue);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public void eUnset(int featureID) {
		switch (featureID) {
			case Km3Package.STRUCTURAL_FEATURE__OWNER:
				setOwner((km3.Class)null);
				return;
			case Km3Package.STRUCTURAL_FEATURE__SUBSET_OF:
				getSubsetOf().clear();
				return;
			case Km3Package.STRUCTURAL_FEATURE__DERIVED_FROM:
				getDerivedFrom().clear();
				return;
		}
		super.eUnset(featureID);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public boolean eIsSet(int featureID) {
		switch (featureID) {
			case Km3Package.STRUCTURAL_FEATURE__OWNER:
				return getOwner() != null;
			case Km3Package.STRUCTURAL_FEATURE__SUBSET_OF:
				return subsetOf != null && !subsetOf.isEmpty();
			case Km3Package.STRUCTURAL_FEATURE__DERIVED_FROM:
				return derivedFrom != null && !derivedFrom.isEmpty();
		}
		return super.eIsSet(featureID);
	}

} //StructuralFeatureImpl