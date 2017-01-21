/*
 * generated by Xtext 2.10.0
 */
grammar InternalKM3;

options {
	superClass=AbstractInternalAntlrParser;
}

@lexer::header {
package org.eclipse.m2m.km3.xtext.parser.antlr.internal;

// Hack: Use our own Lexer superclass by means of import. 
// Currently there is no other way to specify the superclass for the lexer.
import org.eclipse.xtext.parser.antlr.Lexer;
}

@parser::header {
package org.eclipse.m2m.km3.xtext.parser.antlr.internal;

import org.eclipse.xtext.*;
import org.eclipse.xtext.parser.*;
import org.eclipse.xtext.parser.impl.*;
import org.eclipse.emf.ecore.util.EcoreUtil;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.xtext.parser.antlr.AbstractInternalAntlrParser;
import org.eclipse.xtext.parser.antlr.XtextTokenStream;
import org.eclipse.xtext.parser.antlr.XtextTokenStream.HiddenTokens;
import org.eclipse.xtext.parser.antlr.AntlrDatatypeRuleToken;
import org.eclipse.m2m.km3.xtext.services.KM3GrammarAccess;

}

@parser::members {

 	private KM3GrammarAccess grammarAccess;

    public InternalKM3Parser(TokenStream input, KM3GrammarAccess grammarAccess) {
        this(input);
        this.grammarAccess = grammarAccess;
        registerRules(grammarAccess.getGrammar());
    }

    @Override
    protected String getFirstRuleName() {
    	return "Package";
   	}

   	@Override
   	protected KM3GrammarAccess getGrammarAccess() {
   		return grammarAccess;
   	}

}

@rulecatch {
    catch (RecognitionException re) {
        recover(input,re);
        appendSkippedTokens();
    }
}

// Entry rule entryRulePackage
entryRulePackage returns [EObject current=null]:
	{ newCompositeNode(grammarAccess.getPackageRule()); }
	iv_rulePackage=rulePackage
	{ $current=$iv_rulePackage.current; }
	EOF;

// Rule Package
rulePackage returns [EObject current=null]
@init {
	enterRule();
}
@after {
	leaveRule();
}:
	(
		otherlv_0='package'
		{
			newLeafNode(otherlv_0, grammarAccess.getPackageAccess().getPackageKeyword_0());
		}
		(
			(
				lv_name_1_0=RULE_ID
				{
					newLeafNode(lv_name_1_0, grammarAccess.getPackageAccess().getNameIDTerminalRuleCall_1_0());
				}
				{
					if ($current==null) {
						$current = createModelElement(grammarAccess.getPackageRule());
					}
					setWithLastConsumed(
						$current,
						"name",
						lv_name_1_0,
						"org.eclipse.xtext.common.Terminals.ID");
				}
			)
		)
		otherlv_2='{'
		{
			newLeafNode(otherlv_2, grammarAccess.getPackageAccess().getLeftCurlyBracketKeyword_2());
		}
		(
			(
				{
					newCompositeNode(grammarAccess.getPackageAccess().getContentsModelElementParserRuleCall_3_0());
				}
				lv_contents_3_0=ruleModelElement
				{
					if ($current==null) {
						$current = createModelElementForParent(grammarAccess.getPackageRule());
					}
					add(
						$current,
						"contents",
						lv_contents_3_0,
						"org.eclipse.m2m.km3.xtext.KM3.ModelElement");
					afterParserOrEnumRuleCall();
				}
			)
		)*
		otherlv_4='}'
		{
			newLeafNode(otherlv_4, grammarAccess.getPackageAccess().getRightCurlyBracketKeyword_4());
		}
	)
;

// Entry rule entryRuleModelElement
entryRuleModelElement returns [EObject current=null]:
	{ newCompositeNode(grammarAccess.getModelElementRule()); }
	iv_ruleModelElement=ruleModelElement
	{ $current=$iv_ruleModelElement.current; }
	EOF;

// Rule ModelElement
ruleModelElement returns [EObject current=null]
@init {
	enterRule();
}
@after {
	leaveRule();
}:
	(
		{
			newCompositeNode(grammarAccess.getModelElementAccess().getDataTypeParserRuleCall_0());
		}
		this_DataType_0=ruleDataType
		{
			$current = $this_DataType_0.current;
			afterParserOrEnumRuleCall();
		}
		    |
		{
			newCompositeNode(grammarAccess.getModelElementAccess().getClassParserRuleCall_1());
		}
		this_Class_1=ruleClass
		{
			$current = $this_Class_1.current;
			afterParserOrEnumRuleCall();
		}
	)
;

// Entry rule entryRuleDataType
entryRuleDataType returns [EObject current=null]:
	{ newCompositeNode(grammarAccess.getDataTypeRule()); }
	iv_ruleDataType=ruleDataType
	{ $current=$iv_ruleDataType.current; }
	EOF;

// Rule DataType
ruleDataType returns [EObject current=null]
@init {
	enterRule();
}
@after {
	leaveRule();
}:
	(
		otherlv_0='datatype'
		{
			newLeafNode(otherlv_0, grammarAccess.getDataTypeAccess().getDatatypeKeyword_0());
		}
		(
			(
				lv_name_1_0=RULE_ID
				{
					newLeafNode(lv_name_1_0, grammarAccess.getDataTypeAccess().getNameIDTerminalRuleCall_1_0());
				}
				{
					if ($current==null) {
						$current = createModelElement(grammarAccess.getDataTypeRule());
					}
					setWithLastConsumed(
						$current,
						"name",
						lv_name_1_0,
						"org.eclipse.xtext.common.Terminals.ID");
				}
			)
		)
		otherlv_2=';'
		{
			newLeafNode(otherlv_2, grammarAccess.getDataTypeAccess().getSemicolonKeyword_2());
		}
	)
;

// Entry rule entryRuleStructuralFeature
entryRuleStructuralFeature returns [EObject current=null]:
	{ newCompositeNode(grammarAccess.getStructuralFeatureRule()); }
	iv_ruleStructuralFeature=ruleStructuralFeature
	{ $current=$iv_ruleStructuralFeature.current; }
	EOF;

// Rule StructuralFeature
ruleStructuralFeature returns [EObject current=null]
@init {
	enterRule();
}
@after {
	leaveRule();
}:
	(
		{
			newCompositeNode(grammarAccess.getStructuralFeatureAccess().getAttributeParserRuleCall_0());
		}
		this_Attribute_0=ruleAttribute
		{
			$current = $this_Attribute_0.current;
			afterParserOrEnumRuleCall();
		}
		    |
		{
			newCompositeNode(grammarAccess.getStructuralFeatureAccess().getReferenceParserRuleCall_1());
		}
		this_Reference_1=ruleReference
		{
			$current = $this_Reference_1.current;
			afterParserOrEnumRuleCall();
		}
	)
;

// Entry rule entryRuleClass
entryRuleClass returns [EObject current=null]:
	{ newCompositeNode(grammarAccess.getClassRule()); }
	iv_ruleClass=ruleClass
	{ $current=$iv_ruleClass.current; }
	EOF;

// Rule Class
ruleClass returns [EObject current=null]
@init {
	enterRule();
}
@after {
	leaveRule();
}:
	(
		(
			(
				lv_isAbstract_0_0='abstract'
				{
					newLeafNode(lv_isAbstract_0_0, grammarAccess.getClassAccess().getIsAbstractAbstractKeyword_0_0());
				}
				{
					if ($current==null) {
						$current = createModelElement(grammarAccess.getClassRule());
					}
					setWithLastConsumed($current, "isAbstract", true, "abstract");
				}
			)
		)?
		otherlv_1='class'
		{
			newLeafNode(otherlv_1, grammarAccess.getClassAccess().getClassKeyword_1());
		}
		(
			(
				lv_name_2_0=RULE_ID
				{
					newLeafNode(lv_name_2_0, grammarAccess.getClassAccess().getNameIDTerminalRuleCall_2_0());
				}
				{
					if ($current==null) {
						$current = createModelElement(grammarAccess.getClassRule());
					}
					setWithLastConsumed(
						$current,
						"name",
						lv_name_2_0,
						"org.eclipse.xtext.common.Terminals.ID");
				}
			)
		)
		(
			otherlv_3='extends'
			{
				newLeafNode(otherlv_3, grammarAccess.getClassAccess().getExtendsKeyword_3_0());
			}
			(
				(
					{
						if ($current==null) {
							$current = createModelElement(grammarAccess.getClassRule());
						}
					}
					otherlv_4=RULE_ID
					{
						newLeafNode(otherlv_4, grammarAccess.getClassAccess().getSupertypesClassCrossReference_3_1_0());
					}
				)
			)
			(
				otherlv_5=','
				{
					newLeafNode(otherlv_5, grammarAccess.getClassAccess().getCommaKeyword_3_2_0());
				}
				(
					(
						{
							if ($current==null) {
								$current = createModelElement(grammarAccess.getClassRule());
							}
						}
						otherlv_6=RULE_ID
						{
							newLeafNode(otherlv_6, grammarAccess.getClassAccess().getSupertypesClassCrossReference_3_2_1_0());
						}
					)
				)
			)*
		)?
		otherlv_7='{'
		{
			newLeafNode(otherlv_7, grammarAccess.getClassAccess().getLeftCurlyBracketKeyword_4());
		}
		(
			(
				{
					newCompositeNode(grammarAccess.getClassAccess().getStructuralFeaturesStructuralFeatureParserRuleCall_5_0());
				}
				lv_structuralFeatures_8_0=ruleStructuralFeature
				{
					if ($current==null) {
						$current = createModelElementForParent(grammarAccess.getClassRule());
					}
					add(
						$current,
						"structuralFeatures",
						lv_structuralFeatures_8_0,
						"org.eclipse.m2m.km3.xtext.KM3.StructuralFeature");
					afterParserOrEnumRuleCall();
				}
			)
		)*
		otherlv_9='}'
		{
			newLeafNode(otherlv_9, grammarAccess.getClassAccess().getRightCurlyBracketKeyword_6());
		}
	)
;

// Entry rule entryRuleAttribute
entryRuleAttribute returns [EObject current=null]:
	{ newCompositeNode(grammarAccess.getAttributeRule()); }
	iv_ruleAttribute=ruleAttribute
	{ $current=$iv_ruleAttribute.current; }
	EOF;

// Rule Attribute
ruleAttribute returns [EObject current=null]
@init {
	enterRule();
}
@after {
	leaveRule();
}:
	(
		(
			(
				lv_isUnique_0_0='unique'
				{
					newLeafNode(lv_isUnique_0_0, grammarAccess.getAttributeAccess().getIsUniqueUniqueKeyword_0_0());
				}
				{
					if ($current==null) {
						$current = createModelElement(grammarAccess.getAttributeRule());
					}
					setWithLastConsumed($current, "isUnique", true, "unique");
				}
			)
		)?
		otherlv_1='attribute'
		{
			newLeafNode(otherlv_1, grammarAccess.getAttributeAccess().getAttributeKeyword_1());
		}
		(
			(
				lv_name_2_0=RULE_ID
				{
					newLeafNode(lv_name_2_0, grammarAccess.getAttributeAccess().getNameIDTerminalRuleCall_2_0());
				}
				{
					if ($current==null) {
						$current = createModelElement(grammarAccess.getAttributeRule());
					}
					setWithLastConsumed(
						$current,
						"name",
						lv_name_2_0,
						"org.eclipse.xtext.common.Terminals.ID");
				}
			)
		)
		(
			(
				lv_isOrdered_3_0='ordered'
				{
					newLeafNode(lv_isOrdered_3_0, grammarAccess.getAttributeAccess().getIsOrderedOrderedKeyword_3_0());
				}
				{
					if ($current==null) {
						$current = createModelElement(grammarAccess.getAttributeRule());
					}
					setWithLastConsumed($current, "isOrdered", true, "ordered");
				}
			)
		)?
		otherlv_4=':'
		{
			newLeafNode(otherlv_4, grammarAccess.getAttributeAccess().getColonKeyword_4());
		}
		(
			(
				{
					if ($current==null) {
						$current = createModelElement(grammarAccess.getAttributeRule());
					}
				}
				otherlv_5=RULE_ID
				{
					newLeafNode(otherlv_5, grammarAccess.getAttributeAccess().getTypeClassifierCrossReference_5_0());
				}
			)
		)
		otherlv_6=';'
		{
			newLeafNode(otherlv_6, grammarAccess.getAttributeAccess().getSemicolonKeyword_6());
		}
	)
;

// Entry rule entryRuleReference
entryRuleReference returns [EObject current=null]:
	{ newCompositeNode(grammarAccess.getReferenceRule()); }
	iv_ruleReference=ruleReference
	{ $current=$iv_ruleReference.current; }
	EOF;

// Rule Reference
ruleReference returns [EObject current=null]
@init {
	enterRule();
}
@after {
	leaveRule();
}:
	(
		otherlv_0='reference'
		{
			newLeafNode(otherlv_0, grammarAccess.getReferenceAccess().getReferenceKeyword_0());
		}
		(
			(
				lv_name_1_0=RULE_ID
				{
					newLeafNode(lv_name_1_0, grammarAccess.getReferenceAccess().getNameIDTerminalRuleCall_1_0());
				}
				{
					if ($current==null) {
						$current = createModelElement(grammarAccess.getReferenceRule());
					}
					setWithLastConsumed(
						$current,
						"name",
						lv_name_1_0,
						"org.eclipse.xtext.common.Terminals.ID");
				}
			)
		)
		(
			(
				lv_isOrdered_2_0='ordered'
				{
					newLeafNode(lv_isOrdered_2_0, grammarAccess.getReferenceAccess().getIsOrderedOrderedKeyword_2_0());
				}
				{
					if ($current==null) {
						$current = createModelElement(grammarAccess.getReferenceRule());
					}
					setWithLastConsumed($current, "isOrdered", true, "ordered");
				}
			)
		)?
		(
			(
				lv_isContainer_3_0='container'
				{
					newLeafNode(lv_isContainer_3_0, grammarAccess.getReferenceAccess().getIsContainerContainerKeyword_3_0());
				}
				{
					if ($current==null) {
						$current = createModelElement(grammarAccess.getReferenceRule());
					}
					setWithLastConsumed($current, "isContainer", true, "container");
				}
			)
		)?
		otherlv_4=':'
		{
			newLeafNode(otherlv_4, grammarAccess.getReferenceAccess().getColonKeyword_4());
		}
		(
			(
				{
					if ($current==null) {
						$current = createModelElement(grammarAccess.getReferenceRule());
					}
				}
				otherlv_5=RULE_ID
				{
					newLeafNode(otherlv_5, grammarAccess.getReferenceAccess().getTypeClassifierCrossReference_5_0());
				}
			)
		)
		(
			otherlv_6='oppositeOf'
			{
				newLeafNode(otherlv_6, grammarAccess.getReferenceAccess().getOppositeOfKeyword_6_0());
			}
			(
				(
					{
						if ($current==null) {
							$current = createModelElement(grammarAccess.getReferenceRule());
						}
					}
					otherlv_7=RULE_ID
					{
						newLeafNode(otherlv_7, grammarAccess.getReferenceAccess().getOppositeReferenceCrossReference_6_1_0());
					}
				)
			)
		)?
		otherlv_8=';'
		{
			newLeafNode(otherlv_8, grammarAccess.getReferenceAccess().getSemicolonKeyword_7());
		}
	)
;

RULE_COMMENT : '--' ~(('\n'|'\r'))* ('\r'? '\n')?;

RULE_ID : '^'? ('a'..'z'|'A'..'Z'|'_') ('a'..'z'|'A'..'Z'|'_'|'0'..'9')*;

RULE_INT : ('0'..'9')+;

RULE_STRING : ('"' ('\\' .|~(('\\'|'"')))* '"'|'\'' ('\\' .|~(('\\'|'\'')))* '\'');

RULE_ML_COMMENT : '/*' ( options {greedy=false;} : . )*'*/';

RULE_SL_COMMENT : '//' ~(('\n'|'\r'))* ('\r'? '\n')?;

RULE_WS : (' '|'\t'|'\r'|'\n')+;

RULE_ANY_OTHER : .;