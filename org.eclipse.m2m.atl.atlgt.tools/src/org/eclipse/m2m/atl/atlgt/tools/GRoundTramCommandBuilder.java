package org.eclipse.m2m.atl.atlgt.tools;

import java.nio.file.Path;

/**
 * A specific {@link CommandBuilder} for GRoundTram.
 */
public class GRoundTramCommandBuilder extends AbstractCommandBuilder {

    /**
     * Constructs a new {@code GRoundTramCommandBuilder} on the given {@code path}.
     *
     * @param path the path of the {@link Command}
     */
    public GRoundTramCommandBuilder(Path path) {
        super(path);
    }

    /**
     * ???
     *
     * @return a new command
     */
    public Command bwdUncal() {
        return build("bwd_uncal");
    }

    /**
     * ???
     *
     * @return a new command
     */
    public Command bwdDUncal() {
        return build("bwdD_uncal");
    }

    /**
     * ???
     *
     * @return a new command
     */
    public Command bwdIEnumUncal() {
        return build("bwdI_enum_uncal");
    }

    /**
     * ???
     *
     * @return a new command
     */
    public Command bwdIUncal() {
        return build("bwdI_uncal");
    }

    /**
     * ???
     *
     * @return a new command
     */
    public Command bwdIgUncal() {
        return build("bwdIg_uncal");
    }

    /**
     * ???
     *
     * @return a new command
     */
    public Command bxContract() {
        return build("bx_contract");
    }

    /**
     * ???
     *
     * @return a new command
     */
    public Command bxQuick() {
        return build("bx_quick");
    }

    /**
     * ???
     *
     * @return a new command
     */
    public Command chkuncal() {
        return build("chkuncal");
    }

    /**
     * ???
     *
     * @return a new command
     */
    public Command desugar() {
        return build("desugar");
    }

    /**
     * ???
     *
     * @return a new command
     */
    public Command fi2si() {
        return build("fi2si");
    }

    /**
     * ???
     *
     * @return a new command
     */
    public Command fwdUncal() {
        return build("fwd_uncal");
    }

    /**
     * ???
     *
     * @return a new command
     */
    public Command fwdIUncal() {
        return build("fwdI_uncal");
    }

    /**
     * ???
     *
     * @return a new command
     */
    public Command gtram() {
        return build("gtram");
    }

    /**
     * ???
     *
     * @return a new command
     */
    public Command uncal() {
        return build("uncalcmd");
    }

    /**
     * ???
     *
     * @return a new command
     */
    public Command unqlplus() {
        return build("unqlplus");
    }
}
