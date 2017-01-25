package org.eclipse.m2m.atl.atlgt.resource;

import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.emf.ecore.xmi.impl.XMIResourceFactoryImpl;

/**
 * A factory of {@code Resource.Factory} that creates {@link ExtendedXMIResource}s.
 */
public class ExtendedXMIResourceFactory extends XMIResourceFactoryImpl implements Resource.Factory {

    @Override
    public Resource createResource(URI uri) {
        return new ExtendedXMIResource(uri);
    }
}
