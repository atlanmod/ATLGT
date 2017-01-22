package org.eclipse.m2m.atl.atlgt.groundtram;

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
 *
 */
public class Executors {

    private Executors() {
        throw new IllegalStateException("This class should not be initialized");
    }

    public static Executor atlGt() {
        return new DefaultExecutor(resolve("ATL-GT"));
    }

    public static Executor gRoundTram() {
        return new DefaultExecutor(resolve("ground_tram-0.9.5"));
    }

    private static Path resolve(String name) {
        IPath path = new org.eclipse.core.runtime.Path("lib/" + name + "/bin");
        Bundle bundle = Platform.getBundle(Activator.PLUGIN_ID);
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
