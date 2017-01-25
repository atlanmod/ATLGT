package org.eclipse.m2m.atl.atlgt.resource;

import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.xmi.XMIResource;
import org.eclipse.emf.ecore.xmi.impl.XMIResourceImpl;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

import static java.util.Objects.nonNull;

/**
 * An {@link XMIResource} with additional features to ensure a complete understanding with the tools used.
 */
public class ExtendedXMIResource extends XMIResourceImpl implements XMIResource {

    /**
     * Constructs a new {@code ExtendedXMIResource} with the given {@code uri}.
     *
     * @param uri the {@link URI} of this resource
     */
    public ExtendedXMIResource(URI uri) {
        super(uri);
    }

    /**
     * Transforms the given {@code id} to another. The {@link #hashCode()} method is used to ensure consistency between
     * the original identifier and the new.
     *
     * @param id the identifier to transform
     *
     * @return the new identifier
     */
    private static String transformID(String id) {
        return nonNull(id) ? String.valueOf(id.hashCode()) : null;
    }

    @Override
    protected boolean useUUIDs() {
        return true;
    }

    @Override
    public void setID(EObject eObject, String id) {
        super.setID(eObject, transformID(id));
    }

    @Override
    protected EObject getEObjectByID(String id) {
        return super.getEObjectByID(transformID(id));
    }

    @Override
    @SuppressWarnings("unchecked")
    public void save(Map<?, ?> options) throws IOException {
        Map<String, Object> customOptions = new HashMap<>(Optional.ofNullable((Map<String, Object>) options).orElse(new HashMap<>()));
        customOptions.put(OPTION_SAVE_TYPE_INFORMATION, Boolean.TRUE);

        super.save(customOptions);
    }
}
