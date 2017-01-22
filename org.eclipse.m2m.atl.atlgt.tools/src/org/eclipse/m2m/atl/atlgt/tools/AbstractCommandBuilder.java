package org.eclipse.m2m.atl.atlgt.tools;

import java.nio.file.Path;

/**
 * An abstract {@link CommandBuilder} that builds {@link Command}s from a path and a program name.
 */
public abstract class AbstractCommandBuilder implements CommandBuilder {

    /**
     * The path of the {@link Command}.
     */
    private final Path path;

    /**
     * Constructs a new {@code AbstractCommandBuilder} on the given {@code path}.
     *
     * @param path the path of the {@link Command}
     */
    protected AbstractCommandBuilder(Path path) {
        this.path = path;
    }

    /**
     * Builds a new {@link Command} with the given {@code program}.
     *
     * @param program the name of the program
     *
     * @return a new {@link Command}
     */
    protected Command build(String program) {
        return new DefaultCommand(path, program);
    }
}
