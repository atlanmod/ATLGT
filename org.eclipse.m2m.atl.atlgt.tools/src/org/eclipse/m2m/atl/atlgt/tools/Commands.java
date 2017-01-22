package org.eclipse.m2m.atl.atlgt.tools;

import org.eclipse.core.runtime.FileLocator;
import org.eclipse.core.runtime.IPath;
import org.eclipse.core.runtime.Platform;
import org.osgi.framework.Bundle;

import java.io.IOException;
import java.net.URISyntaxException;
import java.net.URL;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Collections;
import java.util.Map;

/**
 * A factory of {@link CommandBuilder}s.
 */
public class Commands {
	
	private static final String BUNDLE_SYMBOLIC_NAME = "org.eclipse.m2m.atl.atlgt.tools";

	private static final String PATH_PATTERN = "lib/%s/bin";

    private Commands() {
        throw new IllegalStateException("This class should not be initialized");
    }

    /**
     * Returns a specific {@link CommandBuilder} for ATL-GT.
     *
     * @return a new builder
     */
    public static AtlGtCommandBuilder atlGt() {
        return new AtlGtCommandBuilder(resolve("ATL-GT"));
    }

    /**
     * Returns a specific {@link CommandBuilder} for GRoundTram.
     *
     * @return a new builder
     */
    public static GRoundTramCommandBuilder gRoundTram() {
        return new GRoundTramCommandBuilder(resolve("ground_tram-0.9.5"));
    }

    /**
     * Resolves the absolute path of a library's binaries, according to the given {@code name}. These binaries must be
     * located in the {@code lib/${name}/bin} folder of the current bundle.
     *
     * @param name the name of the library
     *
     * @return the absolute path of the library
     */
    private static Path resolve(String name) {
        IPath path = new org.eclipse.core.runtime.Path(String.format(PATH_PATTERN, name));
        Bundle bundle = Platform.getBundle(BUNDLE_SYMBOLIC_NAME);
        Map<String, String> options = Collections.emptyMap();

        try {
        	URL url = FileLocator.resolve(FileLocator.find(bundle, path, options));
        	return Paths.get(url.toURI());
        }
        catch (IOException | URISyntaxException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }
}
