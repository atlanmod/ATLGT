package org.eclipse.m2m.atl.atlgt.core;

import org.eclipse.emf.common.util.URI;
import org.eclipse.m2m.atl.atlgt.atlidfier.AtlIdfierTransformationFactory;
import org.eclipse.m2m.atl.atlgt.ecore2km3.EmfToKm3TransformationFactory;
import org.eclipse.m2m.atl.atlgt.tools.Commands;
import org.eclipse.m2m.atl.atlgt.util.Metamodels;
import org.eclipse.m2m.atl.atlgt.util.URIs;

import java.util.function.Function;
import java.util.stream.Collectors;
import java.util.stream.StreamSupport;

/**
 * Static class that regroups the different tasks of ATL-GT.
 */
public final class Tasks {

    private Tasks() {
        throw new IllegalStateException("This class should not be initialized");
    }

    /**
     * Step A: Metamodel processing.
     *
     * @return a new function
     */
    public static Function<Context, Context> metamodelProcessing() {
        return context -> {
            System.out.println();
            System.out.println("### Metamodel processing");

            // A.1 Ecore to KM3
            Iterable<URI> km3Metamodels = StreamSupport.stream(context.metamodels().spliterator(), false)
                    .map(metamodel -> EmfToKm3TransformationFactory.withEmftvm().transform(metamodel, context.tempDirectory().appendSegment(URIs.filename(metamodel, ".km3"))))
                    .collect(Collectors.toList());

            // A.2 Ecore Relaxation
            Iterable<URI> relaxedMetamodels = StreamSupport.stream(context.metamodels().spliterator(), false)
                    .map(metamodel -> Metamodels.relax(metamodel, context.tempDirectory().appendSegment(URIs.filename(metamodel, "-relaxed.ecore"))))
                    .collect(Collectors.toList());

            // A.3 Relaxed Ecore to Relaxed KM3
            Iterable<URI> km3RelaxedMetamodels = StreamSupport.stream(relaxedMetamodels.spliterator(), false)
                    .map(metamodel -> EmfToKm3TransformationFactory.withEmftvm().transform(metamodel, context.tempDirectory().appendSegment(URIs.filename(metamodel, ".km3"))))
                    .collect(Collectors.toList());

            // A.4 KM3 to KM3 with IDs
            // Adding an optional attribute with name __xmiID__ and type String to each class
            km3Metamodels.forEach(Metamodels::identify);

            // A.5 Relaxed KM3 to Relaxed KM3 with IDs
            km3RelaxedMetamodels.forEach(Metamodels::identify);

            return context;
        };
    }

    /**
     * Step B: Transformation processing.
     *
     * @return a new function
     */
    public static Function<Context, Context> transformationProcessing() {
        return context -> {
            System.out.println();
            System.out.println("### Transformation processing");

            // B.1 ATLIDfier
            // Create a copy of the atl file
            URI atlModule = context.module().appendFileExtension("atl");
            URI idfiedAtlModule = context.tempDirectory().appendSegment(atlModule.lastSegment());
            URIs.copy(atlModule, idfiedAtlModule);

            // Run in-place transformation
            AtlIdfierTransformationFactory.withEmftvm().transform(idfiedAtlModule);

            // B.2 ATL2UNQL
            Commands.atlGt().atlToUnql().execute(
                    "-atl", URIs.absolutePath(idfiedAtlModule), // tmp/ClassDiagram2Relational.atl
                    "-uq", URIs.absolutePath(context.tempDirectory().appendSegment(URIs.filename(context.module(), ".unql"))), // tmp/ClassDiagram2Relational.unql
                    "-ikm3", URIs.absolutePath(context.tempDirectory().appendSegment(URIs.filename(context.inMetamodel(), ".km3"))), // tmp/ClassDiagram.km3
                    "-ipkg", Metamodels.firstPackage(context.inMetamodel()).getName(), // ClassDiagram
                    "-okm3", URIs.absolutePath(context.tempDirectory().appendSegment(URIs.filename(context.outMetamodel(), "-relaxed.km3"))), // tmp/Relational-relaxed.km3
                    "-opkg", Metamodels.firstPackage(context.outMetamodel()).getName()); // Relational

            return context;
        };
    }

    /**
     * Step C: Forward transformation.
     *
     * @return a new function
     */
    public static Function<Context, Context> forwardTransformation() {
        return context -> {
            System.out.println();
            System.out.println("### Forward transformation");

            // C.1 XMI2DOT (we choose the first package name but we support only one package)
            Commands.atlGt().xmiToDot().execute(
                    "-xmi", URIs.absolutePath(context.inModel()), // ClassDiagram/Sample-ClassDiagram.xmi
                    "-dot", URIs.absolutePath(context.tempDirectory().appendSegment(URIs.filename(context.inModel(), ".dot"))), // tmp/Sample-ClassDiagram.dot
                    "-km3", URIs.absolutePath(context.tempDirectory().appendSegment(URIs.filename(context.inMetamodel(), ".km3"))), // tmp/ClassDiagram.km3
                    "-pkg", Metamodels.firstPackage(context.inMetamodel()).getName());// ClassDiagram

            // C.2 Forward UnCAL
            Commands.gRoundTram().fwdUncal().execute(
                    "-ge", "-sb", "-cl", "-zn", "-fi", "-np", "-sa", "-t", "-rw", "-as",
                    "-db", URIs.absolutePath(context.tempDirectory().appendSegment(URIs.filename(context.inModel(), ".dot"))), // tmp/Sample-ClassDiagram.dot
                    "-uq", URIs.absolutePath(context.tempDirectory().appendSegment(URIs.filename(context.module(), ".unql"))), // tmp/ClassDiagram2Relational.unql
                    "-dot", URIs.absolutePath(context.tempDirectory().appendSegment(URIs.filename(context.module(), "-target.dot"))), // tmp/ClassDiagram2Relational-target.dot
                    "-xg", URIs.absolutePath(context.tempDirectory().appendSegment(URIs.filename(context.module(), ".xg"))), // tmp/ClassDiagram2Relational.xg
                    "-ei", URIs.absolutePath(context.tempDirectory().appendSegment(URIs.filename(context.module(), ".ei")))); // tmp/ClassDiagram2Relational.ei

            // C.2.1 Normalize (up-to isomorphism)
            Commands.gRoundTram().bxContract().execute(
                    "-batch",
                    "-src", URIs.absolutePath(context.tempDirectory().appendSegment(URIs.filename(context.module(), "-target.dot"))), // tmp/ClassDiagram2Relational-target.dot
                    "-dst", URIs.absolutePath(context.tempDirectory().appendSegment(URIs.filename(context.module(), "-target-normal.dot")))); // tmp/ClassDiagram2Relational-target-normal.dot

            // C.2.2 DOT2XMI
            Commands.atlGt().dotToXmi().execute(
                    "-dot", URIs.absolutePath(context.tempDirectory().appendSegment(URIs.filename(context.module(), "-target-normal.dot"))), // tmp/ClassDiagram2Relational-target-normal.dot
                    "-xmi", URIs.absolutePath(context.tempDirectory().appendSegment(URIs.filename(context.module(), "-target-normal.xmi"))), // tmp/ClassDiagram2Relational-target-normal.xmi
                    "-km3", URIs.absolutePath(context.tempDirectory().appendSegment(URIs.filename(context.outMetamodel(), "-relaxed.km3"))), // tmp/Relational-relaxed.km3
                    "-pkg", Metamodels.firstPackage(context.outMetamodel()).getName(), // Relational
                    "-uri", Metamodels.firstPackage(context.outMetamodel()).getNsURI()); // http://example.org/Relational

            // C.3 Execution of ATL with IDs
            Metamodels.transform(context.inModel(), context.outModel(), context.inMetamodel(), context.outMetamodel(), context.tempDirectory(), context.module().lastSegment());

            // C.4 Copy the target model to the hidden folder
            URIs.copy(context.outModel(), context.tempDirectory().appendSegment(context.outModel().lastSegment()));

            return context;
        };
    }

    /**
     * Step D: Forward transformation.
     *
     * @return a new function
     */
    public static Function<Context, Context> backwardTransformation() {
        return context -> {
            System.out.println();
            System.out.println("### Backward transformation");

            // D.1 XMI2DOT
            Commands.atlGt().xmiToDot().execute(
                    "-xmi", URIs.absolutePath(context.inModel()), // myRelational.xmi
                    "-dot", URIs.absolutePath(context.tempDirectory().appendSegment(URIs.filename(context.module(), "-target-normal-updated.dot"))), // tmp/ClassDiagram2Relational-target-normal-updated.dot
                    "-odot", URIs.absolutePath(context.tempDirectory().appendSegment(URIs.filename(context.module(), "-target-normal.dot"))), // tmp/ClassDiagram2Relational-target-normal.dot
                    "-km3", URIs.absolutePath(context.tempDirectory().appendSegment(URIs.filename(context.inMetamodel(), ".km3"))), // tmp/Relational.km3
                    "-pkg", Metamodels.firstPackage(context.inMetamodel()).getName()); // Relational

            // D.2 Denormalization
            Commands.gRoundTram().bxContract().execute(
                    "-batch",
                    "-src", URIs.absolutePath(context.tempDirectory().appendSegment(URIs.filename(context.module(), "-target.dot"))), // tmp/ClassDiagram2Relational-target.dot
                    "-dst", URIs.absolutePath(context.tempDirectory().appendSegment(URIs.filename(context.module(), "-target-normal-updated.dot"))), // tmp/ClassDiagram2Relational-target-normal-updated.dot
                    "-usrc", URIs.absolutePath(context.tempDirectory().appendSegment(URIs.filename(context.module(), "-target-updated.dot")))); // tmp/ClassDiagram2Relational-target-updated.dot

            // E.1 Backward UnCAL
            Commands.gRoundTram().bwdUncal().execute(
                    "-t",
                    "-db", URIs.absolutePath(context.tempDirectory().appendSegment(URIs.filename(context.outModel(), ".dot"))), // tmp/myClassDiagram.dot
                    "-udot", URIs.absolutePath(context.tempDirectory().appendSegment(URIs.filename(context.outModel(), "-updated.dot"))), // tmp/myClassDiagram-updated.dot
                    "-dot", URIs.absolutePath(context.tempDirectory().appendSegment(URIs.filename(context.module(), "-target-updated.dot"))), // tmp/ClassDiagram2Relational-target-updated.dot
                    "-xg", URIs.absolutePath(context.tempDirectory().appendSegment(URIs.filename(context.module(), ".xg"))), // tmp/ClassDiagram2Relational.xg
                    "-ei", URIs.absolutePath(context.tempDirectory().appendSegment(URIs.filename(context.module(), ".ei")))); // tmp/ClassDiagram2Relational.ei

            // F.1 DOT2XMI
            Commands.atlGt().dotToXmi().execute(
                    "-dot", URIs.absolutePath(context.tempDirectory().appendSegment(URIs.filename(context.outModel(), "-updated.dot"))), // tmp/myClassDiagram-updated.dot
                    "-xmi", URIs.absolutePath(context.outModel()), // myClassDiagram.xmi
                    "-km3", URIs.absolutePath(context.tempDirectory().appendSegment(URIs.filename(context.outMetamodel(), ".km3"))), // tmp/ClassDiagram.km3
                    "-pkg", Metamodels.firstPackage(context.outMetamodel()).getName(), // ClassDiagram
                    "-uri", Metamodels.firstPackage(context.outMetamodel()).getNsURI()); // http://example.org/ClassDiagram
            return context;
        };
    }
}