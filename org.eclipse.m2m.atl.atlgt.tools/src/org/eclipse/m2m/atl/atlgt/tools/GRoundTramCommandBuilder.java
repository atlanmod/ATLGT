package org.eclipse.m2m.atl.atlgt.tools;

import java.nio.file.Path;

/**
 *
 */
public class GRoundTramCommandBuilder extends AbstractCommandBuilder {

    public GRoundTramCommandBuilder(Path path) {
        super(path);
    }

    public Command bwdUncal() {
        return build("bwd_uncal");
    }

    public Command bwdDUncal() {
        return build("bwdD_uncal");
    }

    public Command bwdIEnumUncal() {
        return build("bwdI_enum_uncal");
    }

    public Command bwdIUncal() {
        return build("bwdI_uncal");
    }

    public Command bwdIgUncal() {
        return build("bwdIg_uncal");
    }

    public Command bxContract() {
        return build("bx_contract");
    }

    public Command bxQuick() {
        return build("bx_quick");
    }

    public Command chkuncal() {
        return build("chkuncal");
    }

    public Command desugar() {
        return build("desugar");
    }

    public Command fi2si() {
        return build("fi2si");
    }

    public Command fwdUncal() {
        return build("fwd_uncal");
    }

    public Command fwdIUncal() {
        return build("fwdI_uncal");
    }

    public Command gtram() {
        return build("gtram");
    }

    public Command uncal() {
        return build("uncalcmd");
    }

    public Command unqlplus() {
        return build("unqlplus");
    }
}
