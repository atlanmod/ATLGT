package org.eclipse.m2m.atl.atlgt.ecore2km3;

/**
 *
 */
public final class EcoreTransformationFactory {

    public static EcoreTransformation withEmfvm() {
        return new EcoreTransformationEmfvm();
    }

    public static EcoreTransformation withEmftvm() {
        return new EcoreTransformationEmftvm();
    }
}
