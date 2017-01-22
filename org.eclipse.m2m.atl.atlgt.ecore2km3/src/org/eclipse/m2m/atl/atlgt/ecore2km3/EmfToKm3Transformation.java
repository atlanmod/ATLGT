package org.eclipse.m2m.atl.atlgt.ecore2km3;

import org.eclipse.emf.common.util.URI;

/**
 * A ATL transformation
 */
@FunctionalInterface
public interface EmfToKm3Transformation {

    /**
     * The ATL module.
     */
    String MODULE = "EMF2KM3";

    /**
     * Transforms an Ecore {@code metamodel} to a KM3 metamodel.
     *
     * @param outputDirectory the directory where to store the resulting models
     * @param metamodel the Ecore metamodel to transform
     *
     * @return the URI of the created KM3 model
     *
     * @throws IllegalArgumentException if the given metamodel is not an Ecore model (if its extension is {@code != "ecore"})
     */
    URI transform(URI outputDirectory, URI metamodel);
}
