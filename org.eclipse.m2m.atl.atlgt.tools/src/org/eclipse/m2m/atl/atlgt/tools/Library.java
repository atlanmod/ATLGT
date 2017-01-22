package org.eclipse.m2m.atl.atlgt.tools;

import java.io.IOException;

/**
 *
 */
@FunctionalInterface
public interface Library {

    int execute(String program, String... args) throws IOException;
}
