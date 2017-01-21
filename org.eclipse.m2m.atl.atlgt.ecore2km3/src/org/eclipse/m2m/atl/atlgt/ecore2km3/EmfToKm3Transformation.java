package org.eclipse.m2m.atl.atlgt.ecore2km3;

import org.eclipse.emf.common.util.URI;

@FunctionalInterface
public interface EmfToKm3Transformation {

    /**
     * Transforms an Ecore model to a KM3 model.
     *
     * @param outputDirectory the directory where to store the resulting models
     * @param metamodel the metamodel to transform
     *
     * @return the URI of the created KM3 model
     *
     * @throws IllegalArgumentException if the given metamodel is not an Ecore model (if its extension is {@code != "ecore"})
     */
    URI transform(URI outputDirectory, URI metamodel);
}
