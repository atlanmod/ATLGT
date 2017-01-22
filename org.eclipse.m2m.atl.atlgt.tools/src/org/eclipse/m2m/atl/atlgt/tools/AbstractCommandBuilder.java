package org.eclipse.m2m.atl.atlgt.tools;

import java.nio.file.Path;

/**
 *
 */
public abstract class AbstractCommandBuilder {

    private final Path path;

    protected AbstractCommandBuilder(Path path) {
        this.path = path;
    }

    protected Command build(String program) {
        return new DefaultCommand(path, program);
    }
}
