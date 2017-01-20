package org.eclipse.m2m.atl.atlgt.atlidfier;

/**
 *
 */
public final class ATLIdfierTransformationFactory {

    public static ATLIdfierTransformation withEmftvm() {
        return new ATLIdfierTransformationEmftvm();
    }
}
