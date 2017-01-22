package org.eclipse.m2m.atl.atlgt.tools;

import java.io.IOException;

/**
 * A command-line that can be executed.
 */
@FunctionalInterface
public interface Command {

    /**
     * Executes this {@code Command} with the given {@code args}.
     *
     * @param args the arguments of the command to be executed
     *
     * @return the result of the execution ({@code 0 = success}
     *
     * @throws IOException if an I/O error occurs
     */
    int execute(String... args) throws IOException;
}
