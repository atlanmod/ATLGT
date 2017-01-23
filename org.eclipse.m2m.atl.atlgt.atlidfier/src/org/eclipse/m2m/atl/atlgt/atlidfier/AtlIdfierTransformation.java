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
     * @param module the ATL module to transform
     *
     * @return the {@code module} URI
     */
    URI transform(URI module);
}
