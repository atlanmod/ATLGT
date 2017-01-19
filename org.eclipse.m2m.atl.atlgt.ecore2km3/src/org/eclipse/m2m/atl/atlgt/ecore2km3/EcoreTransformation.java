package org.eclipse.m2m.atl.atlgt.ecore2km3;

import org.eclipse.m2m.atl.core.ATLCoreException;

import java.io.IOException;
import java.nio.file.Path;

public interface EcoreTransformation {

    void transform(Path directory, String metamodelPath) throws ATLCoreException, IOException;
}
