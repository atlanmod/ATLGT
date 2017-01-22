package org.eclipse.m2m.atl.atlgt.util;

import org.eclipse.core.resources.ResourcesPlugin;
import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.resource.URIConverter;
import org.eclipse.emf.ecore.resource.impl.ExtensibleURIConverterImpl;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.ByteBuffer;
import java.nio.channels.Channels;
import java.nio.channels.ReadableByteChannel;
import java.nio.channels.WritableByteChannel;
import java.nio.file.Path;
import java.nio.file.Paths;

/**
 * Utility methods for working with {@link URI}s.
 */
public final class URIHelpers {

    private URIHelpers() {
        throw new IllegalStateException("This class should not be initialized");
    }

    public static Path toAbsolutePath(URI uri) {
        return Paths.get(
                ResourcesPlugin.getWorkspace()
                        .getRoot()
                        .getFile(new org.eclipse.core.runtime.Path(uri.toPlatformString(true)))
                        .getRawLocation()
                        .toOSString());
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
