package org.eclipse.m2m.atl.atlgt.core;

import net.jodah.failsafe.Failsafe;
import net.jodah.failsafe.RetryPolicy;
import net.jodah.failsafe.SyncFailsafe;
import net.jodah.failsafe.function.CheckedRunnable;

import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.EPackage;
import org.eclipse.m2m.atl.atlgt.atlidfier.AtlIdfierTransformationFactory;
import org.eclipse.m2m.atl.atlgt.ecore2km3.EmfToKm3TransformationFactory;
import org.eclipse.m2m.atl.atlgt.projector.ProjectorFactory;
import org.eclipse.m2m.atl.atlgt.tools.Commands;
import org.eclipse.m2m.atl.atlgt.util.Metamodels;
import org.eclipse.m2m.atl.atlgt.util.URIs;
import org.eclipse.m2m.atl.emftvm.util.VMException;

import java.util.List;
import java.util.Objects;
import java.util.concurrent.TimeUnit;
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
     * Step -: Initialize the context.
     */
    private static Function<Context, Context> initialize() {
        return context -> {

            context.monitor().subTask("Initialization");

            if (!context.isInitialized()) {
                // -.1 Link metamodels to their model

                // Retrieve the metamodels
                URI inMetamodel = Metamodels.metamodelOf(context.inModel());

                List<URI> otherMetamodels = StreamSupport.stream(context.metamodels().spliterator(), false)
                        .filter(uri -> !Objects.equals(uri, inMetamodel))
                        .collect(Collectors.toList());

                if (otherMetamodels.size() != 1) {
                    throw new IllegalArgumentException("Exactly 2 metamodels must be defined in an ATL-GT transformation");
                }

                URI outMetamodel = otherMetamodels.get(0);

                // Define the metamodels
                context.inMetamodel(inMetamodel);
                context.outMetamodel(outMetamodel);

                // -.2 Pre-process the source model
                Metamodels.copy(
                        context.inModel(),
                        context.tempDirectory().appendSegment(context.inModel().lastSegment()));

                context.setInitialized();
            }

            return context;
        };
    }

    /**
     * Step A: Metamodel processing.
     * <p>
     * ???
     *
     * @return a new function
     */
    private static Function<Context, Context> metamodelProcessing() {
        return context -> {

            context.monitor().subTask("Metamodel processing");

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
    private static Function<Context, Context> transformationProcessing() {
        return context -> {

            context.monitor().subTask("Transformation processing");

            System.out.println();
            System.out.println("### Transformation processing");

            atlIdfier()
                    .andThen(atlToUnqlProjector())
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

            context.monitor().setTaskName("ATL-GT - Forward transformation");

            initialize()
                    .andThen(metamodelProcessing())
                    .andThen(transformationProcessing())
                    .apply(context);

            System.out.println();
            System.out.println("### Forward transformation");

            context.monitor().subTask("ATL transformation with IDs");
            context.monitor().worked(1);

            // C.3 Execution of ATL with IDs
            retryIfNecessary(() -> Metamodels.transform(
                    context.tempDirectory().appendSegment(context.inModel().lastSegment()),
                    context.tempDirectory().appendSegment(context.outModel().lastSegment()),
                    context.metamodels(),
                    context.tempDirectory(),
                    URIs.fn(context.module(), "Ids")));

            context.monitor().subTask("ATL transformation with IDs projected");
            context.monitor().worked(1);

            // C.4 Execution of ATL with IDs projected
            retryIfNecessary(() -> Metamodels.transform(
                    context.tempDirectory().appendSegment(context.inModel().lastSegment()),
                    context.tempDirectory().appendSegment(URIs.fn(context.outModel(), "-partial.xmi")),
                    context.metamodels(),
                    context.tempDirectory(),
                    URIs.fn(context.module(), "IdsProjected")));

            // C.5 Copy the target model to the user folder
            URIs.copy(context.tempDirectory().appendSegment(context.outModel().lastSegment()), context.outModel());

            // C.6 Launch forward transformation in GRoundTram
            initialize()
                    .andThen(fwdXmiToDot())
                    .andThen(fwdUncal())
                    .andThen(fwdNormalize())
                    .andThen(fwdDotToXmi())
                    .apply(context);

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

            context.monitor().setTaskName("ATL-GT - Backward transformation");

            System.out.println();
            System.out.println("### Backward transformation");

            // Copy the updated target model from the user folder
            URIs.copy(context.outModel(), context.tempDirectory().appendSegment(context.outModel().lastSegment()));

            initialize()
                    .andThen(bwdRestrictAndXmiToDot())
                    .andThen(bwdDenormalize())
                    .andThen(bwdUncal())
                    .andThen(bwdDotToXmi())
                    .apply(context);

            // Copy the source model to the user folder
            URIs.copy(context.tempDirectory().appendSegment(context.inModel().lastSegment()), context.inModel());

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

            context.monitor().subTask("Ecore to KM3");
            context.monitor().worked(1);

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

            context.monitor().subTask("Relaxed Ecore to Relaxed KM3");
            context.monitor().worked(1);

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

            context.monitor().subTask("ATL idifier");
            context.monitor().worked(1);

            // B.1 ATLIDfier
            // Create a copy of the atl file
            URI atlModule = context.module().appendFileExtension("atl");
            URI idfiedAtlModule = context.tempDirectory().appendSegment(URIs.fn(context.module(), "Ids.atl"));
            URIs.copy(atlModule, idfiedAtlModule);

            // Run in-place transformation
            retryIfNecessary(() -> AtlIdfierTransformationFactory.withEmftvm().transform(idfiedAtlModule));

            return context;
        };
    }

    /**
     * Step B.2: ATL2UnQL Projector.
     * <p>
     * ???
     *
     * @return a new function
     */
    private static Function<Context, Context> atlToUnqlProjector() {
        return context -> {

            context.monitor().subTask("ATL to UNQL projection");
            context.monitor().worked(1);

            // B.3 ATL2UnQL Projector
            // Create a copy of the atl file
            URI idfiedAtlModule = context.tempDirectory().appendSegment(URIs.fn(context.module(), "Ids.atl"));
            URI projectedAtlModule = context.tempDirectory().appendSegment(URIs.fn(context.module(), "IdsProjected.atl"));
            URIs.copy(idfiedAtlModule, projectedAtlModule);

            context.monitor().subTask("ATL to UNQL projection");
            context.monitor().worked(1);

            // Run in-place transformation
            retryIfNecessary(() -> ProjectorFactory.withEmftvm().transform(projectedAtlModule));

            return context;
        };
    }

    /**
     * Step B.3: ATL2UNQL.
     * <p>
     * ???
     *
     * @return a new function
     */
    private static Function<Context, Context> atlToUnql() {
        return context -> {

            context.monitor().subTask("Conversion of ATL to UNQL");
            context.monitor().worked(1);

            URI inMetamodel = context.inMetamodel();
            URI outMetamodel = context.outMetamodel();

            EPackage inPackage = Metamodels.firstPackage(inMetamodel);
            EPackage outPackage = Metamodels.firstPackage(outMetamodel);

            // B.3 ATL2UNQL
            Commands.atlGt().atlToUnql().execute(
                    "-atl", URIs.abs(context.tempDirectory().appendSegment(URIs.fn(context.module(), "IdsProjected.atl"))),
                    "-uq", URIs.abs(context.tempDirectory().appendSegment(URIs.fn(context.module(), "IdsProjected.unql"))),
                    "-ikm3", URIs.abs(context.tempDirectory().appendSegment(URIs.fn(inMetamodel, ".km3"))),
                    "-ipkg", inPackage.getName(),
                    "-okm3", URIs.abs(context.tempDirectory().appendSegment(URIs.fn(outMetamodel, "-relaxed.km3"))),
                    "-opkg", outPackage.getName());

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

            context.monitor().subTask("Conversion of XMI to DOT");
            context.monitor().worked(1);

            URI inMetamodel = context.inMetamodel();
            EPackage inPackage = Metamodels.firstPackage(inMetamodel);

            // C.1 XMI2DOT
            // NOTE: We choose the first package name but we support only one package.
            Commands.atlGt().xmiToDot().execute(
                    "-xmi", URIs.abs(context.tempDirectory().appendSegment(context.inModel().lastSegment())),
                    "-dot", URIs.abs(context.tempDirectory().appendSegment(URIs.fn(context.inModel(), ".dot"))),
                    "-km3", URIs.abs(context.tempDirectory().appendSegment(URIs.fn(inMetamodel, ".km3"))),
                    "-pkg", inPackage.getName());

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

            context.monitor().subTask("Uncal (may take a while to execute)");
            context.monitor().worked(5);

            // C.2 Forward UnCAL
            Commands.gRoundTram().fwdUncal().execute(
                    "-ge", "-sb", "-cl", "-zn", "-fi", "-np", "-sa", "-t", "-rw", "-as",
                    "-db", URIs.abs(context.tempDirectory().appendSegment(URIs.fn(context.inModel(), ".dot"))),
                    "-uq", URIs.abs(context.tempDirectory().appendSegment(URIs.fn(context.module(), "IdsProjected.unql"))),
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

            context.monitor().subTask("Normalization");
            context.monitor().worked(1);

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

            context.monitor().subTask("Conversion of DOT to XMI");
            context.monitor().worked(1);

            URI outMetamodel = context.outMetamodel();
            EPackage outPackage = Metamodels.firstPackage(outMetamodel);

            // C.2.2 DOT2XMI
            Commands.atlGt().dotToXmi().execute(
                    "-dot", URIs.abs(context.tempDirectory().appendSegment(URIs.fn(context.outModel(), "-normal.dot"))),
                    "-xmi", URIs.abs(context.tempDirectory().appendSegment(URIs.fn(context.outModel(), "-normal.xmi"))),
                    "-km3", URIs.abs(context.tempDirectory().appendSegment(URIs.fn(outMetamodel, "-relaxed.km3"))),
                    "-pkg", outPackage.getName(),
                    "-uri", outPackage.getNsURI());

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
    private static Function<Context, Context> bwdRestrictAndXmiToDot() {
        return context -> {

            context.monitor().subTask("Conversion of XMI to DOT");
            context.monitor().worked(3);

            URI outMetamodel = context.outMetamodel();
            EPackage outPackage = Metamodels.firstPackage(outMetamodel);

            // D.1 XMI2DOT
            Commands.atlGt().restrictAndXmiToDot().execute(
                    "-pxmi", URIs.abs(context.tempDirectory().appendSegment(URIs.fn(context.outModel(), "-normal.xmi"))),
                    "-xmi", URIs.abs(context.tempDirectory().appendSegment(context.outModel().lastSegment())),
                    "-km3", URIs.abs(context.tempDirectory().appendSegment(URIs.fn(outMetamodel, "-relaxed.km3"))),
                    "-pkg", outPackage.getName(),
                    "-odot", URIs.abs(context.tempDirectory().appendSegment(URIs.fn(context.outModel(), "-normal.dot"))),
                    "-udot", URIs.abs(context.tempDirectory().appendSegment(URIs.fn(context.outModel(), "-normal-updated.dot"))));

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

            context.monitor().subTask("Denormalization");
            context.monitor().worked(3);

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

            context.monitor().subTask("Uncal (may take a while to execute)");
            context.monitor().worked(7);

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

            context.monitor().subTask("Conversion of DOT to XMI");
            context.monitor().worked(3);

            URI inMetamodel = context.inMetamodel();
            EPackage inPackage = Metamodels.firstPackage(inMetamodel);

            // F.1 DOT2XMI
            Commands.atlGt().dotToXmi().execute(
                    "-dot", URIs.abs(context.tempDirectory().appendSegment(URIs.fn(context.inModel(), "-updated.dot"))),
                    "-xmi", URIs.abs(context.tempDirectory().appendSegment(context.inModel().lastSegment())),
                    "-km3", URIs.abs(context.tempDirectory().appendSegment(URIs.fn(inMetamodel, ".km3"))),
                    "-pkg", inPackage.getName(),
                    "-uri", inPackage.getNsURI());

            return context;
        };
    }

    /**
     * Executes the {@code runnable} in a safe environment.
     * <p>
     * In a safe environment, a function is called several times if something goes wrong the first times. This is
     * typically used when using an ATL transformation: Because ATL files are generated or modified by code,
     * *.emftvm and *.asm files may take some time to regenerate.
     *
     * @see RetryPolicy
     * @see SyncFailsafe
     */
    private static void retryIfNecessary(CheckedRunnable runnable) {
        // The default policy that defines when retries should be performed.
        final RetryPolicy retryPolicy = new RetryPolicy()
                .withMaxRetries(3)
                .withDelay(5, TimeUnit.SECONDS)
                .retryOn(VMException.class::isInstance);

        // Performs synchronous executions with failures handled according to a configure {@code #retryPolicy}.
        Failsafe.with(retryPolicy)
                .onFailedAttempt(t -> System.out.println(t.getMessage() + "\nRetrying in 5 seconds..."))
                .onFailure(t -> System.out.println(t.getMessage()))
                .run(runnable);
    }
}
