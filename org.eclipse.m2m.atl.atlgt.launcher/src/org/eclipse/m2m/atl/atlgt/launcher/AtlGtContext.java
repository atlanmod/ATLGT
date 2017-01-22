package org.eclipse.m2m.atl.atlgt.launcher;

import org.eclipse.core.runtime.CoreException;
import org.eclipse.debug.core.ILaunchConfiguration;
import org.eclipse.emf.common.util.URI;

import java.util.Collections;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * A class representing an execution context that manages and pre-processes the parameters from a
 * {@link ILaunchConfiguration}.
 */
// TODO Improve IN/OUT metamodels detection
public class AtlGtContext {

    private static final String TEMP_DIRECTORY_NAME = "hidden";

    private final URI pluginUri;
    private final String moduleName;

    private final URI inMetamodel;
    private final URI outMetamodel;

    private final Iterable<URI> metamodels;
    private final URI inModel;
    private final URI outModel;

    private final boolean forward;
    private final boolean backward;

    private AtlGtContext(URI pluginUri, String moduleName, Map<String, URI> metamodels, URI inModel, URI outModel, boolean forward, boolean backward) {
        this.pluginUri = pluginUri;
        this.moduleName = moduleName;

        this.inMetamodel = metamodels.get(Keys.METAMODEL_IN);
        this.outMetamodel = metamodels.get(Keys.METAMODEL_OUT);
        this.metamodels = metamodels.values();

        this.inModel = inModel;
        this.outModel = outModel;

        this.forward = forward;
        this.backward = backward;
    }

    public static AtlGtContext from(ILaunchConfiguration launchConfiguration) throws CoreException {
        String moduleName = launchConfiguration.getAttribute(Keys.MODULE_NAME, "");

        String modulePath = launchConfiguration.getAttribute(Keys.MODULE_PATH, "");
        URI pluginUri = URI.createPlatformResourceURI(modulePath.substring(0, modulePath.lastIndexOf("/")), false);

        Map<String, URI> metamodels = launchConfiguration.getAttribute(Keys.METAMODELS, Collections.emptyMap()).entrySet()
                .stream()
                .collect(Collectors.toMap(Map.Entry::getKey, p -> URI.createURI(p.getValue())));

        URI inModel = URI.createURI(launchConfiguration.getAttribute(Keys.INPUT_MODELS, Collections.emptyMap()).values().iterator().next());
        URI outModel = URI.createURI(launchConfiguration.getAttribute(Keys.OUTPUT_MODELS, Collections.emptyMap()).values().iterator().next());

        boolean forward = launchConfiguration.getAttribute(Keys.FORWARD, false);
        boolean backward = launchConfiguration.getAttribute(Keys.BACKWARD, false);


        return new AtlGtContext(pluginUri, moduleName, metamodels, inModel, outModel, forward, backward);
    }

    /**
     * Returns the {@link URI} of the output directory.
     *
     * @return the URI
     */
    public URI getTempDirectory() {
        return pluginUri.appendSegment(TEMP_DIRECTORY_NAME);
    }

    /**
     * Returns the {@link URI} of the ATL module, without its extension.
     *
     * @return the URI
     */
    public URI getModule() {
        return pluginUri.appendSegment(moduleName);
    }

    public URI getInMetamodel() {
        return inMetamodel;
    }

    public URI getOutMetamodel() {
        return outMetamodel;
    }

    public Iterable<URI> getMetamodels() {
        return metamodels;
    }

    public URI getInModel() {
        return inModel;
    }

    public URI getOutModel() {
        return outModel;
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
        sb.append("Input metamodel:     ").append(inMetamodel).append('\n');
        sb.append("Input model:         ").append(inModel).append('\n');
        sb.append("Output model:        ").append(outModel).append('\n');
        sb.append("Output metamodel:    ").append(outMetamodel).append('\n');
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

        private static final String METAMODEL_IN = "IN";
        private static final String METAMODEL_OUT = "OUT";

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
