package org.eclipse.m2m.atl.atlgt.launcher;

import org.eclipse.core.runtime.CoreException;
import org.eclipse.debug.core.ILaunchConfiguration;
import org.eclipse.emf.common.util.URI;

import java.util.Collections;
import java.util.stream.Collectors;

/**
 * A class representing an execution context that manages and pre-processes the parameters from a
 * {@link ILaunchConfiguration}.
 */
public class AtlGtContext {

    private static final String OUTPUT_DIRECTORY_NAME = "hidden";

    private final URI pluginUri;
    private final String moduleName;
    
    private final Iterable<URI> metamodels;
    private final Iterable<URI> inModels;
    private final Iterable<URI> inOutModels;
    private final Iterable<URI> outModels;

    private final boolean forward;
    private final boolean backward;

    private AtlGtContext(URI pluginUri, String moduleName, Iterable<URI> metamodels, Iterable<URI> inModels, Iterable<URI> inOutModels, Iterable<URI> outModels, boolean forward, boolean backward) {
        this.pluginUri = pluginUri;
        this.moduleName = moduleName;
        
        this.metamodels = metamodels;
        this.inModels = inModels;
        this.inOutModels = inOutModels;

        this.outModels = outModels;
        this.forward = forward;
        this.backward = backward;
    }

    public static AtlGtContext from(ILaunchConfiguration launchConfiguration) throws CoreException {
        String moduleName = launchConfiguration.getAttribute(Keys.MODULE_NAME, "");

        String modulePath = launchConfiguration.getAttribute(Keys.MODULE_PATH, "");
        URI pluginUri = URI.createPlatformResourceURI(modulePath.substring(0, modulePath.lastIndexOf("/")), false);

        Iterable<URI> metamodels = launchConfiguration.getAttribute(Keys.METAMODELS, Collections.emptyMap()).values()
                .stream()
                .map(URI::createURI)
                .collect(Collectors.toList());

        Iterable<URI> inModels = launchConfiguration.getAttribute(Keys.INPUT_MODELS, Collections.emptyMap()).values()
                .stream()
                .map(URI::createURI)
                .collect(Collectors.toList());

        Iterable<URI> inOutModels = launchConfiguration.getAttribute(Keys.INOUT_MODELS, Collections.emptyMap()).values()
                .stream()
                .map(URI::createURI)
                .collect(Collectors.toList());

        Iterable<URI> outModels = launchConfiguration.getAttribute(Keys.OUTPUT_MODELS, Collections.emptyMap()).values()
                .stream()
                .map(URI::createURI)
                .collect(Collectors.toList());

        boolean forward = launchConfiguration.getAttribute(Keys.FORWARD, false);
        boolean backward = launchConfiguration.getAttribute(Keys.BACKWARD, false);


        return new AtlGtContext(pluginUri, moduleName, metamodels, inModels, inOutModels, outModels, forward, backward);
    }

    /**
     * Returns the {@link URI} of the output directory.
     *
     * @return the URI
     */
    public URI getOutputDirectory() {
        return pluginUri.appendSegment(OUTPUT_DIRECTORY_NAME);
    }

    /**
     * Returns the {@link URI} of the ATL module, without its extension.
     *
     * @return the URI
     */
    public URI getModule() {
        return pluginUri.appendSegment(moduleName);
    }
    
    public Iterable<URI> getMetamodels() {
        return metamodels;
    }

    public Iterable<URI> getInModels() {
        return inModels;
    }

    public Iterable<URI> getInOutModels() {
        return inOutModels;
    }

    public Iterable<URI> getOutModels() {
        return outModels;
    }

    public boolean isForward() {
        return forward;
    }

    public boolean isBackward() {
        return backward;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();

        sb.append("Module:              ").append(moduleName).append('\n');
        sb.append("Plugin:              ").append(pluginUri).append('\n');
        sb.append("Metamodels:          ").append(metamodels).append('\n');
        sb.append("Input models:        ").append(inModels).append('\n');
        sb.append("Input/Output models: ").append(inOutModels).append('\n');
        sb.append("Output models:       ").append(outModels).append('\n');
        sb.append("F/B:                 ").append(forward ? "Forward" : "Backward");

        return sb.toString();
    }

    /**
     * Utility class that contains all the defined keys that can be used in this context.
     */
    private static final class Keys {

        // Module
        private static final String MODULE_NAME = "Module Name";
        private static final String MODULE_PATH = "Module Path";

        // Meta-models
        private static final String METAMODELS = "Metamodels";
        @SuppressWarnings("unused")
        private static final String METAMODEL_OPTIONS = "Metamodel Options";

        // Input models
        private static final String INPUT_MODELS = "Input Models";
        @SuppressWarnings("unused")
        private static final String INPUT_MODEL_OPTIONS = "Input Model Options";

        // Input/Output models
        private static final String INOUT_MODELS = "Inout Models";
        @SuppressWarnings("unused")
        private static final String INOUT_MODEL_OPTIONS = "Inout Model Options";
        @SuppressWarnings("unused")
        private static final String INOUT_MODELS_OUTPUT_LOCATIONS = "Inout Models Output Locations";

        // Output models
        private static final String OUTPUT_MODELS = "Output Models";
        @SuppressWarnings("unused")
        private static final String OUTPUT_MODEL_OPTIONS = "Output Model Options";

        // ATL-GT parameters
        private static final String BACKWARD = "Backward";
        private static final String FORWARD = "Forward";
    }
}
