package org.eclipse.m2m.atl.atlgt.launcher;

import org.eclipse.core.runtime.CoreException;
import org.eclipse.core.runtime.IProgressMonitor;
import org.eclipse.debug.core.ILaunch;
import org.eclipse.debug.core.ILaunchConfiguration;
import org.eclipse.debug.core.model.ILaunchConfigurationDelegate;
import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.EPackage;
import org.eclipse.emf.ecore.resource.URIConverter;
import org.eclipse.emf.ecore.resource.impl.ExtensibleURIConverterImpl;
import org.eclipse.m2m.atl.atlgt.atlidfier.AtlIdfierTransformationFactory;
import org.eclipse.m2m.atl.atlgt.ecore2km3.EmfToKm3TransformationFactory;
import org.eclipse.m2m.atl.atlgt.tools.Commands;
import org.eclipse.m2m.atl.atlgt.util.MetamodelHelpers;
import org.eclipse.m2m.atl.core.ATLCoreException;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.ByteBuffer;
import java.nio.channels.Channels;
import java.nio.channels.ReadableByteChannel;
import java.nio.channels.WritableByteChannel;
import java.util.ArrayList;
import java.util.List;

public class AtlGtLauncher implements ILaunchConfigurationDelegate {

    private AtlGtContext context;

    @Override
    public void launch(ILaunchConfiguration launchConfiguration, String mode, ILaunch launch, IProgressMonitor monitor) throws CoreException {
        try {
            context = AtlGtContext.from(launchConfiguration);
            System.out.println(context);

            // Register all metamodels
            context.getMetamodels().forEach(MetamodelHelpers::registerPackage);

            // Step A: Metamodel processing
            processMetamodels();

            // Step B: Transformation processing
            processTransformation();

            // 1. XMI2DOT (we choose the first package name but we support only one package)
            // TODO Fill args
            Commands.atlGt().xmiToDot().execute(
                    "-xmi", "",
                    "-dot", "",
                    "-km3", "",
                    "-pkg", "");

            // 2. Forward UnCAL
            // TODO Fill args
            Commands.gRoundTram().fwdUncal().execute(
                    "-ge", "-sb", "-cl", "-zn", "-fi", "-np", "-sa", "-t", "-rw", "-as",
                    " -db", "",
                    " -uq", "",
                    " -dot", "",
                    " -xg", "",
                    " -ei", "");

            // 2.1 Normalize (up-to isomorphism)
            // TODO Fill args
            Commands.gRoundTram().bxContract().execute(
                    "-batch",
                    "-src", "",
                    "-dst", "");

            // 2.2 DOT2XMI
            // TODO Fill args
            Commands.atlGt().dotToXmi().execute(
                    "-dot", "",
                    "-xmi", "",
                    "-km3", "",
                    "-pkg", "");

            System.out.println("ATL-GT - Executed!! " + context.getOutputDirectory());
        }
        catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * Metamodel processing. (Step A)
     */
    private void processMetamodels() throws IOException, ATLCoreException {
        // A.1 Ecore to KM3
        for (URI metamodel : context.getMetamodels()) {
            EmfToKm3TransformationFactory.withEmftvm().transform(context.getOutputDirectory(), metamodel);
        }

        List<URI> relaxedMetamodels = new ArrayList<>();

        // A.2 Ecore Relaxation
        for (URI metamodel : context.getMetamodels()) {
            Iterable<EPackage> packages = MetamodelHelpers.readEcore(metamodel);
            URI relaxedMetamodel = MetamodelHelpers.relax(packages, context.getOutputDirectory(), metamodel);
            relaxedMetamodels.add(relaxedMetamodel);
        }

        // A.3 Relaxed Ecore to Relaxed KM3
        for (URI relaxedMetamodel : relaxedMetamodels) {
            EmfToKm3TransformationFactory.withEmftvm().transform(context.getOutputDirectory(), relaxedMetamodel);
        }
    }

    /**
     * Transformation processing. (Step B)
     */
    private void processTransformation() throws ATLCoreException, IOException {
        // B.1 ATLIDfier
        // Create a copy of the atl file
        URI sourceUri = context.getModule().appendFileExtension("atl");
        URI targetUri = context.getOutputDirectory().appendSegment(context.getModule().appendFileExtension("atl").lastSegment());
        copy(sourceUri, targetUri);

        // Run in-place transformation
        AtlIdfierTransformationFactory.withEmftvm().transform(context.getOutputDirectory(), targetUri);

        // B.2 ATL2UNQL
        // TODO Fill args
        Commands.atlGt().atlToUnql().execute(
                "-atl", "",
                "-uq", "",
                "-ikm3", "",
                "-ipkg", "",
                "-okm3", "",
                "-opkg", "");
    }

    private static void copy(URI source, URI target) throws IOException {
        URIConverter uriConverter = new ExtensibleURIConverterImpl();
        uriConverter.createInputStream(source);
        uriConverter.createOutputStream(target);

        try (InputStream inputStream = uriConverter.createInputStream(source); OutputStream outputStream = uriConverter.createOutputStream(target)) {
            try (ReadableByteChannel inputChannel = Channels.newChannel(inputStream); WritableByteChannel outputChannel = Channels.newChannel(outputStream)) {
                final ByteBuffer buffer = ByteBuffer.allocateDirect(16 * 1024);
                while (inputChannel.read(buffer) != -1) {
                    buffer.flip();
                    outputChannel.write(buffer);
                    buffer.compact();
                }
                buffer.flip();
                while (buffer.hasRemaining()) {
                    outputChannel.write(buffer);
                }
            }
        }
    }
}
