package org.eclipse.m2m.atl.atlgt.core;

import org.eclipse.debug.core.ILaunchConfiguration;
import org.eclipse.emf.common.util.URI;
import org.eclipse.m2m.atl.emftvm.launcher.EMFTVMLaunchConstants;

import java.util.Collections;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * A class representing an execution context that manages and pre-processes the parameters from a
 * {@link ILaunchConfiguration}.
 */
public class Context {

    private final URI pluginUri;
    private final String moduleName;

    private final Map<String, URI> metamodels;

    private final URI inModel;
    private final URI outModel;

    private final Direction direction;

    private final String transformationInstance;
    private final URI tempDirectory;

    /**
     * Constructs a new {@code Context} with the given parameters.
     */
    private Context(URI pluginUri, String moduleName, Map<String, URI> metamodels, URI inModel, URI outModel, Direction direction) {
        this.pluginUri = pluginUri;
        this.moduleName = moduleName;

        this.metamodels = metamodels;

        this.inModel = inModel;
        this.outModel = outModel;

        this.direction = direction;

        transformationInstance = inModel.trimFileExtension().lastSegment() + "2" + outModel.trimFileExtension().lastSegment();
        tempDirectory = outModel.trimFileExtension().trimSegments(1).appendSegment(transformationInstance + "-trace");
    }

    /**
     * Creates a new {@code Context} from the given {@code configuration}.
     *
     * @param configuration the configuration to parse
     *
     * @return a new context
     */
    public static Context from(ILaunchConfiguration configuration) {
        try {
            String moduleName = configuration.getAttribute(EMFTVMLaunchConstants.MODULE_NAME, "");

            String modulePath = configuration.getAttribute(EMFTVMLaunchConstants.MODULE_PATH, "");
            URI pluginUri = URI.createPlatformResourceURI(modulePath.substring(0, modulePath.lastIndexOf("/")), false);

            Map<String, URI> metamodels = configuration.getAttribute(EMFTVMLaunchConstants.METAMODELS, Collections.emptyMap()).entrySet()
                    .stream()
                    .collect(Collectors.toMap(Map.Entry::getKey, p -> URI.createURI(p.getValue())));

            URI inModel = URI.createURI(configuration.getAttribute(EMFTVMLaunchConstants.INPUT_MODELS, Collections.emptyMap()).values().iterator().next());
            URI outModel = URI.createURI(configuration.getAttribute(EMFTVMLaunchConstants.OUTPUT_MODELS, Collections.emptyMap()).values().iterator().next());

            boolean forward = configuration.getAttribute(Direction.FORWARD.getName(), false);
            Direction direction = (forward ? Direction.FORWARD : Direction.BACKWARD);

            return new Context(pluginUri, moduleName, metamodels, inModel, outModel, direction);
        }
        catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    /**
     * Returns the {@link URI} of the ATL module, without its extension.
     *
     * @return the URI
     */
    public URI module() {
        return pluginUri.appendSegment(moduleName);
    }

    /**
     * Returns the list of metamodels.
     *
     * @return an immutable list
     */
    public Iterable<URI> metamodels() {
        return Collections.unmodifiableCollection(metamodels.values());
    }

    /**
     * Returns the input metamodel.
     *
     * @return the metamodel
     */
    public URI inMetamodel() {
        return metamodels.get("IN");
    }

    /**
     * Returns the output metamodel.
     *
     * @return the metamodel
     */
    public URI outMetamodel() {
        return metamodels.get("OUT");
    }

    /**
     * Returns the input model.
     *
     * @return the model
     */
    public URI inModel() {
        return inModel;
    }

    /**
     * Returns the output model.
     *
     * @return the model
     */
    public URI outModel() {
        return outModel;
    }

    /**
     * Returns the direction of the transformation.
     *
     * @return the direction
     */
    public Direction direction() {
        return direction;
    }

    /**
     * Returns the name of the current transformation instance.
     *
     * @return the name
     */
    public String transformationInstance() {
        return transformationInstance;
    }

    /**
     * Returns the {@link URI} of the output directory.
     *
     * @return the URI
     */
    public URI tempDirectory() {
        return tempDirectory;
    }
}
