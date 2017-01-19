package org.eclipse.m2m.atl.atlgt.ecore2km3;

import org.eclipse.m2m.atl.core.ATLCoreException;

import java.io.IOException;

public interface EcoreTransformation {

    void transform(String outputDirectory, String metamodelPath) throws ATLCoreException, IOException;
}
