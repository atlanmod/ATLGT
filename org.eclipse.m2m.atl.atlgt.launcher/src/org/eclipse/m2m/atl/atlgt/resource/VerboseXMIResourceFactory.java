package org.eclipse.m2m.atl.atlgt.resource;

import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.emf.ecore.xmi.impl.XMIResourceFactoryImpl;

/**
 *
 */
public class VerboseXMIResourceFactory extends XMIResourceFactoryImpl {

    public VerboseXMIResourceFactory() {
        super();
    }

    @Override
    public Resource createResource(URI uri) {
        return new VerboseXMIResource(uri);
    }
}
