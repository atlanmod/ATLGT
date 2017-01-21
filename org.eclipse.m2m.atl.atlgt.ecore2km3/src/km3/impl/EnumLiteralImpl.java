/**
 */
package km3.impl;

import km3.EnumLiteral;
import km3.Enumeration;
import km3.Km3Package;

import org.eclipse.emf.common.notify.Notification;
import org.eclipse.emf.common.notify.NotificationChain;

import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.InternalEObject;

import org.eclipse.emf.ecore.impl.ENotificationImpl;

/**
 * <!-- begin-user-doc -->
 * An implementation of the model object '<em><b>Enum Literal</b></em>'.
 * <!-- end-user-doc -->
 * <p>
 * The following features are implemented:
 * </p>
 * <ul>
 *   <li>{@link km3.impl.EnumLiteralImpl#getEnum <em>Enum</em>}</li>
 * </ul>
 *
 * @generated
 */
public class EnumLiteralImpl extends ModelElementImpl implements EnumLiteral {
	/**
	 * The cached value of the '{@link #getEnum() <em>Enum</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getEnum()
	 * @generated
	 * @ordered
	 */
	protected Enumeration enum_;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected EnumLiteralImpl() {
		super();
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	protected EClass eStaticClass() {
		return Km3Package.Literals.ENUM_LITERAL;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public Enumeration getEnum() {
		if (enum_ != null && enum_.eIsProxy()) {
			InternalEObject oldEnum = (InternalEObject)enum_;
			enum_ = (Enumeration)eResolveProxy(oldEnum);
			if (enum_ != oldEnum) {
				if (eNotificationRequired())
					eNotify(new ENotificationImpl(this, Notification.RESOLVE, Km3Package.ENUM_LITERAL__ENUM, oldEnum, enum_));
			}
		}
		return enum_;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public Enumeration basicGetEnum() {
		return enum_;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public NotificationChain basicSetEnum(Enumeration newEnum, NotificationChain msgs) {
		Enumeration oldEnum = enum_;
		enum_ = newEnum;
		if (eNotificationRequired()) {
			ENotificationImpl notification = new ENotificationImpl(this, Notification.SET, Km3Package.ENUM_LITERAL__ENUM, oldEnum, newEnum);
			if (msgs == null) msgs = notification; else msgs.add(notification);
		}
		return msgs;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public void setEnum(Enumeration newEnum) {
		if (newEnum != enum_) {
			NotificationChain msgs = null;
			if (enum_ != null)
				msgs = ((InternalEObject)enum_).eInverseRemove(this, Km3Package.ENUMERATION__LITERALS, Enumeration.class, msgs);
			if (newEnum != null)
				msgs = ((InternalEObject)newEnum).eInverseAdd(this, Km3Package.ENUMERATION__LITERALS, Enumeration.class, msgs);
			msgs = basicSetEnum(newEnum, msgs);
			if (msgs != null) msgs.dispatch();
		}
		else if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, Km3Package.ENUM_LITERAL__ENUM, newEnum, newEnum));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public NotificationChain eInverseAdd(InternalEObject otherEnd, int featureID, NotificationChain msgs) {
		switch (featureID) {
			case Km3Package.ENUM_LITERAL__ENUM:
				if (enum_ != null)
					msgs = ((InternalEObject)enum_).eInverseRemove(this, Km3Package.ENUMERATION__LITERALS, Enumeration.class, msgs);
				return basicSetEnum((Enumeration)otherEnd, msgs);
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
			case Km3Package.ENUM_LITERAL__ENUM:
				return basicSetEnum(null, msgs);
		}
		return super.eInverseRemove(otherEnd, featureID, msgs);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public Object eGet(int featureID, boolean resolve, boolean coreType) {
		switch (featureID) {
			case Km3Package.ENUM_LITERAL__ENUM:
				if (resolve) return getEnum();
				return basicGetEnum();
		}
		return super.eGet(featureID, resolve, coreType);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public void eSet(int featureID, Object newValue) {
		switch (featureID) {
			case Km3Package.ENUM_LITERAL__ENUM:
				setEnum((Enumeration)newValue);
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
			case Km3Package.ENUM_LITERAL__ENUM:
				setEnum((Enumeration)null);
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
			case Km3Package.ENUM_LITERAL__ENUM:
				return enum_ != null;
		}
		return super.eIsSet(featureID);
	}

} //EnumLiteralImpl
