package org.eclipse.m2m.atl.atlgt.atlidfier;

/**
 *
 */
public final class AtlIdfierTransformationFactory {

    public static AtlIdfierTransformation withEmftvm() {
        return new AtlIdfierTransformationEmftvm();
    }
}
