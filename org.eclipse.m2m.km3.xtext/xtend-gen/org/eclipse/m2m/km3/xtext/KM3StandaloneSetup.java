/**
 * generated by Xtext 2.10.0
 */
package org.eclipse.m2m.km3.xtext;

import org.eclipse.m2m.km3.xtext.KM3StandaloneSetupGenerated;

/**
 * Initialization support for running Xtext languages without Equinox extension registry.
 */
@SuppressWarnings("all")
public class KM3StandaloneSetup extends KM3StandaloneSetupGenerated {
  public static void doSetup() {
    KM3StandaloneSetup _kM3StandaloneSetup = new KM3StandaloneSetup();
    _kM3StandaloneSetup.createInjectorAndDoEMFRegistration();
  }
}
