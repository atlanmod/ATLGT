package org.eclipse.m2m.atl.atlgt.resource;

import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.xmi.XMIResource;
import org.eclipse.emf.ecore.xmi.impl.XMIResourceImpl;

import java.io.IOException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

import static java.util.Objects.isNull;

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
        if (isNull(id)) {
            return null;
        }
        try {
            MessageDigest messageDigest = MessageDigest.getInstance("MD5");
            byte[] newID = messageDigest.digest(id.getBytes());
            StringBuilder sb = new StringBuilder();
            for (byte aNewID : newID) {
                sb.append(Integer.toHexString((aNewID & 0xFF) | 0x100).substring(1, 3));
            }
            return sb.toString();
        }
        catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
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
