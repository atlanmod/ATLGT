/*
 * generated by Xtext 2.10.0
 */
package org.eclipse.m2m.km3.xtext.ide.contentassist.antlr;

import com.google.inject.Inject;
import java.util.Collection;
import java.util.HashMap;
import java.util.Map;
import org.antlr.runtime.RecognitionException;
import org.eclipse.m2m.km3.xtext.ide.contentassist.antlr.internal.InternalKM3Parser;
import org.eclipse.m2m.km3.xtext.services.KM3GrammarAccess;
import org.eclipse.xtext.AbstractElement;
import org.eclipse.xtext.ide.editor.contentassist.antlr.AbstractContentAssistParser;
import org.eclipse.xtext.ide.editor.contentassist.antlr.FollowElement;
import org.eclipse.xtext.ide.editor.contentassist.antlr.internal.AbstractInternalContentAssistParser;

public class KM3Parser extends AbstractContentAssistParser {

	@Inject
	private KM3GrammarAccess grammarAccess;

	private Map<AbstractElement, String> nameMappings;

	@Override
	protected InternalKM3Parser createParser() {
		InternalKM3Parser result = new InternalKM3Parser(null);
		result.setGrammarAccess(grammarAccess);
		return result;
	}

	@Override
	protected String getRuleName(AbstractElement element) {
		if (nameMappings == null) {
			nameMappings = new HashMap<AbstractElement, String>() {
				private static final long serialVersionUID = 1L;
				{
					put(grammarAccess.getModelElementAccess().getAlternatives(), "rule__ModelElement__Alternatives");
					put(grammarAccess.getStructuralFeatureAccess().getAlternatives(), "rule__StructuralFeature__Alternatives");
					put(grammarAccess.getPackageAccess().getGroup(), "rule__Package__Group__0");
					put(grammarAccess.getDataTypeAccess().getGroup(), "rule__DataType__Group__0");
					put(grammarAccess.getClassAccess().getGroup(), "rule__Class__Group__0");
					put(grammarAccess.getClassAccess().getGroup_3(), "rule__Class__Group_3__0");
					put(grammarAccess.getClassAccess().getGroup_3_2(), "rule__Class__Group_3_2__0");
					put(grammarAccess.getAttributeAccess().getGroup(), "rule__Attribute__Group__0");
					put(grammarAccess.getReferenceAccess().getGroup(), "rule__Reference__Group__0");
					put(grammarAccess.getReferenceAccess().getGroup_6(), "rule__Reference__Group_6__0");
					put(grammarAccess.getPackageAccess().getNameAssignment_1(), "rule__Package__NameAssignment_1");
					put(grammarAccess.getPackageAccess().getContentsAssignment_3(), "rule__Package__ContentsAssignment_3");
					put(grammarAccess.getDataTypeAccess().getNameAssignment_1(), "rule__DataType__NameAssignment_1");
					put(grammarAccess.getClassAccess().getIsAbstractAssignment_0(), "rule__Class__IsAbstractAssignment_0");
					put(grammarAccess.getClassAccess().getNameAssignment_2(), "rule__Class__NameAssignment_2");
					put(grammarAccess.getClassAccess().getSupertypesAssignment_3_1(), "rule__Class__SupertypesAssignment_3_1");
					put(grammarAccess.getClassAccess().getSupertypesAssignment_3_2_1(), "rule__Class__SupertypesAssignment_3_2_1");
					put(grammarAccess.getClassAccess().getStructuralFeaturesAssignment_5(), "rule__Class__StructuralFeaturesAssignment_5");
					put(grammarAccess.getAttributeAccess().getIsUniqueAssignment_0(), "rule__Attribute__IsUniqueAssignment_0");
					put(grammarAccess.getAttributeAccess().getNameAssignment_2(), "rule__Attribute__NameAssignment_2");
					put(grammarAccess.getAttributeAccess().getIsOrderedAssignment_3(), "rule__Attribute__IsOrderedAssignment_3");
					put(grammarAccess.getAttributeAccess().getTypeAssignment_5(), "rule__Attribute__TypeAssignment_5");
					put(grammarAccess.getReferenceAccess().getNameAssignment_1(), "rule__Reference__NameAssignment_1");
					put(grammarAccess.getReferenceAccess().getIsOrderedAssignment_2(), "rule__Reference__IsOrderedAssignment_2");
					put(grammarAccess.getReferenceAccess().getIsContainerAssignment_3(), "rule__Reference__IsContainerAssignment_3");
					put(grammarAccess.getReferenceAccess().getTypeAssignment_5(), "rule__Reference__TypeAssignment_5");
					put(grammarAccess.getReferenceAccess().getOppositeAssignment_6_1(), "rule__Reference__OppositeAssignment_6_1");
				}
			};
		}
		return nameMappings.get(element);
	}

	@Override
	protected Collection<FollowElement> getFollowElements(AbstractInternalContentAssistParser parser) {
		try {
			InternalKM3Parser typedParser = (InternalKM3Parser) parser;
			typedParser.entryRulePackage();
			return typedParser.getFollowElements();
		} catch(RecognitionException ex) {
			throw new RuntimeException(ex);
		}
	}

	@Override
	protected String[] getInitialHiddenTokens() {
		return new String[] { "RULE_COMMENT", "RULE_WS" };
	}

	public KM3GrammarAccess getGrammarAccess() {
		return this.grammarAccess;
	}

	public void setGrammarAccess(KM3GrammarAccess grammarAccess) {
		this.grammarAccess = grammarAccess;
	}
}