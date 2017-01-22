package org.eclipse.m2m.atl.atlgt.ecore2km3;

/**
 * A factory of {@link EmfToKm3Transformation}s.
 */
public final class EmfToKm3TransformationFactory {

    private EmfToKm3TransformationFactory() {
        throw new IllegalStateException("This class should not be initialized");
    }

    /**
     * Creates an {@link EmfToKm3Transformation} that is executed on an 'EMFVM' virtual machine.
     *
     * @return a new transformation
     */
    @Deprecated
    public static EmfToKm3Transformation withEmfvm() {
        return new EmfToKm3TransformationEmfvm();
    }

    /**
     * Creates an {@link EmfToKm3Transformation} that is executed on an 'EMFTVM' virtual machine.
     *
     * @return a new transformation
     */
    public static EmfToKm3Transformation withEmftvm() {
        return new EmfToKm3TransformationEmftvm();
    }
}
