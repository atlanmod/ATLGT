package org.eclipse.m2m.atl.atlgt.tools;

import java.nio.file.Path;

/**
 *
 */
public class AtlGtCommandBuilder extends AbstractCommandBuilder {

    public AtlGtCommandBuilder(Path path) {
        super(path);
    }

    public Command atlToUnql() {
        return build("atl2unql");
    }

    public Command dotToDgm() {
        return build("dot2dgm_command");
    }

    public Command dotToXmi() {
        return build("dot2xmi_command");
    }

    public Command trace() {
        return build("trace");
    }

    public Command xmiToDot() {
        return build("xmi2dot_generic_command");
    }
}
