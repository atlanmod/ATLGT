package org.eclipse.m2m.atl.atlgt.projector;

/**
 * A factory of {@link Projector}s.
 */
public final class ProjectorFactory {

    private ProjectorFactory() {
        throw new IllegalStateException("This class should not be initialized");
    }

    /**
     * Creates an {@link AtlIdfierTransformation} that is executed on an 'EMFTVM' virtual machine.
     *
     * @return a new transformation
     */
    public static Projector withEmftvm() {
        return new Projector();
    }
}
