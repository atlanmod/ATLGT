package org.eclipse.m2m.atl.atlgt.util;

import org.eclipse.core.runtime.FileLocator;
import org.eclipse.core.runtime.IPath;
import org.eclipse.core.runtime.Platform;
import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.resource.URIConverter;
import org.eclipse.emf.ecore.resource.impl.ExtensibleURIConverterImpl;
import org.osgi.framework.Bundle;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URISyntaxException;
import java.net.URL;
import java.nio.ByteBuffer;
import java.nio.channels.Channels;
import java.nio.channels.ReadableByteChannel;
import java.nio.channels.WritableByteChannel;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Collections;
import java.util.Map;

import static java.util.Objects.isNull;

/**
 * Utility methods for working with {@link URI}s.
 */
public final class URIHelpers {

    private URIHelpers() {
        throw new IllegalStateException("This class should not be initialized");
    }

    public static Path toPath(URI uri) {
        if (!uri.isPlatformResource()) {
            throw new IllegalArgumentException("Cannot convert a non platform-URI");
        }

        System.out.println("URI:             " + uri);

        String bundlePath = uri.toString().replace("platform:/resource/", "");
        System.out.println("Bundle path:     " + bundlePath);

        String bundleName = bundlePath.substring(0, bundlePath.indexOf('/'));
        System.out.println("Bundle name:     " + bundleName);

        String internalPath = bundlePath.substring(bundleName.length() + 1);
        System.out.println("Internal path:   " + internalPath);

        String internalFolder = internalPath.substring(0, internalPath.length() - uri.lastSegment().length() - 1);
        System.out.println("Internal folder: " + internalFolder);

        IPath path = new org.eclipse.core.runtime.Path(internalFolder);
        System.out.println("IPath:           " + path);

        Bundle bundle = Platform.getBundle(bundleName);
        System.out.println("Bundle:          " + bundle);
        if (isNull(bundle)) {
            throw new NullPointerException("Cannot find the bundle '" + bundleName + "' in this platform");
        }
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

    /**
     * Copies the content of the {@code source} {@link URI} to the {@code target} {@link URI}.
     *
     * @param source the URI to copy
     * @param target the URI of the copy
     *
     * @throws IOException if an I/O error occurs
     */
    public static void copy(URI source, URI target) throws IOException {
        URIConverter uriConverter = new ExtensibleURIConverterImpl();
        uriConverter.createInputStream(source);
        uriConverter.createOutputStream(target);

        try (InputStream inputStream = uriConverter.createInputStream(source); OutputStream outputStream = uriConverter.createOutputStream(target)) {
            try (ReadableByteChannel inputChannel = Channels.newChannel(inputStream); WritableByteChannel outputChannel = Channels.newChannel(outputStream)) {
                final ByteBuffer buffer = ByteBuffer.allocateDirect(16 * 1024);
                while (inputChannel.read(buffer) != -1) {
                    buffer.flip();
                    outputChannel.write(buffer);
                    buffer.compact();
                }
                buffer.flip();
                while (buffer.hasRemaining()) {
                    outputChannel.write(buffer);
                }
            }
        }
    }
}
