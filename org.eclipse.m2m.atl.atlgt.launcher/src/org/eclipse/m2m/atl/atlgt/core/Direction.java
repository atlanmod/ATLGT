package org.eclipse.m2m.atl.atlgt.core;

/**
 * Represents the direction of a transformation.
 */
public enum Direction {

    FORWARD("Forward"),
    BACKWARD("Backward");

    private final String name;

    Direction(String name) {
        this.name = name;
    }

    /**
     * Returns a literal description of this direction.
     *
     * @return the literal description
     */
    public String getName() {
        return name;
    }
}
