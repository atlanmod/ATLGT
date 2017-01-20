package org.eclipse.m2m.atl.atlgt.launcher;

import org.eclipse.core.runtime.CoreException;
import org.eclipse.debug.core.ILaunchConfiguration;

import java.util.Collections;

/**
 * A class representing an execution context that manages and pre-processes the parameters from a
 * {@link ILaunchConfiguration}.
 */
public class AtlGtContext {

    private static final String OUTPUT_DIRECTORY_NAME = "/hidden/";

    private final String path;

    private final Iterable<String> metamodels;
    private final Iterable<String> inModels;
    private final Iterable<String> inOutModels;
    private final Iterable<String> outModels;

    private final boolean forward;
    private final boolean backward;

    private AtlGtContext(String path, Iterable<String> metamodels, Iterable<String> inModels, Iterable<String> inOutModels, Iterable<String> outModels, boolean forward, boolean backward) {
        this.path = path;

        this.metamodels = metamodels;
        this.inModels = inModels;
        this.inOutModels = inOutModels;

        this.outModels = outModels;
        this.forward = forward;
        this.backward = backward;
    }

    public static AtlGtContext from(ILaunchConfiguration launchConfiguration) throws CoreException {
        String modulePath = launchConfiguration.getAttribute(Keys.MODULE_PATH, "");
        String path = modulePath.substring(0, modulePath.lastIndexOf("/")) + OUTPUT_DIRECTORY_NAME;

        Iterable<String> metamodels = launchConfiguration.getAttribute(Keys.METAMODELS, Collections.emptyMap()).values();
        Iterable<String> inModels = launchConfiguration.getAttribute(Keys.INPUT_MODELS, Collections.emptyMap()).values();
        Iterable<String> inOutModels = launchConfiguration.getAttribute(Keys.INOUT_MODELS, Collections.emptyMap()).values();
        Iterable<String> outModels = launchConfiguration.getAttribute(Keys.OUTPUT_MODELS, Collections.emptyMap()).values();

        boolean forward = launchConfiguration.getAttribute(Keys.FORWARD, false);
        boolean backward = launchConfiguration.getAttribute(Keys.BACKWARD, false);

        return new AtlGtContext(path, metamodels, inModels, inOutModels, outModels, forward, backward);
    }

    public String getPath() {
        return path;
    }

    public Iterable<String> getMetamodels() {
        return metamodels;
    }

    public Iterable<String> getInModels() {
        return inModels;
    }

    public Iterable<String> getInOutModels() {
        return inOutModels;
    }

    public Iterable<String> getOutModels() {
        return outModels;
    }

    public boolean isForward() {
        return forward;
    }

    public boolean isBackward() {
        return backward;
    }

    /**
     * Utility class that contains all the defined keys that can be used in this context.
     */
    private static final class Keys {

        // Module
        @SuppressWarnings("unused")
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
