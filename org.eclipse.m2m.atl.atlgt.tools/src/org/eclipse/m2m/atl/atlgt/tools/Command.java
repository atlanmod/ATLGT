package org.eclipse.m2m.atl.atlgt.tools;

import java.io.IOException;

/**
 *
 */
@FunctionalInterface
public interface Command {

    int execute(String... args) throws IOException;
}
