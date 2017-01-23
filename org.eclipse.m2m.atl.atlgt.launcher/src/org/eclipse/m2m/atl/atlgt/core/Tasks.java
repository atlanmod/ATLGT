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
                    .map(metamodel -> EmfToKm3TransformationFactory.withEmftvm().transform(metamodel, context.tempDirectory().appendSegment(URIs.fn(metamodel, ".km3"))))
                    .collect(Collectors.toList());

            // A.2 Ecore Relaxation
            Iterable<URI> relaxedMetamodels = StreamSupport.stream(context.metamodels().spliterator(), false)
                    .map(metamodel -> Metamodels.relax(metamodel, context.tempDirectory().appendSegment(URIs.fn(metamodel, "-relaxed.ecore"))))
                    .collect(Collectors.toList());

            // A.3 Relaxed Ecore to Relaxed KM3
            Iterable<URI> km3RelaxedMetamodels = StreamSupport.stream(relaxedMetamodels.spliterator(), false)
                    .map(metamodel -> EmfToKm3TransformationFactory.withEmftvm().transform(metamodel, context.tempDirectory().appendSegment(URIs.fn(metamodel, ".km3"))))
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
                    "-atl", URIs.abs(idfiedAtlModule),
                    "-uq", URIs.abs(context.tempDirectory().appendSegment(URIs.fn(context.module(), ".unql"))),
                    "-ikm3", URIs.abs(context.tempDirectory().appendSegment(URIs.fn(context.inMetamodel(), ".km3"))),
                    "-ipkg", Metamodels.firstPackage(context.inMetamodel()).getName(),
                    "-okm3", URIs.abs(context.tempDirectory().appendSegment(URIs.fn(context.outMetamodel(), "-relaxed.km3"))),
                    "-opkg", Metamodels.firstPackage(context.outMetamodel()).getName());

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
                    "-xmi", URIs.abs(context.inModel()),
                    "-dot", URIs.abs(context.tempDirectory().appendSegment(URIs.fn(context.inModel(), ".dot"))),
                    "-km3", URIs.abs(context.tempDirectory().appendSegment(URIs.fn(context.inMetamodel(), ".km3"))),
                    "-pkg", Metamodels.firstPackage(context.inMetamodel()).getName());

            // C.2 Forward UnCAL
            Commands.gRoundTram().fwdUncal().execute(
                    "-ge", "-sb", "-cl", "-zn", "-fi", "-np", "-sa", "-t", "-rw", "-as",
                    "-db", URIs.abs(context.tempDirectory().appendSegment(URIs.fn(context.inModel(), ".dot"))),
                    "-uq", URIs.abs(context.tempDirectory().appendSegment(URIs.fn(context.module(), ".unql"))),
                    "-dot", URIs.abs(context.tempDirectory().appendSegment(URIs.fn(context.outModel(), ".dot"))),
                    "-xg", URIs.abs(context.tempDirectory().appendSegment(context.transformationInstance() + ".xg")),
                    "-ei", URIs.abs(context.tempDirectory().appendSegment(context.transformationInstance() + ".ei")));

            // C.2.1 Normalize (up-to isomorphism)
            Commands.gRoundTram().bxContract().execute(
                    "-batch",
                    "-src", URIs.abs(context.tempDirectory().appendSegment(URIs.fn(context.outModel(), ".dot"))),
                    "-dst", URIs.abs(context.tempDirectory().appendSegment(URIs.fn(context.outModel(), "-normal.dot"))));

            // C.2.2 DOT2XMI
            Commands.atlGt().dotToXmi().execute(
                    "-dot", URIs.abs(context.tempDirectory().appendSegment(URIs.fn(context.outModel(), "-normal.dot"))),
                    "-xmi", URIs.abs(context.tempDirectory().appendSegment(URIs.fn(context.outModel(), "-normal.xmi"))),
                    "-km3", URIs.abs(context.tempDirectory().appendSegment(URIs.fn(context.outMetamodel(), "-relaxed.km3"))),
                    "-pkg", Metamodels.firstPackage(context.outMetamodel()).getName(),
                    "-uri", Metamodels.firstPackage(context.outMetamodel()).getNsURI());

            // C.3 Execution of ATL with IDs
            Metamodels.transform(context.inModel(), context.outModel(), context.metamodels(), context.tempDirectory(), context.module().lastSegment());

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
                    "-xmi", URIs.abs(context.outModel()),
                    "-dot", URIs.abs(context.tempDirectory().appendSegment(URIs.fn(context.outModel(), "-normal-updated.dot"))),
                    "-odot", URIs.abs(context.tempDirectory().appendSegment(URIs.fn(context.outModel(), "-normal.dot"))),
                    "-km3", URIs.abs(context.tempDirectory().appendSegment(URIs.fn(context.outMetamodel(), "-relaxed.km3"))),
                    "-pkg", Metamodels.firstPackage(context.outMetamodel()).getName());

            // D.2 Denormalization
            Commands.gRoundTram().bxContract().execute(
                    "-batch",
                    "-src", URIs.abs(context.tempDirectory().appendSegment(URIs.fn(context.outModel(), ".dot"))),
                    "-dst", URIs.abs(context.tempDirectory().appendSegment(URIs.fn(context.outModel(), "-normal-updated.dot"))),
                    "-usrc", URIs.abs(context.tempDirectory().appendSegment(URIs.fn(context.outModel(), "-updated.dot"))));

            // E.1 Backward UnCAL
            Commands.gRoundTram().bwdUncal().execute(
                    "-t",
                    "-db", URIs.abs(context.tempDirectory().appendSegment(URIs.fn(context.inModel(), ".dot"))),
                    "-udot", URIs.abs(context.tempDirectory().appendSegment(URIs.fn(context.inModel(), "-updated.dot"))),
                    "-dot", URIs.abs(context.tempDirectory().appendSegment(URIs.fn(context.outModel(), "-updated.dot"))),
                    "-xg", URIs.abs(context.tempDirectory().appendSegment(context.transformationInstance() + ".xg")),
                    "-ei", URIs.abs(context.tempDirectory().appendSegment(context.transformationInstance() + ".ei")));

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
