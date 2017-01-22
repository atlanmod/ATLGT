package org.eclipse.m2m.atl.atlgt.atlidfier;

import org.eclipse.emf.common.util.URI;

/**
 * ???
 */
@FunctionalInterface
public interface AtlIdfierTransformation {

    /**
     * The ATL module.
     */
    String MODULE = "ATLIDfier";

    /**
     * Transforms an ATL {@code module}.
     *
     * @param outputDirectory the directory where to store the resulting models
     * @param module          the ATL module to transform
     *
     * @return the URI of the created ATL module
     */
    URI transform(URI outputDirectory, URI module);
}
