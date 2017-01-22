package org.eclipse.m2m.atl.atlgt.groundtram;

import java.io.IOException;

/**
 *
 */
@FunctionalInterface
public interface Executor {

    int execute(String program, String... args) throws IOException;
}
