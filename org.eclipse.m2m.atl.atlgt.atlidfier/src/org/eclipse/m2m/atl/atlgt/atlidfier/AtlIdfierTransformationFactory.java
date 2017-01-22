package org.eclipse.m2m.atl.atlgt.atlidfier;

/**
 * A factory of {@link AtlIdfierTransformation}s.
 */
public final class AtlIdfierTransformationFactory {

    /**
     * Creates an {@link AtlIdfierTransformation} that is executed on an 'EMFTVM' virtual machine.
     *
     * @return a new transformation
     */
    public static AtlIdfierTransformation withEmftvm() {
        return new AtlIdfierTransformationEmftvm();
    }
}
