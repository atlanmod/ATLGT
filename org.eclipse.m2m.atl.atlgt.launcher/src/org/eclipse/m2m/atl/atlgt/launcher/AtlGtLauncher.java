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

            // Register all metamodels
            context.getMetamodels().forEach(MetamodelHelpers::registerPackage);

            // Step A: Metamodel processing
            processMetamodels();

            // Step B: Transformation processing
            processTransformation();

            System.out.println("ATL-GT - Executed!! " + context.getPath());
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
        for (String metamodel : context.getMetamodels()) {
            EmfToKm3TransformationFactory.withEmftvm().transform(context.getPath(), metamodel);
        }

        List<String> relaxedMetamodels = new ArrayList<>();

        // A.2 Ecore Relaxation
        for (String metamodel : context.getMetamodels()) {
            Iterable<EPackage> packages = MetamodelHelpers.readEcore(metamodel);
            String relaxedMetamodel = MetamodelHelpers.relax(packages, context.getPath(), metamodel);
            relaxedMetamodels.add(relaxedMetamodel);
        }

        // A.3 Relaxed Ecore to Relaxed KM3
        for (String relaxedMetamodel : relaxedMetamodels) {
            EmfToKm3TransformationFactory.withEmftvm().transform(context.getPath(), relaxedMetamodel);
        }
    }

    /**
     * Transformation processing. (Step B)
     */
    private void processTransformation() throws ATLCoreException, IOException {
        // B.1 ATLIDfier
        // Create a copy of the atl file
        URI sourceUrl = URI.createURI("platform:/resource" + context.getModulePath());
        URI targetUrl = URI.createURI("platform:/resource" + context.getPath() + context.getModulePath().substring(context.getModulePath().lastIndexOf('/') + 1));
        copy(sourceUrl, targetUrl);

        // Run in-place transformation
        AtlIdfierTransformationFactory.withEmftvm().transform(context.getPath(), targetUrl.toString());
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
