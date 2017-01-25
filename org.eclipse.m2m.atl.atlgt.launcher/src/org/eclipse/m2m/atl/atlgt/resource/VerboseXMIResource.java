package org.eclipse.m2m.atl.atlgt.resource;

import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.xmi.XMIResource;
import org.eclipse.emf.ecore.xmi.XMLLoad;
import org.eclipse.emf.ecore.xmi.XMLSave;
import org.eclipse.emf.ecore.xmi.impl.XMIResourceImpl;

import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

/**
 *
 */
public class VerboseXMIResource extends XMIResourceImpl implements XMIResource {

    public VerboseXMIResource() {
        super();
    }

    public VerboseXMIResource(URI uri) {
        super(uri);
    }

    @Override
    protected boolean useUUIDs() {
        return true;
    }

    @Override
    @SuppressWarnings("unchecked")
    protected XMLLoad createXMLLoad(Map<?, ?> options) {
        Map<String, Object> customOptions = Optional.ofNullable((Map<String, Object>) options).orElse(new HashMap<>());
        customOptions.put(OPTION_SAVE_TYPE_INFORMATION, Boolean.TRUE);
        return super.createXMLLoad(customOptions);
    }

    @Override
    @SuppressWarnings("unchecked")
    protected XMLSave createXMLSave(Map<?, ?> options) {
        Map<String, Object> castOptions = Optional.ofNullable((Map<String, Object>) options).orElse(new HashMap<>());
        castOptions.put(OPTION_SAVE_TYPE_INFORMATION, Boolean.TRUE);
        return super.createXMLSave(castOptions);
    }
}
