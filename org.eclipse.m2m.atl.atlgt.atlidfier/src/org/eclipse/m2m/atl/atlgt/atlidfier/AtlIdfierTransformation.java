package org.eclipse.m2m.atl.atlgt.atlidfier;

import org.eclipse.emf.common.util.URI;
import org.eclipse.m2m.atl.core.ATLCoreException;

import java.io.IOException;

@FunctionalInterface
public interface AtlIdfierTransformation {

    URI transform(URI outputDirectory, URI module) throws ATLCoreException, IOException;
}
