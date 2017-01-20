package org.eclipse.m2m.atl.atlgt.ecore2km3;

/**
 *
 */
public final class EmfToKm3TransformationFactory {

    @Deprecated
    public static EmfToKm3Transformation withEmfvm() {
        return new EmfToKm3TransformationEmfvm();
    }

    public static EmfToKm3Transformation withEmftvm() {
        return new EmfToKm3TransformationEmftvm();
    }
}
