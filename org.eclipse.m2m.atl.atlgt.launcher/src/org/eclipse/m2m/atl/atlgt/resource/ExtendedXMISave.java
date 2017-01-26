package org.eclipse.m2m.atl.atlgt.resource;

import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.EReference;
import org.eclipse.emf.ecore.EStructuralFeature;
import org.eclipse.emf.ecore.xmi.XMLHelper;
import org.eclipse.emf.ecore.xmi.impl.XMISaveImpl;

import java.util.Objects;

import static java.util.Objects.nonNull;

/**
 * An {@link org.eclipse.emf.ecore.xmi.XMLSave} that handles containment references in the XMI file.
 */
public class ExtendedXMISave extends XMISaveImpl {

    private EObject currentObject;

    private EStructuralFeature currentFeature;

    /**
     * Constructs a new {@code ExtendedXMISave} with the given {@code helper}.
     *
     * @param helper the helper
     */
    public ExtendedXMISave(XMLHelper helper) {
        super(helper);
    }

    @Override
    protected void saveElement(EObject object, EStructuralFeature feature) {
        currentObject = object;
        currentFeature = feature;

        super.saveElement(object, feature);
    }

    @Override
    protected boolean saveFeatures(EObject object) {
        // Print the containment information before all other features
        if (Objects.equals(object, currentObject)) {
            saveContainment(currentObject, currentFeature);
            currentObject = null;
            currentFeature = null;
        }

        return super.saveFeatures(object);
    }

    /**
     * Processes the containment of the {@code object} according to the {@code feature} of its parent.
     *
     * @param object  the containment
     * @param feature the feature of its parent
     */
    private void saveContainment(EObject object, EStructuralFeature feature) {
        // Add containment reference
        if (EReference.class.isInstance(feature)) {
            EReference reference = (EReference) feature;
            if (reference.isContainment()) {
                // Retrieve the container of the object
                EObject referencedObject = (EObject) object.eGet(reference.getEOpposite());
                String id = helper.getID(referencedObject);

                if (nonNull(id) && nonNull(referencedObject) && !Objects.equals(object, referencedObject)) {
                    // Print the containment reference
                    doc.addAttribute(reference.getEOpposite().getName(), id);
                }
            }
        }
    }
}
