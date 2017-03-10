package org.eclipse.m2m.atl.atlgt.examples;

import org.eclipse.ui.plugin.AbstractUIPlugin;

/**
 * ATL-GT examples plugin.
 */
public class AtlGtExamplesPlugin extends AbstractUIPlugin {
	
	/** The plugin id. */
	public static final String PLUGIN_ID = "org.eclipse.m2m.atl.atlgt.examples"; //$NON-NLS-1$

	private static AtlGtExamplesPlugin instance;
	
	/**
	 * Constructor.
	 */
	public AtlGtExamplesPlugin() {
		instance = this;
	}
	
	/**
	 * Returns the default {@link AtlGtExamplesPlugin} instance.
	 * 
	 * @return the default {@link AtlGtExamplesPlugin} instance
	 */
	public static AtlGtExamplesPlugin getDefault() {
		if (instance == null) {
			return new AtlGtExamplesPlugin();
		}
		return instance;
	}
}
