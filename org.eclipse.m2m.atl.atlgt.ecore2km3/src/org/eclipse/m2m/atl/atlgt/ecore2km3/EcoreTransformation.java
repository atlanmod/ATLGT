package org.eclipse.m2m.atl.atlgt.ecore2km3;

import org.eclipse.m2m.atl.core.ATLCoreException;

import java.io.File;
import java.io.IOException;

public interface EcoreTransformation {

    void transform(File directory, String metamodelPath) throws ATLCoreException, IOException;
}
