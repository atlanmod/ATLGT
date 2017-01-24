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
     * <p>
     * ???
     *
     * @return a new function
     */
    public static Function<Context, Context> metamodelProcessing() {
        return context -> {

            System.out.println();
            System.out.println("### Metamodel processing");

            ecoreToKm3()
                    .andThen(relaxedEcoreToRelaxedKm3())
                    .apply(context);

            return context;
        };
    }

    /**
     * Step B: Transformation processing.
     * <p>
     * ???
     *
     * @return a new function
     */
    public static Function<Context, Context> transformationProcessing() {
        return context -> {

            System.out.println();
            System.out.println("### Transformation processing");

            atlIdfier()
                    .andThen(atlToUnql())
                    .apply(context);

            return context;
        };
    }

    /**
     * Step C: Forward transformation.
     * <p>
     * ???
     *
     * @return a new function
     */
    public static Function<Context, Context> forwardTransformation() {
        return context -> {

            System.out.println();
            System.out.println("### Forward transformation");

            fwdXmiToDot()
                    .andThen(fwdUncal())
                    .andThen(fwdNormalize())
                    .andThen(fwdDotToXmi())
                    .apply(context);

            // C.3 Execution of ATL with IDs
            Metamodels.transform(context.inModel(), context.outModel(), context.metamodels(), context.tempDirectory(), context.module().lastSegment());

            // C.4 Copy the target model to the hidden folder
            URIs.copy(context.outModel(), context.tempDirectory().appendSegment(context.outModel().lastSegment()));

            return context;
        };
    }

    /**
     * Step D: Backward transformation.
     * <p>
     * ???
     *
     * @return a new function
     */
    public static Function<Context, Context> backwardTransformation() {
        return context -> {

            System.out.println();
            System.out.println("### Backward transformation");

            bwdXmiToDot()
                    .andThen(bwdDenormalize())
                    .andThen(bwdUncal())
                    .andThen(bwdDotToXmi())
                    .apply(context);

            return context;
        };
    }

    /**
     * Step A.1: Ecore to KM3 / Step A.2: KM3 to KM3 with IDs.
     * <p>
     * ???
     *
     * @return a new function
     */
    private static Function<Context, Context> ecoreToKm3() {
        return context -> {

            // A.1 Ecore to KM3
            Iterable<URI> km3Metamodels = StreamSupport.stream(context.metamodels().spliterator(), false)
                    .map(metamodel -> EmfToKm3TransformationFactory.withEmftvm().transform(metamodel, context.tempDirectory().appendSegment(URIs.fn(metamodel, ".km3"))))
                    .collect(Collectors.toList());

            // A.2 KM3 to KM3 with IDs
            // Adding an optional attribute with name __xmiID__ and type String to each class
            km3Metamodels.forEach(Metamodels::identify);

            return context;
        };
    }

    /**
     * Step A.3 Ecore Relaxation / Step A.4 Relaxed Ecore to Relaxed KM3 / Step A.5 Relaxed KM3 to Relaxed KM3 with IDs.
     * <p>
     * ???
     *
     * @return a new function
     */
    private static Function<Context, Context> relaxedEcoreToRelaxedKm3() {
        return context -> {

            // A.3 Ecore Relaxation
            Iterable<URI> relaxedMetamodels = StreamSupport.stream(context.metamodels().spliterator(), false)
                    .map(metamodel -> Metamodels.relax(metamodel, context.tempDirectory().appendSegment(URIs.fn(metamodel, "-relaxed.ecore"))))
                    .collect(Collectors.toList());

            // A.4 Relaxed Ecore to Relaxed KM3
            Iterable<URI> km3RelaxedMetamodels = StreamSupport.stream(relaxedMetamodels.spliterator(), false)
                    .map(metamodel -> EmfToKm3TransformationFactory.withEmftvm().transform(metamodel, context.tempDirectory().appendSegment(URIs.fn(metamodel, ".km3"))))
                    .collect(Collectors.toList());

            // A.5 Relaxed KM3 to Relaxed KM3 with IDs
            km3RelaxedMetamodels.forEach(Metamodels::identify);

            return context;
        };
    }

    /**
     * Step B.1: ATLIDfier.
     * <p>
     * ???
     *
     * @return a new function
     */
    private static Function<Context, Context> atlIdfier() {
        return context -> {

            // B.1 ATLIDfier
            // Create a copy of the atl file
            URI atlModule = context.module().appendFileExtension("atl");
            URI idfiedAtlModule = context.tempDirectory().appendSegment(atlModule.lastSegment());
            URIs.copy(atlModule, idfiedAtlModule);

            // Run in-place transformation
            AtlIdfierTransformationFactory.withEmftvm().transform(idfiedAtlModule);

            return context;
        };
    }

    /**
     * Step B.2: ATL2UNQL.
     * <p>
     * ???
     *
     * @return a new function
     */
    private static Function<Context, Context> atlToUnql() {
        return context -> {

            // B.2 ATL2UNQL
            Commands.atlGt().atlToUnql().execute(
                    "-atl", URIs.abs(context.tempDirectory().appendSegment(URIs.fn(context.module(), ".atl"))),
                    "-uq", URIs.abs(context.tempDirectory().appendSegment(URIs.fn(context.module(), ".unql"))),
                    "-ikm3", URIs.abs(context.tempDirectory().appendSegment(URIs.fn(context.inMetamodel(), ".km3"))),
                    "-ipkg", Metamodels.firstPackage(context.inMetamodel()).getName(),
                    "-okm3", URIs.abs(context.tempDirectory().appendSegment(URIs.fn(context.outMetamodel(), "-relaxed.km3"))),
                    "-opkg", Metamodels.firstPackage(context.outMetamodel()).getName());

            return context;
        };
    }

    /**
     * Step C.1: XMI2DOT.
     * <p>
     * ???
     *
     * @return a new function
     */
    private static Function<Context, Context> fwdXmiToDot() {
        return context -> {

            // C.1 XMI2DOT
            // NOTE: We choose the first package name but we support only one package.
            Commands.atlGt().xmiToDot().execute(
                    "-xmi", URIs.abs(context.inModel()),
                    "-dot", URIs.abs(context.tempDirectory().appendSegment(URIs.fn(context.inModel(), ".dot"))),
                    "-km3", URIs.abs(context.tempDirectory().appendSegment(URIs.fn(context.inMetamodel(), ".km3"))),
                    "-pkg", Metamodels.firstPackage(context.inMetamodel()).getName());

            return context;
        };
    }

    /**
     * Step C.2: Forward UnCAL.
     * <p>
     * ???
     *
     * @return a new function
     */
    private static Function<Context, Context> fwdUncal() {
        return context -> {

            // C.2 Forward UnCAL
            Commands.gRoundTram().fwdUncal().execute(
                    "-ge", "-sb", "-cl", "-zn", "-fi", "-np", "-sa", "-t", "-rw", "-as",
                    "-db", URIs.abs(context.tempDirectory().appendSegment(URIs.fn(context.inModel(), ".dot"))),
                    "-uq", URIs.abs(context.tempDirectory().appendSegment(URIs.fn(context.module(), ".unql"))),
                    "-dot", URIs.abs(context.tempDirectory().appendSegment(URIs.fn(context.outModel(), ".dot"))),
                    "-xg", URIs.abs(context.tempDirectory().appendSegment(URIs.fn(context.transformationInstance(), ".xg"))),
                    "-ei", URIs.abs(context.tempDirectory().appendSegment(URIs.fn(context.transformationInstance(), ".ei"))));

            return context;
        };
    }

    /**
     * Step C.2.1: Normalize (up-to isomorphism).
     * <p>
     * ???
     *
     * @return a new function
     */
    private static Function<Context, Context> fwdNormalize() {
        return context -> {

            // C.2.1 Normalize (up-to isomorphism)
            Commands.gRoundTram().bxContract().execute(
                    "-batch",
                    "-src", URIs.abs(context.tempDirectory().appendSegment(URIs.fn(context.outModel(), ".dot"))),
                    "-dst", URIs.abs(context.tempDirectory().appendSegment(URIs.fn(context.outModel(), "-normal.dot"))));

            return context;
        };
    }

    /**
     * Step C.2.2: DOT2XMI.
     * <p>
     * ???
     *
     * @return a new function
     */
    private static Function<Context, Context> fwdDotToXmi() {
        return context -> {

            // C.2.2 DOT2XMI
            Commands.atlGt().dotToXmi().execute(
                    "-dot", URIs.abs(context.tempDirectory().appendSegment(URIs.fn(context.outModel(), "-normal.dot"))),
                    "-xmi", URIs.abs(context.tempDirectory().appendSegment(URIs.fn(context.outModel(), "-normal.xmi"))),
                    "-km3", URIs.abs(context.tempDirectory().appendSegment(URIs.fn(context.outMetamodel(), "-relaxed.km3"))),
                    "-pkg", Metamodels.firstPackage(context.outMetamodel()).getName(),
                    "-uri", Metamodels.firstPackage(context.outMetamodel()).getNsURI());

            return context;
        };
    }

    /**
     * Step D.1: XMI2DOT.
     * <p>
     * ???
     *
     * @return a new function
     */
    private static Function<Context, Context> bwdXmiToDot() {
        return context -> {

            // D.1 XMI2DOT
            Commands.atlGt().xmiToDot().execute(
                    "-xmi", URIs.abs(context.outModel()),
                    "-dot", URIs.abs(context.tempDirectory().appendSegment(URIs.fn(context.outModel(), "-normal-updated.dot"))),
                    "-odot", URIs.abs(context.tempDirectory().appendSegment(URIs.fn(context.outModel(), "-normal.dot"))),
                    "-km3", URIs.abs(context.tempDirectory().appendSegment(URIs.fn(context.outMetamodel(), "-relaxed.km3"))),
                    "-pkg", Metamodels.firstPackage(context.outMetamodel()).getName());

            return context;
        };
    }

    /**
     * Step D.2: Denormalization.
     * <p>
     * ???
     *
     * @return a new function
     */
    private static Function<Context, Context> bwdDenormalize() {
        return context -> {

            // D.2 Denormalization
            Commands.gRoundTram().bxContract().execute(
                    "-batch",
                    "-src", URIs.abs(context.tempDirectory().appendSegment(URIs.fn(context.outModel(), ".dot"))),
                    "-dst", URIs.abs(context.tempDirectory().appendSegment(URIs.fn(context.outModel(), "-normal-updated.dot"))),
                    "-usrc", URIs.abs(context.tempDirectory().appendSegment(URIs.fn(context.outModel(), "-updated.dot"))));

            return context;
        };
    }

    /**
     * Step E.1. Backward UnCAL.
     * <p>
     * ???
     *
     * @return a new function
     */
    private static Function<Context, Context> bwdUncal() {
        return context -> {

            // E.1 Backward UnCAL
            Commands.gRoundTram().bwdUncal().execute(
                    "-t",
                    "-db", URIs.abs(context.tempDirectory().appendSegment(URIs.fn(context.inModel(), ".dot"))),
                    "-udot", URIs.abs(context.tempDirectory().appendSegment(URIs.fn(context.inModel(), "-updated.dot"))),
                    "-dot", URIs.abs(context.tempDirectory().appendSegment(URIs.fn(context.outModel(), "-updated.dot"))),
                    "-xg", URIs.abs(context.tempDirectory().appendSegment(URIs.fn(context.transformationInstance(), ".xg"))),
                    "-ei", URIs.abs(context.tempDirectory().appendSegment(URIs.fn(context.transformationInstance(), ".ei"))));

            return context;
        };
    }

    /**
     * Step F.1: DOT2XMI.
     * <p>
     * ???
     *
     * @return a new function
     */
    private static Function<Context, Context> bwdDotToXmi() {
        return context -> {

            // F.1 DOT2XMI
            Commands.atlGt().dotToXmi().execute(
                    "-dot", URIs.abs(context.tempDirectory().appendSegment(URIs.fn(context.inModel(), "-updated.dot"))),
                    "-xmi", URIs.abs(context.inModel()),
                    "-km3", URIs.abs(context.tempDirectory().appendSegment(URIs.fn(context.inMetamodel(), ".km3"))),
                    "-pkg", Metamodels.firstPackage(context.inMetamodel()).getName(),
                    "-uri", Metamodels.firstPackage(context.inMetamodel()).getNsURI());

            return context;
        };
    }
}
