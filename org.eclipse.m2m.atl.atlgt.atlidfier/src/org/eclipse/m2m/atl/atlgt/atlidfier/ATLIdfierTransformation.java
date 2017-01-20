package org.eclipse.m2m.atl.atlgt.atlidfier;

import org.eclipse.m2m.atl.core.ATLCoreException;

import java.io.IOException;

@FunctionalInterface
public interface ATLIdfierTransformation {

    void transform(String outputDirectory, String atlPath) throws ATLCoreException, IOException;
}
