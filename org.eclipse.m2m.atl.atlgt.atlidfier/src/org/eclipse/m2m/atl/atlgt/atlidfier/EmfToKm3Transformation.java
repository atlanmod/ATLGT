package org.eclipse.m2m.atl.atlgt.atlidfier;

import org.eclipse.m2m.atl.core.ATLCoreException;

import java.io.IOException;

@FunctionalInterface
public interface EmfToKm3Transformation {

    void transform(String outputDirectory, String metamodelPath) throws ATLCoreException, IOException;
}
