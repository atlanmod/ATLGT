/*
 * generated by Xtext 2.10.0
 */
package org.eclipse.m2m.km3.xtext


/**
 * Initialization support for running Xtext languages without Equinox extension registry.
 */
class KM3StandaloneSetup extends KM3StandaloneSetupGenerated {

	def static void doSetup() {
		new KM3StandaloneSetup().createInjectorAndDoEMFRegistration()
	}
}
