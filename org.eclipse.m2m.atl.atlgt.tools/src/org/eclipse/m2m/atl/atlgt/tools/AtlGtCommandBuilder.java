package org.eclipse.m2m.atl.atlgt.tools;

import java.nio.file.Path;

/**
 * A specific {@link CommandBuilder} for ATL-GT.
 */
public class AtlGtCommandBuilder extends AbstractCommandBuilder {

    /**
     * Constructs a new {@code AtlGtCommandBuilder} on the given {@code path}.
     *
     * @param path the path of the {@link Command}
     */
    public AtlGtCommandBuilder(Path path) {
        super(path);
    }

    /**
     * ???
     *
     * @return a new command
     */
    public Command atlToUnql() {
        return build("atl2unql");
    }

    /**
     * ???
     *
     * @return a new command
     */
    public Command dotToDgm() {
        return build("dot2dgm_command");
    }

    /**
     * ???
     *
     * @return a new command
     */
    public Command dotToXmi() {
        return build("dot2xmi_command");
    }

    /**
     * ???
     *
     * @return a new command
     */
    public Command trace() {
        return build("trace");
    }

    /**
     * ???
     *
     * @return a new command
     */
    public Command xmiToDot() {
        return build("xmi2dot_generic_command");
    }
    
    /**
     * ???
     *
     * @return a new command
     */
    public Command restrictAndXmiToDot() {
        return build("restrictxmi_xmi2dot_command");
    }


    /**
     * ???
     *
     * @return a new command
     */
    public Command xmiToDotRestricted() {
        return build("restrictxmi_xmi2dot_command");
    }
}
