package org.eclipse.m2m.atl.atlgt.tools;

import org.eclipse.core.runtime.FileLocator;
import org.eclipse.core.runtime.IPath;
import org.eclipse.core.runtime.Platform;
import org.osgi.framework.Bundle;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URISyntaxException;
import java.net.URL;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Collections;
import java.util.Enumeration;
import java.util.Objects;
import java.util.jar.JarEntry;
import java.util.jar.JarFile;

import static java.util.Objects.isNull;

/**
 * A factory of {@link CommandBuilder}s.
 */
public class Commands {

    private static final String BUNDLE_SYMBOLIC_NAME = "org.eclipse.m2m.atl.atlgt.tools";

    /**
     * The temporary directory where to extract the executables.
     */
    private static Path tempDirectory;

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
        IPath internalPath = new org.eclipse.core.runtime.Path(String.format("lib/%s/bin/%s", name, os()));
        Bundle bundle = Platform.getBundle(BUNDLE_SYMBOLIC_NAME);

        try {
            URL url = FileLocator.resolve(bundle.getEntry("/"));

            // If the bundle is inside a JAR
            if (Objects.equals(url.getProtocol(), "jar")) {
                return extractJar(url).resolve(internalPath.toOSString());
            }
            else {
                return Paths.get(FileLocator.resolve(FileLocator.find(bundle, internalPath, Collections.emptyMap())).toURI());
            }
        }
        catch (IOException | URISyntaxException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    /**
     * Extracts the content from a JAR file to a temporary directory.
     *
     * @param url the bundle URL
     *
     * @return the location
     *
     * @throws IOException if an I/O error occurs during the extraction
     */
    private static Path extractJar(URL url) throws IOException {
        if (isNull(tempDirectory)) {
            tempDirectory = Files.createTempDirectory("atlgt-tools");

            String jarUrl = new URL(url.getPath()).getPath();
            File jarFile = new File(jarUrl.substring(os().startsWith("win") ? 1 : 0, jarUrl.indexOf('!')));

            System.out.println("Extracting binaries from: " + jarFile.getName());

            // Extracting the content from the JAR
            try (JarFile jar = new JarFile(jarFile)) {
                for (Enumeration<JarEntry> entries = jar.entries(); entries.hasMoreElements(); ) {
                    JarEntry entry = entries.nextElement();

                    Path fileName = tempDirectory.resolve(entry.getName());

                    if (!entry.isDirectory() && entry.getName().startsWith("lib/") && entry.getName().contains(os())) {
                        Files.createDirectories(fileName.getParent());

                        try (InputStream in = new BufferedInputStream(jar.getInputStream(entry)); OutputStream out = new BufferedOutputStream(new FileOutputStream(fileName.toFile()))) {
                            while (in.available() > 0) {
                                out.write(in.read());
                            }
                        }
                    }
                }
            }
        }
        return tempDirectory;
    }

    private static String os() {
        String name = System.getProperty("os.name").toLowerCase();
        String arch = System.getProperty("os.arch").toLowerCase();

        if (name.contains("win")) {
            name = "win";
        }
        else if (name.contains("mac")) {
            name = "osx";
        }
        else {
            name = "linux";
        }

        if (arch.contains("64")) {
            arch = "64";
        }
        else {
            arch = "32";
        }

        return String.format("%s-%s", name, arch);
    }
}
