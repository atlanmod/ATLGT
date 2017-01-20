package org.eclipse.m2m.atl.atlgt.atlidfier;

import org.eclipse.m2m.atl.core.ATLCoreException;

import java.io.IOException;

@FunctionalInterface
public interface AtlIdfierTransformation {

    String transform(String outputDirectory, String module) throws ATLCoreException, IOException;
}
