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
     * Transforms an Ecore metamodel to a KM3 metamodel.
     *
     * @param source the Ecore metamodel to transform
     * @param target the KM3 metamodel to create
     *
     * @return the {@code target} URI
     *
     * @throws IllegalArgumentException if the given metamodel is not an Ecore model (if its extension is {@code !=
     *                                  "ecore"})
     */
    URI transform(URI source, URI target);
}
