/*
 * generated by Xtext 2.10.0
 */
package org.eclipse.m2m.km3.xtext.ui.tests;

import com.google.inject.Injector;
import org.eclipse.m2m.km3.xtext.ui.internal.XtextActivator;
import org.eclipse.xtext.junit4.IInjectorProvider;

public class KM3UiInjectorProvider implements IInjectorProvider {

	@Override
	public Injector getInjector() {
		return XtextActivator.getInstance().getInjector("org.eclipse.m2m.km3.xtext.KM3");
	}

}
