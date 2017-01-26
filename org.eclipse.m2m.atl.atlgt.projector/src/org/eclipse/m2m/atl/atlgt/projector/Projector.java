package org.eclipse.m2m.atl.atlgt.projector;

import org.eclipse.emf.common.util.TreeIterator;
import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.EReference;
import org.eclipse.emf.ecore.EStructuralFeature;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl;
import org.eclipse.emf.ecore.util.EcoreUtil;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;

/**
 * A {@link Projector}
 */
public class Projector {

    private static final String[] additivityModules = {"Binding", "OutPatternElement", "MatchedRule", "Helper", "Module"};

    // We can translate them if they do not refer to anything bad
    // Missing: CollectionOperationCallExp OperatorCallExp OperationCallExp
    private static final String[] translatableClasses = {"Module", "OclModel", "MatchedRule", "OutPattern",
            "SimpleOutPatternElement", "OclModelElement", "Binding", "NavigationOrAttributeCallExp", "VariableExp",
            "StringExp", "InPattern", "Iterator", "IteratorExp", "OclUndefinedExp", "SimpleInPatternElement"};

    private static final String[][] translatablePatterns = {{"OperationCallExp", "operationName", "isEmpty"},
            {"OperatorCallExp", "operationName", "+"},
            {"OperatorCallExp", "operationName", "not"},
            {"OperationCallExp", "operationName", "concat"}};

    private final Set<String> additivityModulesSet;

    private final Set<String> translatableClassesSet;

    private final Map<EObject, Boolean> toTranslate;

    private final ArrayList<EObject> toProcess;

    public Projector() {
        this.additivityModulesSet = new HashSet<>(Arrays.asList(additivityModules));
        this.translatableClassesSet = new HashSet<>(Arrays.asList(translatableClasses));
        this.toTranslate = new HashMap<>();
        this.toProcess = new ArrayList<>();
    }

    public URI transform(URI program) {

        System.out.println("Projection of '" + program);

        Resource resource = (new ResourceSetImpl()).getResource(program, true);

        EObject root = resource.getContents().get(0);
        EStructuralFeature programNameAttribute = root.eClass().getEStructuralFeature("name");
        String oldProgramName = (String) root.eGet(programNameAttribute);
        root.eSet(programNameAttribute, oldProgramName + "Projected");

        Iterable<EObject> allContents = resource::getAllContents;
        allContents.forEach(toProcess::add);

        List<EObject> toProcessB = new ArrayList<>(toProcess);

        for (EObject eo : toProcessB) {
            if (!isTranslatableKind(eo)) {
                setNotTranslatable(eo);
            }
        }

        boolean changed = true;
        while (changed) {
            changed = false;
            toProcessB = new ArrayList<>(toProcess);

            for (EObject eo : toProcessB) {
                if (!isTranslatable(eo)) {
                    setNotTranslatable(eo);
                    changed = true;
                }
            }
        }

        for (EObject e : toTranslate.keySet()) {
            if (!toTranslate.get(e)) {
                EcoreUtil.delete(e);
            }
        }

        try {
            resource.save(Collections.emptyMap());
        }
        catch (IOException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }

        return program;
    }

    private boolean isTranslatable(EObject eo) {

        for (EObject ec : eo.eContents()) {
            if (!isAdditivityModule(ec) && toTranslate.containsKey(ec) && !toTranslate.get(ec)) {
                return false;
            }
        }

        for (EReference er : eo.eClass().getEAllReferences()) {
            if (!er.isContainment() && eo.eGet(er) != null && !er.isMany() && !er.isContainer()) {
                EObject ec = (EObject) eo.eGet(er);
                if (toTranslate.containsKey(ec) && !toTranslate.get(ec)) {
                    return false;
                }
            }
        }

        return true;
    }

    private void setNotTranslatable(EObject eo) {
        toProcess.remove(eo);
        toTranslate.put(eo, false);
        if (isAdditivityModule(eo)) {
            TreeIterator<EObject> allModuleContents = eo.eAllContents();
            while (allModuleContents.hasNext()) {
                EObject ec = allModuleContents.next();
                toProcess.remove(ec);
                toTranslate.put(ec, false);
            }
        }
    }

    private boolean isTranslatableKind(EObject eo) {
        if (translatableClassesSet.contains(eo.eClass().getName())) {
            return true;
        }

        for (String[] translatablePattern : translatablePatterns) {
            if (Objects.equals(translatablePattern[0], eo.eClass().getName()) &&
                    Objects.equals(translatablePattern[2], eo.eGet(eo.eClass().getEStructuralFeature(translatablePattern[1]))))
            {
                return true;
            }
        }

        return false;
    }

    private boolean isAdditivityModule(EObject eo) {
        return additivityModulesSet.contains(eo.eClass().getName());
    }
}
