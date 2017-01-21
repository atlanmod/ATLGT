/*
 * generated by Xtext 2.10.0
 */
grammar InternalKM3;

options {
	superClass=AbstractInternalContentAssistParser;
}

@lexer::header {
package org.eclipse.m2m.km3.xtext.ide.contentassist.antlr.internal;

// Hack: Use our own Lexer superclass by means of import. 
// Currently there is no other way to specify the superclass for the lexer.
import org.eclipse.xtext.ide.editor.contentassist.antlr.internal.Lexer;
}

@parser::header {
package org.eclipse.m2m.km3.xtext.ide.contentassist.antlr.internal;

import java.io.InputStream;
import org.eclipse.xtext.*;
import org.eclipse.xtext.parser.*;
import org.eclipse.xtext.parser.impl.*;
import org.eclipse.emf.ecore.util.EcoreUtil;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.xtext.parser.antlr.XtextTokenStream;
import org.eclipse.xtext.parser.antlr.XtextTokenStream.HiddenTokens;
import org.eclipse.xtext.ide.editor.contentassist.antlr.internal.AbstractInternalContentAssistParser;
import org.eclipse.xtext.ide.editor.contentassist.antlr.internal.DFA;
import org.eclipse.m2m.km3.xtext.services.KM3GrammarAccess;

}
@parser::members {
	private KM3GrammarAccess grammarAccess;

	public void setGrammarAccess(KM3GrammarAccess grammarAccess) {
		this.grammarAccess = grammarAccess;
	}

	@Override
	protected Grammar getGrammar() {
		return grammarAccess.getGrammar();
	}

	@Override
	protected String getValueForTokenName(String tokenName) {
		return tokenName;
	}
}

// Entry rule entryRulePackage
entryRulePackage
:
{ before(grammarAccess.getPackageRule()); }
	 rulePackage
{ after(grammarAccess.getPackageRule()); } 
	 EOF 
;

// Rule Package
rulePackage 
	@init {
		int stackSize = keepStackSize();
	}
	:
	(
		{ before(grammarAccess.getPackageAccess().getGroup()); }
		(rule__Package__Group__0)
		{ after(grammarAccess.getPackageAccess().getGroup()); }
	)
;
finally {
	restoreStackSize(stackSize);
}

// Entry rule entryRuleModelElement
entryRuleModelElement
:
{ before(grammarAccess.getModelElementRule()); }
	 ruleModelElement
{ after(grammarAccess.getModelElementRule()); } 
	 EOF 
;

// Rule ModelElement
ruleModelElement 
	@init {
		int stackSize = keepStackSize();
	}
	:
	(
		{ before(grammarAccess.getModelElementAccess().getAlternatives()); }
		(rule__ModelElement__Alternatives)
		{ after(grammarAccess.getModelElementAccess().getAlternatives()); }
	)
;
finally {
	restoreStackSize(stackSize);
}

// Entry rule entryRuleDataType
entryRuleDataType
:
{ before(grammarAccess.getDataTypeRule()); }
	 ruleDataType
{ after(grammarAccess.getDataTypeRule()); } 
	 EOF 
;

// Rule DataType
ruleDataType 
	@init {
		int stackSize = keepStackSize();
	}
	:
	(
		{ before(grammarAccess.getDataTypeAccess().getGroup()); }
		(rule__DataType__Group__0)
		{ after(grammarAccess.getDataTypeAccess().getGroup()); }
	)
;
finally {
	restoreStackSize(stackSize);
}

// Entry rule entryRuleStructuralFeature
entryRuleStructuralFeature
:
{ before(grammarAccess.getStructuralFeatureRule()); }
	 ruleStructuralFeature
{ after(grammarAccess.getStructuralFeatureRule()); } 
	 EOF 
;

// Rule StructuralFeature
ruleStructuralFeature 
	@init {
		int stackSize = keepStackSize();
	}
	:
	(
		{ before(grammarAccess.getStructuralFeatureAccess().getAlternatives()); }
		(rule__StructuralFeature__Alternatives)
		{ after(grammarAccess.getStructuralFeatureAccess().getAlternatives()); }
	)
;
finally {
	restoreStackSize(stackSize);
}

// Entry rule entryRuleClass
entryRuleClass
:
{ before(grammarAccess.getClassRule()); }
	 ruleClass
{ after(grammarAccess.getClassRule()); } 
	 EOF 
;

// Rule Class
ruleClass 
	@init {
		int stackSize = keepStackSize();
	}
	:
	(
		{ before(grammarAccess.getClassAccess().getGroup()); }
		(rule__Class__Group__0)
		{ after(grammarAccess.getClassAccess().getGroup()); }
	)
;
finally {
	restoreStackSize(stackSize);
}

// Entry rule entryRuleAttribute
entryRuleAttribute
:
{ before(grammarAccess.getAttributeRule()); }
	 ruleAttribute
{ after(grammarAccess.getAttributeRule()); } 
	 EOF 
;

// Rule Attribute
ruleAttribute 
	@init {
		int stackSize = keepStackSize();
	}
	:
	(
		{ before(grammarAccess.getAttributeAccess().getGroup()); }
		(rule__Attribute__Group__0)
		{ after(grammarAccess.getAttributeAccess().getGroup()); }
	)
;
finally {
	restoreStackSize(stackSize);
}

// Entry rule entryRuleReference
entryRuleReference
:
{ before(grammarAccess.getReferenceRule()); }
	 ruleReference
{ after(grammarAccess.getReferenceRule()); } 
	 EOF 
;

// Rule Reference
ruleReference 
	@init {
		int stackSize = keepStackSize();
	}
	:
	(
		{ before(grammarAccess.getReferenceAccess().getGroup()); }
		(rule__Reference__Group__0)
		{ after(grammarAccess.getReferenceAccess().getGroup()); }
	)
;
finally {
	restoreStackSize(stackSize);
}

rule__ModelElement__Alternatives
	@init {
		int stackSize = keepStackSize();
	}
:
	(
		{ before(grammarAccess.getModelElementAccess().getDataTypeParserRuleCall_0()); }
		ruleDataType
		{ after(grammarAccess.getModelElementAccess().getDataTypeParserRuleCall_0()); }
	)
	|
	(
		{ before(grammarAccess.getModelElementAccess().getClassParserRuleCall_1()); }
		ruleClass
		{ after(grammarAccess.getModelElementAccess().getClassParserRuleCall_1()); }
	)
;
finally {
	restoreStackSize(stackSize);
}

rule__StructuralFeature__Alternatives
	@init {
		int stackSize = keepStackSize();
	}
:
	(
		{ before(grammarAccess.getStructuralFeatureAccess().getAttributeParserRuleCall_0()); }
		ruleAttribute
		{ after(grammarAccess.getStructuralFeatureAccess().getAttributeParserRuleCall_0()); }
	)
	|
	(
		{ before(grammarAccess.getStructuralFeatureAccess().getReferenceParserRuleCall_1()); }
		ruleReference
		{ after(grammarAccess.getStructuralFeatureAccess().getReferenceParserRuleCall_1()); }
	)
;
finally {
	restoreStackSize(stackSize);
}

rule__Package__Group__0
	@init {
		int stackSize = keepStackSize();
	}
:
	rule__Package__Group__0__Impl
	rule__Package__Group__1
;
finally {
	restoreStackSize(stackSize);
}

rule__Package__Group__0__Impl
	@init {
		int stackSize = keepStackSize();
	}
:
(
	{ before(grammarAccess.getPackageAccess().getPackageKeyword_0()); }
	'package'
	{ after(grammarAccess.getPackageAccess().getPackageKeyword_0()); }
)
;
finally {
	restoreStackSize(stackSize);
}

rule__Package__Group__1
	@init {
		int stackSize = keepStackSize();
	}
:
	rule__Package__Group__1__Impl
	rule__Package__Group__2
;
finally {
	restoreStackSize(stackSize);
}

rule__Package__Group__1__Impl
	@init {
		int stackSize = keepStackSize();
	}
:
(
	{ before(grammarAccess.getPackageAccess().getNameAssignment_1()); }
	(rule__Package__NameAssignment_1)
	{ after(grammarAccess.getPackageAccess().getNameAssignment_1()); }
)
;
finally {
	restoreStackSize(stackSize);
}

rule__Package__Group__2
	@init {
		int stackSize = keepStackSize();
	}
:
	rule__Package__Group__2__Impl
	rule__Package__Group__3
;
finally {
	restoreStackSize(stackSize);
}

rule__Package__Group__2__Impl
	@init {
		int stackSize = keepStackSize();
	}
:
(
	{ before(grammarAccess.getPackageAccess().getLeftCurlyBracketKeyword_2()); }
	'{'
	{ after(grammarAccess.getPackageAccess().getLeftCurlyBracketKeyword_2()); }
)
;
finally {
	restoreStackSize(stackSize);
}

rule__Package__Group__3
	@init {
		int stackSize = keepStackSize();
	}
:
	rule__Package__Group__3__Impl
	rule__Package__Group__4
;
finally {
	restoreStackSize(stackSize);
}

rule__Package__Group__3__Impl
	@init {
		int stackSize = keepStackSize();
	}
:
(
	{ before(grammarAccess.getPackageAccess().getContentsAssignment_3()); }
	(rule__Package__ContentsAssignment_3)*
	{ after(grammarAccess.getPackageAccess().getContentsAssignment_3()); }
)
;
finally {
	restoreStackSize(stackSize);
}

rule__Package__Group__4
	@init {
		int stackSize = keepStackSize();
	}
:
	rule__Package__Group__4__Impl
;
finally {
	restoreStackSize(stackSize);
}

rule__Package__Group__4__Impl
	@init {
		int stackSize = keepStackSize();
	}
:
(
	{ before(grammarAccess.getPackageAccess().getRightCurlyBracketKeyword_4()); }
	'}'
	{ after(grammarAccess.getPackageAccess().getRightCurlyBracketKeyword_4()); }
)
;
finally {
	restoreStackSize(stackSize);
}


rule__DataType__Group__0
	@init {
		int stackSize = keepStackSize();
	}
:
	rule__DataType__Group__0__Impl
	rule__DataType__Group__1
;
finally {
	restoreStackSize(stackSize);
}

rule__DataType__Group__0__Impl
	@init {
		int stackSize = keepStackSize();
	}
:
(
	{ before(grammarAccess.getDataTypeAccess().getDatatypeKeyword_0()); }
	'datatype'
	{ after(grammarAccess.getDataTypeAccess().getDatatypeKeyword_0()); }
)
;
finally {
	restoreStackSize(stackSize);
}

rule__DataType__Group__1
	@init {
		int stackSize = keepStackSize();
	}
:
	rule__DataType__Group__1__Impl
	rule__DataType__Group__2
;
finally {
	restoreStackSize(stackSize);
}

rule__DataType__Group__1__Impl
	@init {
		int stackSize = keepStackSize();
	}
:
(
	{ before(grammarAccess.getDataTypeAccess().getNameAssignment_1()); }
	(rule__DataType__NameAssignment_1)
	{ after(grammarAccess.getDataTypeAccess().getNameAssignment_1()); }
)
;
finally {
	restoreStackSize(stackSize);
}

rule__DataType__Group__2
	@init {
		int stackSize = keepStackSize();
	}
:
	rule__DataType__Group__2__Impl
;
finally {
	restoreStackSize(stackSize);
}

rule__DataType__Group__2__Impl
	@init {
		int stackSize = keepStackSize();
	}
:
(
	{ before(grammarAccess.getDataTypeAccess().getSemicolonKeyword_2()); }
	';'
	{ after(grammarAccess.getDataTypeAccess().getSemicolonKeyword_2()); }
)
;
finally {
	restoreStackSize(stackSize);
}


rule__Class__Group__0
	@init {
		int stackSize = keepStackSize();
	}
:
	rule__Class__Group__0__Impl
	rule__Class__Group__1
;
finally {
	restoreStackSize(stackSize);
}

rule__Class__Group__0__Impl
	@init {
		int stackSize = keepStackSize();
	}
:
(
	{ before(grammarAccess.getClassAccess().getIsAbstractAssignment_0()); }
	(rule__Class__IsAbstractAssignment_0)?
	{ after(grammarAccess.getClassAccess().getIsAbstractAssignment_0()); }
)
;
finally {
	restoreStackSize(stackSize);
}

rule__Class__Group__1
	@init {
		int stackSize = keepStackSize();
	}
:
	rule__Class__Group__1__Impl
	rule__Class__Group__2
;
finally {
	restoreStackSize(stackSize);
}

rule__Class__Group__1__Impl
	@init {
		int stackSize = keepStackSize();
	}
:
(
	{ before(grammarAccess.getClassAccess().getClassKeyword_1()); }
	'class'
	{ after(grammarAccess.getClassAccess().getClassKeyword_1()); }
)
;
finally {
	restoreStackSize(stackSize);
}

rule__Class__Group__2
	@init {
		int stackSize = keepStackSize();
	}
:
	rule__Class__Group__2__Impl
	rule__Class__Group__3
;
finally {
	restoreStackSize(stackSize);
}

rule__Class__Group__2__Impl
	@init {
		int stackSize = keepStackSize();
	}
:
(
	{ before(grammarAccess.getClassAccess().getNameAssignment_2()); }
	(rule__Class__NameAssignment_2)
	{ after(grammarAccess.getClassAccess().getNameAssignment_2()); }
)
;
finally {
	restoreStackSize(stackSize);
}

rule__Class__Group__3
	@init {
		int stackSize = keepStackSize();
	}
:
	rule__Class__Group__3__Impl
	rule__Class__Group__4
;
finally {
	restoreStackSize(stackSize);
}

rule__Class__Group__3__Impl
	@init {
		int stackSize = keepStackSize();
	}
:
(
	{ before(grammarAccess.getClassAccess().getGroup_3()); }
	(rule__Class__Group_3__0)?
	{ after(grammarAccess.getClassAccess().getGroup_3()); }
)
;
finally {
	restoreStackSize(stackSize);
}

rule__Class__Group__4
	@init {
		int stackSize = keepStackSize();
	}
:
	rule__Class__Group__4__Impl
	rule__Class__Group__5
;
finally {
	restoreStackSize(stackSize);
}

rule__Class__Group__4__Impl
	@init {
		int stackSize = keepStackSize();
	}
:
(
	{ before(grammarAccess.getClassAccess().getLeftCurlyBracketKeyword_4()); }
	'{'
	{ after(grammarAccess.getClassAccess().getLeftCurlyBracketKeyword_4()); }
)
;
finally {
	restoreStackSize(stackSize);
}

rule__Class__Group__5
	@init {
		int stackSize = keepStackSize();
	}
:
	rule__Class__Group__5__Impl
	rule__Class__Group__6
;
finally {
	restoreStackSize(stackSize);
}

rule__Class__Group__5__Impl
	@init {
		int stackSize = keepStackSize();
	}
:
(
	{ before(grammarAccess.getClassAccess().getStructuralFeaturesAssignment_5()); }
	(rule__Class__StructuralFeaturesAssignment_5)*
	{ after(grammarAccess.getClassAccess().getStructuralFeaturesAssignment_5()); }
)
;
finally {
	restoreStackSize(stackSize);
}

rule__Class__Group__6
	@init {
		int stackSize = keepStackSize();
	}
:
	rule__Class__Group__6__Impl
;
finally {
	restoreStackSize(stackSize);
}

rule__Class__Group__6__Impl
	@init {
		int stackSize = keepStackSize();
	}
:
(
	{ before(grammarAccess.getClassAccess().getRightCurlyBracketKeyword_6()); }
	'}'
	{ after(grammarAccess.getClassAccess().getRightCurlyBracketKeyword_6()); }
)
;
finally {
	restoreStackSize(stackSize);
}


rule__Class__Group_3__0
	@init {
		int stackSize = keepStackSize();
	}
:
	rule__Class__Group_3__0__Impl
	rule__Class__Group_3__1
;
finally {
	restoreStackSize(stackSize);
}

rule__Class__Group_3__0__Impl
	@init {
		int stackSize = keepStackSize();
	}
:
(
	{ before(grammarAccess.getClassAccess().getExtendsKeyword_3_0()); }
	'extends'
	{ after(grammarAccess.getClassAccess().getExtendsKeyword_3_0()); }
)
;
finally {
	restoreStackSize(stackSize);
}

rule__Class__Group_3__1
	@init {
		int stackSize = keepStackSize();
	}
:
	rule__Class__Group_3__1__Impl
	rule__Class__Group_3__2
;
finally {
	restoreStackSize(stackSize);
}

rule__Class__Group_3__1__Impl
	@init {
		int stackSize = keepStackSize();
	}
:
(
	{ before(grammarAccess.getClassAccess().getSupertypesAssignment_3_1()); }
	(rule__Class__SupertypesAssignment_3_1)
	{ after(grammarAccess.getClassAccess().getSupertypesAssignment_3_1()); }
)
;
finally {
	restoreStackSize(stackSize);
}

rule__Class__Group_3__2
	@init {
		int stackSize = keepStackSize();
	}
:
	rule__Class__Group_3__2__Impl
;
finally {
	restoreStackSize(stackSize);
}

rule__Class__Group_3__2__Impl
	@init {
		int stackSize = keepStackSize();
	}
:
(
	{ before(grammarAccess.getClassAccess().getGroup_3_2()); }
	(rule__Class__Group_3_2__0)*
	{ after(grammarAccess.getClassAccess().getGroup_3_2()); }
)
;
finally {
	restoreStackSize(stackSize);
}


rule__Class__Group_3_2__0
	@init {
		int stackSize = keepStackSize();
	}
:
	rule__Class__Group_3_2__0__Impl
	rule__Class__Group_3_2__1
;
finally {
	restoreStackSize(stackSize);
}

rule__Class__Group_3_2__0__Impl
	@init {
		int stackSize = keepStackSize();
	}
:
(
	{ before(grammarAccess.getClassAccess().getCommaKeyword_3_2_0()); }
	','
	{ after(grammarAccess.getClassAccess().getCommaKeyword_3_2_0()); }
)
;
finally {
	restoreStackSize(stackSize);
}

rule__Class__Group_3_2__1
	@init {
		int stackSize = keepStackSize();
	}
:
	rule__Class__Group_3_2__1__Impl
;
finally {
	restoreStackSize(stackSize);
}

rule__Class__Group_3_2__1__Impl
	@init {
		int stackSize = keepStackSize();
	}
:
(
	{ before(grammarAccess.getClassAccess().getSupertypesAssignment_3_2_1()); }
	(rule__Class__SupertypesAssignment_3_2_1)
	{ after(grammarAccess.getClassAccess().getSupertypesAssignment_3_2_1()); }
)
;
finally {
	restoreStackSize(stackSize);
}


rule__Attribute__Group__0
	@init {
		int stackSize = keepStackSize();
	}
:
	rule__Attribute__Group__0__Impl
	rule__Attribute__Group__1
;
finally {
	restoreStackSize(stackSize);
}

rule__Attribute__Group__0__Impl
	@init {
		int stackSize = keepStackSize();
	}
:
(
	{ before(grammarAccess.getAttributeAccess().getIsUniqueAssignment_0()); }
	(rule__Attribute__IsUniqueAssignment_0)?
	{ after(grammarAccess.getAttributeAccess().getIsUniqueAssignment_0()); }
)
;
finally {
	restoreStackSize(stackSize);
}

rule__Attribute__Group__1
	@init {
		int stackSize = keepStackSize();
	}
:
	rule__Attribute__Group__1__Impl
	rule__Attribute__Group__2
;
finally {
	restoreStackSize(stackSize);
}

rule__Attribute__Group__1__Impl
	@init {
		int stackSize = keepStackSize();
	}
:
(
	{ before(grammarAccess.getAttributeAccess().getAttributeKeyword_1()); }
	'attribute'
	{ after(grammarAccess.getAttributeAccess().getAttributeKeyword_1()); }
)
;
finally {
	restoreStackSize(stackSize);
}

rule__Attribute__Group__2
	@init {
		int stackSize = keepStackSize();
	}
:
	rule__Attribute__Group__2__Impl
	rule__Attribute__Group__3
;
finally {
	restoreStackSize(stackSize);
}

rule__Attribute__Group__2__Impl
	@init {
		int stackSize = keepStackSize();
	}
:
(
	{ before(grammarAccess.getAttributeAccess().getNameAssignment_2()); }
	(rule__Attribute__NameAssignment_2)
	{ after(grammarAccess.getAttributeAccess().getNameAssignment_2()); }
)
;
finally {
	restoreStackSize(stackSize);
}

rule__Attribute__Group__3
	@init {
		int stackSize = keepStackSize();
	}
:
	rule__Attribute__Group__3__Impl
	rule__Attribute__Group__4
;
finally {
	restoreStackSize(stackSize);
}

rule__Attribute__Group__3__Impl
	@init {
		int stackSize = keepStackSize();
	}
:
(
	{ before(grammarAccess.getAttributeAccess().getIsOrderedAssignment_3()); }
	(rule__Attribute__IsOrderedAssignment_3)?
	{ after(grammarAccess.getAttributeAccess().getIsOrderedAssignment_3()); }
)
;
finally {
	restoreStackSize(stackSize);
}

rule__Attribute__Group__4
	@init {
		int stackSize = keepStackSize();
	}
:
	rule__Attribute__Group__4__Impl
	rule__Attribute__Group__5
;
finally {
	restoreStackSize(stackSize);
}

rule__Attribute__Group__4__Impl
	@init {
		int stackSize = keepStackSize();
	}
:
(
	{ before(grammarAccess.getAttributeAccess().getColonKeyword_4()); }
	':'
	{ after(grammarAccess.getAttributeAccess().getColonKeyword_4()); }
)
;
finally {
	restoreStackSize(stackSize);
}

rule__Attribute__Group__5
	@init {
		int stackSize = keepStackSize();
	}
:
	rule__Attribute__Group__5__Impl
	rule__Attribute__Group__6
;
finally {
	restoreStackSize(stackSize);
}

rule__Attribute__Group__5__Impl
	@init {
		int stackSize = keepStackSize();
	}
:
(
	{ before(grammarAccess.getAttributeAccess().getTypeAssignment_5()); }
	(rule__Attribute__TypeAssignment_5)
	{ after(grammarAccess.getAttributeAccess().getTypeAssignment_5()); }
)
;
finally {
	restoreStackSize(stackSize);
}

rule__Attribute__Group__6
	@init {
		int stackSize = keepStackSize();
	}
:
	rule__Attribute__Group__6__Impl
;
finally {
	restoreStackSize(stackSize);
}

rule__Attribute__Group__6__Impl
	@init {
		int stackSize = keepStackSize();
	}
:
(
	{ before(grammarAccess.getAttributeAccess().getSemicolonKeyword_6()); }
	';'
	{ after(grammarAccess.getAttributeAccess().getSemicolonKeyword_6()); }
)
;
finally {
	restoreStackSize(stackSize);
}


rule__Reference__Group__0
	@init {
		int stackSize = keepStackSize();
	}
:
	rule__Reference__Group__0__Impl
	rule__Reference__Group__1
;
finally {
	restoreStackSize(stackSize);
}

rule__Reference__Group__0__Impl
	@init {
		int stackSize = keepStackSize();
	}
:
(
	{ before(grammarAccess.getReferenceAccess().getReferenceKeyword_0()); }
	'reference'
	{ after(grammarAccess.getReferenceAccess().getReferenceKeyword_0()); }
)
;
finally {
	restoreStackSize(stackSize);
}

rule__Reference__Group__1
	@init {
		int stackSize = keepStackSize();
	}
:
	rule__Reference__Group__1__Impl
	rule__Reference__Group__2
;
finally {
	restoreStackSize(stackSize);
}

rule__Reference__Group__1__Impl
	@init {
		int stackSize = keepStackSize();
	}
:
(
	{ before(grammarAccess.getReferenceAccess().getNameAssignment_1()); }
	(rule__Reference__NameAssignment_1)
	{ after(grammarAccess.getReferenceAccess().getNameAssignment_1()); }
)
;
finally {
	restoreStackSize(stackSize);
}

rule__Reference__Group__2
	@init {
		int stackSize = keepStackSize();
	}
:
	rule__Reference__Group__2__Impl
	rule__Reference__Group__3
;
finally {
	restoreStackSize(stackSize);
}

rule__Reference__Group__2__Impl
	@init {
		int stackSize = keepStackSize();
	}
:
(
	{ before(grammarAccess.getReferenceAccess().getGroup_2()); }
	(rule__Reference__Group_2__0)?
	{ after(grammarAccess.getReferenceAccess().getGroup_2()); }
)
;
finally {
	restoreStackSize(stackSize);
}

rule__Reference__Group__3
	@init {
		int stackSize = keepStackSize();
	}
:
	rule__Reference__Group__3__Impl
	rule__Reference__Group__4
;
finally {
	restoreStackSize(stackSize);
}

rule__Reference__Group__3__Impl
	@init {
		int stackSize = keepStackSize();
	}
:
(
	{ before(grammarAccess.getReferenceAccess().getIsOrderedAssignment_3()); }
	(rule__Reference__IsOrderedAssignment_3)?
	{ after(grammarAccess.getReferenceAccess().getIsOrderedAssignment_3()); }
)
;
finally {
	restoreStackSize(stackSize);
}

rule__Reference__Group__4
	@init {
		int stackSize = keepStackSize();
	}
:
	rule__Reference__Group__4__Impl
	rule__Reference__Group__5
;
finally {
	restoreStackSize(stackSize);
}

rule__Reference__Group__4__Impl
	@init {
		int stackSize = keepStackSize();
	}
:
(
	{ before(grammarAccess.getReferenceAccess().getIsContainerAssignment_4()); }
	(rule__Reference__IsContainerAssignment_4)?
	{ after(grammarAccess.getReferenceAccess().getIsContainerAssignment_4()); }
)
;
finally {
	restoreStackSize(stackSize);
}

rule__Reference__Group__5
	@init {
		int stackSize = keepStackSize();
	}
:
	rule__Reference__Group__5__Impl
	rule__Reference__Group__6
;
finally {
	restoreStackSize(stackSize);
}

rule__Reference__Group__5__Impl
	@init {
		int stackSize = keepStackSize();
	}
:
(
	{ before(grammarAccess.getReferenceAccess().getColonKeyword_5()); }
	':'
	{ after(grammarAccess.getReferenceAccess().getColonKeyword_5()); }
)
;
finally {
	restoreStackSize(stackSize);
}

rule__Reference__Group__6
	@init {
		int stackSize = keepStackSize();
	}
:
	rule__Reference__Group__6__Impl
	rule__Reference__Group__7
;
finally {
	restoreStackSize(stackSize);
}

rule__Reference__Group__6__Impl
	@init {
		int stackSize = keepStackSize();
	}
:
(
	{ before(grammarAccess.getReferenceAccess().getTypeAssignment_6()); }
	(rule__Reference__TypeAssignment_6)
	{ after(grammarAccess.getReferenceAccess().getTypeAssignment_6()); }
)
;
finally {
	restoreStackSize(stackSize);
}

rule__Reference__Group__7
	@init {
		int stackSize = keepStackSize();
	}
:
	rule__Reference__Group__7__Impl
	rule__Reference__Group__8
;
finally {
	restoreStackSize(stackSize);
}

rule__Reference__Group__7__Impl
	@init {
		int stackSize = keepStackSize();
	}
:
(
	{ before(grammarAccess.getReferenceAccess().getGroup_7()); }
	(rule__Reference__Group_7__0)?
	{ after(grammarAccess.getReferenceAccess().getGroup_7()); }
)
;
finally {
	restoreStackSize(stackSize);
}

rule__Reference__Group__8
	@init {
		int stackSize = keepStackSize();
	}
:
	rule__Reference__Group__8__Impl
;
finally {
	restoreStackSize(stackSize);
}

rule__Reference__Group__8__Impl
	@init {
		int stackSize = keepStackSize();
	}
:
(
	{ before(grammarAccess.getReferenceAccess().getSemicolonKeyword_8()); }
	';'
	{ after(grammarAccess.getReferenceAccess().getSemicolonKeyword_8()); }
)
;
finally {
	restoreStackSize(stackSize);
}


rule__Reference__Group_2__0
	@init {
		int stackSize = keepStackSize();
	}
:
	rule__Reference__Group_2__0__Impl
	rule__Reference__Group_2__1
;
finally {
	restoreStackSize(stackSize);
}

rule__Reference__Group_2__0__Impl
	@init {
		int stackSize = keepStackSize();
	}
:
(
	{ before(grammarAccess.getReferenceAccess().getLeftSquareBracketKeyword_2_0()); }
	'['
	{ after(grammarAccess.getReferenceAccess().getLeftSquareBracketKeyword_2_0()); }
)
;
finally {
	restoreStackSize(stackSize);
}

rule__Reference__Group_2__1
	@init {
		int stackSize = keepStackSize();
	}
:
	rule__Reference__Group_2__1__Impl
;
finally {
	restoreStackSize(stackSize);
}

rule__Reference__Group_2__1__Impl
	@init {
		int stackSize = keepStackSize();
	}
:
(
	{ before(grammarAccess.getReferenceAccess().getRightSquareBracketKeyword_2_1()); }
	']'
	{ after(grammarAccess.getReferenceAccess().getRightSquareBracketKeyword_2_1()); }
)
;
finally {
	restoreStackSize(stackSize);
}


rule__Reference__Group_7__0
	@init {
		int stackSize = keepStackSize();
	}
:
	rule__Reference__Group_7__0__Impl
	rule__Reference__Group_7__1
;
finally {
	restoreStackSize(stackSize);
}

rule__Reference__Group_7__0__Impl
	@init {
		int stackSize = keepStackSize();
	}
:
(
	{ before(grammarAccess.getReferenceAccess().getOppositeOfKeyword_7_0()); }
	'oppositeOf'
	{ after(grammarAccess.getReferenceAccess().getOppositeOfKeyword_7_0()); }
)
;
finally {
	restoreStackSize(stackSize);
}

rule__Reference__Group_7__1
	@init {
		int stackSize = keepStackSize();
	}
:
	rule__Reference__Group_7__1__Impl
;
finally {
	restoreStackSize(stackSize);
}

rule__Reference__Group_7__1__Impl
	@init {
		int stackSize = keepStackSize();
	}
:
(
	{ before(grammarAccess.getReferenceAccess().getOppositeAssignment_7_1()); }
	(rule__Reference__OppositeAssignment_7_1)
	{ after(grammarAccess.getReferenceAccess().getOppositeAssignment_7_1()); }
)
;
finally {
	restoreStackSize(stackSize);
}


rule__Package__NameAssignment_1
	@init {
		int stackSize = keepStackSize();
	}
:
	(
		{ before(grammarAccess.getPackageAccess().getNameIDTerminalRuleCall_1_0()); }
		RULE_ID
		{ after(grammarAccess.getPackageAccess().getNameIDTerminalRuleCall_1_0()); }
	)
;
finally {
	restoreStackSize(stackSize);
}

rule__Package__ContentsAssignment_3
	@init {
		int stackSize = keepStackSize();
	}
:
	(
		{ before(grammarAccess.getPackageAccess().getContentsModelElementParserRuleCall_3_0()); }
		ruleModelElement
		{ after(grammarAccess.getPackageAccess().getContentsModelElementParserRuleCall_3_0()); }
	)
;
finally {
	restoreStackSize(stackSize);
}

rule__DataType__NameAssignment_1
	@init {
		int stackSize = keepStackSize();
	}
:
	(
		{ before(grammarAccess.getDataTypeAccess().getNameIDTerminalRuleCall_1_0()); }
		RULE_ID
		{ after(grammarAccess.getDataTypeAccess().getNameIDTerminalRuleCall_1_0()); }
	)
;
finally {
	restoreStackSize(stackSize);
}

rule__Class__IsAbstractAssignment_0
	@init {
		int stackSize = keepStackSize();
	}
:
	(
		{ before(grammarAccess.getClassAccess().getIsAbstractAbstractKeyword_0_0()); }
		(
			{ before(grammarAccess.getClassAccess().getIsAbstractAbstractKeyword_0_0()); }
			'abstract'
			{ after(grammarAccess.getClassAccess().getIsAbstractAbstractKeyword_0_0()); }
		)
		{ after(grammarAccess.getClassAccess().getIsAbstractAbstractKeyword_0_0()); }
	)
;
finally {
	restoreStackSize(stackSize);
}

rule__Class__NameAssignment_2
	@init {
		int stackSize = keepStackSize();
	}
:
	(
		{ before(grammarAccess.getClassAccess().getNameIDTerminalRuleCall_2_0()); }
		RULE_ID
		{ after(grammarAccess.getClassAccess().getNameIDTerminalRuleCall_2_0()); }
	)
;
finally {
	restoreStackSize(stackSize);
}

rule__Class__SupertypesAssignment_3_1
	@init {
		int stackSize = keepStackSize();
	}
:
	(
		{ before(grammarAccess.getClassAccess().getSupertypesClassCrossReference_3_1_0()); }
		(
			{ before(grammarAccess.getClassAccess().getSupertypesClassIDTerminalRuleCall_3_1_0_1()); }
			RULE_ID
			{ after(grammarAccess.getClassAccess().getSupertypesClassIDTerminalRuleCall_3_1_0_1()); }
		)
		{ after(grammarAccess.getClassAccess().getSupertypesClassCrossReference_3_1_0()); }
	)
;
finally {
	restoreStackSize(stackSize);
}

rule__Class__SupertypesAssignment_3_2_1
	@init {
		int stackSize = keepStackSize();
	}
:
	(
		{ before(grammarAccess.getClassAccess().getSupertypesClassCrossReference_3_2_1_0()); }
		(
			{ before(grammarAccess.getClassAccess().getSupertypesClassIDTerminalRuleCall_3_2_1_0_1()); }
			RULE_ID
			{ after(grammarAccess.getClassAccess().getSupertypesClassIDTerminalRuleCall_3_2_1_0_1()); }
		)
		{ after(grammarAccess.getClassAccess().getSupertypesClassCrossReference_3_2_1_0()); }
	)
;
finally {
	restoreStackSize(stackSize);
}

rule__Class__StructuralFeaturesAssignment_5
	@init {
		int stackSize = keepStackSize();
	}
:
	(
		{ before(grammarAccess.getClassAccess().getStructuralFeaturesStructuralFeatureParserRuleCall_5_0()); }
		ruleStructuralFeature
		{ after(grammarAccess.getClassAccess().getStructuralFeaturesStructuralFeatureParserRuleCall_5_0()); }
	)
;
finally {
	restoreStackSize(stackSize);
}

rule__Attribute__IsUniqueAssignment_0
	@init {
		int stackSize = keepStackSize();
	}
:
	(
		{ before(grammarAccess.getAttributeAccess().getIsUniqueUniqueKeyword_0_0()); }
		(
			{ before(grammarAccess.getAttributeAccess().getIsUniqueUniqueKeyword_0_0()); }
			'unique'
			{ after(grammarAccess.getAttributeAccess().getIsUniqueUniqueKeyword_0_0()); }
		)
		{ after(grammarAccess.getAttributeAccess().getIsUniqueUniqueKeyword_0_0()); }
	)
;
finally {
	restoreStackSize(stackSize);
}

rule__Attribute__NameAssignment_2
	@init {
		int stackSize = keepStackSize();
	}
:
	(
		{ before(grammarAccess.getAttributeAccess().getNameIDTerminalRuleCall_2_0()); }
		RULE_ID
		{ after(grammarAccess.getAttributeAccess().getNameIDTerminalRuleCall_2_0()); }
	)
;
finally {
	restoreStackSize(stackSize);
}

rule__Attribute__IsOrderedAssignment_3
	@init {
		int stackSize = keepStackSize();
	}
:
	(
		{ before(grammarAccess.getAttributeAccess().getIsOrderedOrderedKeyword_3_0()); }
		(
			{ before(grammarAccess.getAttributeAccess().getIsOrderedOrderedKeyword_3_0()); }
			'ordered'
			{ after(grammarAccess.getAttributeAccess().getIsOrderedOrderedKeyword_3_0()); }
		)
		{ after(grammarAccess.getAttributeAccess().getIsOrderedOrderedKeyword_3_0()); }
	)
;
finally {
	restoreStackSize(stackSize);
}

rule__Attribute__TypeAssignment_5
	@init {
		int stackSize = keepStackSize();
	}
:
	(
		{ before(grammarAccess.getAttributeAccess().getTypeClassifierCrossReference_5_0()); }
		(
			{ before(grammarAccess.getAttributeAccess().getTypeClassifierIDTerminalRuleCall_5_0_1()); }
			RULE_ID
			{ after(grammarAccess.getAttributeAccess().getTypeClassifierIDTerminalRuleCall_5_0_1()); }
		)
		{ after(grammarAccess.getAttributeAccess().getTypeClassifierCrossReference_5_0()); }
	)
;
finally {
	restoreStackSize(stackSize);
}

rule__Reference__NameAssignment_1
	@init {
		int stackSize = keepStackSize();
	}
:
	(
		{ before(grammarAccess.getReferenceAccess().getNameIDTerminalRuleCall_1_0()); }
		RULE_ID
		{ after(grammarAccess.getReferenceAccess().getNameIDTerminalRuleCall_1_0()); }
	)
;
finally {
	restoreStackSize(stackSize);
}

rule__Reference__IsOrderedAssignment_3
	@init {
		int stackSize = keepStackSize();
	}
:
	(
		{ before(grammarAccess.getReferenceAccess().getIsOrderedOrderedKeyword_3_0()); }
		(
			{ before(grammarAccess.getReferenceAccess().getIsOrderedOrderedKeyword_3_0()); }
			'ordered'
			{ after(grammarAccess.getReferenceAccess().getIsOrderedOrderedKeyword_3_0()); }
		)
		{ after(grammarAccess.getReferenceAccess().getIsOrderedOrderedKeyword_3_0()); }
	)
;
finally {
	restoreStackSize(stackSize);
}

rule__Reference__IsContainerAssignment_4
	@init {
		int stackSize = keepStackSize();
	}
:
	(
		{ before(grammarAccess.getReferenceAccess().getIsContainerContainerKeyword_4_0()); }
		(
			{ before(grammarAccess.getReferenceAccess().getIsContainerContainerKeyword_4_0()); }
			'container'
			{ after(grammarAccess.getReferenceAccess().getIsContainerContainerKeyword_4_0()); }
		)
		{ after(grammarAccess.getReferenceAccess().getIsContainerContainerKeyword_4_0()); }
	)
;
finally {
	restoreStackSize(stackSize);
}

rule__Reference__TypeAssignment_6
	@init {
		int stackSize = keepStackSize();
	}
:
	(
		{ before(grammarAccess.getReferenceAccess().getTypeClassifierCrossReference_6_0()); }
		(
			{ before(grammarAccess.getReferenceAccess().getTypeClassifierIDTerminalRuleCall_6_0_1()); }
			RULE_ID
			{ after(grammarAccess.getReferenceAccess().getTypeClassifierIDTerminalRuleCall_6_0_1()); }
		)
		{ after(grammarAccess.getReferenceAccess().getTypeClassifierCrossReference_6_0()); }
	)
;
finally {
	restoreStackSize(stackSize);
}

rule__Reference__OppositeAssignment_7_1
	@init {
		int stackSize = keepStackSize();
	}
:
	(
		{ before(grammarAccess.getReferenceAccess().getOppositeReferenceCrossReference_7_1_0()); }
		(
			{ before(grammarAccess.getReferenceAccess().getOppositeReferenceIDTerminalRuleCall_7_1_0_1()); }
			RULE_ID
			{ after(grammarAccess.getReferenceAccess().getOppositeReferenceIDTerminalRuleCall_7_1_0_1()); }
		)
		{ after(grammarAccess.getReferenceAccess().getOppositeReferenceCrossReference_7_1_0()); }
	)
;
finally {
	restoreStackSize(stackSize);
}

RULE_COMMENT : '--' ~(('\n'|'\r'))* ('\r'? '\n')?;

RULE_ID : '^'? ('a'..'z'|'A'..'Z'|'_') ('a'..'z'|'A'..'Z'|'_'|'0'..'9')*;

RULE_INT : ('0'..'9')+;

RULE_STRING : ('"' ('\\' .|~(('\\'|'"')))* '"'|'\'' ('\\' .|~(('\\'|'\'')))* '\'');

RULE_ML_COMMENT : '/*' ( options {greedy=false;} : . )*'*/';

RULE_SL_COMMENT : '//' ~(('\n'|'\r'))* ('\r'? '\n')?;

RULE_WS : (' '|'\t'|'\r'|'\n')+;

RULE_ANY_OTHER : .;
