package org.eclipse.m2m.atl.atlgt.ecore2km3;

@FunctionalInterface
public interface EmfToKm3Transformation {

    String transform(String outputDirectory, String metamodel);
}
