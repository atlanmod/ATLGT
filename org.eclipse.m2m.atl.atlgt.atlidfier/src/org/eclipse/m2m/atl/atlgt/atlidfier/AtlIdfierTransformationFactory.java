package org.eclipse.m2m.atl.atlgt.atlidfier;

/**
 * A factory of {@link AtlIdfierTransformation}s.
 */
public final class AtlIdfierTransformationFactory {

    private AtlIdfierTransformationFactory() {
        throw new IllegalStateException("This class should not be initialized");
    }

    /**
     * Creates an {@link AtlIdfierTransformation} that is executed on an 'EMFTVM' virtual machine.
     *
     * @return a new transformation
     */
    public static AtlIdfierTransformation withEmftvm() {
        return new AtlIdfierTransformationEmftvm();
    }
}
