package org.eclipse.m2m.atl.atlgt.tools;

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
     */
    int execute(String... args);
}
