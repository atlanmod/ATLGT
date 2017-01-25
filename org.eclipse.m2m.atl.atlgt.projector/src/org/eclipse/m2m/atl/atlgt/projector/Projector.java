package org.eclipse.m2m.atl.atlgt.projector;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

import org.eclipse.emf.common.util.TreeIterator;
import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.EReference;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl;
import org.eclipse.emf.ecore.util.EcoreUtil;

/**
 * A {@link Projector}
 */
public class Projector {

	final String[] additivityModules = { "Binding", "OutPatternElement", "MatchedRule", "Helper", "Module" };
	Set<String> additivityModulesSet = new HashSet<String>(Arrays.asList(additivityModules));

	// We can translate them if they do not refer to anything bad (missing
	// CollectionOperationCallExp OperatorCallExp OperationCallExp)
	final String[] translatableClasses = { "Module", "OclModel", "MatchedRule", "OutPattern", "SimpleOutPatternElement",
			"OclModelElement", "Binding", "NavigationOrAttributeCallExp", "VariableExp", "StringExp", "InPattern",
			"IfExp", "Iterator", "IteratorExp", "OclUndefinedExp", "SimpleInPatternElement" };
	Set<String> translatableClassesSet = new HashSet<String>(Arrays.asList(translatableClasses));
	
	final String[][] translatablePatterns = {{ "OperationCallExp", "operationName", "isEmpty"}, 
			{"OperatorCallExp", "operationName", "+"}, 
			{"OperatorCallExp", "operationName", "not"}, 
			{"OperationCallExp", "operationName", "concat"}};

	Map<EObject, Boolean> toTranslate = new HashMap<EObject, Boolean>();

	ArrayList<EObject> toProcess = new ArrayList<EObject>();

	public URI transform(URI program) {

		System.out.println("Projection of '" + program);

		Resource resource = (new ResourceSetImpl()).getResource(program, true);
		TreeIterator<EObject> allContents = resource.getAllContents();
		while (allContents.hasNext())
			toProcess.add(allContents.next());
		
		ArrayList<EObject> toProcessB = new ArrayList<EObject>();
		for (EObject eo: toProcess) {
			toProcessB.add(eo);
		}
		
		for (EObject eo: toProcessB) {
			if (!isTranslatableKind(eo)) {
				setNotTranslatable(eo);
			}
		}
		
		boolean changed = true;
		while (changed) {
			changed = false;
			toProcessB = new ArrayList<EObject>();
			for (EObject eo: toProcess) {
				toProcessB.add(eo);
			}
			
			for (EObject eo: toProcessB) {
				if (!isTranslatable(eo)) {
					setNotTranslatable(eo);
					changed = true;
				}
			}
		}

		for (EObject e : toTranslate.keySet()) {
			if (toTranslate.get(e) == false)
				EcoreUtil.delete(e);
		}

		try {
			resource.save(Collections.emptyMap());
		} catch (IOException e) {
			e.printStackTrace();
			throw new RuntimeException(e);
		}

		return program;
	}

	private boolean isTranslatable(EObject eo) {
		
		for (EObject ec : eo.eContents())
			if (!isAdditivityModule(ec) && toTranslate.containsKey(ec) && !toTranslate.get(ec))
				return false;
		
		for (EReference er : eo.eClass().getEAllReferences()) {
			if (!er.isContainment() && eo.eGet(er) != null && !er.isMany() && !er.isContainer()) {
				EObject ec = (EObject) eo.eGet(er);
				if (toTranslate.containsKey(ec) && !toTranslate.get(ec))
					return false;
			}
		}
		
		return true;
	}

	private void setNotTranslatable(EObject eo) {
		toProcess.remove(eo);
		toTranslate.put(eo, false);
		if (isAdditivityModule(eo)) {
			TreeIterator<EObject> allModuleContents = eo.eAllContents();
			while (allModuleContents.hasNext()){
				EObject ec = allModuleContents.next();
				toProcess.remove(ec);
				toTranslate.put(ec, false);
			}
		}
	}

	private boolean isTranslatableKind(EObject eo) {
		if (translatableClassesSet.contains(eo.eClass().getName())) return true;
		
		for (int i=0; i<translatablePatterns.length; i++)
			if (translatablePatterns[i][0].equals(eo.eClass().getName()) &&
				translatablePatterns[i][2].equals(eo.eGet(eo.eClass().getEStructuralFeature(translatablePatterns[i][1]))))
				return true;
				
		return false;
	}

	private boolean isAdditivityModule(EObject eo) {
		return additivityModulesSet.contains(eo.eClass().getName());
	}

}
