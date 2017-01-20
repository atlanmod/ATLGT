package org.eclipse.m2m.atl.atlgt.ecore2km3;

/**
 *
 */
public final class TransformationFactory {

    @Deprecated
    public static Transformation withEmfvm() {
        return new TransformationEmfvm();
    }

    public static Transformation withEmftvm() {
        return new TransformationEmftvm();
    }
}
