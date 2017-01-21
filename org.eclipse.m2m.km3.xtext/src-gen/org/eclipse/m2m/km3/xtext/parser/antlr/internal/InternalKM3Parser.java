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



import org.antlr.runtime.*;
import java.util.Stack;
import java.util.List;
import java.util.ArrayList;

@SuppressWarnings("all")
public class InternalKM3Parser extends AbstractInternalAntlrParser {
    public static final String[] tokenNames = new String[] {
        "<invalid>", "<EOR>", "<DOWN>", "<UP>", "RULE_STRING", "RULE_ID", "RULE_INT", "RULE_ML_COMMENT", "RULE_SL_COMMENT", "RULE_WS", "RULE_ANY_OTHER", "'Metamodel'", "'{'", "'location'", "'contents'", "'('", "','", "')'", "'}'", "'String'", "'Package'", "'name'", "'metamodel'", "'Classifier'", "'DataType'", "'Enumeration'", "'literals'", "'EnumLiteral'", "'enum'", "'TemplateParameter'", "'Class'", "'isAbstract'", "'parameters'", "'supertypes'", "'structuralFeatures'", "'operations'", "'TypedElement'", "'lower'", "'upper'", "'isOrdered'", "'isUnique'", "'type'", "'StructuralFeature'", "'owner'", "'subsetOf'", "'derivedFrom'", "'Attribute'", "'Reference'", "'isContainer'", "'opposite'", "'Operation'", "'Parameter'", "'Boolean'", "'Integer'"
    };
    public static final int T__50=50;
    public static final int T__19=19;
    public static final int T__15=15;
    public static final int T__16=16;
    public static final int T__17=17;
    public static final int T__18=18;
    public static final int T__11=11;
    public static final int T__12=12;
    public static final int T__13=13;
    public static final int T__14=14;
    public static final int T__51=51;
    public static final int T__52=52;
    public static final int T__53=53;
    public static final int RULE_ID=5;
    public static final int T__26=26;
    public static final int T__27=27;
    public static final int T__28=28;
    public static final int RULE_INT=6;
    public static final int T__29=29;
    public static final int T__22=22;
    public static final int RULE_ML_COMMENT=7;
    public static final int T__23=23;
    public static final int T__24=24;
    public static final int T__25=25;
    public static final int T__20=20;
    public static final int T__21=21;
    public static final int RULE_STRING=4;
    public static final int RULE_SL_COMMENT=8;
    public static final int T__37=37;
    public static final int T__38=38;
    public static final int T__39=39;
    public static final int T__33=33;
    public static final int T__34=34;
    public static final int T__35=35;
    public static final int T__36=36;
    public static final int EOF=-1;
    public static final int T__30=30;
    public static final int T__31=31;
    public static final int T__32=32;
    public static final int RULE_WS=9;
    public static final int RULE_ANY_OTHER=10;
    public static final int T__48=48;
    public static final int T__49=49;
    public static final int T__44=44;
    public static final int T__45=45;
    public static final int T__46=46;
    public static final int T__47=47;
    public static final int T__40=40;
    public static final int T__41=41;
    public static final int T__42=42;
    public static final int T__43=43;

    // delegates
    // delegators


        public InternalKM3Parser(TokenStream input) {
            this(input, new RecognizerSharedState());
        }
        public InternalKM3Parser(TokenStream input, RecognizerSharedState state) {
            super(input, state);
             
        }
        

    public String[] getTokenNames() { return InternalKM3Parser.tokenNames; }
    public String getGrammarFileName() { return "InternalKM3.g"; }



     	private KM3GrammarAccess grammarAccess;

        public InternalKM3Parser(TokenStream input, KM3GrammarAccess grammarAccess) {
            this(input);
            this.grammarAccess = grammarAccess;
            registerRules(grammarAccess.getGrammar());
        }

        @Override
        protected String getFirstRuleName() {
        	return "Metamodel";
       	}

       	@Override
       	protected KM3GrammarAccess getGrammarAccess() {
       		return grammarAccess;
       	}




    // $ANTLR start "entryRuleMetamodel"
    // InternalKM3.g:64:1: entryRuleMetamodel returns [EObject current=null] : iv_ruleMetamodel= ruleMetamodel EOF ;
    public final EObject entryRuleMetamodel() throws RecognitionException {
        EObject current = null;

        EObject iv_ruleMetamodel = null;


        try {
            // InternalKM3.g:64:50: (iv_ruleMetamodel= ruleMetamodel EOF )
            // InternalKM3.g:65:2: iv_ruleMetamodel= ruleMetamodel EOF
            {
             newCompositeNode(grammarAccess.getMetamodelRule()); 
            pushFollow(FOLLOW_1);
            iv_ruleMetamodel=ruleMetamodel();

            state._fsp--;

             current =iv_ruleMetamodel; 
            match(input,EOF,FOLLOW_2); 

            }

        }

            catch (RecognitionException re) {
                recover(input,re);
                appendSkippedTokens();
            }
        finally {
        }
        return current;
    }
    // $ANTLR end "entryRuleMetamodel"


    // $ANTLR start "ruleMetamodel"
    // InternalKM3.g:71:1: ruleMetamodel returns [EObject current=null] : (otherlv_0= 'Metamodel' otherlv_1= '{' otherlv_2= 'location' ( (lv_location_3_0= ruleString0 ) ) (otherlv_4= 'contents' otherlv_5= '(' ( (otherlv_6= RULE_STRING ) ) (otherlv_7= ',' ( (otherlv_8= RULE_STRING ) ) )* otherlv_9= ')' )? otherlv_10= '}' ) ;
    public final EObject ruleMetamodel() throws RecognitionException {
        EObject current = null;

        Token otherlv_0=null;
        Token otherlv_1=null;
        Token otherlv_2=null;
        Token otherlv_4=null;
        Token otherlv_5=null;
        Token otherlv_6=null;
        Token otherlv_7=null;
        Token otherlv_8=null;
        Token otherlv_9=null;
        Token otherlv_10=null;
        AntlrDatatypeRuleToken lv_location_3_0 = null;



        	enterRule();

        try {
            // InternalKM3.g:77:2: ( (otherlv_0= 'Metamodel' otherlv_1= '{' otherlv_2= 'location' ( (lv_location_3_0= ruleString0 ) ) (otherlv_4= 'contents' otherlv_5= '(' ( (otherlv_6= RULE_STRING ) ) (otherlv_7= ',' ( (otherlv_8= RULE_STRING ) ) )* otherlv_9= ')' )? otherlv_10= '}' ) )
            // InternalKM3.g:78:2: (otherlv_0= 'Metamodel' otherlv_1= '{' otherlv_2= 'location' ( (lv_location_3_0= ruleString0 ) ) (otherlv_4= 'contents' otherlv_5= '(' ( (otherlv_6= RULE_STRING ) ) (otherlv_7= ',' ( (otherlv_8= RULE_STRING ) ) )* otherlv_9= ')' )? otherlv_10= '}' )
            {
            // InternalKM3.g:78:2: (otherlv_0= 'Metamodel' otherlv_1= '{' otherlv_2= 'location' ( (lv_location_3_0= ruleString0 ) ) (otherlv_4= 'contents' otherlv_5= '(' ( (otherlv_6= RULE_STRING ) ) (otherlv_7= ',' ( (otherlv_8= RULE_STRING ) ) )* otherlv_9= ')' )? otherlv_10= '}' )
            // InternalKM3.g:79:3: otherlv_0= 'Metamodel' otherlv_1= '{' otherlv_2= 'location' ( (lv_location_3_0= ruleString0 ) ) (otherlv_4= 'contents' otherlv_5= '(' ( (otherlv_6= RULE_STRING ) ) (otherlv_7= ',' ( (otherlv_8= RULE_STRING ) ) )* otherlv_9= ')' )? otherlv_10= '}'
            {
            otherlv_0=(Token)match(input,11,FOLLOW_3); 

            			newLeafNode(otherlv_0, grammarAccess.getMetamodelAccess().getMetamodelKeyword_0());
            		
            otherlv_1=(Token)match(input,12,FOLLOW_4); 

            			newLeafNode(otherlv_1, grammarAccess.getMetamodelAccess().getLeftCurlyBracketKeyword_1());
            		
            otherlv_2=(Token)match(input,13,FOLLOW_5); 

            			newLeafNode(otherlv_2, grammarAccess.getMetamodelAccess().getLocationKeyword_2());
            		
            // InternalKM3.g:91:3: ( (lv_location_3_0= ruleString0 ) )
            // InternalKM3.g:92:4: (lv_location_3_0= ruleString0 )
            {
            // InternalKM3.g:92:4: (lv_location_3_0= ruleString0 )
            // InternalKM3.g:93:5: lv_location_3_0= ruleString0
            {

            					newCompositeNode(grammarAccess.getMetamodelAccess().getLocationString0ParserRuleCall_3_0());
            				
            pushFollow(FOLLOW_6);
            lv_location_3_0=ruleString0();

            state._fsp--;


            					if (current==null) {
            						current = createModelElementForParent(grammarAccess.getMetamodelRule());
            					}
            					set(
            						current,
            						"location",
            						lv_location_3_0,
            						"org.eclipse.m2m.km3.xtext.KM3.String0");
            					afterParserOrEnumRuleCall();
            				

            }


            }

            // InternalKM3.g:110:3: (otherlv_4= 'contents' otherlv_5= '(' ( (otherlv_6= RULE_STRING ) ) (otherlv_7= ',' ( (otherlv_8= RULE_STRING ) ) )* otherlv_9= ')' )?
            int alt2=2;
            int LA2_0 = input.LA(1);

            if ( (LA2_0==14) ) {
                alt2=1;
            }
            switch (alt2) {
                case 1 :
                    // InternalKM3.g:111:4: otherlv_4= 'contents' otherlv_5= '(' ( (otherlv_6= RULE_STRING ) ) (otherlv_7= ',' ( (otherlv_8= RULE_STRING ) ) )* otherlv_9= ')'
                    {
                    otherlv_4=(Token)match(input,14,FOLLOW_7); 

                    				newLeafNode(otherlv_4, grammarAccess.getMetamodelAccess().getContentsKeyword_4_0());
                    			
                    otherlv_5=(Token)match(input,15,FOLLOW_8); 

                    				newLeafNode(otherlv_5, grammarAccess.getMetamodelAccess().getLeftParenthesisKeyword_4_1());
                    			
                    // InternalKM3.g:119:4: ( (otherlv_6= RULE_STRING ) )
                    // InternalKM3.g:120:5: (otherlv_6= RULE_STRING )
                    {
                    // InternalKM3.g:120:5: (otherlv_6= RULE_STRING )
                    // InternalKM3.g:121:6: otherlv_6= RULE_STRING
                    {

                    						if (current==null) {
                    							current = createModelElement(grammarAccess.getMetamodelRule());
                    						}
                    					
                    otherlv_6=(Token)match(input,RULE_STRING,FOLLOW_9); 

                    						newLeafNode(otherlv_6, grammarAccess.getMetamodelAccess().getContentsPackageCrossReference_4_2_0());
                    					

                    }


                    }

                    // InternalKM3.g:132:4: (otherlv_7= ',' ( (otherlv_8= RULE_STRING ) ) )*
                    loop1:
                    do {
                        int alt1=2;
                        int LA1_0 = input.LA(1);

                        if ( (LA1_0==16) ) {
                            alt1=1;
                        }


                        switch (alt1) {
                    	case 1 :
                    	    // InternalKM3.g:133:5: otherlv_7= ',' ( (otherlv_8= RULE_STRING ) )
                    	    {
                    	    otherlv_7=(Token)match(input,16,FOLLOW_8); 

                    	    					newLeafNode(otherlv_7, grammarAccess.getMetamodelAccess().getCommaKeyword_4_3_0());
                    	    				
                    	    // InternalKM3.g:137:5: ( (otherlv_8= RULE_STRING ) )
                    	    // InternalKM3.g:138:6: (otherlv_8= RULE_STRING )
                    	    {
                    	    // InternalKM3.g:138:6: (otherlv_8= RULE_STRING )
                    	    // InternalKM3.g:139:7: otherlv_8= RULE_STRING
                    	    {

                    	    							if (current==null) {
                    	    								current = createModelElement(grammarAccess.getMetamodelRule());
                    	    							}
                    	    						
                    	    otherlv_8=(Token)match(input,RULE_STRING,FOLLOW_9); 

                    	    							newLeafNode(otherlv_8, grammarAccess.getMetamodelAccess().getContentsPackageCrossReference_4_3_1_0());
                    	    						

                    	    }


                    	    }


                    	    }
                    	    break;

                    	default :
                    	    break loop1;
                        }
                    } while (true);

                    otherlv_9=(Token)match(input,17,FOLLOW_10); 

                    				newLeafNode(otherlv_9, grammarAccess.getMetamodelAccess().getRightParenthesisKeyword_4_4());
                    			

                    }
                    break;

            }

            otherlv_10=(Token)match(input,18,FOLLOW_2); 

            			newLeafNode(otherlv_10, grammarAccess.getMetamodelAccess().getRightCurlyBracketKeyword_5());
            		

            }


            }


            	leaveRule();

        }

            catch (RecognitionException re) {
                recover(input,re);
                appendSkippedTokens();
            }
        finally {
        }
        return current;
    }
    // $ANTLR end "ruleMetamodel"


    // $ANTLR start "entryRuleModelElement"
    // InternalKM3.g:164:1: entryRuleModelElement returns [EObject current=null] : iv_ruleModelElement= ruleModelElement EOF ;
    public final EObject entryRuleModelElement() throws RecognitionException {
        EObject current = null;

        EObject iv_ruleModelElement = null;


        try {
            // InternalKM3.g:164:53: (iv_ruleModelElement= ruleModelElement EOF )
            // InternalKM3.g:165:2: iv_ruleModelElement= ruleModelElement EOF
            {
             newCompositeNode(grammarAccess.getModelElementRule()); 
            pushFollow(FOLLOW_1);
            iv_ruleModelElement=ruleModelElement();

            state._fsp--;

             current =iv_ruleModelElement; 
            match(input,EOF,FOLLOW_2); 

            }

        }

            catch (RecognitionException re) {
                recover(input,re);
                appendSkippedTokens();
            }
        finally {
        }
        return current;
    }
    // $ANTLR end "entryRuleModelElement"


    // $ANTLR start "ruleModelElement"
    // InternalKM3.g:171:1: ruleModelElement returns [EObject current=null] : (this_Classifier_Impl_0= ruleClassifier_Impl | this_DataType_1= ruleDataType | this_Enumeration_2= ruleEnumeration | this_EnumLiteral_3= ruleEnumLiteral | this_TemplateParameter_4= ruleTemplateParameter | this_Class_5= ruleClass | this_TypedElement_Impl_6= ruleTypedElement_Impl | this_StructuralFeature_Impl_7= ruleStructuralFeature_Impl | this_Attribute_8= ruleAttribute | this_Reference_9= ruleReference | this_Operation_10= ruleOperation | this_Parameter_11= ruleParameter | this_Package_12= rulePackage ) ;
    public final EObject ruleModelElement() throws RecognitionException {
        EObject current = null;

        EObject this_Classifier_Impl_0 = null;

        EObject this_DataType_1 = null;

        EObject this_Enumeration_2 = null;

        EObject this_EnumLiteral_3 = null;

        EObject this_TemplateParameter_4 = null;

        EObject this_Class_5 = null;

        EObject this_TypedElement_Impl_6 = null;

        EObject this_StructuralFeature_Impl_7 = null;

        EObject this_Attribute_8 = null;

        EObject this_Reference_9 = null;

        EObject this_Operation_10 = null;

        EObject this_Parameter_11 = null;

        EObject this_Package_12 = null;



        	enterRule();

        try {
            // InternalKM3.g:177:2: ( (this_Classifier_Impl_0= ruleClassifier_Impl | this_DataType_1= ruleDataType | this_Enumeration_2= ruleEnumeration | this_EnumLiteral_3= ruleEnumLiteral | this_TemplateParameter_4= ruleTemplateParameter | this_Class_5= ruleClass | this_TypedElement_Impl_6= ruleTypedElement_Impl | this_StructuralFeature_Impl_7= ruleStructuralFeature_Impl | this_Attribute_8= ruleAttribute | this_Reference_9= ruleReference | this_Operation_10= ruleOperation | this_Parameter_11= ruleParameter | this_Package_12= rulePackage ) )
            // InternalKM3.g:178:2: (this_Classifier_Impl_0= ruleClassifier_Impl | this_DataType_1= ruleDataType | this_Enumeration_2= ruleEnumeration | this_EnumLiteral_3= ruleEnumLiteral | this_TemplateParameter_4= ruleTemplateParameter | this_Class_5= ruleClass | this_TypedElement_Impl_6= ruleTypedElement_Impl | this_StructuralFeature_Impl_7= ruleStructuralFeature_Impl | this_Attribute_8= ruleAttribute | this_Reference_9= ruleReference | this_Operation_10= ruleOperation | this_Parameter_11= ruleParameter | this_Package_12= rulePackage )
            {
            // InternalKM3.g:178:2: (this_Classifier_Impl_0= ruleClassifier_Impl | this_DataType_1= ruleDataType | this_Enumeration_2= ruleEnumeration | this_EnumLiteral_3= ruleEnumLiteral | this_TemplateParameter_4= ruleTemplateParameter | this_Class_5= ruleClass | this_TypedElement_Impl_6= ruleTypedElement_Impl | this_StructuralFeature_Impl_7= ruleStructuralFeature_Impl | this_Attribute_8= ruleAttribute | this_Reference_9= ruleReference | this_Operation_10= ruleOperation | this_Parameter_11= ruleParameter | this_Package_12= rulePackage )
            int alt3=13;
            switch ( input.LA(1) ) {
            case 23:
                {
                alt3=1;
                }
                break;
            case 24:
                {
                alt3=2;
                }
                break;
            case 25:
                {
                alt3=3;
                }
                break;
            case 27:
                {
                alt3=4;
                }
                break;
            case 29:
                {
                alt3=5;
                }
                break;
            case 30:
                {
                alt3=6;
                }
                break;
            case 36:
                {
                alt3=7;
                }
                break;
            case 42:
                {
                alt3=8;
                }
                break;
            case 46:
                {
                alt3=9;
                }
                break;
            case 47:
                {
                alt3=10;
                }
                break;
            case 50:
                {
                alt3=11;
                }
                break;
            case 51:
                {
                alt3=12;
                }
                break;
            case 20:
                {
                alt3=13;
                }
                break;
            default:
                NoViableAltException nvae =
                    new NoViableAltException("", 3, 0, input);

                throw nvae;
            }

            switch (alt3) {
                case 1 :
                    // InternalKM3.g:179:3: this_Classifier_Impl_0= ruleClassifier_Impl
                    {

                    			newCompositeNode(grammarAccess.getModelElementAccess().getClassifier_ImplParserRuleCall_0());
                    		
                    pushFollow(FOLLOW_2);
                    this_Classifier_Impl_0=ruleClassifier_Impl();

                    state._fsp--;


                    			current = this_Classifier_Impl_0;
                    			afterParserOrEnumRuleCall();
                    		

                    }
                    break;
                case 2 :
                    // InternalKM3.g:188:3: this_DataType_1= ruleDataType
                    {

                    			newCompositeNode(grammarAccess.getModelElementAccess().getDataTypeParserRuleCall_1());
                    		
                    pushFollow(FOLLOW_2);
                    this_DataType_1=ruleDataType();

                    state._fsp--;


                    			current = this_DataType_1;
                    			afterParserOrEnumRuleCall();
                    		

                    }
                    break;
                case 3 :
                    // InternalKM3.g:197:3: this_Enumeration_2= ruleEnumeration
                    {

                    			newCompositeNode(grammarAccess.getModelElementAccess().getEnumerationParserRuleCall_2());
                    		
                    pushFollow(FOLLOW_2);
                    this_Enumeration_2=ruleEnumeration();

                    state._fsp--;


                    			current = this_Enumeration_2;
                    			afterParserOrEnumRuleCall();
                    		

                    }
                    break;
                case 4 :
                    // InternalKM3.g:206:3: this_EnumLiteral_3= ruleEnumLiteral
                    {

                    			newCompositeNode(grammarAccess.getModelElementAccess().getEnumLiteralParserRuleCall_3());
                    		
                    pushFollow(FOLLOW_2);
                    this_EnumLiteral_3=ruleEnumLiteral();

                    state._fsp--;


                    			current = this_EnumLiteral_3;
                    			afterParserOrEnumRuleCall();
                    		

                    }
                    break;
                case 5 :
                    // InternalKM3.g:215:3: this_TemplateParameter_4= ruleTemplateParameter
                    {

                    			newCompositeNode(grammarAccess.getModelElementAccess().getTemplateParameterParserRuleCall_4());
                    		
                    pushFollow(FOLLOW_2);
                    this_TemplateParameter_4=ruleTemplateParameter();

                    state._fsp--;


                    			current = this_TemplateParameter_4;
                    			afterParserOrEnumRuleCall();
                    		

                    }
                    break;
                case 6 :
                    // InternalKM3.g:224:3: this_Class_5= ruleClass
                    {

                    			newCompositeNode(grammarAccess.getModelElementAccess().getClassParserRuleCall_5());
                    		
                    pushFollow(FOLLOW_2);
                    this_Class_5=ruleClass();

                    state._fsp--;


                    			current = this_Class_5;
                    			afterParserOrEnumRuleCall();
                    		

                    }
                    break;
                case 7 :
                    // InternalKM3.g:233:3: this_TypedElement_Impl_6= ruleTypedElement_Impl
                    {

                    			newCompositeNode(grammarAccess.getModelElementAccess().getTypedElement_ImplParserRuleCall_6());
                    		
                    pushFollow(FOLLOW_2);
                    this_TypedElement_Impl_6=ruleTypedElement_Impl();

                    state._fsp--;


                    			current = this_TypedElement_Impl_6;
                    			afterParserOrEnumRuleCall();
                    		

                    }
                    break;
                case 8 :
                    // InternalKM3.g:242:3: this_StructuralFeature_Impl_7= ruleStructuralFeature_Impl
                    {

                    			newCompositeNode(grammarAccess.getModelElementAccess().getStructuralFeature_ImplParserRuleCall_7());
                    		
                    pushFollow(FOLLOW_2);
                    this_StructuralFeature_Impl_7=ruleStructuralFeature_Impl();

                    state._fsp--;


                    			current = this_StructuralFeature_Impl_7;
                    			afterParserOrEnumRuleCall();
                    		

                    }
                    break;
                case 9 :
                    // InternalKM3.g:251:3: this_Attribute_8= ruleAttribute
                    {

                    			newCompositeNode(grammarAccess.getModelElementAccess().getAttributeParserRuleCall_8());
                    		
                    pushFollow(FOLLOW_2);
                    this_Attribute_8=ruleAttribute();

                    state._fsp--;


                    			current = this_Attribute_8;
                    			afterParserOrEnumRuleCall();
                    		

                    }
                    break;
                case 10 :
                    // InternalKM3.g:260:3: this_Reference_9= ruleReference
                    {

                    			newCompositeNode(grammarAccess.getModelElementAccess().getReferenceParserRuleCall_9());
                    		
                    pushFollow(FOLLOW_2);
                    this_Reference_9=ruleReference();

                    state._fsp--;


                    			current = this_Reference_9;
                    			afterParserOrEnumRuleCall();
                    		

                    }
                    break;
                case 11 :
                    // InternalKM3.g:269:3: this_Operation_10= ruleOperation
                    {

                    			newCompositeNode(grammarAccess.getModelElementAccess().getOperationParserRuleCall_10());
                    		
                    pushFollow(FOLLOW_2);
                    this_Operation_10=ruleOperation();

                    state._fsp--;


                    			current = this_Operation_10;
                    			afterParserOrEnumRuleCall();
                    		

                    }
                    break;
                case 12 :
                    // InternalKM3.g:278:3: this_Parameter_11= ruleParameter
                    {

                    			newCompositeNode(grammarAccess.getModelElementAccess().getParameterParserRuleCall_11());
                    		
                    pushFollow(FOLLOW_2);
                    this_Parameter_11=ruleParameter();

                    state._fsp--;


                    			current = this_Parameter_11;
                    			afterParserOrEnumRuleCall();
                    		

                    }
                    break;
                case 13 :
                    // InternalKM3.g:287:3: this_Package_12= rulePackage
                    {

                    			newCompositeNode(grammarAccess.getModelElementAccess().getPackageParserRuleCall_12());
                    		
                    pushFollow(FOLLOW_2);
                    this_Package_12=rulePackage();

                    state._fsp--;


                    			current = this_Package_12;
                    			afterParserOrEnumRuleCall();
                    		

                    }
                    break;

            }


            }


            	leaveRule();

        }

            catch (RecognitionException re) {
                recover(input,re);
                appendSkippedTokens();
            }
        finally {
        }
        return current;
    }
    // $ANTLR end "ruleModelElement"


    // $ANTLR start "entryRuleString0"
    // InternalKM3.g:299:1: entryRuleString0 returns [String current=null] : iv_ruleString0= ruleString0 EOF ;
    public final String entryRuleString0() throws RecognitionException {
        String current = null;

        AntlrDatatypeRuleToken iv_ruleString0 = null;


        try {
            // InternalKM3.g:299:47: (iv_ruleString0= ruleString0 EOF )
            // InternalKM3.g:300:2: iv_ruleString0= ruleString0 EOF
            {
             newCompositeNode(grammarAccess.getString0Rule()); 
            pushFollow(FOLLOW_1);
            iv_ruleString0=ruleString0();

            state._fsp--;

             current =iv_ruleString0.getText(); 
            match(input,EOF,FOLLOW_2); 

            }

        }

            catch (RecognitionException re) {
                recover(input,re);
                appendSkippedTokens();
            }
        finally {
        }
        return current;
    }
    // $ANTLR end "entryRuleString0"


    // $ANTLR start "ruleString0"
    // InternalKM3.g:306:1: ruleString0 returns [AntlrDatatypeRuleToken current=new AntlrDatatypeRuleToken()] : kw= 'String' ;
    public final AntlrDatatypeRuleToken ruleString0() throws RecognitionException {
        AntlrDatatypeRuleToken current = new AntlrDatatypeRuleToken();

        Token kw=null;


        	enterRule();

        try {
            // InternalKM3.g:312:2: (kw= 'String' )
            // InternalKM3.g:313:2: kw= 'String'
            {
            kw=(Token)match(input,19,FOLLOW_2); 

            		current.merge(kw);
            		newLeafNode(kw, grammarAccess.getString0Access().getStringKeyword());
            	

            }


            	leaveRule();

        }

            catch (RecognitionException re) {
                recover(input,re);
                appendSkippedTokens();
            }
        finally {
        }
        return current;
    }
    // $ANTLR end "ruleString0"


    // $ANTLR start "entryRulePackage"
    // InternalKM3.g:321:1: entryRulePackage returns [EObject current=null] : iv_rulePackage= rulePackage EOF ;
    public final EObject entryRulePackage() throws RecognitionException {
        EObject current = null;

        EObject iv_rulePackage = null;


        try {
            // InternalKM3.g:321:48: (iv_rulePackage= rulePackage EOF )
            // InternalKM3.g:322:2: iv_rulePackage= rulePackage EOF
            {
             newCompositeNode(grammarAccess.getPackageRule()); 
            pushFollow(FOLLOW_1);
            iv_rulePackage=rulePackage();

            state._fsp--;

             current =iv_rulePackage; 
            match(input,EOF,FOLLOW_2); 

            }

        }

            catch (RecognitionException re) {
                recover(input,re);
                appendSkippedTokens();
            }
        finally {
        }
        return current;
    }
    // $ANTLR end "entryRulePackage"


    // $ANTLR start "rulePackage"
    // InternalKM3.g:328:1: rulePackage returns [EObject current=null] : (otherlv_0= 'Package' otherlv_1= '{' otherlv_2= 'location' ( (lv_location_3_0= ruleString0 ) ) otherlv_4= 'name' ( (lv_name_5_0= ruleString0 ) ) otherlv_6= 'metamodel' ( (otherlv_7= RULE_STRING ) ) (otherlv_8= 'contents' otherlv_9= '{' ( (lv_contents_10_0= ruleModelElement ) ) (otherlv_11= ',' ( (lv_contents_12_0= ruleModelElement ) ) )* otherlv_13= '}' )? otherlv_14= '}' ) ;
    public final EObject rulePackage() throws RecognitionException {
        EObject current = null;

        Token otherlv_0=null;
        Token otherlv_1=null;
        Token otherlv_2=null;
        Token otherlv_4=null;
        Token otherlv_6=null;
        Token otherlv_7=null;
        Token otherlv_8=null;
        Token otherlv_9=null;
        Token otherlv_11=null;
        Token otherlv_13=null;
        Token otherlv_14=null;
        AntlrDatatypeRuleToken lv_location_3_0 = null;

        AntlrDatatypeRuleToken lv_name_5_0 = null;

        EObject lv_contents_10_0 = null;

        EObject lv_contents_12_0 = null;



        	enterRule();

        try {
            // InternalKM3.g:334:2: ( (otherlv_0= 'Package' otherlv_1= '{' otherlv_2= 'location' ( (lv_location_3_0= ruleString0 ) ) otherlv_4= 'name' ( (lv_name_5_0= ruleString0 ) ) otherlv_6= 'metamodel' ( (otherlv_7= RULE_STRING ) ) (otherlv_8= 'contents' otherlv_9= '{' ( (lv_contents_10_0= ruleModelElement ) ) (otherlv_11= ',' ( (lv_contents_12_0= ruleModelElement ) ) )* otherlv_13= '}' )? otherlv_14= '}' ) )
            // InternalKM3.g:335:2: (otherlv_0= 'Package' otherlv_1= '{' otherlv_2= 'location' ( (lv_location_3_0= ruleString0 ) ) otherlv_4= 'name' ( (lv_name_5_0= ruleString0 ) ) otherlv_6= 'metamodel' ( (otherlv_7= RULE_STRING ) ) (otherlv_8= 'contents' otherlv_9= '{' ( (lv_contents_10_0= ruleModelElement ) ) (otherlv_11= ',' ( (lv_contents_12_0= ruleModelElement ) ) )* otherlv_13= '}' )? otherlv_14= '}' )
            {
            // InternalKM3.g:335:2: (otherlv_0= 'Package' otherlv_1= '{' otherlv_2= 'location' ( (lv_location_3_0= ruleString0 ) ) otherlv_4= 'name' ( (lv_name_5_0= ruleString0 ) ) otherlv_6= 'metamodel' ( (otherlv_7= RULE_STRING ) ) (otherlv_8= 'contents' otherlv_9= '{' ( (lv_contents_10_0= ruleModelElement ) ) (otherlv_11= ',' ( (lv_contents_12_0= ruleModelElement ) ) )* otherlv_13= '}' )? otherlv_14= '}' )
            // InternalKM3.g:336:3: otherlv_0= 'Package' otherlv_1= '{' otherlv_2= 'location' ( (lv_location_3_0= ruleString0 ) ) otherlv_4= 'name' ( (lv_name_5_0= ruleString0 ) ) otherlv_6= 'metamodel' ( (otherlv_7= RULE_STRING ) ) (otherlv_8= 'contents' otherlv_9= '{' ( (lv_contents_10_0= ruleModelElement ) ) (otherlv_11= ',' ( (lv_contents_12_0= ruleModelElement ) ) )* otherlv_13= '}' )? otherlv_14= '}'
            {
            otherlv_0=(Token)match(input,20,FOLLOW_3); 

            			newLeafNode(otherlv_0, grammarAccess.getPackageAccess().getPackageKeyword_0());
            		
            otherlv_1=(Token)match(input,12,FOLLOW_4); 

            			newLeafNode(otherlv_1, grammarAccess.getPackageAccess().getLeftCurlyBracketKeyword_1());
            		
            otherlv_2=(Token)match(input,13,FOLLOW_5); 

            			newLeafNode(otherlv_2, grammarAccess.getPackageAccess().getLocationKeyword_2());
            		
            // InternalKM3.g:348:3: ( (lv_location_3_0= ruleString0 ) )
            // InternalKM3.g:349:4: (lv_location_3_0= ruleString0 )
            {
            // InternalKM3.g:349:4: (lv_location_3_0= ruleString0 )
            // InternalKM3.g:350:5: lv_location_3_0= ruleString0
            {

            					newCompositeNode(grammarAccess.getPackageAccess().getLocationString0ParserRuleCall_3_0());
            				
            pushFollow(FOLLOW_11);
            lv_location_3_0=ruleString0();

            state._fsp--;


            					if (current==null) {
            						current = createModelElementForParent(grammarAccess.getPackageRule());
            					}
            					set(
            						current,
            						"location",
            						lv_location_3_0,
            						"org.eclipse.m2m.km3.xtext.KM3.String0");
            					afterParserOrEnumRuleCall();
            				

            }


            }

            otherlv_4=(Token)match(input,21,FOLLOW_5); 

            			newLeafNode(otherlv_4, grammarAccess.getPackageAccess().getNameKeyword_4());
            		
            // InternalKM3.g:371:3: ( (lv_name_5_0= ruleString0 ) )
            // InternalKM3.g:372:4: (lv_name_5_0= ruleString0 )
            {
            // InternalKM3.g:372:4: (lv_name_5_0= ruleString0 )
            // InternalKM3.g:373:5: lv_name_5_0= ruleString0
            {

            					newCompositeNode(grammarAccess.getPackageAccess().getNameString0ParserRuleCall_5_0());
            				
            pushFollow(FOLLOW_12);
            lv_name_5_0=ruleString0();

            state._fsp--;


            					if (current==null) {
            						current = createModelElementForParent(grammarAccess.getPackageRule());
            					}
            					set(
            						current,
            						"name",
            						lv_name_5_0,
            						"org.eclipse.m2m.km3.xtext.KM3.String0");
            					afterParserOrEnumRuleCall();
            				

            }


            }

            otherlv_6=(Token)match(input,22,FOLLOW_8); 

            			newLeafNode(otherlv_6, grammarAccess.getPackageAccess().getMetamodelKeyword_6());
            		
            // InternalKM3.g:394:3: ( (otherlv_7= RULE_STRING ) )
            // InternalKM3.g:395:4: (otherlv_7= RULE_STRING )
            {
            // InternalKM3.g:395:4: (otherlv_7= RULE_STRING )
            // InternalKM3.g:396:5: otherlv_7= RULE_STRING
            {

            					if (current==null) {
            						current = createModelElement(grammarAccess.getPackageRule());
            					}
            				
            otherlv_7=(Token)match(input,RULE_STRING,FOLLOW_6); 

            					newLeafNode(otherlv_7, grammarAccess.getPackageAccess().getMetamodelMetamodelCrossReference_7_0());
            				

            }


            }

            // InternalKM3.g:407:3: (otherlv_8= 'contents' otherlv_9= '{' ( (lv_contents_10_0= ruleModelElement ) ) (otherlv_11= ',' ( (lv_contents_12_0= ruleModelElement ) ) )* otherlv_13= '}' )?
            int alt5=2;
            int LA5_0 = input.LA(1);

            if ( (LA5_0==14) ) {
                alt5=1;
            }
            switch (alt5) {
                case 1 :
                    // InternalKM3.g:408:4: otherlv_8= 'contents' otherlv_9= '{' ( (lv_contents_10_0= ruleModelElement ) ) (otherlv_11= ',' ( (lv_contents_12_0= ruleModelElement ) ) )* otherlv_13= '}'
                    {
                    otherlv_8=(Token)match(input,14,FOLLOW_3); 

                    				newLeafNode(otherlv_8, grammarAccess.getPackageAccess().getContentsKeyword_8_0());
                    			
                    otherlv_9=(Token)match(input,12,FOLLOW_13); 

                    				newLeafNode(otherlv_9, grammarAccess.getPackageAccess().getLeftCurlyBracketKeyword_8_1());
                    			
                    // InternalKM3.g:416:4: ( (lv_contents_10_0= ruleModelElement ) )
                    // InternalKM3.g:417:5: (lv_contents_10_0= ruleModelElement )
                    {
                    // InternalKM3.g:417:5: (lv_contents_10_0= ruleModelElement )
                    // InternalKM3.g:418:6: lv_contents_10_0= ruleModelElement
                    {

                    						newCompositeNode(grammarAccess.getPackageAccess().getContentsModelElementParserRuleCall_8_2_0());
                    					
                    pushFollow(FOLLOW_14);
                    lv_contents_10_0=ruleModelElement();

                    state._fsp--;


                    						if (current==null) {
                    							current = createModelElementForParent(grammarAccess.getPackageRule());
                    						}
                    						add(
                    							current,
                    							"contents",
                    							lv_contents_10_0,
                    							"org.eclipse.m2m.km3.xtext.KM3.ModelElement");
                    						afterParserOrEnumRuleCall();
                    					

                    }


                    }

                    // InternalKM3.g:435:4: (otherlv_11= ',' ( (lv_contents_12_0= ruleModelElement ) ) )*
                    loop4:
                    do {
                        int alt4=2;
                        int LA4_0 = input.LA(1);

                        if ( (LA4_0==16) ) {
                            alt4=1;
                        }


                        switch (alt4) {
                    	case 1 :
                    	    // InternalKM3.g:436:5: otherlv_11= ',' ( (lv_contents_12_0= ruleModelElement ) )
                    	    {
                    	    otherlv_11=(Token)match(input,16,FOLLOW_13); 

                    	    					newLeafNode(otherlv_11, grammarAccess.getPackageAccess().getCommaKeyword_8_3_0());
                    	    				
                    	    // InternalKM3.g:440:5: ( (lv_contents_12_0= ruleModelElement ) )
                    	    // InternalKM3.g:441:6: (lv_contents_12_0= ruleModelElement )
                    	    {
                    	    // InternalKM3.g:441:6: (lv_contents_12_0= ruleModelElement )
                    	    // InternalKM3.g:442:7: lv_contents_12_0= ruleModelElement
                    	    {

                    	    							newCompositeNode(grammarAccess.getPackageAccess().getContentsModelElementParserRuleCall_8_3_1_0());
                    	    						
                    	    pushFollow(FOLLOW_14);
                    	    lv_contents_12_0=ruleModelElement();

                    	    state._fsp--;


                    	    							if (current==null) {
                    	    								current = createModelElementForParent(grammarAccess.getPackageRule());
                    	    							}
                    	    							add(
                    	    								current,
                    	    								"contents",
                    	    								lv_contents_12_0,
                    	    								"org.eclipse.m2m.km3.xtext.KM3.ModelElement");
                    	    							afterParserOrEnumRuleCall();
                    	    						

                    	    }


                    	    }


                    	    }
                    	    break;

                    	default :
                    	    break loop4;
                        }
                    } while (true);

                    otherlv_13=(Token)match(input,18,FOLLOW_10); 

                    				newLeafNode(otherlv_13, grammarAccess.getPackageAccess().getRightCurlyBracketKeyword_8_4());
                    			

                    }
                    break;

            }

            otherlv_14=(Token)match(input,18,FOLLOW_2); 

            			newLeafNode(otherlv_14, grammarAccess.getPackageAccess().getRightCurlyBracketKeyword_9());
            		

            }


            }


            	leaveRule();

        }

            catch (RecognitionException re) {
                recover(input,re);
                appendSkippedTokens();
            }
        finally {
        }
        return current;
    }
    // $ANTLR end "rulePackage"


    // $ANTLR start "entryRuleClassifier_Impl"
    // InternalKM3.g:473:1: entryRuleClassifier_Impl returns [EObject current=null] : iv_ruleClassifier_Impl= ruleClassifier_Impl EOF ;
    public final EObject entryRuleClassifier_Impl() throws RecognitionException {
        EObject current = null;

        EObject iv_ruleClassifier_Impl = null;


        try {
            // InternalKM3.g:473:56: (iv_ruleClassifier_Impl= ruleClassifier_Impl EOF )
            // InternalKM3.g:474:2: iv_ruleClassifier_Impl= ruleClassifier_Impl EOF
            {
             newCompositeNode(grammarAccess.getClassifier_ImplRule()); 
            pushFollow(FOLLOW_1);
            iv_ruleClassifier_Impl=ruleClassifier_Impl();

            state._fsp--;

             current =iv_ruleClassifier_Impl; 
            match(input,EOF,FOLLOW_2); 

            }

        }

            catch (RecognitionException re) {
                recover(input,re);
                appendSkippedTokens();
            }
        finally {
        }
        return current;
    }
    // $ANTLR end "entryRuleClassifier_Impl"


    // $ANTLR start "ruleClassifier_Impl"
    // InternalKM3.g:480:1: ruleClassifier_Impl returns [EObject current=null] : (otherlv_0= 'Classifier' otherlv_1= '{' otherlv_2= 'location' ( (lv_location_3_0= ruleString0 ) ) otherlv_4= 'name' ( (lv_name_5_0= ruleString0 ) ) otherlv_6= '}' ) ;
    public final EObject ruleClassifier_Impl() throws RecognitionException {
        EObject current = null;

        Token otherlv_0=null;
        Token otherlv_1=null;
        Token otherlv_2=null;
        Token otherlv_4=null;
        Token otherlv_6=null;
        AntlrDatatypeRuleToken lv_location_3_0 = null;

        AntlrDatatypeRuleToken lv_name_5_0 = null;



        	enterRule();

        try {
            // InternalKM3.g:486:2: ( (otherlv_0= 'Classifier' otherlv_1= '{' otherlv_2= 'location' ( (lv_location_3_0= ruleString0 ) ) otherlv_4= 'name' ( (lv_name_5_0= ruleString0 ) ) otherlv_6= '}' ) )
            // InternalKM3.g:487:2: (otherlv_0= 'Classifier' otherlv_1= '{' otherlv_2= 'location' ( (lv_location_3_0= ruleString0 ) ) otherlv_4= 'name' ( (lv_name_5_0= ruleString0 ) ) otherlv_6= '}' )
            {
            // InternalKM3.g:487:2: (otherlv_0= 'Classifier' otherlv_1= '{' otherlv_2= 'location' ( (lv_location_3_0= ruleString0 ) ) otherlv_4= 'name' ( (lv_name_5_0= ruleString0 ) ) otherlv_6= '}' )
            // InternalKM3.g:488:3: otherlv_0= 'Classifier' otherlv_1= '{' otherlv_2= 'location' ( (lv_location_3_0= ruleString0 ) ) otherlv_4= 'name' ( (lv_name_5_0= ruleString0 ) ) otherlv_6= '}'
            {
            otherlv_0=(Token)match(input,23,FOLLOW_3); 

            			newLeafNode(otherlv_0, grammarAccess.getClassifier_ImplAccess().getClassifierKeyword_0());
            		
            otherlv_1=(Token)match(input,12,FOLLOW_4); 

            			newLeafNode(otherlv_1, grammarAccess.getClassifier_ImplAccess().getLeftCurlyBracketKeyword_1());
            		
            otherlv_2=(Token)match(input,13,FOLLOW_5); 

            			newLeafNode(otherlv_2, grammarAccess.getClassifier_ImplAccess().getLocationKeyword_2());
            		
            // InternalKM3.g:500:3: ( (lv_location_3_0= ruleString0 ) )
            // InternalKM3.g:501:4: (lv_location_3_0= ruleString0 )
            {
            // InternalKM3.g:501:4: (lv_location_3_0= ruleString0 )
            // InternalKM3.g:502:5: lv_location_3_0= ruleString0
            {

            					newCompositeNode(grammarAccess.getClassifier_ImplAccess().getLocationString0ParserRuleCall_3_0());
            				
            pushFollow(FOLLOW_11);
            lv_location_3_0=ruleString0();

            state._fsp--;


            					if (current==null) {
            						current = createModelElementForParent(grammarAccess.getClassifier_ImplRule());
            					}
            					set(
            						current,
            						"location",
            						lv_location_3_0,
            						"org.eclipse.m2m.km3.xtext.KM3.String0");
            					afterParserOrEnumRuleCall();
            				

            }


            }

            otherlv_4=(Token)match(input,21,FOLLOW_5); 

            			newLeafNode(otherlv_4, grammarAccess.getClassifier_ImplAccess().getNameKeyword_4());
            		
            // InternalKM3.g:523:3: ( (lv_name_5_0= ruleString0 ) )
            // InternalKM3.g:524:4: (lv_name_5_0= ruleString0 )
            {
            // InternalKM3.g:524:4: (lv_name_5_0= ruleString0 )
            // InternalKM3.g:525:5: lv_name_5_0= ruleString0
            {

            					newCompositeNode(grammarAccess.getClassifier_ImplAccess().getNameString0ParserRuleCall_5_0());
            				
            pushFollow(FOLLOW_10);
            lv_name_5_0=ruleString0();

            state._fsp--;


            					if (current==null) {
            						current = createModelElementForParent(grammarAccess.getClassifier_ImplRule());
            					}
            					set(
            						current,
            						"name",
            						lv_name_5_0,
            						"org.eclipse.m2m.km3.xtext.KM3.String0");
            					afterParserOrEnumRuleCall();
            				

            }


            }

            otherlv_6=(Token)match(input,18,FOLLOW_2); 

            			newLeafNode(otherlv_6, grammarAccess.getClassifier_ImplAccess().getRightCurlyBracketKeyword_6());
            		

            }


            }


            	leaveRule();

        }

            catch (RecognitionException re) {
                recover(input,re);
                appendSkippedTokens();
            }
        finally {
        }
        return current;
    }
    // $ANTLR end "ruleClassifier_Impl"


    // $ANTLR start "entryRuleDataType"
    // InternalKM3.g:550:1: entryRuleDataType returns [EObject current=null] : iv_ruleDataType= ruleDataType EOF ;
    public final EObject entryRuleDataType() throws RecognitionException {
        EObject current = null;

        EObject iv_ruleDataType = null;


        try {
            // InternalKM3.g:550:49: (iv_ruleDataType= ruleDataType EOF )
            // InternalKM3.g:551:2: iv_ruleDataType= ruleDataType EOF
            {
             newCompositeNode(grammarAccess.getDataTypeRule()); 
            pushFollow(FOLLOW_1);
            iv_ruleDataType=ruleDataType();

            state._fsp--;

             current =iv_ruleDataType; 
            match(input,EOF,FOLLOW_2); 

            }

        }

            catch (RecognitionException re) {
                recover(input,re);
                appendSkippedTokens();
            }
        finally {
        }
        return current;
    }
    // $ANTLR end "entryRuleDataType"


    // $ANTLR start "ruleDataType"
    // InternalKM3.g:557:1: ruleDataType returns [EObject current=null] : (otherlv_0= 'DataType' otherlv_1= '{' otherlv_2= 'location' ( (lv_location_3_0= ruleString0 ) ) otherlv_4= 'name' ( (lv_name_5_0= ruleString0 ) ) otherlv_6= '}' ) ;
    public final EObject ruleDataType() throws RecognitionException {
        EObject current = null;

        Token otherlv_0=null;
        Token otherlv_1=null;
        Token otherlv_2=null;
        Token otherlv_4=null;
        Token otherlv_6=null;
        AntlrDatatypeRuleToken lv_location_3_0 = null;

        AntlrDatatypeRuleToken lv_name_5_0 = null;



        	enterRule();

        try {
            // InternalKM3.g:563:2: ( (otherlv_0= 'DataType' otherlv_1= '{' otherlv_2= 'location' ( (lv_location_3_0= ruleString0 ) ) otherlv_4= 'name' ( (lv_name_5_0= ruleString0 ) ) otherlv_6= '}' ) )
            // InternalKM3.g:564:2: (otherlv_0= 'DataType' otherlv_1= '{' otherlv_2= 'location' ( (lv_location_3_0= ruleString0 ) ) otherlv_4= 'name' ( (lv_name_5_0= ruleString0 ) ) otherlv_6= '}' )
            {
            // InternalKM3.g:564:2: (otherlv_0= 'DataType' otherlv_1= '{' otherlv_2= 'location' ( (lv_location_3_0= ruleString0 ) ) otherlv_4= 'name' ( (lv_name_5_0= ruleString0 ) ) otherlv_6= '}' )
            // InternalKM3.g:565:3: otherlv_0= 'DataType' otherlv_1= '{' otherlv_2= 'location' ( (lv_location_3_0= ruleString0 ) ) otherlv_4= 'name' ( (lv_name_5_0= ruleString0 ) ) otherlv_6= '}'
            {
            otherlv_0=(Token)match(input,24,FOLLOW_3); 

            			newLeafNode(otherlv_0, grammarAccess.getDataTypeAccess().getDataTypeKeyword_0());
            		
            otherlv_1=(Token)match(input,12,FOLLOW_4); 

            			newLeafNode(otherlv_1, grammarAccess.getDataTypeAccess().getLeftCurlyBracketKeyword_1());
            		
            otherlv_2=(Token)match(input,13,FOLLOW_5); 

            			newLeafNode(otherlv_2, grammarAccess.getDataTypeAccess().getLocationKeyword_2());
            		
            // InternalKM3.g:577:3: ( (lv_location_3_0= ruleString0 ) )
            // InternalKM3.g:578:4: (lv_location_3_0= ruleString0 )
            {
            // InternalKM3.g:578:4: (lv_location_3_0= ruleString0 )
            // InternalKM3.g:579:5: lv_location_3_0= ruleString0
            {

            					newCompositeNode(grammarAccess.getDataTypeAccess().getLocationString0ParserRuleCall_3_0());
            				
            pushFollow(FOLLOW_11);
            lv_location_3_0=ruleString0();

            state._fsp--;


            					if (current==null) {
            						current = createModelElementForParent(grammarAccess.getDataTypeRule());
            					}
            					set(
            						current,
            						"location",
            						lv_location_3_0,
            						"org.eclipse.m2m.km3.xtext.KM3.String0");
            					afterParserOrEnumRuleCall();
            				

            }


            }

            otherlv_4=(Token)match(input,21,FOLLOW_5); 

            			newLeafNode(otherlv_4, grammarAccess.getDataTypeAccess().getNameKeyword_4());
            		
            // InternalKM3.g:600:3: ( (lv_name_5_0= ruleString0 ) )
            // InternalKM3.g:601:4: (lv_name_5_0= ruleString0 )
            {
            // InternalKM3.g:601:4: (lv_name_5_0= ruleString0 )
            // InternalKM3.g:602:5: lv_name_5_0= ruleString0
            {

            					newCompositeNode(grammarAccess.getDataTypeAccess().getNameString0ParserRuleCall_5_0());
            				
            pushFollow(FOLLOW_10);
            lv_name_5_0=ruleString0();

            state._fsp--;


            					if (current==null) {
            						current = createModelElementForParent(grammarAccess.getDataTypeRule());
            					}
            					set(
            						current,
            						"name",
            						lv_name_5_0,
            						"org.eclipse.m2m.km3.xtext.KM3.String0");
            					afterParserOrEnumRuleCall();
            				

            }


            }

            otherlv_6=(Token)match(input,18,FOLLOW_2); 

            			newLeafNode(otherlv_6, grammarAccess.getDataTypeAccess().getRightCurlyBracketKeyword_6());
            		

            }


            }


            	leaveRule();

        }

            catch (RecognitionException re) {
                recover(input,re);
                appendSkippedTokens();
            }
        finally {
        }
        return current;
    }
    // $ANTLR end "ruleDataType"


    // $ANTLR start "entryRuleEnumeration"
    // InternalKM3.g:627:1: entryRuleEnumeration returns [EObject current=null] : iv_ruleEnumeration= ruleEnumeration EOF ;
    public final EObject entryRuleEnumeration() throws RecognitionException {
        EObject current = null;

        EObject iv_ruleEnumeration = null;


        try {
            // InternalKM3.g:627:52: (iv_ruleEnumeration= ruleEnumeration EOF )
            // InternalKM3.g:628:2: iv_ruleEnumeration= ruleEnumeration EOF
            {
             newCompositeNode(grammarAccess.getEnumerationRule()); 
            pushFollow(FOLLOW_1);
            iv_ruleEnumeration=ruleEnumeration();

            state._fsp--;

             current =iv_ruleEnumeration; 
            match(input,EOF,FOLLOW_2); 

            }

        }

            catch (RecognitionException re) {
                recover(input,re);
                appendSkippedTokens();
            }
        finally {
        }
        return current;
    }
    // $ANTLR end "entryRuleEnumeration"


    // $ANTLR start "ruleEnumeration"
    // InternalKM3.g:634:1: ruleEnumeration returns [EObject current=null] : (otherlv_0= 'Enumeration' otherlv_1= '{' otherlv_2= 'location' ( (lv_location_3_0= ruleString0 ) ) otherlv_4= 'name' ( (lv_name_5_0= ruleString0 ) ) (otherlv_6= 'literals' otherlv_7= '(' ( (otherlv_8= RULE_STRING ) ) (otherlv_9= ',' ( (otherlv_10= RULE_STRING ) ) )* otherlv_11= ')' )? otherlv_12= '}' ) ;
    public final EObject ruleEnumeration() throws RecognitionException {
        EObject current = null;

        Token otherlv_0=null;
        Token otherlv_1=null;
        Token otherlv_2=null;
        Token otherlv_4=null;
        Token otherlv_6=null;
        Token otherlv_7=null;
        Token otherlv_8=null;
        Token otherlv_9=null;
        Token otherlv_10=null;
        Token otherlv_11=null;
        Token otherlv_12=null;
        AntlrDatatypeRuleToken lv_location_3_0 = null;

        AntlrDatatypeRuleToken lv_name_5_0 = null;



        	enterRule();

        try {
            // InternalKM3.g:640:2: ( (otherlv_0= 'Enumeration' otherlv_1= '{' otherlv_2= 'location' ( (lv_location_3_0= ruleString0 ) ) otherlv_4= 'name' ( (lv_name_5_0= ruleString0 ) ) (otherlv_6= 'literals' otherlv_7= '(' ( (otherlv_8= RULE_STRING ) ) (otherlv_9= ',' ( (otherlv_10= RULE_STRING ) ) )* otherlv_11= ')' )? otherlv_12= '}' ) )
            // InternalKM3.g:641:2: (otherlv_0= 'Enumeration' otherlv_1= '{' otherlv_2= 'location' ( (lv_location_3_0= ruleString0 ) ) otherlv_4= 'name' ( (lv_name_5_0= ruleString0 ) ) (otherlv_6= 'literals' otherlv_7= '(' ( (otherlv_8= RULE_STRING ) ) (otherlv_9= ',' ( (otherlv_10= RULE_STRING ) ) )* otherlv_11= ')' )? otherlv_12= '}' )
            {
            // InternalKM3.g:641:2: (otherlv_0= 'Enumeration' otherlv_1= '{' otherlv_2= 'location' ( (lv_location_3_0= ruleString0 ) ) otherlv_4= 'name' ( (lv_name_5_0= ruleString0 ) ) (otherlv_6= 'literals' otherlv_7= '(' ( (otherlv_8= RULE_STRING ) ) (otherlv_9= ',' ( (otherlv_10= RULE_STRING ) ) )* otherlv_11= ')' )? otherlv_12= '}' )
            // InternalKM3.g:642:3: otherlv_0= 'Enumeration' otherlv_1= '{' otherlv_2= 'location' ( (lv_location_3_0= ruleString0 ) ) otherlv_4= 'name' ( (lv_name_5_0= ruleString0 ) ) (otherlv_6= 'literals' otherlv_7= '(' ( (otherlv_8= RULE_STRING ) ) (otherlv_9= ',' ( (otherlv_10= RULE_STRING ) ) )* otherlv_11= ')' )? otherlv_12= '}'
            {
            otherlv_0=(Token)match(input,25,FOLLOW_3); 

            			newLeafNode(otherlv_0, grammarAccess.getEnumerationAccess().getEnumerationKeyword_0());
            		
            otherlv_1=(Token)match(input,12,FOLLOW_4); 

            			newLeafNode(otherlv_1, grammarAccess.getEnumerationAccess().getLeftCurlyBracketKeyword_1());
            		
            otherlv_2=(Token)match(input,13,FOLLOW_5); 

            			newLeafNode(otherlv_2, grammarAccess.getEnumerationAccess().getLocationKeyword_2());
            		
            // InternalKM3.g:654:3: ( (lv_location_3_0= ruleString0 ) )
            // InternalKM3.g:655:4: (lv_location_3_0= ruleString0 )
            {
            // InternalKM3.g:655:4: (lv_location_3_0= ruleString0 )
            // InternalKM3.g:656:5: lv_location_3_0= ruleString0
            {

            					newCompositeNode(grammarAccess.getEnumerationAccess().getLocationString0ParserRuleCall_3_0());
            				
            pushFollow(FOLLOW_11);
            lv_location_3_0=ruleString0();

            state._fsp--;


            					if (current==null) {
            						current = createModelElementForParent(grammarAccess.getEnumerationRule());
            					}
            					set(
            						current,
            						"location",
            						lv_location_3_0,
            						"org.eclipse.m2m.km3.xtext.KM3.String0");
            					afterParserOrEnumRuleCall();
            				

            }


            }

            otherlv_4=(Token)match(input,21,FOLLOW_5); 

            			newLeafNode(otherlv_4, grammarAccess.getEnumerationAccess().getNameKeyword_4());
            		
            // InternalKM3.g:677:3: ( (lv_name_5_0= ruleString0 ) )
            // InternalKM3.g:678:4: (lv_name_5_0= ruleString0 )
            {
            // InternalKM3.g:678:4: (lv_name_5_0= ruleString0 )
            // InternalKM3.g:679:5: lv_name_5_0= ruleString0
            {

            					newCompositeNode(grammarAccess.getEnumerationAccess().getNameString0ParserRuleCall_5_0());
            				
            pushFollow(FOLLOW_15);
            lv_name_5_0=ruleString0();

            state._fsp--;


            					if (current==null) {
            						current = createModelElementForParent(grammarAccess.getEnumerationRule());
            					}
            					set(
            						current,
            						"name",
            						lv_name_5_0,
            						"org.eclipse.m2m.km3.xtext.KM3.String0");
            					afterParserOrEnumRuleCall();
            				

            }


            }

            // InternalKM3.g:696:3: (otherlv_6= 'literals' otherlv_7= '(' ( (otherlv_8= RULE_STRING ) ) (otherlv_9= ',' ( (otherlv_10= RULE_STRING ) ) )* otherlv_11= ')' )?
            int alt7=2;
            int LA7_0 = input.LA(1);

            if ( (LA7_0==26) ) {
                alt7=1;
            }
            switch (alt7) {
                case 1 :
                    // InternalKM3.g:697:4: otherlv_6= 'literals' otherlv_7= '(' ( (otherlv_8= RULE_STRING ) ) (otherlv_9= ',' ( (otherlv_10= RULE_STRING ) ) )* otherlv_11= ')'
                    {
                    otherlv_6=(Token)match(input,26,FOLLOW_7); 

                    				newLeafNode(otherlv_6, grammarAccess.getEnumerationAccess().getLiteralsKeyword_6_0());
                    			
                    otherlv_7=(Token)match(input,15,FOLLOW_8); 

                    				newLeafNode(otherlv_7, grammarAccess.getEnumerationAccess().getLeftParenthesisKeyword_6_1());
                    			
                    // InternalKM3.g:705:4: ( (otherlv_8= RULE_STRING ) )
                    // InternalKM3.g:706:5: (otherlv_8= RULE_STRING )
                    {
                    // InternalKM3.g:706:5: (otherlv_8= RULE_STRING )
                    // InternalKM3.g:707:6: otherlv_8= RULE_STRING
                    {

                    						if (current==null) {
                    							current = createModelElement(grammarAccess.getEnumerationRule());
                    						}
                    					
                    otherlv_8=(Token)match(input,RULE_STRING,FOLLOW_9); 

                    						newLeafNode(otherlv_8, grammarAccess.getEnumerationAccess().getLiteralsEnumLiteralCrossReference_6_2_0());
                    					

                    }


                    }

                    // InternalKM3.g:718:4: (otherlv_9= ',' ( (otherlv_10= RULE_STRING ) ) )*
                    loop6:
                    do {
                        int alt6=2;
                        int LA6_0 = input.LA(1);

                        if ( (LA6_0==16) ) {
                            alt6=1;
                        }


                        switch (alt6) {
                    	case 1 :
                    	    // InternalKM3.g:719:5: otherlv_9= ',' ( (otherlv_10= RULE_STRING ) )
                    	    {
                    	    otherlv_9=(Token)match(input,16,FOLLOW_8); 

                    	    					newLeafNode(otherlv_9, grammarAccess.getEnumerationAccess().getCommaKeyword_6_3_0());
                    	    				
                    	    // InternalKM3.g:723:5: ( (otherlv_10= RULE_STRING ) )
                    	    // InternalKM3.g:724:6: (otherlv_10= RULE_STRING )
                    	    {
                    	    // InternalKM3.g:724:6: (otherlv_10= RULE_STRING )
                    	    // InternalKM3.g:725:7: otherlv_10= RULE_STRING
                    	    {

                    	    							if (current==null) {
                    	    								current = createModelElement(grammarAccess.getEnumerationRule());
                    	    							}
                    	    						
                    	    otherlv_10=(Token)match(input,RULE_STRING,FOLLOW_9); 

                    	    							newLeafNode(otherlv_10, grammarAccess.getEnumerationAccess().getLiteralsEnumLiteralCrossReference_6_3_1_0());
                    	    						

                    	    }


                    	    }


                    	    }
                    	    break;

                    	default :
                    	    break loop6;
                        }
                    } while (true);

                    otherlv_11=(Token)match(input,17,FOLLOW_10); 

                    				newLeafNode(otherlv_11, grammarAccess.getEnumerationAccess().getRightParenthesisKeyword_6_4());
                    			

                    }
                    break;

            }

            otherlv_12=(Token)match(input,18,FOLLOW_2); 

            			newLeafNode(otherlv_12, grammarAccess.getEnumerationAccess().getRightCurlyBracketKeyword_7());
            		

            }


            }


            	leaveRule();

        }

            catch (RecognitionException re) {
                recover(input,re);
                appendSkippedTokens();
            }
        finally {
        }
        return current;
    }
    // $ANTLR end "ruleEnumeration"


    // $ANTLR start "entryRuleEnumLiteral"
    // InternalKM3.g:750:1: entryRuleEnumLiteral returns [EObject current=null] : iv_ruleEnumLiteral= ruleEnumLiteral EOF ;
    public final EObject entryRuleEnumLiteral() throws RecognitionException {
        EObject current = null;

        EObject iv_ruleEnumLiteral = null;


        try {
            // InternalKM3.g:750:52: (iv_ruleEnumLiteral= ruleEnumLiteral EOF )
            // InternalKM3.g:751:2: iv_ruleEnumLiteral= ruleEnumLiteral EOF
            {
             newCompositeNode(grammarAccess.getEnumLiteralRule()); 
            pushFollow(FOLLOW_1);
            iv_ruleEnumLiteral=ruleEnumLiteral();

            state._fsp--;

             current =iv_ruleEnumLiteral; 
            match(input,EOF,FOLLOW_2); 

            }

        }

            catch (RecognitionException re) {
                recover(input,re);
                appendSkippedTokens();
            }
        finally {
        }
        return current;
    }
    // $ANTLR end "entryRuleEnumLiteral"


    // $ANTLR start "ruleEnumLiteral"
    // InternalKM3.g:757:1: ruleEnumLiteral returns [EObject current=null] : (otherlv_0= 'EnumLiteral' otherlv_1= '{' otherlv_2= 'location' ( (lv_location_3_0= ruleString0 ) ) otherlv_4= 'name' ( (lv_name_5_0= ruleString0 ) ) otherlv_6= 'enum' ( (otherlv_7= RULE_STRING ) ) otherlv_8= '}' ) ;
    public final EObject ruleEnumLiteral() throws RecognitionException {
        EObject current = null;

        Token otherlv_0=null;
        Token otherlv_1=null;
        Token otherlv_2=null;
        Token otherlv_4=null;
        Token otherlv_6=null;
        Token otherlv_7=null;
        Token otherlv_8=null;
        AntlrDatatypeRuleToken lv_location_3_0 = null;

        AntlrDatatypeRuleToken lv_name_5_0 = null;



        	enterRule();

        try {
            // InternalKM3.g:763:2: ( (otherlv_0= 'EnumLiteral' otherlv_1= '{' otherlv_2= 'location' ( (lv_location_3_0= ruleString0 ) ) otherlv_4= 'name' ( (lv_name_5_0= ruleString0 ) ) otherlv_6= 'enum' ( (otherlv_7= RULE_STRING ) ) otherlv_8= '}' ) )
            // InternalKM3.g:764:2: (otherlv_0= 'EnumLiteral' otherlv_1= '{' otherlv_2= 'location' ( (lv_location_3_0= ruleString0 ) ) otherlv_4= 'name' ( (lv_name_5_0= ruleString0 ) ) otherlv_6= 'enum' ( (otherlv_7= RULE_STRING ) ) otherlv_8= '}' )
            {
            // InternalKM3.g:764:2: (otherlv_0= 'EnumLiteral' otherlv_1= '{' otherlv_2= 'location' ( (lv_location_3_0= ruleString0 ) ) otherlv_4= 'name' ( (lv_name_5_0= ruleString0 ) ) otherlv_6= 'enum' ( (otherlv_7= RULE_STRING ) ) otherlv_8= '}' )
            // InternalKM3.g:765:3: otherlv_0= 'EnumLiteral' otherlv_1= '{' otherlv_2= 'location' ( (lv_location_3_0= ruleString0 ) ) otherlv_4= 'name' ( (lv_name_5_0= ruleString0 ) ) otherlv_6= 'enum' ( (otherlv_7= RULE_STRING ) ) otherlv_8= '}'
            {
            otherlv_0=(Token)match(input,27,FOLLOW_3); 

            			newLeafNode(otherlv_0, grammarAccess.getEnumLiteralAccess().getEnumLiteralKeyword_0());
            		
            otherlv_1=(Token)match(input,12,FOLLOW_4); 

            			newLeafNode(otherlv_1, grammarAccess.getEnumLiteralAccess().getLeftCurlyBracketKeyword_1());
            		
            otherlv_2=(Token)match(input,13,FOLLOW_5); 

            			newLeafNode(otherlv_2, grammarAccess.getEnumLiteralAccess().getLocationKeyword_2());
            		
            // InternalKM3.g:777:3: ( (lv_location_3_0= ruleString0 ) )
            // InternalKM3.g:778:4: (lv_location_3_0= ruleString0 )
            {
            // InternalKM3.g:778:4: (lv_location_3_0= ruleString0 )
            // InternalKM3.g:779:5: lv_location_3_0= ruleString0
            {

            					newCompositeNode(grammarAccess.getEnumLiteralAccess().getLocationString0ParserRuleCall_3_0());
            				
            pushFollow(FOLLOW_11);
            lv_location_3_0=ruleString0();

            state._fsp--;


            					if (current==null) {
            						current = createModelElementForParent(grammarAccess.getEnumLiteralRule());
            					}
            					set(
            						current,
            						"location",
            						lv_location_3_0,
            						"org.eclipse.m2m.km3.xtext.KM3.String0");
            					afterParserOrEnumRuleCall();
            				

            }


            }

            otherlv_4=(Token)match(input,21,FOLLOW_5); 

            			newLeafNode(otherlv_4, grammarAccess.getEnumLiteralAccess().getNameKeyword_4());
            		
            // InternalKM3.g:800:3: ( (lv_name_5_0= ruleString0 ) )
            // InternalKM3.g:801:4: (lv_name_5_0= ruleString0 )
            {
            // InternalKM3.g:801:4: (lv_name_5_0= ruleString0 )
            // InternalKM3.g:802:5: lv_name_5_0= ruleString0
            {

            					newCompositeNode(grammarAccess.getEnumLiteralAccess().getNameString0ParserRuleCall_5_0());
            				
            pushFollow(FOLLOW_16);
            lv_name_5_0=ruleString0();

            state._fsp--;


            					if (current==null) {
            						current = createModelElementForParent(grammarAccess.getEnumLiteralRule());
            					}
            					set(
            						current,
            						"name",
            						lv_name_5_0,
            						"org.eclipse.m2m.km3.xtext.KM3.String0");
            					afterParserOrEnumRuleCall();
            				

            }


            }

            otherlv_6=(Token)match(input,28,FOLLOW_8); 

            			newLeafNode(otherlv_6, grammarAccess.getEnumLiteralAccess().getEnumKeyword_6());
            		
            // InternalKM3.g:823:3: ( (otherlv_7= RULE_STRING ) )
            // InternalKM3.g:824:4: (otherlv_7= RULE_STRING )
            {
            // InternalKM3.g:824:4: (otherlv_7= RULE_STRING )
            // InternalKM3.g:825:5: otherlv_7= RULE_STRING
            {

            					if (current==null) {
            						current = createModelElement(grammarAccess.getEnumLiteralRule());
            					}
            				
            otherlv_7=(Token)match(input,RULE_STRING,FOLLOW_10); 

            					newLeafNode(otherlv_7, grammarAccess.getEnumLiteralAccess().getEnumEnumerationCrossReference_7_0());
            				

            }


            }

            otherlv_8=(Token)match(input,18,FOLLOW_2); 

            			newLeafNode(otherlv_8, grammarAccess.getEnumLiteralAccess().getRightCurlyBracketKeyword_8());
            		

            }


            }


            	leaveRule();

        }

            catch (RecognitionException re) {
                recover(input,re);
                appendSkippedTokens();
            }
        finally {
        }
        return current;
    }
    // $ANTLR end "ruleEnumLiteral"


    // $ANTLR start "entryRuleTemplateParameter"
    // InternalKM3.g:844:1: entryRuleTemplateParameter returns [EObject current=null] : iv_ruleTemplateParameter= ruleTemplateParameter EOF ;
    public final EObject entryRuleTemplateParameter() throws RecognitionException {
        EObject current = null;

        EObject iv_ruleTemplateParameter = null;


        try {
            // InternalKM3.g:844:58: (iv_ruleTemplateParameter= ruleTemplateParameter EOF )
            // InternalKM3.g:845:2: iv_ruleTemplateParameter= ruleTemplateParameter EOF
            {
             newCompositeNode(grammarAccess.getTemplateParameterRule()); 
            pushFollow(FOLLOW_1);
            iv_ruleTemplateParameter=ruleTemplateParameter();

            state._fsp--;

             current =iv_ruleTemplateParameter; 
            match(input,EOF,FOLLOW_2); 

            }

        }

            catch (RecognitionException re) {
                recover(input,re);
                appendSkippedTokens();
            }
        finally {
        }
        return current;
    }
    // $ANTLR end "entryRuleTemplateParameter"


    // $ANTLR start "ruleTemplateParameter"
    // InternalKM3.g:851:1: ruleTemplateParameter returns [EObject current=null] : (otherlv_0= 'TemplateParameter' otherlv_1= '{' otherlv_2= 'location' ( (lv_location_3_0= ruleString0 ) ) otherlv_4= 'name' ( (lv_name_5_0= ruleString0 ) ) otherlv_6= '}' ) ;
    public final EObject ruleTemplateParameter() throws RecognitionException {
        EObject current = null;

        Token otherlv_0=null;
        Token otherlv_1=null;
        Token otherlv_2=null;
        Token otherlv_4=null;
        Token otherlv_6=null;
        AntlrDatatypeRuleToken lv_location_3_0 = null;

        AntlrDatatypeRuleToken lv_name_5_0 = null;



        	enterRule();

        try {
            // InternalKM3.g:857:2: ( (otherlv_0= 'TemplateParameter' otherlv_1= '{' otherlv_2= 'location' ( (lv_location_3_0= ruleString0 ) ) otherlv_4= 'name' ( (lv_name_5_0= ruleString0 ) ) otherlv_6= '}' ) )
            // InternalKM3.g:858:2: (otherlv_0= 'TemplateParameter' otherlv_1= '{' otherlv_2= 'location' ( (lv_location_3_0= ruleString0 ) ) otherlv_4= 'name' ( (lv_name_5_0= ruleString0 ) ) otherlv_6= '}' )
            {
            // InternalKM3.g:858:2: (otherlv_0= 'TemplateParameter' otherlv_1= '{' otherlv_2= 'location' ( (lv_location_3_0= ruleString0 ) ) otherlv_4= 'name' ( (lv_name_5_0= ruleString0 ) ) otherlv_6= '}' )
            // InternalKM3.g:859:3: otherlv_0= 'TemplateParameter' otherlv_1= '{' otherlv_2= 'location' ( (lv_location_3_0= ruleString0 ) ) otherlv_4= 'name' ( (lv_name_5_0= ruleString0 ) ) otherlv_6= '}'
            {
            otherlv_0=(Token)match(input,29,FOLLOW_3); 

            			newLeafNode(otherlv_0, grammarAccess.getTemplateParameterAccess().getTemplateParameterKeyword_0());
            		
            otherlv_1=(Token)match(input,12,FOLLOW_4); 

            			newLeafNode(otherlv_1, grammarAccess.getTemplateParameterAccess().getLeftCurlyBracketKeyword_1());
            		
            otherlv_2=(Token)match(input,13,FOLLOW_5); 

            			newLeafNode(otherlv_2, grammarAccess.getTemplateParameterAccess().getLocationKeyword_2());
            		
            // InternalKM3.g:871:3: ( (lv_location_3_0= ruleString0 ) )
            // InternalKM3.g:872:4: (lv_location_3_0= ruleString0 )
            {
            // InternalKM3.g:872:4: (lv_location_3_0= ruleString0 )
            // InternalKM3.g:873:5: lv_location_3_0= ruleString0
            {

            					newCompositeNode(grammarAccess.getTemplateParameterAccess().getLocationString0ParserRuleCall_3_0());
            				
            pushFollow(FOLLOW_11);
            lv_location_3_0=ruleString0();

            state._fsp--;


            					if (current==null) {
            						current = createModelElementForParent(grammarAccess.getTemplateParameterRule());
            					}
            					set(
            						current,
            						"location",
            						lv_location_3_0,
            						"org.eclipse.m2m.km3.xtext.KM3.String0");
            					afterParserOrEnumRuleCall();
            				

            }


            }

            otherlv_4=(Token)match(input,21,FOLLOW_5); 

            			newLeafNode(otherlv_4, grammarAccess.getTemplateParameterAccess().getNameKeyword_4());
            		
            // InternalKM3.g:894:3: ( (lv_name_5_0= ruleString0 ) )
            // InternalKM3.g:895:4: (lv_name_5_0= ruleString0 )
            {
            // InternalKM3.g:895:4: (lv_name_5_0= ruleString0 )
            // InternalKM3.g:896:5: lv_name_5_0= ruleString0
            {

            					newCompositeNode(grammarAccess.getTemplateParameterAccess().getNameString0ParserRuleCall_5_0());
            				
            pushFollow(FOLLOW_10);
            lv_name_5_0=ruleString0();

            state._fsp--;


            					if (current==null) {
            						current = createModelElementForParent(grammarAccess.getTemplateParameterRule());
            					}
            					set(
            						current,
            						"name",
            						lv_name_5_0,
            						"org.eclipse.m2m.km3.xtext.KM3.String0");
            					afterParserOrEnumRuleCall();
            				

            }


            }

            otherlv_6=(Token)match(input,18,FOLLOW_2); 

            			newLeafNode(otherlv_6, grammarAccess.getTemplateParameterAccess().getRightCurlyBracketKeyword_6());
            		

            }


            }


            	leaveRule();

        }

            catch (RecognitionException re) {
                recover(input,re);
                appendSkippedTokens();
            }
        finally {
        }
        return current;
    }
    // $ANTLR end "ruleTemplateParameter"


    // $ANTLR start "entryRuleClass"
    // InternalKM3.g:921:1: entryRuleClass returns [EObject current=null] : iv_ruleClass= ruleClass EOF ;
    public final EObject entryRuleClass() throws RecognitionException {
        EObject current = null;

        EObject iv_ruleClass = null;


        try {
            // InternalKM3.g:921:46: (iv_ruleClass= ruleClass EOF )
            // InternalKM3.g:922:2: iv_ruleClass= ruleClass EOF
            {
             newCompositeNode(grammarAccess.getClassRule()); 
            pushFollow(FOLLOW_1);
            iv_ruleClass=ruleClass();

            state._fsp--;

             current =iv_ruleClass; 
            match(input,EOF,FOLLOW_2); 

            }

        }

            catch (RecognitionException re) {
                recover(input,re);
                appendSkippedTokens();
            }
        finally {
        }
        return current;
    }
    // $ANTLR end "entryRuleClass"


    // $ANTLR start "ruleClass"
    // InternalKM3.g:928:1: ruleClass returns [EObject current=null] : (otherlv_0= 'Class' otherlv_1= '{' otherlv_2= 'location' ( (lv_location_3_0= ruleString0 ) ) otherlv_4= 'name' ( (lv_name_5_0= ruleString0 ) ) otherlv_6= 'isAbstract' ( (lv_isAbstract_7_0= ruleBoolean ) ) (otherlv_8= 'parameters' otherlv_9= '(' ( (otherlv_10= RULE_STRING ) ) (otherlv_11= ',' ( (otherlv_12= RULE_STRING ) ) )* otherlv_13= ')' )? (otherlv_14= 'supertypes' otherlv_15= '(' ( (otherlv_16= RULE_STRING ) ) (otherlv_17= ',' ( (otherlv_18= RULE_STRING ) ) )* otherlv_19= ')' )? (otherlv_20= 'structuralFeatures' otherlv_21= '(' ( (otherlv_22= RULE_STRING ) ) (otherlv_23= ',' ( (otherlv_24= RULE_STRING ) ) )* otherlv_25= ')' )? (otherlv_26= 'operations' otherlv_27= '(' ( (otherlv_28= RULE_STRING ) ) (otherlv_29= ',' ( (otherlv_30= RULE_STRING ) ) )* otherlv_31= ')' )? otherlv_32= '}' ) ;
    public final EObject ruleClass() throws RecognitionException {
        EObject current = null;

        Token otherlv_0=null;
        Token otherlv_1=null;
        Token otherlv_2=null;
        Token otherlv_4=null;
        Token otherlv_6=null;
        Token otherlv_8=null;
        Token otherlv_9=null;
        Token otherlv_10=null;
        Token otherlv_11=null;
        Token otherlv_12=null;
        Token otherlv_13=null;
        Token otherlv_14=null;
        Token otherlv_15=null;
        Token otherlv_16=null;
        Token otherlv_17=null;
        Token otherlv_18=null;
        Token otherlv_19=null;
        Token otherlv_20=null;
        Token otherlv_21=null;
        Token otherlv_22=null;
        Token otherlv_23=null;
        Token otherlv_24=null;
        Token otherlv_25=null;
        Token otherlv_26=null;
        Token otherlv_27=null;
        Token otherlv_28=null;
        Token otherlv_29=null;
        Token otherlv_30=null;
        Token otherlv_31=null;
        Token otherlv_32=null;
        AntlrDatatypeRuleToken lv_location_3_0 = null;

        AntlrDatatypeRuleToken lv_name_5_0 = null;

        AntlrDatatypeRuleToken lv_isAbstract_7_0 = null;



        	enterRule();

        try {
            // InternalKM3.g:934:2: ( (otherlv_0= 'Class' otherlv_1= '{' otherlv_2= 'location' ( (lv_location_3_0= ruleString0 ) ) otherlv_4= 'name' ( (lv_name_5_0= ruleString0 ) ) otherlv_6= 'isAbstract' ( (lv_isAbstract_7_0= ruleBoolean ) ) (otherlv_8= 'parameters' otherlv_9= '(' ( (otherlv_10= RULE_STRING ) ) (otherlv_11= ',' ( (otherlv_12= RULE_STRING ) ) )* otherlv_13= ')' )? (otherlv_14= 'supertypes' otherlv_15= '(' ( (otherlv_16= RULE_STRING ) ) (otherlv_17= ',' ( (otherlv_18= RULE_STRING ) ) )* otherlv_19= ')' )? (otherlv_20= 'structuralFeatures' otherlv_21= '(' ( (otherlv_22= RULE_STRING ) ) (otherlv_23= ',' ( (otherlv_24= RULE_STRING ) ) )* otherlv_25= ')' )? (otherlv_26= 'operations' otherlv_27= '(' ( (otherlv_28= RULE_STRING ) ) (otherlv_29= ',' ( (otherlv_30= RULE_STRING ) ) )* otherlv_31= ')' )? otherlv_32= '}' ) )
            // InternalKM3.g:935:2: (otherlv_0= 'Class' otherlv_1= '{' otherlv_2= 'location' ( (lv_location_3_0= ruleString0 ) ) otherlv_4= 'name' ( (lv_name_5_0= ruleString0 ) ) otherlv_6= 'isAbstract' ( (lv_isAbstract_7_0= ruleBoolean ) ) (otherlv_8= 'parameters' otherlv_9= '(' ( (otherlv_10= RULE_STRING ) ) (otherlv_11= ',' ( (otherlv_12= RULE_STRING ) ) )* otherlv_13= ')' )? (otherlv_14= 'supertypes' otherlv_15= '(' ( (otherlv_16= RULE_STRING ) ) (otherlv_17= ',' ( (otherlv_18= RULE_STRING ) ) )* otherlv_19= ')' )? (otherlv_20= 'structuralFeatures' otherlv_21= '(' ( (otherlv_22= RULE_STRING ) ) (otherlv_23= ',' ( (otherlv_24= RULE_STRING ) ) )* otherlv_25= ')' )? (otherlv_26= 'operations' otherlv_27= '(' ( (otherlv_28= RULE_STRING ) ) (otherlv_29= ',' ( (otherlv_30= RULE_STRING ) ) )* otherlv_31= ')' )? otherlv_32= '}' )
            {
            // InternalKM3.g:935:2: (otherlv_0= 'Class' otherlv_1= '{' otherlv_2= 'location' ( (lv_location_3_0= ruleString0 ) ) otherlv_4= 'name' ( (lv_name_5_0= ruleString0 ) ) otherlv_6= 'isAbstract' ( (lv_isAbstract_7_0= ruleBoolean ) ) (otherlv_8= 'parameters' otherlv_9= '(' ( (otherlv_10= RULE_STRING ) ) (otherlv_11= ',' ( (otherlv_12= RULE_STRING ) ) )* otherlv_13= ')' )? (otherlv_14= 'supertypes' otherlv_15= '(' ( (otherlv_16= RULE_STRING ) ) (otherlv_17= ',' ( (otherlv_18= RULE_STRING ) ) )* otherlv_19= ')' )? (otherlv_20= 'structuralFeatures' otherlv_21= '(' ( (otherlv_22= RULE_STRING ) ) (otherlv_23= ',' ( (otherlv_24= RULE_STRING ) ) )* otherlv_25= ')' )? (otherlv_26= 'operations' otherlv_27= '(' ( (otherlv_28= RULE_STRING ) ) (otherlv_29= ',' ( (otherlv_30= RULE_STRING ) ) )* otherlv_31= ')' )? otherlv_32= '}' )
            // InternalKM3.g:936:3: otherlv_0= 'Class' otherlv_1= '{' otherlv_2= 'location' ( (lv_location_3_0= ruleString0 ) ) otherlv_4= 'name' ( (lv_name_5_0= ruleString0 ) ) otherlv_6= 'isAbstract' ( (lv_isAbstract_7_0= ruleBoolean ) ) (otherlv_8= 'parameters' otherlv_9= '(' ( (otherlv_10= RULE_STRING ) ) (otherlv_11= ',' ( (otherlv_12= RULE_STRING ) ) )* otherlv_13= ')' )? (otherlv_14= 'supertypes' otherlv_15= '(' ( (otherlv_16= RULE_STRING ) ) (otherlv_17= ',' ( (otherlv_18= RULE_STRING ) ) )* otherlv_19= ')' )? (otherlv_20= 'structuralFeatures' otherlv_21= '(' ( (otherlv_22= RULE_STRING ) ) (otherlv_23= ',' ( (otherlv_24= RULE_STRING ) ) )* otherlv_25= ')' )? (otherlv_26= 'operations' otherlv_27= '(' ( (otherlv_28= RULE_STRING ) ) (otherlv_29= ',' ( (otherlv_30= RULE_STRING ) ) )* otherlv_31= ')' )? otherlv_32= '}'
            {
            otherlv_0=(Token)match(input,30,FOLLOW_3); 

            			newLeafNode(otherlv_0, grammarAccess.getClassAccess().getClassKeyword_0());
            		
            otherlv_1=(Token)match(input,12,FOLLOW_4); 

            			newLeafNode(otherlv_1, grammarAccess.getClassAccess().getLeftCurlyBracketKeyword_1());
            		
            otherlv_2=(Token)match(input,13,FOLLOW_5); 

            			newLeafNode(otherlv_2, grammarAccess.getClassAccess().getLocationKeyword_2());
            		
            // InternalKM3.g:948:3: ( (lv_location_3_0= ruleString0 ) )
            // InternalKM3.g:949:4: (lv_location_3_0= ruleString0 )
            {
            // InternalKM3.g:949:4: (lv_location_3_0= ruleString0 )
            // InternalKM3.g:950:5: lv_location_3_0= ruleString0
            {

            					newCompositeNode(grammarAccess.getClassAccess().getLocationString0ParserRuleCall_3_0());
            				
            pushFollow(FOLLOW_11);
            lv_location_3_0=ruleString0();

            state._fsp--;


            					if (current==null) {
            						current = createModelElementForParent(grammarAccess.getClassRule());
            					}
            					set(
            						current,
            						"location",
            						lv_location_3_0,
            						"org.eclipse.m2m.km3.xtext.KM3.String0");
            					afterParserOrEnumRuleCall();
            				

            }


            }

            otherlv_4=(Token)match(input,21,FOLLOW_5); 

            			newLeafNode(otherlv_4, grammarAccess.getClassAccess().getNameKeyword_4());
            		
            // InternalKM3.g:971:3: ( (lv_name_5_0= ruleString0 ) )
            // InternalKM3.g:972:4: (lv_name_5_0= ruleString0 )
            {
            // InternalKM3.g:972:4: (lv_name_5_0= ruleString0 )
            // InternalKM3.g:973:5: lv_name_5_0= ruleString0
            {

            					newCompositeNode(grammarAccess.getClassAccess().getNameString0ParserRuleCall_5_0());
            				
            pushFollow(FOLLOW_17);
            lv_name_5_0=ruleString0();

            state._fsp--;


            					if (current==null) {
            						current = createModelElementForParent(grammarAccess.getClassRule());
            					}
            					set(
            						current,
            						"name",
            						lv_name_5_0,
            						"org.eclipse.m2m.km3.xtext.KM3.String0");
            					afterParserOrEnumRuleCall();
            				

            }


            }

            otherlv_6=(Token)match(input,31,FOLLOW_18); 

            			newLeafNode(otherlv_6, grammarAccess.getClassAccess().getIsAbstractKeyword_6());
            		
            // InternalKM3.g:994:3: ( (lv_isAbstract_7_0= ruleBoolean ) )
            // InternalKM3.g:995:4: (lv_isAbstract_7_0= ruleBoolean )
            {
            // InternalKM3.g:995:4: (lv_isAbstract_7_0= ruleBoolean )
            // InternalKM3.g:996:5: lv_isAbstract_7_0= ruleBoolean
            {

            					newCompositeNode(grammarAccess.getClassAccess().getIsAbstractBooleanParserRuleCall_7_0());
            				
            pushFollow(FOLLOW_19);
            lv_isAbstract_7_0=ruleBoolean();

            state._fsp--;


            					if (current==null) {
            						current = createModelElementForParent(grammarAccess.getClassRule());
            					}
            					set(
            						current,
            						"isAbstract",
            						lv_isAbstract_7_0,
            						"org.eclipse.m2m.km3.xtext.KM3.Boolean");
            					afterParserOrEnumRuleCall();
            				

            }


            }

            // InternalKM3.g:1013:3: (otherlv_8= 'parameters' otherlv_9= '(' ( (otherlv_10= RULE_STRING ) ) (otherlv_11= ',' ( (otherlv_12= RULE_STRING ) ) )* otherlv_13= ')' )?
            int alt9=2;
            int LA9_0 = input.LA(1);

            if ( (LA9_0==32) ) {
                alt9=1;
            }
            switch (alt9) {
                case 1 :
                    // InternalKM3.g:1014:4: otherlv_8= 'parameters' otherlv_9= '(' ( (otherlv_10= RULE_STRING ) ) (otherlv_11= ',' ( (otherlv_12= RULE_STRING ) ) )* otherlv_13= ')'
                    {
                    otherlv_8=(Token)match(input,32,FOLLOW_7); 

                    				newLeafNode(otherlv_8, grammarAccess.getClassAccess().getParametersKeyword_8_0());
                    			
                    otherlv_9=(Token)match(input,15,FOLLOW_8); 

                    				newLeafNode(otherlv_9, grammarAccess.getClassAccess().getLeftParenthesisKeyword_8_1());
                    			
                    // InternalKM3.g:1022:4: ( (otherlv_10= RULE_STRING ) )
                    // InternalKM3.g:1023:5: (otherlv_10= RULE_STRING )
                    {
                    // InternalKM3.g:1023:5: (otherlv_10= RULE_STRING )
                    // InternalKM3.g:1024:6: otherlv_10= RULE_STRING
                    {

                    						if (current==null) {
                    							current = createModelElement(grammarAccess.getClassRule());
                    						}
                    					
                    otherlv_10=(Token)match(input,RULE_STRING,FOLLOW_9); 

                    						newLeafNode(otherlv_10, grammarAccess.getClassAccess().getParametersTemplateParameterCrossReference_8_2_0());
                    					

                    }


                    }

                    // InternalKM3.g:1035:4: (otherlv_11= ',' ( (otherlv_12= RULE_STRING ) ) )*
                    loop8:
                    do {
                        int alt8=2;
                        int LA8_0 = input.LA(1);

                        if ( (LA8_0==16) ) {
                            alt8=1;
                        }


                        switch (alt8) {
                    	case 1 :
                    	    // InternalKM3.g:1036:5: otherlv_11= ',' ( (otherlv_12= RULE_STRING ) )
                    	    {
                    	    otherlv_11=(Token)match(input,16,FOLLOW_8); 

                    	    					newLeafNode(otherlv_11, grammarAccess.getClassAccess().getCommaKeyword_8_3_0());
                    	    				
                    	    // InternalKM3.g:1040:5: ( (otherlv_12= RULE_STRING ) )
                    	    // InternalKM3.g:1041:6: (otherlv_12= RULE_STRING )
                    	    {
                    	    // InternalKM3.g:1041:6: (otherlv_12= RULE_STRING )
                    	    // InternalKM3.g:1042:7: otherlv_12= RULE_STRING
                    	    {

                    	    							if (current==null) {
                    	    								current = createModelElement(grammarAccess.getClassRule());
                    	    							}
                    	    						
                    	    otherlv_12=(Token)match(input,RULE_STRING,FOLLOW_9); 

                    	    							newLeafNode(otherlv_12, grammarAccess.getClassAccess().getParametersTemplateParameterCrossReference_8_3_1_0());
                    	    						

                    	    }


                    	    }


                    	    }
                    	    break;

                    	default :
                    	    break loop8;
                        }
                    } while (true);

                    otherlv_13=(Token)match(input,17,FOLLOW_20); 

                    				newLeafNode(otherlv_13, grammarAccess.getClassAccess().getRightParenthesisKeyword_8_4());
                    			

                    }
                    break;

            }

            // InternalKM3.g:1059:3: (otherlv_14= 'supertypes' otherlv_15= '(' ( (otherlv_16= RULE_STRING ) ) (otherlv_17= ',' ( (otherlv_18= RULE_STRING ) ) )* otherlv_19= ')' )?
            int alt11=2;
            int LA11_0 = input.LA(1);

            if ( (LA11_0==33) ) {
                alt11=1;
            }
            switch (alt11) {
                case 1 :
                    // InternalKM3.g:1060:4: otherlv_14= 'supertypes' otherlv_15= '(' ( (otherlv_16= RULE_STRING ) ) (otherlv_17= ',' ( (otherlv_18= RULE_STRING ) ) )* otherlv_19= ')'
                    {
                    otherlv_14=(Token)match(input,33,FOLLOW_7); 

                    				newLeafNode(otherlv_14, grammarAccess.getClassAccess().getSupertypesKeyword_9_0());
                    			
                    otherlv_15=(Token)match(input,15,FOLLOW_8); 

                    				newLeafNode(otherlv_15, grammarAccess.getClassAccess().getLeftParenthesisKeyword_9_1());
                    			
                    // InternalKM3.g:1068:4: ( (otherlv_16= RULE_STRING ) )
                    // InternalKM3.g:1069:5: (otherlv_16= RULE_STRING )
                    {
                    // InternalKM3.g:1069:5: (otherlv_16= RULE_STRING )
                    // InternalKM3.g:1070:6: otherlv_16= RULE_STRING
                    {

                    						if (current==null) {
                    							current = createModelElement(grammarAccess.getClassRule());
                    						}
                    					
                    otherlv_16=(Token)match(input,RULE_STRING,FOLLOW_9); 

                    						newLeafNode(otherlv_16, grammarAccess.getClassAccess().getSupertypesClassCrossReference_9_2_0());
                    					

                    }


                    }

                    // InternalKM3.g:1081:4: (otherlv_17= ',' ( (otherlv_18= RULE_STRING ) ) )*
                    loop10:
                    do {
                        int alt10=2;
                        int LA10_0 = input.LA(1);

                        if ( (LA10_0==16) ) {
                            alt10=1;
                        }


                        switch (alt10) {
                    	case 1 :
                    	    // InternalKM3.g:1082:5: otherlv_17= ',' ( (otherlv_18= RULE_STRING ) )
                    	    {
                    	    otherlv_17=(Token)match(input,16,FOLLOW_8); 

                    	    					newLeafNode(otherlv_17, grammarAccess.getClassAccess().getCommaKeyword_9_3_0());
                    	    				
                    	    // InternalKM3.g:1086:5: ( (otherlv_18= RULE_STRING ) )
                    	    // InternalKM3.g:1087:6: (otherlv_18= RULE_STRING )
                    	    {
                    	    // InternalKM3.g:1087:6: (otherlv_18= RULE_STRING )
                    	    // InternalKM3.g:1088:7: otherlv_18= RULE_STRING
                    	    {

                    	    							if (current==null) {
                    	    								current = createModelElement(grammarAccess.getClassRule());
                    	    							}
                    	    						
                    	    otherlv_18=(Token)match(input,RULE_STRING,FOLLOW_9); 

                    	    							newLeafNode(otherlv_18, grammarAccess.getClassAccess().getSupertypesClassCrossReference_9_3_1_0());
                    	    						

                    	    }


                    	    }


                    	    }
                    	    break;

                    	default :
                    	    break loop10;
                        }
                    } while (true);

                    otherlv_19=(Token)match(input,17,FOLLOW_21); 

                    				newLeafNode(otherlv_19, grammarAccess.getClassAccess().getRightParenthesisKeyword_9_4());
                    			

                    }
                    break;

            }

            // InternalKM3.g:1105:3: (otherlv_20= 'structuralFeatures' otherlv_21= '(' ( (otherlv_22= RULE_STRING ) ) (otherlv_23= ',' ( (otherlv_24= RULE_STRING ) ) )* otherlv_25= ')' )?
            int alt13=2;
            int LA13_0 = input.LA(1);

            if ( (LA13_0==34) ) {
                alt13=1;
            }
            switch (alt13) {
                case 1 :
                    // InternalKM3.g:1106:4: otherlv_20= 'structuralFeatures' otherlv_21= '(' ( (otherlv_22= RULE_STRING ) ) (otherlv_23= ',' ( (otherlv_24= RULE_STRING ) ) )* otherlv_25= ')'
                    {
                    otherlv_20=(Token)match(input,34,FOLLOW_7); 

                    				newLeafNode(otherlv_20, grammarAccess.getClassAccess().getStructuralFeaturesKeyword_10_0());
                    			
                    otherlv_21=(Token)match(input,15,FOLLOW_8); 

                    				newLeafNode(otherlv_21, grammarAccess.getClassAccess().getLeftParenthesisKeyword_10_1());
                    			
                    // InternalKM3.g:1114:4: ( (otherlv_22= RULE_STRING ) )
                    // InternalKM3.g:1115:5: (otherlv_22= RULE_STRING )
                    {
                    // InternalKM3.g:1115:5: (otherlv_22= RULE_STRING )
                    // InternalKM3.g:1116:6: otherlv_22= RULE_STRING
                    {

                    						if (current==null) {
                    							current = createModelElement(grammarAccess.getClassRule());
                    						}
                    					
                    otherlv_22=(Token)match(input,RULE_STRING,FOLLOW_9); 

                    						newLeafNode(otherlv_22, grammarAccess.getClassAccess().getStructuralFeaturesStructuralFeatureCrossReference_10_2_0());
                    					

                    }


                    }

                    // InternalKM3.g:1127:4: (otherlv_23= ',' ( (otherlv_24= RULE_STRING ) ) )*
                    loop12:
                    do {
                        int alt12=2;
                        int LA12_0 = input.LA(1);

                        if ( (LA12_0==16) ) {
                            alt12=1;
                        }


                        switch (alt12) {
                    	case 1 :
                    	    // InternalKM3.g:1128:5: otherlv_23= ',' ( (otherlv_24= RULE_STRING ) )
                    	    {
                    	    otherlv_23=(Token)match(input,16,FOLLOW_8); 

                    	    					newLeafNode(otherlv_23, grammarAccess.getClassAccess().getCommaKeyword_10_3_0());
                    	    				
                    	    // InternalKM3.g:1132:5: ( (otherlv_24= RULE_STRING ) )
                    	    // InternalKM3.g:1133:6: (otherlv_24= RULE_STRING )
                    	    {
                    	    // InternalKM3.g:1133:6: (otherlv_24= RULE_STRING )
                    	    // InternalKM3.g:1134:7: otherlv_24= RULE_STRING
                    	    {

                    	    							if (current==null) {
                    	    								current = createModelElement(grammarAccess.getClassRule());
                    	    							}
                    	    						
                    	    otherlv_24=(Token)match(input,RULE_STRING,FOLLOW_9); 

                    	    							newLeafNode(otherlv_24, grammarAccess.getClassAccess().getStructuralFeaturesStructuralFeatureCrossReference_10_3_1_0());
                    	    						

                    	    }


                    	    }


                    	    }
                    	    break;

                    	default :
                    	    break loop12;
                        }
                    } while (true);

                    otherlv_25=(Token)match(input,17,FOLLOW_22); 

                    				newLeafNode(otherlv_25, grammarAccess.getClassAccess().getRightParenthesisKeyword_10_4());
                    			

                    }
                    break;

            }

            // InternalKM3.g:1151:3: (otherlv_26= 'operations' otherlv_27= '(' ( (otherlv_28= RULE_STRING ) ) (otherlv_29= ',' ( (otherlv_30= RULE_STRING ) ) )* otherlv_31= ')' )?
            int alt15=2;
            int LA15_0 = input.LA(1);

            if ( (LA15_0==35) ) {
                alt15=1;
            }
            switch (alt15) {
                case 1 :
                    // InternalKM3.g:1152:4: otherlv_26= 'operations' otherlv_27= '(' ( (otherlv_28= RULE_STRING ) ) (otherlv_29= ',' ( (otherlv_30= RULE_STRING ) ) )* otherlv_31= ')'
                    {
                    otherlv_26=(Token)match(input,35,FOLLOW_7); 

                    				newLeafNode(otherlv_26, grammarAccess.getClassAccess().getOperationsKeyword_11_0());
                    			
                    otherlv_27=(Token)match(input,15,FOLLOW_8); 

                    				newLeafNode(otherlv_27, grammarAccess.getClassAccess().getLeftParenthesisKeyword_11_1());
                    			
                    // InternalKM3.g:1160:4: ( (otherlv_28= RULE_STRING ) )
                    // InternalKM3.g:1161:5: (otherlv_28= RULE_STRING )
                    {
                    // InternalKM3.g:1161:5: (otherlv_28= RULE_STRING )
                    // InternalKM3.g:1162:6: otherlv_28= RULE_STRING
                    {

                    						if (current==null) {
                    							current = createModelElement(grammarAccess.getClassRule());
                    						}
                    					
                    otherlv_28=(Token)match(input,RULE_STRING,FOLLOW_9); 

                    						newLeafNode(otherlv_28, grammarAccess.getClassAccess().getOperationsOperationCrossReference_11_2_0());
                    					

                    }


                    }

                    // InternalKM3.g:1173:4: (otherlv_29= ',' ( (otherlv_30= RULE_STRING ) ) )*
                    loop14:
                    do {
                        int alt14=2;
                        int LA14_0 = input.LA(1);

                        if ( (LA14_0==16) ) {
                            alt14=1;
                        }


                        switch (alt14) {
                    	case 1 :
                    	    // InternalKM3.g:1174:5: otherlv_29= ',' ( (otherlv_30= RULE_STRING ) )
                    	    {
                    	    otherlv_29=(Token)match(input,16,FOLLOW_8); 

                    	    					newLeafNode(otherlv_29, grammarAccess.getClassAccess().getCommaKeyword_11_3_0());
                    	    				
                    	    // InternalKM3.g:1178:5: ( (otherlv_30= RULE_STRING ) )
                    	    // InternalKM3.g:1179:6: (otherlv_30= RULE_STRING )
                    	    {
                    	    // InternalKM3.g:1179:6: (otherlv_30= RULE_STRING )
                    	    // InternalKM3.g:1180:7: otherlv_30= RULE_STRING
                    	    {

                    	    							if (current==null) {
                    	    								current = createModelElement(grammarAccess.getClassRule());
                    	    							}
                    	    						
                    	    otherlv_30=(Token)match(input,RULE_STRING,FOLLOW_9); 

                    	    							newLeafNode(otherlv_30, grammarAccess.getClassAccess().getOperationsOperationCrossReference_11_3_1_0());
                    	    						

                    	    }


                    	    }


                    	    }
                    	    break;

                    	default :
                    	    break loop14;
                        }
                    } while (true);

                    otherlv_31=(Token)match(input,17,FOLLOW_10); 

                    				newLeafNode(otherlv_31, grammarAccess.getClassAccess().getRightParenthesisKeyword_11_4());
                    			

                    }
                    break;

            }

            otherlv_32=(Token)match(input,18,FOLLOW_2); 

            			newLeafNode(otherlv_32, grammarAccess.getClassAccess().getRightCurlyBracketKeyword_12());
            		

            }


            }


            	leaveRule();

        }

            catch (RecognitionException re) {
                recover(input,re);
                appendSkippedTokens();
            }
        finally {
        }
        return current;
    }
    // $ANTLR end "ruleClass"


    // $ANTLR start "entryRuleTypedElement_Impl"
    // InternalKM3.g:1205:1: entryRuleTypedElement_Impl returns [EObject current=null] : iv_ruleTypedElement_Impl= ruleTypedElement_Impl EOF ;
    public final EObject entryRuleTypedElement_Impl() throws RecognitionException {
        EObject current = null;

        EObject iv_ruleTypedElement_Impl = null;


        try {
            // InternalKM3.g:1205:58: (iv_ruleTypedElement_Impl= ruleTypedElement_Impl EOF )
            // InternalKM3.g:1206:2: iv_ruleTypedElement_Impl= ruleTypedElement_Impl EOF
            {
             newCompositeNode(grammarAccess.getTypedElement_ImplRule()); 
            pushFollow(FOLLOW_1);
            iv_ruleTypedElement_Impl=ruleTypedElement_Impl();

            state._fsp--;

             current =iv_ruleTypedElement_Impl; 
            match(input,EOF,FOLLOW_2); 

            }

        }

            catch (RecognitionException re) {
                recover(input,re);
                appendSkippedTokens();
            }
        finally {
        }
        return current;
    }
    // $ANTLR end "entryRuleTypedElement_Impl"


    // $ANTLR start "ruleTypedElement_Impl"
    // InternalKM3.g:1212:1: ruleTypedElement_Impl returns [EObject current=null] : (otherlv_0= 'TypedElement' otherlv_1= '{' otherlv_2= 'location' ( (lv_location_3_0= ruleString0 ) ) otherlv_4= 'name' ( (lv_name_5_0= ruleString0 ) ) otherlv_6= 'lower' ( (lv_lower_7_0= ruleInteger ) ) otherlv_8= 'upper' ( (lv_upper_9_0= ruleInteger ) ) otherlv_10= 'isOrdered' ( (lv_isOrdered_11_0= ruleBoolean ) ) otherlv_12= 'isUnique' ( (lv_isUnique_13_0= ruleBoolean ) ) otherlv_14= 'type' ( (otherlv_15= RULE_STRING ) ) otherlv_16= '}' ) ;
    public final EObject ruleTypedElement_Impl() throws RecognitionException {
        EObject current = null;

        Token otherlv_0=null;
        Token otherlv_1=null;
        Token otherlv_2=null;
        Token otherlv_4=null;
        Token otherlv_6=null;
        Token otherlv_8=null;
        Token otherlv_10=null;
        Token otherlv_12=null;
        Token otherlv_14=null;
        Token otherlv_15=null;
        Token otherlv_16=null;
        AntlrDatatypeRuleToken lv_location_3_0 = null;

        AntlrDatatypeRuleToken lv_name_5_0 = null;

        AntlrDatatypeRuleToken lv_lower_7_0 = null;

        AntlrDatatypeRuleToken lv_upper_9_0 = null;

        AntlrDatatypeRuleToken lv_isOrdered_11_0 = null;

        AntlrDatatypeRuleToken lv_isUnique_13_0 = null;



        	enterRule();

        try {
            // InternalKM3.g:1218:2: ( (otherlv_0= 'TypedElement' otherlv_1= '{' otherlv_2= 'location' ( (lv_location_3_0= ruleString0 ) ) otherlv_4= 'name' ( (lv_name_5_0= ruleString0 ) ) otherlv_6= 'lower' ( (lv_lower_7_0= ruleInteger ) ) otherlv_8= 'upper' ( (lv_upper_9_0= ruleInteger ) ) otherlv_10= 'isOrdered' ( (lv_isOrdered_11_0= ruleBoolean ) ) otherlv_12= 'isUnique' ( (lv_isUnique_13_0= ruleBoolean ) ) otherlv_14= 'type' ( (otherlv_15= RULE_STRING ) ) otherlv_16= '}' ) )
            // InternalKM3.g:1219:2: (otherlv_0= 'TypedElement' otherlv_1= '{' otherlv_2= 'location' ( (lv_location_3_0= ruleString0 ) ) otherlv_4= 'name' ( (lv_name_5_0= ruleString0 ) ) otherlv_6= 'lower' ( (lv_lower_7_0= ruleInteger ) ) otherlv_8= 'upper' ( (lv_upper_9_0= ruleInteger ) ) otherlv_10= 'isOrdered' ( (lv_isOrdered_11_0= ruleBoolean ) ) otherlv_12= 'isUnique' ( (lv_isUnique_13_0= ruleBoolean ) ) otherlv_14= 'type' ( (otherlv_15= RULE_STRING ) ) otherlv_16= '}' )
            {
            // InternalKM3.g:1219:2: (otherlv_0= 'TypedElement' otherlv_1= '{' otherlv_2= 'location' ( (lv_location_3_0= ruleString0 ) ) otherlv_4= 'name' ( (lv_name_5_0= ruleString0 ) ) otherlv_6= 'lower' ( (lv_lower_7_0= ruleInteger ) ) otherlv_8= 'upper' ( (lv_upper_9_0= ruleInteger ) ) otherlv_10= 'isOrdered' ( (lv_isOrdered_11_0= ruleBoolean ) ) otherlv_12= 'isUnique' ( (lv_isUnique_13_0= ruleBoolean ) ) otherlv_14= 'type' ( (otherlv_15= RULE_STRING ) ) otherlv_16= '}' )
            // InternalKM3.g:1220:3: otherlv_0= 'TypedElement' otherlv_1= '{' otherlv_2= 'location' ( (lv_location_3_0= ruleString0 ) ) otherlv_4= 'name' ( (lv_name_5_0= ruleString0 ) ) otherlv_6= 'lower' ( (lv_lower_7_0= ruleInteger ) ) otherlv_8= 'upper' ( (lv_upper_9_0= ruleInteger ) ) otherlv_10= 'isOrdered' ( (lv_isOrdered_11_0= ruleBoolean ) ) otherlv_12= 'isUnique' ( (lv_isUnique_13_0= ruleBoolean ) ) otherlv_14= 'type' ( (otherlv_15= RULE_STRING ) ) otherlv_16= '}'
            {
            otherlv_0=(Token)match(input,36,FOLLOW_3); 

            			newLeafNode(otherlv_0, grammarAccess.getTypedElement_ImplAccess().getTypedElementKeyword_0());
            		
            otherlv_1=(Token)match(input,12,FOLLOW_4); 

            			newLeafNode(otherlv_1, grammarAccess.getTypedElement_ImplAccess().getLeftCurlyBracketKeyword_1());
            		
            otherlv_2=(Token)match(input,13,FOLLOW_5); 

            			newLeafNode(otherlv_2, grammarAccess.getTypedElement_ImplAccess().getLocationKeyword_2());
            		
            // InternalKM3.g:1232:3: ( (lv_location_3_0= ruleString0 ) )
            // InternalKM3.g:1233:4: (lv_location_3_0= ruleString0 )
            {
            // InternalKM3.g:1233:4: (lv_location_3_0= ruleString0 )
            // InternalKM3.g:1234:5: lv_location_3_0= ruleString0
            {

            					newCompositeNode(grammarAccess.getTypedElement_ImplAccess().getLocationString0ParserRuleCall_3_0());
            				
            pushFollow(FOLLOW_11);
            lv_location_3_0=ruleString0();

            state._fsp--;


            					if (current==null) {
            						current = createModelElementForParent(grammarAccess.getTypedElement_ImplRule());
            					}
            					set(
            						current,
            						"location",
            						lv_location_3_0,
            						"org.eclipse.m2m.km3.xtext.KM3.String0");
            					afterParserOrEnumRuleCall();
            				

            }


            }

            otherlv_4=(Token)match(input,21,FOLLOW_5); 

            			newLeafNode(otherlv_4, grammarAccess.getTypedElement_ImplAccess().getNameKeyword_4());
            		
            // InternalKM3.g:1255:3: ( (lv_name_5_0= ruleString0 ) )
            // InternalKM3.g:1256:4: (lv_name_5_0= ruleString0 )
            {
            // InternalKM3.g:1256:4: (lv_name_5_0= ruleString0 )
            // InternalKM3.g:1257:5: lv_name_5_0= ruleString0
            {

            					newCompositeNode(grammarAccess.getTypedElement_ImplAccess().getNameString0ParserRuleCall_5_0());
            				
            pushFollow(FOLLOW_23);
            lv_name_5_0=ruleString0();

            state._fsp--;


            					if (current==null) {
            						current = createModelElementForParent(grammarAccess.getTypedElement_ImplRule());
            					}
            					set(
            						current,
            						"name",
            						lv_name_5_0,
            						"org.eclipse.m2m.km3.xtext.KM3.String0");
            					afterParserOrEnumRuleCall();
            				

            }


            }

            otherlv_6=(Token)match(input,37,FOLLOW_24); 

            			newLeafNode(otherlv_6, grammarAccess.getTypedElement_ImplAccess().getLowerKeyword_6());
            		
            // InternalKM3.g:1278:3: ( (lv_lower_7_0= ruleInteger ) )
            // InternalKM3.g:1279:4: (lv_lower_7_0= ruleInteger )
            {
            // InternalKM3.g:1279:4: (lv_lower_7_0= ruleInteger )
            // InternalKM3.g:1280:5: lv_lower_7_0= ruleInteger
            {

            					newCompositeNode(grammarAccess.getTypedElement_ImplAccess().getLowerIntegerParserRuleCall_7_0());
            				
            pushFollow(FOLLOW_25);
            lv_lower_7_0=ruleInteger();

            state._fsp--;


            					if (current==null) {
            						current = createModelElementForParent(grammarAccess.getTypedElement_ImplRule());
            					}
            					set(
            						current,
            						"lower",
            						lv_lower_7_0,
            						"org.eclipse.m2m.km3.xtext.KM3.Integer");
            					afterParserOrEnumRuleCall();
            				

            }


            }

            otherlv_8=(Token)match(input,38,FOLLOW_24); 

            			newLeafNode(otherlv_8, grammarAccess.getTypedElement_ImplAccess().getUpperKeyword_8());
            		
            // InternalKM3.g:1301:3: ( (lv_upper_9_0= ruleInteger ) )
            // InternalKM3.g:1302:4: (lv_upper_9_0= ruleInteger )
            {
            // InternalKM3.g:1302:4: (lv_upper_9_0= ruleInteger )
            // InternalKM3.g:1303:5: lv_upper_9_0= ruleInteger
            {

            					newCompositeNode(grammarAccess.getTypedElement_ImplAccess().getUpperIntegerParserRuleCall_9_0());
            				
            pushFollow(FOLLOW_26);
            lv_upper_9_0=ruleInteger();

            state._fsp--;


            					if (current==null) {
            						current = createModelElementForParent(grammarAccess.getTypedElement_ImplRule());
            					}
            					set(
            						current,
            						"upper",
            						lv_upper_9_0,
            						"org.eclipse.m2m.km3.xtext.KM3.Integer");
            					afterParserOrEnumRuleCall();
            				

            }


            }

            otherlv_10=(Token)match(input,39,FOLLOW_18); 

            			newLeafNode(otherlv_10, grammarAccess.getTypedElement_ImplAccess().getIsOrderedKeyword_10());
            		
            // InternalKM3.g:1324:3: ( (lv_isOrdered_11_0= ruleBoolean ) )
            // InternalKM3.g:1325:4: (lv_isOrdered_11_0= ruleBoolean )
            {
            // InternalKM3.g:1325:4: (lv_isOrdered_11_0= ruleBoolean )
            // InternalKM3.g:1326:5: lv_isOrdered_11_0= ruleBoolean
            {

            					newCompositeNode(grammarAccess.getTypedElement_ImplAccess().getIsOrderedBooleanParserRuleCall_11_0());
            				
            pushFollow(FOLLOW_27);
            lv_isOrdered_11_0=ruleBoolean();

            state._fsp--;


            					if (current==null) {
            						current = createModelElementForParent(grammarAccess.getTypedElement_ImplRule());
            					}
            					set(
            						current,
            						"isOrdered",
            						lv_isOrdered_11_0,
            						"org.eclipse.m2m.km3.xtext.KM3.Boolean");
            					afterParserOrEnumRuleCall();
            				

            }


            }

            otherlv_12=(Token)match(input,40,FOLLOW_18); 

            			newLeafNode(otherlv_12, grammarAccess.getTypedElement_ImplAccess().getIsUniqueKeyword_12());
            		
            // InternalKM3.g:1347:3: ( (lv_isUnique_13_0= ruleBoolean ) )
            // InternalKM3.g:1348:4: (lv_isUnique_13_0= ruleBoolean )
            {
            // InternalKM3.g:1348:4: (lv_isUnique_13_0= ruleBoolean )
            // InternalKM3.g:1349:5: lv_isUnique_13_0= ruleBoolean
            {

            					newCompositeNode(grammarAccess.getTypedElement_ImplAccess().getIsUniqueBooleanParserRuleCall_13_0());
            				
            pushFollow(FOLLOW_28);
            lv_isUnique_13_0=ruleBoolean();

            state._fsp--;


            					if (current==null) {
            						current = createModelElementForParent(grammarAccess.getTypedElement_ImplRule());
            					}
            					set(
            						current,
            						"isUnique",
            						lv_isUnique_13_0,
            						"org.eclipse.m2m.km3.xtext.KM3.Boolean");
            					afterParserOrEnumRuleCall();
            				

            }


            }

            otherlv_14=(Token)match(input,41,FOLLOW_8); 

            			newLeafNode(otherlv_14, grammarAccess.getTypedElement_ImplAccess().getTypeKeyword_14());
            		
            // InternalKM3.g:1370:3: ( (otherlv_15= RULE_STRING ) )
            // InternalKM3.g:1371:4: (otherlv_15= RULE_STRING )
            {
            // InternalKM3.g:1371:4: (otherlv_15= RULE_STRING )
            // InternalKM3.g:1372:5: otherlv_15= RULE_STRING
            {

            					if (current==null) {
            						current = createModelElement(grammarAccess.getTypedElement_ImplRule());
            					}
            				
            otherlv_15=(Token)match(input,RULE_STRING,FOLLOW_10); 

            					newLeafNode(otherlv_15, grammarAccess.getTypedElement_ImplAccess().getTypeClassifierCrossReference_15_0());
            				

            }


            }

            otherlv_16=(Token)match(input,18,FOLLOW_2); 

            			newLeafNode(otherlv_16, grammarAccess.getTypedElement_ImplAccess().getRightCurlyBracketKeyword_16());
            		

            }


            }


            	leaveRule();

        }

            catch (RecognitionException re) {
                recover(input,re);
                appendSkippedTokens();
            }
        finally {
        }
        return current;
    }
    // $ANTLR end "ruleTypedElement_Impl"


    // $ANTLR start "entryRuleStructuralFeature_Impl"
    // InternalKM3.g:1391:1: entryRuleStructuralFeature_Impl returns [EObject current=null] : iv_ruleStructuralFeature_Impl= ruleStructuralFeature_Impl EOF ;
    public final EObject entryRuleStructuralFeature_Impl() throws RecognitionException {
        EObject current = null;

        EObject iv_ruleStructuralFeature_Impl = null;


        try {
            // InternalKM3.g:1391:63: (iv_ruleStructuralFeature_Impl= ruleStructuralFeature_Impl EOF )
            // InternalKM3.g:1392:2: iv_ruleStructuralFeature_Impl= ruleStructuralFeature_Impl EOF
            {
             newCompositeNode(grammarAccess.getStructuralFeature_ImplRule()); 
            pushFollow(FOLLOW_1);
            iv_ruleStructuralFeature_Impl=ruleStructuralFeature_Impl();

            state._fsp--;

             current =iv_ruleStructuralFeature_Impl; 
            match(input,EOF,FOLLOW_2); 

            }

        }

            catch (RecognitionException re) {
                recover(input,re);
                appendSkippedTokens();
            }
        finally {
        }
        return current;
    }
    // $ANTLR end "entryRuleStructuralFeature_Impl"


    // $ANTLR start "ruleStructuralFeature_Impl"
    // InternalKM3.g:1398:1: ruleStructuralFeature_Impl returns [EObject current=null] : (otherlv_0= 'StructuralFeature' otherlv_1= '{' otherlv_2= 'location' ( (lv_location_3_0= ruleString0 ) ) otherlv_4= 'name' ( (lv_name_5_0= ruleString0 ) ) otherlv_6= 'lower' ( (lv_lower_7_0= ruleInteger ) ) otherlv_8= 'upper' ( (lv_upper_9_0= ruleInteger ) ) otherlv_10= 'isOrdered' ( (lv_isOrdered_11_0= ruleBoolean ) ) otherlv_12= 'isUnique' ( (lv_isUnique_13_0= ruleBoolean ) ) otherlv_14= 'type' ( (otherlv_15= RULE_STRING ) ) otherlv_16= 'owner' ( (otherlv_17= RULE_STRING ) ) (otherlv_18= 'subsetOf' otherlv_19= '(' ( (otherlv_20= RULE_STRING ) ) (otherlv_21= ',' ( (otherlv_22= RULE_STRING ) ) )* otherlv_23= ')' )? (otherlv_24= 'derivedFrom' otherlv_25= '(' ( (otherlv_26= RULE_STRING ) ) (otherlv_27= ',' ( (otherlv_28= RULE_STRING ) ) )* otherlv_29= ')' )? otherlv_30= '}' ) ;
    public final EObject ruleStructuralFeature_Impl() throws RecognitionException {
        EObject current = null;

        Token otherlv_0=null;
        Token otherlv_1=null;
        Token otherlv_2=null;
        Token otherlv_4=null;
        Token otherlv_6=null;
        Token otherlv_8=null;
        Token otherlv_10=null;
        Token otherlv_12=null;
        Token otherlv_14=null;
        Token otherlv_15=null;
        Token otherlv_16=null;
        Token otherlv_17=null;
        Token otherlv_18=null;
        Token otherlv_19=null;
        Token otherlv_20=null;
        Token otherlv_21=null;
        Token otherlv_22=null;
        Token otherlv_23=null;
        Token otherlv_24=null;
        Token otherlv_25=null;
        Token otherlv_26=null;
        Token otherlv_27=null;
        Token otherlv_28=null;
        Token otherlv_29=null;
        Token otherlv_30=null;
        AntlrDatatypeRuleToken lv_location_3_0 = null;

        AntlrDatatypeRuleToken lv_name_5_0 = null;

        AntlrDatatypeRuleToken lv_lower_7_0 = null;

        AntlrDatatypeRuleToken lv_upper_9_0 = null;

        AntlrDatatypeRuleToken lv_isOrdered_11_0 = null;

        AntlrDatatypeRuleToken lv_isUnique_13_0 = null;



        	enterRule();

        try {
            // InternalKM3.g:1404:2: ( (otherlv_0= 'StructuralFeature' otherlv_1= '{' otherlv_2= 'location' ( (lv_location_3_0= ruleString0 ) ) otherlv_4= 'name' ( (lv_name_5_0= ruleString0 ) ) otherlv_6= 'lower' ( (lv_lower_7_0= ruleInteger ) ) otherlv_8= 'upper' ( (lv_upper_9_0= ruleInteger ) ) otherlv_10= 'isOrdered' ( (lv_isOrdered_11_0= ruleBoolean ) ) otherlv_12= 'isUnique' ( (lv_isUnique_13_0= ruleBoolean ) ) otherlv_14= 'type' ( (otherlv_15= RULE_STRING ) ) otherlv_16= 'owner' ( (otherlv_17= RULE_STRING ) ) (otherlv_18= 'subsetOf' otherlv_19= '(' ( (otherlv_20= RULE_STRING ) ) (otherlv_21= ',' ( (otherlv_22= RULE_STRING ) ) )* otherlv_23= ')' )? (otherlv_24= 'derivedFrom' otherlv_25= '(' ( (otherlv_26= RULE_STRING ) ) (otherlv_27= ',' ( (otherlv_28= RULE_STRING ) ) )* otherlv_29= ')' )? otherlv_30= '}' ) )
            // InternalKM3.g:1405:2: (otherlv_0= 'StructuralFeature' otherlv_1= '{' otherlv_2= 'location' ( (lv_location_3_0= ruleString0 ) ) otherlv_4= 'name' ( (lv_name_5_0= ruleString0 ) ) otherlv_6= 'lower' ( (lv_lower_7_0= ruleInteger ) ) otherlv_8= 'upper' ( (lv_upper_9_0= ruleInteger ) ) otherlv_10= 'isOrdered' ( (lv_isOrdered_11_0= ruleBoolean ) ) otherlv_12= 'isUnique' ( (lv_isUnique_13_0= ruleBoolean ) ) otherlv_14= 'type' ( (otherlv_15= RULE_STRING ) ) otherlv_16= 'owner' ( (otherlv_17= RULE_STRING ) ) (otherlv_18= 'subsetOf' otherlv_19= '(' ( (otherlv_20= RULE_STRING ) ) (otherlv_21= ',' ( (otherlv_22= RULE_STRING ) ) )* otherlv_23= ')' )? (otherlv_24= 'derivedFrom' otherlv_25= '(' ( (otherlv_26= RULE_STRING ) ) (otherlv_27= ',' ( (otherlv_28= RULE_STRING ) ) )* otherlv_29= ')' )? otherlv_30= '}' )
            {
            // InternalKM3.g:1405:2: (otherlv_0= 'StructuralFeature' otherlv_1= '{' otherlv_2= 'location' ( (lv_location_3_0= ruleString0 ) ) otherlv_4= 'name' ( (lv_name_5_0= ruleString0 ) ) otherlv_6= 'lower' ( (lv_lower_7_0= ruleInteger ) ) otherlv_8= 'upper' ( (lv_upper_9_0= ruleInteger ) ) otherlv_10= 'isOrdered' ( (lv_isOrdered_11_0= ruleBoolean ) ) otherlv_12= 'isUnique' ( (lv_isUnique_13_0= ruleBoolean ) ) otherlv_14= 'type' ( (otherlv_15= RULE_STRING ) ) otherlv_16= 'owner' ( (otherlv_17= RULE_STRING ) ) (otherlv_18= 'subsetOf' otherlv_19= '(' ( (otherlv_20= RULE_STRING ) ) (otherlv_21= ',' ( (otherlv_22= RULE_STRING ) ) )* otherlv_23= ')' )? (otherlv_24= 'derivedFrom' otherlv_25= '(' ( (otherlv_26= RULE_STRING ) ) (otherlv_27= ',' ( (otherlv_28= RULE_STRING ) ) )* otherlv_29= ')' )? otherlv_30= '}' )
            // InternalKM3.g:1406:3: otherlv_0= 'StructuralFeature' otherlv_1= '{' otherlv_2= 'location' ( (lv_location_3_0= ruleString0 ) ) otherlv_4= 'name' ( (lv_name_5_0= ruleString0 ) ) otherlv_6= 'lower' ( (lv_lower_7_0= ruleInteger ) ) otherlv_8= 'upper' ( (lv_upper_9_0= ruleInteger ) ) otherlv_10= 'isOrdered' ( (lv_isOrdered_11_0= ruleBoolean ) ) otherlv_12= 'isUnique' ( (lv_isUnique_13_0= ruleBoolean ) ) otherlv_14= 'type' ( (otherlv_15= RULE_STRING ) ) otherlv_16= 'owner' ( (otherlv_17= RULE_STRING ) ) (otherlv_18= 'subsetOf' otherlv_19= '(' ( (otherlv_20= RULE_STRING ) ) (otherlv_21= ',' ( (otherlv_22= RULE_STRING ) ) )* otherlv_23= ')' )? (otherlv_24= 'derivedFrom' otherlv_25= '(' ( (otherlv_26= RULE_STRING ) ) (otherlv_27= ',' ( (otherlv_28= RULE_STRING ) ) )* otherlv_29= ')' )? otherlv_30= '}'
            {
            otherlv_0=(Token)match(input,42,FOLLOW_3); 

            			newLeafNode(otherlv_0, grammarAccess.getStructuralFeature_ImplAccess().getStructuralFeatureKeyword_0());
            		
            otherlv_1=(Token)match(input,12,FOLLOW_4); 

            			newLeafNode(otherlv_1, grammarAccess.getStructuralFeature_ImplAccess().getLeftCurlyBracketKeyword_1());
            		
            otherlv_2=(Token)match(input,13,FOLLOW_5); 

            			newLeafNode(otherlv_2, grammarAccess.getStructuralFeature_ImplAccess().getLocationKeyword_2());
            		
            // InternalKM3.g:1418:3: ( (lv_location_3_0= ruleString0 ) )
            // InternalKM3.g:1419:4: (lv_location_3_0= ruleString0 )
            {
            // InternalKM3.g:1419:4: (lv_location_3_0= ruleString0 )
            // InternalKM3.g:1420:5: lv_location_3_0= ruleString0
            {

            					newCompositeNode(grammarAccess.getStructuralFeature_ImplAccess().getLocationString0ParserRuleCall_3_0());
            				
            pushFollow(FOLLOW_11);
            lv_location_3_0=ruleString0();

            state._fsp--;


            					if (current==null) {
            						current = createModelElementForParent(grammarAccess.getStructuralFeature_ImplRule());
            					}
            					set(
            						current,
            						"location",
            						lv_location_3_0,
            						"org.eclipse.m2m.km3.xtext.KM3.String0");
            					afterParserOrEnumRuleCall();
            				

            }


            }

            otherlv_4=(Token)match(input,21,FOLLOW_5); 

            			newLeafNode(otherlv_4, grammarAccess.getStructuralFeature_ImplAccess().getNameKeyword_4());
            		
            // InternalKM3.g:1441:3: ( (lv_name_5_0= ruleString0 ) )
            // InternalKM3.g:1442:4: (lv_name_5_0= ruleString0 )
            {
            // InternalKM3.g:1442:4: (lv_name_5_0= ruleString0 )
            // InternalKM3.g:1443:5: lv_name_5_0= ruleString0
            {

            					newCompositeNode(grammarAccess.getStructuralFeature_ImplAccess().getNameString0ParserRuleCall_5_0());
            				
            pushFollow(FOLLOW_23);
            lv_name_5_0=ruleString0();

            state._fsp--;


            					if (current==null) {
            						current = createModelElementForParent(grammarAccess.getStructuralFeature_ImplRule());
            					}
            					set(
            						current,
            						"name",
            						lv_name_5_0,
            						"org.eclipse.m2m.km3.xtext.KM3.String0");
            					afterParserOrEnumRuleCall();
            				

            }


            }

            otherlv_6=(Token)match(input,37,FOLLOW_24); 

            			newLeafNode(otherlv_6, grammarAccess.getStructuralFeature_ImplAccess().getLowerKeyword_6());
            		
            // InternalKM3.g:1464:3: ( (lv_lower_7_0= ruleInteger ) )
            // InternalKM3.g:1465:4: (lv_lower_7_0= ruleInteger )
            {
            // InternalKM3.g:1465:4: (lv_lower_7_0= ruleInteger )
            // InternalKM3.g:1466:5: lv_lower_7_0= ruleInteger
            {

            					newCompositeNode(grammarAccess.getStructuralFeature_ImplAccess().getLowerIntegerParserRuleCall_7_0());
            				
            pushFollow(FOLLOW_25);
            lv_lower_7_0=ruleInteger();

            state._fsp--;


            					if (current==null) {
            						current = createModelElementForParent(grammarAccess.getStructuralFeature_ImplRule());
            					}
            					set(
            						current,
            						"lower",
            						lv_lower_7_0,
            						"org.eclipse.m2m.km3.xtext.KM3.Integer");
            					afterParserOrEnumRuleCall();
            				

            }


            }

            otherlv_8=(Token)match(input,38,FOLLOW_24); 

            			newLeafNode(otherlv_8, grammarAccess.getStructuralFeature_ImplAccess().getUpperKeyword_8());
            		
            // InternalKM3.g:1487:3: ( (lv_upper_9_0= ruleInteger ) )
            // InternalKM3.g:1488:4: (lv_upper_9_0= ruleInteger )
            {
            // InternalKM3.g:1488:4: (lv_upper_9_0= ruleInteger )
            // InternalKM3.g:1489:5: lv_upper_9_0= ruleInteger
            {

            					newCompositeNode(grammarAccess.getStructuralFeature_ImplAccess().getUpperIntegerParserRuleCall_9_0());
            				
            pushFollow(FOLLOW_26);
            lv_upper_9_0=ruleInteger();

            state._fsp--;


            					if (current==null) {
            						current = createModelElementForParent(grammarAccess.getStructuralFeature_ImplRule());
            					}
            					set(
            						current,
            						"upper",
            						lv_upper_9_0,
            						"org.eclipse.m2m.km3.xtext.KM3.Integer");
            					afterParserOrEnumRuleCall();
            				

            }


            }

            otherlv_10=(Token)match(input,39,FOLLOW_18); 

            			newLeafNode(otherlv_10, grammarAccess.getStructuralFeature_ImplAccess().getIsOrderedKeyword_10());
            		
            // InternalKM3.g:1510:3: ( (lv_isOrdered_11_0= ruleBoolean ) )
            // InternalKM3.g:1511:4: (lv_isOrdered_11_0= ruleBoolean )
            {
            // InternalKM3.g:1511:4: (lv_isOrdered_11_0= ruleBoolean )
            // InternalKM3.g:1512:5: lv_isOrdered_11_0= ruleBoolean
            {

            					newCompositeNode(grammarAccess.getStructuralFeature_ImplAccess().getIsOrderedBooleanParserRuleCall_11_0());
            				
            pushFollow(FOLLOW_27);
            lv_isOrdered_11_0=ruleBoolean();

            state._fsp--;


            					if (current==null) {
            						current = createModelElementForParent(grammarAccess.getStructuralFeature_ImplRule());
            					}
            					set(
            						current,
            						"isOrdered",
            						lv_isOrdered_11_0,
            						"org.eclipse.m2m.km3.xtext.KM3.Boolean");
            					afterParserOrEnumRuleCall();
            				

            }


            }

            otherlv_12=(Token)match(input,40,FOLLOW_18); 

            			newLeafNode(otherlv_12, grammarAccess.getStructuralFeature_ImplAccess().getIsUniqueKeyword_12());
            		
            // InternalKM3.g:1533:3: ( (lv_isUnique_13_0= ruleBoolean ) )
            // InternalKM3.g:1534:4: (lv_isUnique_13_0= ruleBoolean )
            {
            // InternalKM3.g:1534:4: (lv_isUnique_13_0= ruleBoolean )
            // InternalKM3.g:1535:5: lv_isUnique_13_0= ruleBoolean
            {

            					newCompositeNode(grammarAccess.getStructuralFeature_ImplAccess().getIsUniqueBooleanParserRuleCall_13_0());
            				
            pushFollow(FOLLOW_28);
            lv_isUnique_13_0=ruleBoolean();

            state._fsp--;


            					if (current==null) {
            						current = createModelElementForParent(grammarAccess.getStructuralFeature_ImplRule());
            					}
            					set(
            						current,
            						"isUnique",
            						lv_isUnique_13_0,
            						"org.eclipse.m2m.km3.xtext.KM3.Boolean");
            					afterParserOrEnumRuleCall();
            				

            }


            }

            otherlv_14=(Token)match(input,41,FOLLOW_8); 

            			newLeafNode(otherlv_14, grammarAccess.getStructuralFeature_ImplAccess().getTypeKeyword_14());
            		
            // InternalKM3.g:1556:3: ( (otherlv_15= RULE_STRING ) )
            // InternalKM3.g:1557:4: (otherlv_15= RULE_STRING )
            {
            // InternalKM3.g:1557:4: (otherlv_15= RULE_STRING )
            // InternalKM3.g:1558:5: otherlv_15= RULE_STRING
            {

            					if (current==null) {
            						current = createModelElement(grammarAccess.getStructuralFeature_ImplRule());
            					}
            				
            otherlv_15=(Token)match(input,RULE_STRING,FOLLOW_29); 

            					newLeafNode(otherlv_15, grammarAccess.getStructuralFeature_ImplAccess().getTypeClassifierCrossReference_15_0());
            				

            }


            }

            otherlv_16=(Token)match(input,43,FOLLOW_8); 

            			newLeafNode(otherlv_16, grammarAccess.getStructuralFeature_ImplAccess().getOwnerKeyword_16());
            		
            // InternalKM3.g:1573:3: ( (otherlv_17= RULE_STRING ) )
            // InternalKM3.g:1574:4: (otherlv_17= RULE_STRING )
            {
            // InternalKM3.g:1574:4: (otherlv_17= RULE_STRING )
            // InternalKM3.g:1575:5: otherlv_17= RULE_STRING
            {

            					if (current==null) {
            						current = createModelElement(grammarAccess.getStructuralFeature_ImplRule());
            					}
            				
            otherlv_17=(Token)match(input,RULE_STRING,FOLLOW_30); 

            					newLeafNode(otherlv_17, grammarAccess.getStructuralFeature_ImplAccess().getOwnerClassCrossReference_17_0());
            				

            }


            }

            // InternalKM3.g:1586:3: (otherlv_18= 'subsetOf' otherlv_19= '(' ( (otherlv_20= RULE_STRING ) ) (otherlv_21= ',' ( (otherlv_22= RULE_STRING ) ) )* otherlv_23= ')' )?
            int alt17=2;
            int LA17_0 = input.LA(1);

            if ( (LA17_0==44) ) {
                alt17=1;
            }
            switch (alt17) {
                case 1 :
                    // InternalKM3.g:1587:4: otherlv_18= 'subsetOf' otherlv_19= '(' ( (otherlv_20= RULE_STRING ) ) (otherlv_21= ',' ( (otherlv_22= RULE_STRING ) ) )* otherlv_23= ')'
                    {
                    otherlv_18=(Token)match(input,44,FOLLOW_7); 

                    				newLeafNode(otherlv_18, grammarAccess.getStructuralFeature_ImplAccess().getSubsetOfKeyword_18_0());
                    			
                    otherlv_19=(Token)match(input,15,FOLLOW_8); 

                    				newLeafNode(otherlv_19, grammarAccess.getStructuralFeature_ImplAccess().getLeftParenthesisKeyword_18_1());
                    			
                    // InternalKM3.g:1595:4: ( (otherlv_20= RULE_STRING ) )
                    // InternalKM3.g:1596:5: (otherlv_20= RULE_STRING )
                    {
                    // InternalKM3.g:1596:5: (otherlv_20= RULE_STRING )
                    // InternalKM3.g:1597:6: otherlv_20= RULE_STRING
                    {

                    						if (current==null) {
                    							current = createModelElement(grammarAccess.getStructuralFeature_ImplRule());
                    						}
                    					
                    otherlv_20=(Token)match(input,RULE_STRING,FOLLOW_9); 

                    						newLeafNode(otherlv_20, grammarAccess.getStructuralFeature_ImplAccess().getSubsetOfStructuralFeatureCrossReference_18_2_0());
                    					

                    }


                    }

                    // InternalKM3.g:1608:4: (otherlv_21= ',' ( (otherlv_22= RULE_STRING ) ) )*
                    loop16:
                    do {
                        int alt16=2;
                        int LA16_0 = input.LA(1);

                        if ( (LA16_0==16) ) {
                            alt16=1;
                        }


                        switch (alt16) {
                    	case 1 :
                    	    // InternalKM3.g:1609:5: otherlv_21= ',' ( (otherlv_22= RULE_STRING ) )
                    	    {
                    	    otherlv_21=(Token)match(input,16,FOLLOW_8); 

                    	    					newLeafNode(otherlv_21, grammarAccess.getStructuralFeature_ImplAccess().getCommaKeyword_18_3_0());
                    	    				
                    	    // InternalKM3.g:1613:5: ( (otherlv_22= RULE_STRING ) )
                    	    // InternalKM3.g:1614:6: (otherlv_22= RULE_STRING )
                    	    {
                    	    // InternalKM3.g:1614:6: (otherlv_22= RULE_STRING )
                    	    // InternalKM3.g:1615:7: otherlv_22= RULE_STRING
                    	    {

                    	    							if (current==null) {
                    	    								current = createModelElement(grammarAccess.getStructuralFeature_ImplRule());
                    	    							}
                    	    						
                    	    otherlv_22=(Token)match(input,RULE_STRING,FOLLOW_9); 

                    	    							newLeafNode(otherlv_22, grammarAccess.getStructuralFeature_ImplAccess().getSubsetOfStructuralFeatureCrossReference_18_3_1_0());
                    	    						

                    	    }


                    	    }


                    	    }
                    	    break;

                    	default :
                    	    break loop16;
                        }
                    } while (true);

                    otherlv_23=(Token)match(input,17,FOLLOW_31); 

                    				newLeafNode(otherlv_23, grammarAccess.getStructuralFeature_ImplAccess().getRightParenthesisKeyword_18_4());
                    			

                    }
                    break;

            }

            // InternalKM3.g:1632:3: (otherlv_24= 'derivedFrom' otherlv_25= '(' ( (otherlv_26= RULE_STRING ) ) (otherlv_27= ',' ( (otherlv_28= RULE_STRING ) ) )* otherlv_29= ')' )?
            int alt19=2;
            int LA19_0 = input.LA(1);

            if ( (LA19_0==45) ) {
                alt19=1;
            }
            switch (alt19) {
                case 1 :
                    // InternalKM3.g:1633:4: otherlv_24= 'derivedFrom' otherlv_25= '(' ( (otherlv_26= RULE_STRING ) ) (otherlv_27= ',' ( (otherlv_28= RULE_STRING ) ) )* otherlv_29= ')'
                    {
                    otherlv_24=(Token)match(input,45,FOLLOW_7); 

                    				newLeafNode(otherlv_24, grammarAccess.getStructuralFeature_ImplAccess().getDerivedFromKeyword_19_0());
                    			
                    otherlv_25=(Token)match(input,15,FOLLOW_8); 

                    				newLeafNode(otherlv_25, grammarAccess.getStructuralFeature_ImplAccess().getLeftParenthesisKeyword_19_1());
                    			
                    // InternalKM3.g:1641:4: ( (otherlv_26= RULE_STRING ) )
                    // InternalKM3.g:1642:5: (otherlv_26= RULE_STRING )
                    {
                    // InternalKM3.g:1642:5: (otherlv_26= RULE_STRING )
                    // InternalKM3.g:1643:6: otherlv_26= RULE_STRING
                    {

                    						if (current==null) {
                    							current = createModelElement(grammarAccess.getStructuralFeature_ImplRule());
                    						}
                    					
                    otherlv_26=(Token)match(input,RULE_STRING,FOLLOW_9); 

                    						newLeafNode(otherlv_26, grammarAccess.getStructuralFeature_ImplAccess().getDerivedFromStructuralFeatureCrossReference_19_2_0());
                    					

                    }


                    }

                    // InternalKM3.g:1654:4: (otherlv_27= ',' ( (otherlv_28= RULE_STRING ) ) )*
                    loop18:
                    do {
                        int alt18=2;
                        int LA18_0 = input.LA(1);

                        if ( (LA18_0==16) ) {
                            alt18=1;
                        }


                        switch (alt18) {
                    	case 1 :
                    	    // InternalKM3.g:1655:5: otherlv_27= ',' ( (otherlv_28= RULE_STRING ) )
                    	    {
                    	    otherlv_27=(Token)match(input,16,FOLLOW_8); 

                    	    					newLeafNode(otherlv_27, grammarAccess.getStructuralFeature_ImplAccess().getCommaKeyword_19_3_0());
                    	    				
                    	    // InternalKM3.g:1659:5: ( (otherlv_28= RULE_STRING ) )
                    	    // InternalKM3.g:1660:6: (otherlv_28= RULE_STRING )
                    	    {
                    	    // InternalKM3.g:1660:6: (otherlv_28= RULE_STRING )
                    	    // InternalKM3.g:1661:7: otherlv_28= RULE_STRING
                    	    {

                    	    							if (current==null) {
                    	    								current = createModelElement(grammarAccess.getStructuralFeature_ImplRule());
                    	    							}
                    	    						
                    	    otherlv_28=(Token)match(input,RULE_STRING,FOLLOW_9); 

                    	    							newLeafNode(otherlv_28, grammarAccess.getStructuralFeature_ImplAccess().getDerivedFromStructuralFeatureCrossReference_19_3_1_0());
                    	    						

                    	    }


                    	    }


                    	    }
                    	    break;

                    	default :
                    	    break loop18;
                        }
                    } while (true);

                    otherlv_29=(Token)match(input,17,FOLLOW_10); 

                    				newLeafNode(otherlv_29, grammarAccess.getStructuralFeature_ImplAccess().getRightParenthesisKeyword_19_4());
                    			

                    }
                    break;

            }

            otherlv_30=(Token)match(input,18,FOLLOW_2); 

            			newLeafNode(otherlv_30, grammarAccess.getStructuralFeature_ImplAccess().getRightCurlyBracketKeyword_20());
            		

            }


            }


            	leaveRule();

        }

            catch (RecognitionException re) {
                recover(input,re);
                appendSkippedTokens();
            }
        finally {
        }
        return current;
    }
    // $ANTLR end "ruleStructuralFeature_Impl"


    // $ANTLR start "entryRuleAttribute"
    // InternalKM3.g:1686:1: entryRuleAttribute returns [EObject current=null] : iv_ruleAttribute= ruleAttribute EOF ;
    public final EObject entryRuleAttribute() throws RecognitionException {
        EObject current = null;

        EObject iv_ruleAttribute = null;


        try {
            // InternalKM3.g:1686:50: (iv_ruleAttribute= ruleAttribute EOF )
            // InternalKM3.g:1687:2: iv_ruleAttribute= ruleAttribute EOF
            {
             newCompositeNode(grammarAccess.getAttributeRule()); 
            pushFollow(FOLLOW_1);
            iv_ruleAttribute=ruleAttribute();

            state._fsp--;

             current =iv_ruleAttribute; 
            match(input,EOF,FOLLOW_2); 

            }

        }

            catch (RecognitionException re) {
                recover(input,re);
                appendSkippedTokens();
            }
        finally {
        }
        return current;
    }
    // $ANTLR end "entryRuleAttribute"


    // $ANTLR start "ruleAttribute"
    // InternalKM3.g:1693:1: ruleAttribute returns [EObject current=null] : (otherlv_0= 'Attribute' otherlv_1= '{' otherlv_2= 'location' ( (lv_location_3_0= ruleString0 ) ) otherlv_4= 'name' ( (lv_name_5_0= ruleString0 ) ) otherlv_6= 'lower' ( (lv_lower_7_0= ruleInteger ) ) otherlv_8= 'upper' ( (lv_upper_9_0= ruleInteger ) ) otherlv_10= 'isOrdered' ( (lv_isOrdered_11_0= ruleBoolean ) ) otherlv_12= 'isUnique' ( (lv_isUnique_13_0= ruleBoolean ) ) otherlv_14= 'type' ( (otherlv_15= RULE_STRING ) ) otherlv_16= 'owner' ( (otherlv_17= RULE_STRING ) ) (otherlv_18= 'subsetOf' otherlv_19= '(' ( (otherlv_20= RULE_STRING ) ) (otherlv_21= ',' ( (otherlv_22= RULE_STRING ) ) )* otherlv_23= ')' )? (otherlv_24= 'derivedFrom' otherlv_25= '(' ( (otherlv_26= RULE_STRING ) ) (otherlv_27= ',' ( (otherlv_28= RULE_STRING ) ) )* otherlv_29= ')' )? otherlv_30= '}' ) ;
    public final EObject ruleAttribute() throws RecognitionException {
        EObject current = null;

        Token otherlv_0=null;
        Token otherlv_1=null;
        Token otherlv_2=null;
        Token otherlv_4=null;
        Token otherlv_6=null;
        Token otherlv_8=null;
        Token otherlv_10=null;
        Token otherlv_12=null;
        Token otherlv_14=null;
        Token otherlv_15=null;
        Token otherlv_16=null;
        Token otherlv_17=null;
        Token otherlv_18=null;
        Token otherlv_19=null;
        Token otherlv_20=null;
        Token otherlv_21=null;
        Token otherlv_22=null;
        Token otherlv_23=null;
        Token otherlv_24=null;
        Token otherlv_25=null;
        Token otherlv_26=null;
        Token otherlv_27=null;
        Token otherlv_28=null;
        Token otherlv_29=null;
        Token otherlv_30=null;
        AntlrDatatypeRuleToken lv_location_3_0 = null;

        AntlrDatatypeRuleToken lv_name_5_0 = null;

        AntlrDatatypeRuleToken lv_lower_7_0 = null;

        AntlrDatatypeRuleToken lv_upper_9_0 = null;

        AntlrDatatypeRuleToken lv_isOrdered_11_0 = null;

        AntlrDatatypeRuleToken lv_isUnique_13_0 = null;



        	enterRule();

        try {
            // InternalKM3.g:1699:2: ( (otherlv_0= 'Attribute' otherlv_1= '{' otherlv_2= 'location' ( (lv_location_3_0= ruleString0 ) ) otherlv_4= 'name' ( (lv_name_5_0= ruleString0 ) ) otherlv_6= 'lower' ( (lv_lower_7_0= ruleInteger ) ) otherlv_8= 'upper' ( (lv_upper_9_0= ruleInteger ) ) otherlv_10= 'isOrdered' ( (lv_isOrdered_11_0= ruleBoolean ) ) otherlv_12= 'isUnique' ( (lv_isUnique_13_0= ruleBoolean ) ) otherlv_14= 'type' ( (otherlv_15= RULE_STRING ) ) otherlv_16= 'owner' ( (otherlv_17= RULE_STRING ) ) (otherlv_18= 'subsetOf' otherlv_19= '(' ( (otherlv_20= RULE_STRING ) ) (otherlv_21= ',' ( (otherlv_22= RULE_STRING ) ) )* otherlv_23= ')' )? (otherlv_24= 'derivedFrom' otherlv_25= '(' ( (otherlv_26= RULE_STRING ) ) (otherlv_27= ',' ( (otherlv_28= RULE_STRING ) ) )* otherlv_29= ')' )? otherlv_30= '}' ) )
            // InternalKM3.g:1700:2: (otherlv_0= 'Attribute' otherlv_1= '{' otherlv_2= 'location' ( (lv_location_3_0= ruleString0 ) ) otherlv_4= 'name' ( (lv_name_5_0= ruleString0 ) ) otherlv_6= 'lower' ( (lv_lower_7_0= ruleInteger ) ) otherlv_8= 'upper' ( (lv_upper_9_0= ruleInteger ) ) otherlv_10= 'isOrdered' ( (lv_isOrdered_11_0= ruleBoolean ) ) otherlv_12= 'isUnique' ( (lv_isUnique_13_0= ruleBoolean ) ) otherlv_14= 'type' ( (otherlv_15= RULE_STRING ) ) otherlv_16= 'owner' ( (otherlv_17= RULE_STRING ) ) (otherlv_18= 'subsetOf' otherlv_19= '(' ( (otherlv_20= RULE_STRING ) ) (otherlv_21= ',' ( (otherlv_22= RULE_STRING ) ) )* otherlv_23= ')' )? (otherlv_24= 'derivedFrom' otherlv_25= '(' ( (otherlv_26= RULE_STRING ) ) (otherlv_27= ',' ( (otherlv_28= RULE_STRING ) ) )* otherlv_29= ')' )? otherlv_30= '}' )
            {
            // InternalKM3.g:1700:2: (otherlv_0= 'Attribute' otherlv_1= '{' otherlv_2= 'location' ( (lv_location_3_0= ruleString0 ) ) otherlv_4= 'name' ( (lv_name_5_0= ruleString0 ) ) otherlv_6= 'lower' ( (lv_lower_7_0= ruleInteger ) ) otherlv_8= 'upper' ( (lv_upper_9_0= ruleInteger ) ) otherlv_10= 'isOrdered' ( (lv_isOrdered_11_0= ruleBoolean ) ) otherlv_12= 'isUnique' ( (lv_isUnique_13_0= ruleBoolean ) ) otherlv_14= 'type' ( (otherlv_15= RULE_STRING ) ) otherlv_16= 'owner' ( (otherlv_17= RULE_STRING ) ) (otherlv_18= 'subsetOf' otherlv_19= '(' ( (otherlv_20= RULE_STRING ) ) (otherlv_21= ',' ( (otherlv_22= RULE_STRING ) ) )* otherlv_23= ')' )? (otherlv_24= 'derivedFrom' otherlv_25= '(' ( (otherlv_26= RULE_STRING ) ) (otherlv_27= ',' ( (otherlv_28= RULE_STRING ) ) )* otherlv_29= ')' )? otherlv_30= '}' )
            // InternalKM3.g:1701:3: otherlv_0= 'Attribute' otherlv_1= '{' otherlv_2= 'location' ( (lv_location_3_0= ruleString0 ) ) otherlv_4= 'name' ( (lv_name_5_0= ruleString0 ) ) otherlv_6= 'lower' ( (lv_lower_7_0= ruleInteger ) ) otherlv_8= 'upper' ( (lv_upper_9_0= ruleInteger ) ) otherlv_10= 'isOrdered' ( (lv_isOrdered_11_0= ruleBoolean ) ) otherlv_12= 'isUnique' ( (lv_isUnique_13_0= ruleBoolean ) ) otherlv_14= 'type' ( (otherlv_15= RULE_STRING ) ) otherlv_16= 'owner' ( (otherlv_17= RULE_STRING ) ) (otherlv_18= 'subsetOf' otherlv_19= '(' ( (otherlv_20= RULE_STRING ) ) (otherlv_21= ',' ( (otherlv_22= RULE_STRING ) ) )* otherlv_23= ')' )? (otherlv_24= 'derivedFrom' otherlv_25= '(' ( (otherlv_26= RULE_STRING ) ) (otherlv_27= ',' ( (otherlv_28= RULE_STRING ) ) )* otherlv_29= ')' )? otherlv_30= '}'
            {
            otherlv_0=(Token)match(input,46,FOLLOW_3); 

            			newLeafNode(otherlv_0, grammarAccess.getAttributeAccess().getAttributeKeyword_0());
            		
            otherlv_1=(Token)match(input,12,FOLLOW_4); 

            			newLeafNode(otherlv_1, grammarAccess.getAttributeAccess().getLeftCurlyBracketKeyword_1());
            		
            otherlv_2=(Token)match(input,13,FOLLOW_5); 

            			newLeafNode(otherlv_2, grammarAccess.getAttributeAccess().getLocationKeyword_2());
            		
            // InternalKM3.g:1713:3: ( (lv_location_3_0= ruleString0 ) )
            // InternalKM3.g:1714:4: (lv_location_3_0= ruleString0 )
            {
            // InternalKM3.g:1714:4: (lv_location_3_0= ruleString0 )
            // InternalKM3.g:1715:5: lv_location_3_0= ruleString0
            {

            					newCompositeNode(grammarAccess.getAttributeAccess().getLocationString0ParserRuleCall_3_0());
            				
            pushFollow(FOLLOW_11);
            lv_location_3_0=ruleString0();

            state._fsp--;


            					if (current==null) {
            						current = createModelElementForParent(grammarAccess.getAttributeRule());
            					}
            					set(
            						current,
            						"location",
            						lv_location_3_0,
            						"org.eclipse.m2m.km3.xtext.KM3.String0");
            					afterParserOrEnumRuleCall();
            				

            }


            }

            otherlv_4=(Token)match(input,21,FOLLOW_5); 

            			newLeafNode(otherlv_4, grammarAccess.getAttributeAccess().getNameKeyword_4());
            		
            // InternalKM3.g:1736:3: ( (lv_name_5_0= ruleString0 ) )
            // InternalKM3.g:1737:4: (lv_name_5_0= ruleString0 )
            {
            // InternalKM3.g:1737:4: (lv_name_5_0= ruleString0 )
            // InternalKM3.g:1738:5: lv_name_5_0= ruleString0
            {

            					newCompositeNode(grammarAccess.getAttributeAccess().getNameString0ParserRuleCall_5_0());
            				
            pushFollow(FOLLOW_23);
            lv_name_5_0=ruleString0();

            state._fsp--;


            					if (current==null) {
            						current = createModelElementForParent(grammarAccess.getAttributeRule());
            					}
            					set(
            						current,
            						"name",
            						lv_name_5_0,
            						"org.eclipse.m2m.km3.xtext.KM3.String0");
            					afterParserOrEnumRuleCall();
            				

            }


            }

            otherlv_6=(Token)match(input,37,FOLLOW_24); 

            			newLeafNode(otherlv_6, grammarAccess.getAttributeAccess().getLowerKeyword_6());
            		
            // InternalKM3.g:1759:3: ( (lv_lower_7_0= ruleInteger ) )
            // InternalKM3.g:1760:4: (lv_lower_7_0= ruleInteger )
            {
            // InternalKM3.g:1760:4: (lv_lower_7_0= ruleInteger )
            // InternalKM3.g:1761:5: lv_lower_7_0= ruleInteger
            {

            					newCompositeNode(grammarAccess.getAttributeAccess().getLowerIntegerParserRuleCall_7_0());
            				
            pushFollow(FOLLOW_25);
            lv_lower_7_0=ruleInteger();

            state._fsp--;


            					if (current==null) {
            						current = createModelElementForParent(grammarAccess.getAttributeRule());
            					}
            					set(
            						current,
            						"lower",
            						lv_lower_7_0,
            						"org.eclipse.m2m.km3.xtext.KM3.Integer");
            					afterParserOrEnumRuleCall();
            				

            }


            }

            otherlv_8=(Token)match(input,38,FOLLOW_24); 

            			newLeafNode(otherlv_8, grammarAccess.getAttributeAccess().getUpperKeyword_8());
            		
            // InternalKM3.g:1782:3: ( (lv_upper_9_0= ruleInteger ) )
            // InternalKM3.g:1783:4: (lv_upper_9_0= ruleInteger )
            {
            // InternalKM3.g:1783:4: (lv_upper_9_0= ruleInteger )
            // InternalKM3.g:1784:5: lv_upper_9_0= ruleInteger
            {

            					newCompositeNode(grammarAccess.getAttributeAccess().getUpperIntegerParserRuleCall_9_0());
            				
            pushFollow(FOLLOW_26);
            lv_upper_9_0=ruleInteger();

            state._fsp--;


            					if (current==null) {
            						current = createModelElementForParent(grammarAccess.getAttributeRule());
            					}
            					set(
            						current,
            						"upper",
            						lv_upper_9_0,
            						"org.eclipse.m2m.km3.xtext.KM3.Integer");
            					afterParserOrEnumRuleCall();
            				

            }


            }

            otherlv_10=(Token)match(input,39,FOLLOW_18); 

            			newLeafNode(otherlv_10, grammarAccess.getAttributeAccess().getIsOrderedKeyword_10());
            		
            // InternalKM3.g:1805:3: ( (lv_isOrdered_11_0= ruleBoolean ) )
            // InternalKM3.g:1806:4: (lv_isOrdered_11_0= ruleBoolean )
            {
            // InternalKM3.g:1806:4: (lv_isOrdered_11_0= ruleBoolean )
            // InternalKM3.g:1807:5: lv_isOrdered_11_0= ruleBoolean
            {

            					newCompositeNode(grammarAccess.getAttributeAccess().getIsOrderedBooleanParserRuleCall_11_0());
            				
            pushFollow(FOLLOW_27);
            lv_isOrdered_11_0=ruleBoolean();

            state._fsp--;


            					if (current==null) {
            						current = createModelElementForParent(grammarAccess.getAttributeRule());
            					}
            					set(
            						current,
            						"isOrdered",
            						lv_isOrdered_11_0,
            						"org.eclipse.m2m.km3.xtext.KM3.Boolean");
            					afterParserOrEnumRuleCall();
            				

            }


            }

            otherlv_12=(Token)match(input,40,FOLLOW_18); 

            			newLeafNode(otherlv_12, grammarAccess.getAttributeAccess().getIsUniqueKeyword_12());
            		
            // InternalKM3.g:1828:3: ( (lv_isUnique_13_0= ruleBoolean ) )
            // InternalKM3.g:1829:4: (lv_isUnique_13_0= ruleBoolean )
            {
            // InternalKM3.g:1829:4: (lv_isUnique_13_0= ruleBoolean )
            // InternalKM3.g:1830:5: lv_isUnique_13_0= ruleBoolean
            {

            					newCompositeNode(grammarAccess.getAttributeAccess().getIsUniqueBooleanParserRuleCall_13_0());
            				
            pushFollow(FOLLOW_28);
            lv_isUnique_13_0=ruleBoolean();

            state._fsp--;


            					if (current==null) {
            						current = createModelElementForParent(grammarAccess.getAttributeRule());
            					}
            					set(
            						current,
            						"isUnique",
            						lv_isUnique_13_0,
            						"org.eclipse.m2m.km3.xtext.KM3.Boolean");
            					afterParserOrEnumRuleCall();
            				

            }


            }

            otherlv_14=(Token)match(input,41,FOLLOW_8); 

            			newLeafNode(otherlv_14, grammarAccess.getAttributeAccess().getTypeKeyword_14());
            		
            // InternalKM3.g:1851:3: ( (otherlv_15= RULE_STRING ) )
            // InternalKM3.g:1852:4: (otherlv_15= RULE_STRING )
            {
            // InternalKM3.g:1852:4: (otherlv_15= RULE_STRING )
            // InternalKM3.g:1853:5: otherlv_15= RULE_STRING
            {

            					if (current==null) {
            						current = createModelElement(grammarAccess.getAttributeRule());
            					}
            				
            otherlv_15=(Token)match(input,RULE_STRING,FOLLOW_29); 

            					newLeafNode(otherlv_15, grammarAccess.getAttributeAccess().getTypeClassifierCrossReference_15_0());
            				

            }


            }

            otherlv_16=(Token)match(input,43,FOLLOW_8); 

            			newLeafNode(otherlv_16, grammarAccess.getAttributeAccess().getOwnerKeyword_16());
            		
            // InternalKM3.g:1868:3: ( (otherlv_17= RULE_STRING ) )
            // InternalKM3.g:1869:4: (otherlv_17= RULE_STRING )
            {
            // InternalKM3.g:1869:4: (otherlv_17= RULE_STRING )
            // InternalKM3.g:1870:5: otherlv_17= RULE_STRING
            {

            					if (current==null) {
            						current = createModelElement(grammarAccess.getAttributeRule());
            					}
            				
            otherlv_17=(Token)match(input,RULE_STRING,FOLLOW_30); 

            					newLeafNode(otherlv_17, grammarAccess.getAttributeAccess().getOwnerClassCrossReference_17_0());
            				

            }


            }

            // InternalKM3.g:1881:3: (otherlv_18= 'subsetOf' otherlv_19= '(' ( (otherlv_20= RULE_STRING ) ) (otherlv_21= ',' ( (otherlv_22= RULE_STRING ) ) )* otherlv_23= ')' )?
            int alt21=2;
            int LA21_0 = input.LA(1);

            if ( (LA21_0==44) ) {
                alt21=1;
            }
            switch (alt21) {
                case 1 :
                    // InternalKM3.g:1882:4: otherlv_18= 'subsetOf' otherlv_19= '(' ( (otherlv_20= RULE_STRING ) ) (otherlv_21= ',' ( (otherlv_22= RULE_STRING ) ) )* otherlv_23= ')'
                    {
                    otherlv_18=(Token)match(input,44,FOLLOW_7); 

                    				newLeafNode(otherlv_18, grammarAccess.getAttributeAccess().getSubsetOfKeyword_18_0());
                    			
                    otherlv_19=(Token)match(input,15,FOLLOW_8); 

                    				newLeafNode(otherlv_19, grammarAccess.getAttributeAccess().getLeftParenthesisKeyword_18_1());
                    			
                    // InternalKM3.g:1890:4: ( (otherlv_20= RULE_STRING ) )
                    // InternalKM3.g:1891:5: (otherlv_20= RULE_STRING )
                    {
                    // InternalKM3.g:1891:5: (otherlv_20= RULE_STRING )
                    // InternalKM3.g:1892:6: otherlv_20= RULE_STRING
                    {

                    						if (current==null) {
                    							current = createModelElement(grammarAccess.getAttributeRule());
                    						}
                    					
                    otherlv_20=(Token)match(input,RULE_STRING,FOLLOW_9); 

                    						newLeafNode(otherlv_20, grammarAccess.getAttributeAccess().getSubsetOfStructuralFeatureCrossReference_18_2_0());
                    					

                    }


                    }

                    // InternalKM3.g:1903:4: (otherlv_21= ',' ( (otherlv_22= RULE_STRING ) ) )*
                    loop20:
                    do {
                        int alt20=2;
                        int LA20_0 = input.LA(1);

                        if ( (LA20_0==16) ) {
                            alt20=1;
                        }


                        switch (alt20) {
                    	case 1 :
                    	    // InternalKM3.g:1904:5: otherlv_21= ',' ( (otherlv_22= RULE_STRING ) )
                    	    {
                    	    otherlv_21=(Token)match(input,16,FOLLOW_8); 

                    	    					newLeafNode(otherlv_21, grammarAccess.getAttributeAccess().getCommaKeyword_18_3_0());
                    	    				
                    	    // InternalKM3.g:1908:5: ( (otherlv_22= RULE_STRING ) )
                    	    // InternalKM3.g:1909:6: (otherlv_22= RULE_STRING )
                    	    {
                    	    // InternalKM3.g:1909:6: (otherlv_22= RULE_STRING )
                    	    // InternalKM3.g:1910:7: otherlv_22= RULE_STRING
                    	    {

                    	    							if (current==null) {
                    	    								current = createModelElement(grammarAccess.getAttributeRule());
                    	    							}
                    	    						
                    	    otherlv_22=(Token)match(input,RULE_STRING,FOLLOW_9); 

                    	    							newLeafNode(otherlv_22, grammarAccess.getAttributeAccess().getSubsetOfStructuralFeatureCrossReference_18_3_1_0());
                    	    						

                    	    }


                    	    }


                    	    }
                    	    break;

                    	default :
                    	    break loop20;
                        }
                    } while (true);

                    otherlv_23=(Token)match(input,17,FOLLOW_31); 

                    				newLeafNode(otherlv_23, grammarAccess.getAttributeAccess().getRightParenthesisKeyword_18_4());
                    			

                    }
                    break;

            }

            // InternalKM3.g:1927:3: (otherlv_24= 'derivedFrom' otherlv_25= '(' ( (otherlv_26= RULE_STRING ) ) (otherlv_27= ',' ( (otherlv_28= RULE_STRING ) ) )* otherlv_29= ')' )?
            int alt23=2;
            int LA23_0 = input.LA(1);

            if ( (LA23_0==45) ) {
                alt23=1;
            }
            switch (alt23) {
                case 1 :
                    // InternalKM3.g:1928:4: otherlv_24= 'derivedFrom' otherlv_25= '(' ( (otherlv_26= RULE_STRING ) ) (otherlv_27= ',' ( (otherlv_28= RULE_STRING ) ) )* otherlv_29= ')'
                    {
                    otherlv_24=(Token)match(input,45,FOLLOW_7); 

                    				newLeafNode(otherlv_24, grammarAccess.getAttributeAccess().getDerivedFromKeyword_19_0());
                    			
                    otherlv_25=(Token)match(input,15,FOLLOW_8); 

                    				newLeafNode(otherlv_25, grammarAccess.getAttributeAccess().getLeftParenthesisKeyword_19_1());
                    			
                    // InternalKM3.g:1936:4: ( (otherlv_26= RULE_STRING ) )
                    // InternalKM3.g:1937:5: (otherlv_26= RULE_STRING )
                    {
                    // InternalKM3.g:1937:5: (otherlv_26= RULE_STRING )
                    // InternalKM3.g:1938:6: otherlv_26= RULE_STRING
                    {

                    						if (current==null) {
                    							current = createModelElement(grammarAccess.getAttributeRule());
                    						}
                    					
                    otherlv_26=(Token)match(input,RULE_STRING,FOLLOW_9); 

                    						newLeafNode(otherlv_26, grammarAccess.getAttributeAccess().getDerivedFromStructuralFeatureCrossReference_19_2_0());
                    					

                    }


                    }

                    // InternalKM3.g:1949:4: (otherlv_27= ',' ( (otherlv_28= RULE_STRING ) ) )*
                    loop22:
                    do {
                        int alt22=2;
                        int LA22_0 = input.LA(1);

                        if ( (LA22_0==16) ) {
                            alt22=1;
                        }


                        switch (alt22) {
                    	case 1 :
                    	    // InternalKM3.g:1950:5: otherlv_27= ',' ( (otherlv_28= RULE_STRING ) )
                    	    {
                    	    otherlv_27=(Token)match(input,16,FOLLOW_8); 

                    	    					newLeafNode(otherlv_27, grammarAccess.getAttributeAccess().getCommaKeyword_19_3_0());
                    	    				
                    	    // InternalKM3.g:1954:5: ( (otherlv_28= RULE_STRING ) )
                    	    // InternalKM3.g:1955:6: (otherlv_28= RULE_STRING )
                    	    {
                    	    // InternalKM3.g:1955:6: (otherlv_28= RULE_STRING )
                    	    // InternalKM3.g:1956:7: otherlv_28= RULE_STRING
                    	    {

                    	    							if (current==null) {
                    	    								current = createModelElement(grammarAccess.getAttributeRule());
                    	    							}
                    	    						
                    	    otherlv_28=(Token)match(input,RULE_STRING,FOLLOW_9); 

                    	    							newLeafNode(otherlv_28, grammarAccess.getAttributeAccess().getDerivedFromStructuralFeatureCrossReference_19_3_1_0());
                    	    						

                    	    }


                    	    }


                    	    }
                    	    break;

                    	default :
                    	    break loop22;
                        }
                    } while (true);

                    otherlv_29=(Token)match(input,17,FOLLOW_10); 

                    				newLeafNode(otherlv_29, grammarAccess.getAttributeAccess().getRightParenthesisKeyword_19_4());
                    			

                    }
                    break;

            }

            otherlv_30=(Token)match(input,18,FOLLOW_2); 

            			newLeafNode(otherlv_30, grammarAccess.getAttributeAccess().getRightCurlyBracketKeyword_20());
            		

            }


            }


            	leaveRule();

        }

            catch (RecognitionException re) {
                recover(input,re);
                appendSkippedTokens();
            }
        finally {
        }
        return current;
    }
    // $ANTLR end "ruleAttribute"


    // $ANTLR start "entryRuleReference"
    // InternalKM3.g:1981:1: entryRuleReference returns [EObject current=null] : iv_ruleReference= ruleReference EOF ;
    public final EObject entryRuleReference() throws RecognitionException {
        EObject current = null;

        EObject iv_ruleReference = null;


        try {
            // InternalKM3.g:1981:50: (iv_ruleReference= ruleReference EOF )
            // InternalKM3.g:1982:2: iv_ruleReference= ruleReference EOF
            {
             newCompositeNode(grammarAccess.getReferenceRule()); 
            pushFollow(FOLLOW_1);
            iv_ruleReference=ruleReference();

            state._fsp--;

             current =iv_ruleReference; 
            match(input,EOF,FOLLOW_2); 

            }

        }

            catch (RecognitionException re) {
                recover(input,re);
                appendSkippedTokens();
            }
        finally {
        }
        return current;
    }
    // $ANTLR end "entryRuleReference"


    // $ANTLR start "ruleReference"
    // InternalKM3.g:1988:1: ruleReference returns [EObject current=null] : (otherlv_0= 'Reference' otherlv_1= '{' otherlv_2= 'location' ( (lv_location_3_0= ruleString0 ) ) otherlv_4= 'name' ( (lv_name_5_0= ruleString0 ) ) otherlv_6= 'lower' ( (lv_lower_7_0= ruleInteger ) ) otherlv_8= 'upper' ( (lv_upper_9_0= ruleInteger ) ) otherlv_10= 'isOrdered' ( (lv_isOrdered_11_0= ruleBoolean ) ) otherlv_12= 'isUnique' ( (lv_isUnique_13_0= ruleBoolean ) ) otherlv_14= 'isContainer' ( (lv_isContainer_15_0= ruleBoolean ) ) otherlv_16= 'type' ( (otherlv_17= RULE_STRING ) ) otherlv_18= 'owner' ( (otherlv_19= RULE_STRING ) ) (otherlv_20= 'subsetOf' otherlv_21= '(' ( (otherlv_22= RULE_STRING ) ) (otherlv_23= ',' ( (otherlv_24= RULE_STRING ) ) )* otherlv_25= ')' )? (otherlv_26= 'derivedFrom' otherlv_27= '(' ( (otherlv_28= RULE_STRING ) ) (otherlv_29= ',' ( (otherlv_30= RULE_STRING ) ) )* otherlv_31= ')' )? (otherlv_32= 'opposite' ( (otherlv_33= RULE_STRING ) ) )? otherlv_34= '}' ) ;
    public final EObject ruleReference() throws RecognitionException {
        EObject current = null;

        Token otherlv_0=null;
        Token otherlv_1=null;
        Token otherlv_2=null;
        Token otherlv_4=null;
        Token otherlv_6=null;
        Token otherlv_8=null;
        Token otherlv_10=null;
        Token otherlv_12=null;
        Token otherlv_14=null;
        Token otherlv_16=null;
        Token otherlv_17=null;
        Token otherlv_18=null;
        Token otherlv_19=null;
        Token otherlv_20=null;
        Token otherlv_21=null;
        Token otherlv_22=null;
        Token otherlv_23=null;
        Token otherlv_24=null;
        Token otherlv_25=null;
        Token otherlv_26=null;
        Token otherlv_27=null;
        Token otherlv_28=null;
        Token otherlv_29=null;
        Token otherlv_30=null;
        Token otherlv_31=null;
        Token otherlv_32=null;
        Token otherlv_33=null;
        Token otherlv_34=null;
        AntlrDatatypeRuleToken lv_location_3_0 = null;

        AntlrDatatypeRuleToken lv_name_5_0 = null;

        AntlrDatatypeRuleToken lv_lower_7_0 = null;

        AntlrDatatypeRuleToken lv_upper_9_0 = null;

        AntlrDatatypeRuleToken lv_isOrdered_11_0 = null;

        AntlrDatatypeRuleToken lv_isUnique_13_0 = null;

        AntlrDatatypeRuleToken lv_isContainer_15_0 = null;



        	enterRule();

        try {
            // InternalKM3.g:1994:2: ( (otherlv_0= 'Reference' otherlv_1= '{' otherlv_2= 'location' ( (lv_location_3_0= ruleString0 ) ) otherlv_4= 'name' ( (lv_name_5_0= ruleString0 ) ) otherlv_6= 'lower' ( (lv_lower_7_0= ruleInteger ) ) otherlv_8= 'upper' ( (lv_upper_9_0= ruleInteger ) ) otherlv_10= 'isOrdered' ( (lv_isOrdered_11_0= ruleBoolean ) ) otherlv_12= 'isUnique' ( (lv_isUnique_13_0= ruleBoolean ) ) otherlv_14= 'isContainer' ( (lv_isContainer_15_0= ruleBoolean ) ) otherlv_16= 'type' ( (otherlv_17= RULE_STRING ) ) otherlv_18= 'owner' ( (otherlv_19= RULE_STRING ) ) (otherlv_20= 'subsetOf' otherlv_21= '(' ( (otherlv_22= RULE_STRING ) ) (otherlv_23= ',' ( (otherlv_24= RULE_STRING ) ) )* otherlv_25= ')' )? (otherlv_26= 'derivedFrom' otherlv_27= '(' ( (otherlv_28= RULE_STRING ) ) (otherlv_29= ',' ( (otherlv_30= RULE_STRING ) ) )* otherlv_31= ')' )? (otherlv_32= 'opposite' ( (otherlv_33= RULE_STRING ) ) )? otherlv_34= '}' ) )
            // InternalKM3.g:1995:2: (otherlv_0= 'Reference' otherlv_1= '{' otherlv_2= 'location' ( (lv_location_3_0= ruleString0 ) ) otherlv_4= 'name' ( (lv_name_5_0= ruleString0 ) ) otherlv_6= 'lower' ( (lv_lower_7_0= ruleInteger ) ) otherlv_8= 'upper' ( (lv_upper_9_0= ruleInteger ) ) otherlv_10= 'isOrdered' ( (lv_isOrdered_11_0= ruleBoolean ) ) otherlv_12= 'isUnique' ( (lv_isUnique_13_0= ruleBoolean ) ) otherlv_14= 'isContainer' ( (lv_isContainer_15_0= ruleBoolean ) ) otherlv_16= 'type' ( (otherlv_17= RULE_STRING ) ) otherlv_18= 'owner' ( (otherlv_19= RULE_STRING ) ) (otherlv_20= 'subsetOf' otherlv_21= '(' ( (otherlv_22= RULE_STRING ) ) (otherlv_23= ',' ( (otherlv_24= RULE_STRING ) ) )* otherlv_25= ')' )? (otherlv_26= 'derivedFrom' otherlv_27= '(' ( (otherlv_28= RULE_STRING ) ) (otherlv_29= ',' ( (otherlv_30= RULE_STRING ) ) )* otherlv_31= ')' )? (otherlv_32= 'opposite' ( (otherlv_33= RULE_STRING ) ) )? otherlv_34= '}' )
            {
            // InternalKM3.g:1995:2: (otherlv_0= 'Reference' otherlv_1= '{' otherlv_2= 'location' ( (lv_location_3_0= ruleString0 ) ) otherlv_4= 'name' ( (lv_name_5_0= ruleString0 ) ) otherlv_6= 'lower' ( (lv_lower_7_0= ruleInteger ) ) otherlv_8= 'upper' ( (lv_upper_9_0= ruleInteger ) ) otherlv_10= 'isOrdered' ( (lv_isOrdered_11_0= ruleBoolean ) ) otherlv_12= 'isUnique' ( (lv_isUnique_13_0= ruleBoolean ) ) otherlv_14= 'isContainer' ( (lv_isContainer_15_0= ruleBoolean ) ) otherlv_16= 'type' ( (otherlv_17= RULE_STRING ) ) otherlv_18= 'owner' ( (otherlv_19= RULE_STRING ) ) (otherlv_20= 'subsetOf' otherlv_21= '(' ( (otherlv_22= RULE_STRING ) ) (otherlv_23= ',' ( (otherlv_24= RULE_STRING ) ) )* otherlv_25= ')' )? (otherlv_26= 'derivedFrom' otherlv_27= '(' ( (otherlv_28= RULE_STRING ) ) (otherlv_29= ',' ( (otherlv_30= RULE_STRING ) ) )* otherlv_31= ')' )? (otherlv_32= 'opposite' ( (otherlv_33= RULE_STRING ) ) )? otherlv_34= '}' )
            // InternalKM3.g:1996:3: otherlv_0= 'Reference' otherlv_1= '{' otherlv_2= 'location' ( (lv_location_3_0= ruleString0 ) ) otherlv_4= 'name' ( (lv_name_5_0= ruleString0 ) ) otherlv_6= 'lower' ( (lv_lower_7_0= ruleInteger ) ) otherlv_8= 'upper' ( (lv_upper_9_0= ruleInteger ) ) otherlv_10= 'isOrdered' ( (lv_isOrdered_11_0= ruleBoolean ) ) otherlv_12= 'isUnique' ( (lv_isUnique_13_0= ruleBoolean ) ) otherlv_14= 'isContainer' ( (lv_isContainer_15_0= ruleBoolean ) ) otherlv_16= 'type' ( (otherlv_17= RULE_STRING ) ) otherlv_18= 'owner' ( (otherlv_19= RULE_STRING ) ) (otherlv_20= 'subsetOf' otherlv_21= '(' ( (otherlv_22= RULE_STRING ) ) (otherlv_23= ',' ( (otherlv_24= RULE_STRING ) ) )* otherlv_25= ')' )? (otherlv_26= 'derivedFrom' otherlv_27= '(' ( (otherlv_28= RULE_STRING ) ) (otherlv_29= ',' ( (otherlv_30= RULE_STRING ) ) )* otherlv_31= ')' )? (otherlv_32= 'opposite' ( (otherlv_33= RULE_STRING ) ) )? otherlv_34= '}'
            {
            otherlv_0=(Token)match(input,47,FOLLOW_3); 

            			newLeafNode(otherlv_0, grammarAccess.getReferenceAccess().getReferenceKeyword_0());
            		
            otherlv_1=(Token)match(input,12,FOLLOW_4); 

            			newLeafNode(otherlv_1, grammarAccess.getReferenceAccess().getLeftCurlyBracketKeyword_1());
            		
            otherlv_2=(Token)match(input,13,FOLLOW_5); 

            			newLeafNode(otherlv_2, grammarAccess.getReferenceAccess().getLocationKeyword_2());
            		
            // InternalKM3.g:2008:3: ( (lv_location_3_0= ruleString0 ) )
            // InternalKM3.g:2009:4: (lv_location_3_0= ruleString0 )
            {
            // InternalKM3.g:2009:4: (lv_location_3_0= ruleString0 )
            // InternalKM3.g:2010:5: lv_location_3_0= ruleString0
            {

            					newCompositeNode(grammarAccess.getReferenceAccess().getLocationString0ParserRuleCall_3_0());
            				
            pushFollow(FOLLOW_11);
            lv_location_3_0=ruleString0();

            state._fsp--;


            					if (current==null) {
            						current = createModelElementForParent(grammarAccess.getReferenceRule());
            					}
            					set(
            						current,
            						"location",
            						lv_location_3_0,
            						"org.eclipse.m2m.km3.xtext.KM3.String0");
            					afterParserOrEnumRuleCall();
            				

            }


            }

            otherlv_4=(Token)match(input,21,FOLLOW_5); 

            			newLeafNode(otherlv_4, grammarAccess.getReferenceAccess().getNameKeyword_4());
            		
            // InternalKM3.g:2031:3: ( (lv_name_5_0= ruleString0 ) )
            // InternalKM3.g:2032:4: (lv_name_5_0= ruleString0 )
            {
            // InternalKM3.g:2032:4: (lv_name_5_0= ruleString0 )
            // InternalKM3.g:2033:5: lv_name_5_0= ruleString0
            {

            					newCompositeNode(grammarAccess.getReferenceAccess().getNameString0ParserRuleCall_5_0());
            				
            pushFollow(FOLLOW_23);
            lv_name_5_0=ruleString0();

            state._fsp--;


            					if (current==null) {
            						current = createModelElementForParent(grammarAccess.getReferenceRule());
            					}
            					set(
            						current,
            						"name",
            						lv_name_5_0,
            						"org.eclipse.m2m.km3.xtext.KM3.String0");
            					afterParserOrEnumRuleCall();
            				

            }


            }

            otherlv_6=(Token)match(input,37,FOLLOW_24); 

            			newLeafNode(otherlv_6, grammarAccess.getReferenceAccess().getLowerKeyword_6());
            		
            // InternalKM3.g:2054:3: ( (lv_lower_7_0= ruleInteger ) )
            // InternalKM3.g:2055:4: (lv_lower_7_0= ruleInteger )
            {
            // InternalKM3.g:2055:4: (lv_lower_7_0= ruleInteger )
            // InternalKM3.g:2056:5: lv_lower_7_0= ruleInteger
            {

            					newCompositeNode(grammarAccess.getReferenceAccess().getLowerIntegerParserRuleCall_7_0());
            				
            pushFollow(FOLLOW_25);
            lv_lower_7_0=ruleInteger();

            state._fsp--;


            					if (current==null) {
            						current = createModelElementForParent(grammarAccess.getReferenceRule());
            					}
            					set(
            						current,
            						"lower",
            						lv_lower_7_0,
            						"org.eclipse.m2m.km3.xtext.KM3.Integer");
            					afterParserOrEnumRuleCall();
            				

            }


            }

            otherlv_8=(Token)match(input,38,FOLLOW_24); 

            			newLeafNode(otherlv_8, grammarAccess.getReferenceAccess().getUpperKeyword_8());
            		
            // InternalKM3.g:2077:3: ( (lv_upper_9_0= ruleInteger ) )
            // InternalKM3.g:2078:4: (lv_upper_9_0= ruleInteger )
            {
            // InternalKM3.g:2078:4: (lv_upper_9_0= ruleInteger )
            // InternalKM3.g:2079:5: lv_upper_9_0= ruleInteger
            {

            					newCompositeNode(grammarAccess.getReferenceAccess().getUpperIntegerParserRuleCall_9_0());
            				
            pushFollow(FOLLOW_26);
            lv_upper_9_0=ruleInteger();

            state._fsp--;


            					if (current==null) {
            						current = createModelElementForParent(grammarAccess.getReferenceRule());
            					}
            					set(
            						current,
            						"upper",
            						lv_upper_9_0,
            						"org.eclipse.m2m.km3.xtext.KM3.Integer");
            					afterParserOrEnumRuleCall();
            				

            }


            }

            otherlv_10=(Token)match(input,39,FOLLOW_18); 

            			newLeafNode(otherlv_10, grammarAccess.getReferenceAccess().getIsOrderedKeyword_10());
            		
            // InternalKM3.g:2100:3: ( (lv_isOrdered_11_0= ruleBoolean ) )
            // InternalKM3.g:2101:4: (lv_isOrdered_11_0= ruleBoolean )
            {
            // InternalKM3.g:2101:4: (lv_isOrdered_11_0= ruleBoolean )
            // InternalKM3.g:2102:5: lv_isOrdered_11_0= ruleBoolean
            {

            					newCompositeNode(grammarAccess.getReferenceAccess().getIsOrderedBooleanParserRuleCall_11_0());
            				
            pushFollow(FOLLOW_27);
            lv_isOrdered_11_0=ruleBoolean();

            state._fsp--;


            					if (current==null) {
            						current = createModelElementForParent(grammarAccess.getReferenceRule());
            					}
            					set(
            						current,
            						"isOrdered",
            						lv_isOrdered_11_0,
            						"org.eclipse.m2m.km3.xtext.KM3.Boolean");
            					afterParserOrEnumRuleCall();
            				

            }


            }

            otherlv_12=(Token)match(input,40,FOLLOW_18); 

            			newLeafNode(otherlv_12, grammarAccess.getReferenceAccess().getIsUniqueKeyword_12());
            		
            // InternalKM3.g:2123:3: ( (lv_isUnique_13_0= ruleBoolean ) )
            // InternalKM3.g:2124:4: (lv_isUnique_13_0= ruleBoolean )
            {
            // InternalKM3.g:2124:4: (lv_isUnique_13_0= ruleBoolean )
            // InternalKM3.g:2125:5: lv_isUnique_13_0= ruleBoolean
            {

            					newCompositeNode(grammarAccess.getReferenceAccess().getIsUniqueBooleanParserRuleCall_13_0());
            				
            pushFollow(FOLLOW_32);
            lv_isUnique_13_0=ruleBoolean();

            state._fsp--;


            					if (current==null) {
            						current = createModelElementForParent(grammarAccess.getReferenceRule());
            					}
            					set(
            						current,
            						"isUnique",
            						lv_isUnique_13_0,
            						"org.eclipse.m2m.km3.xtext.KM3.Boolean");
            					afterParserOrEnumRuleCall();
            				

            }


            }

            otherlv_14=(Token)match(input,48,FOLLOW_18); 

            			newLeafNode(otherlv_14, grammarAccess.getReferenceAccess().getIsContainerKeyword_14());
            		
            // InternalKM3.g:2146:3: ( (lv_isContainer_15_0= ruleBoolean ) )
            // InternalKM3.g:2147:4: (lv_isContainer_15_0= ruleBoolean )
            {
            // InternalKM3.g:2147:4: (lv_isContainer_15_0= ruleBoolean )
            // InternalKM3.g:2148:5: lv_isContainer_15_0= ruleBoolean
            {

            					newCompositeNode(grammarAccess.getReferenceAccess().getIsContainerBooleanParserRuleCall_15_0());
            				
            pushFollow(FOLLOW_28);
            lv_isContainer_15_0=ruleBoolean();

            state._fsp--;


            					if (current==null) {
            						current = createModelElementForParent(grammarAccess.getReferenceRule());
            					}
            					set(
            						current,
            						"isContainer",
            						lv_isContainer_15_0,
            						"org.eclipse.m2m.km3.xtext.KM3.Boolean");
            					afterParserOrEnumRuleCall();
            				

            }


            }

            otherlv_16=(Token)match(input,41,FOLLOW_8); 

            			newLeafNode(otherlv_16, grammarAccess.getReferenceAccess().getTypeKeyword_16());
            		
            // InternalKM3.g:2169:3: ( (otherlv_17= RULE_STRING ) )
            // InternalKM3.g:2170:4: (otherlv_17= RULE_STRING )
            {
            // InternalKM3.g:2170:4: (otherlv_17= RULE_STRING )
            // InternalKM3.g:2171:5: otherlv_17= RULE_STRING
            {

            					if (current==null) {
            						current = createModelElement(grammarAccess.getReferenceRule());
            					}
            				
            otherlv_17=(Token)match(input,RULE_STRING,FOLLOW_29); 

            					newLeafNode(otherlv_17, grammarAccess.getReferenceAccess().getTypeClassifierCrossReference_17_0());
            				

            }


            }

            otherlv_18=(Token)match(input,43,FOLLOW_8); 

            			newLeafNode(otherlv_18, grammarAccess.getReferenceAccess().getOwnerKeyword_18());
            		
            // InternalKM3.g:2186:3: ( (otherlv_19= RULE_STRING ) )
            // InternalKM3.g:2187:4: (otherlv_19= RULE_STRING )
            {
            // InternalKM3.g:2187:4: (otherlv_19= RULE_STRING )
            // InternalKM3.g:2188:5: otherlv_19= RULE_STRING
            {

            					if (current==null) {
            						current = createModelElement(grammarAccess.getReferenceRule());
            					}
            				
            otherlv_19=(Token)match(input,RULE_STRING,FOLLOW_33); 

            					newLeafNode(otherlv_19, grammarAccess.getReferenceAccess().getOwnerClassCrossReference_19_0());
            				

            }


            }

            // InternalKM3.g:2199:3: (otherlv_20= 'subsetOf' otherlv_21= '(' ( (otherlv_22= RULE_STRING ) ) (otherlv_23= ',' ( (otherlv_24= RULE_STRING ) ) )* otherlv_25= ')' )?
            int alt25=2;
            int LA25_0 = input.LA(1);

            if ( (LA25_0==44) ) {
                alt25=1;
            }
            switch (alt25) {
                case 1 :
                    // InternalKM3.g:2200:4: otherlv_20= 'subsetOf' otherlv_21= '(' ( (otherlv_22= RULE_STRING ) ) (otherlv_23= ',' ( (otherlv_24= RULE_STRING ) ) )* otherlv_25= ')'
                    {
                    otherlv_20=(Token)match(input,44,FOLLOW_7); 

                    				newLeafNode(otherlv_20, grammarAccess.getReferenceAccess().getSubsetOfKeyword_20_0());
                    			
                    otherlv_21=(Token)match(input,15,FOLLOW_8); 

                    				newLeafNode(otherlv_21, grammarAccess.getReferenceAccess().getLeftParenthesisKeyword_20_1());
                    			
                    // InternalKM3.g:2208:4: ( (otherlv_22= RULE_STRING ) )
                    // InternalKM3.g:2209:5: (otherlv_22= RULE_STRING )
                    {
                    // InternalKM3.g:2209:5: (otherlv_22= RULE_STRING )
                    // InternalKM3.g:2210:6: otherlv_22= RULE_STRING
                    {

                    						if (current==null) {
                    							current = createModelElement(grammarAccess.getReferenceRule());
                    						}
                    					
                    otherlv_22=(Token)match(input,RULE_STRING,FOLLOW_9); 

                    						newLeafNode(otherlv_22, grammarAccess.getReferenceAccess().getSubsetOfStructuralFeatureCrossReference_20_2_0());
                    					

                    }


                    }

                    // InternalKM3.g:2221:4: (otherlv_23= ',' ( (otherlv_24= RULE_STRING ) ) )*
                    loop24:
                    do {
                        int alt24=2;
                        int LA24_0 = input.LA(1);

                        if ( (LA24_0==16) ) {
                            alt24=1;
                        }


                        switch (alt24) {
                    	case 1 :
                    	    // InternalKM3.g:2222:5: otherlv_23= ',' ( (otherlv_24= RULE_STRING ) )
                    	    {
                    	    otherlv_23=(Token)match(input,16,FOLLOW_8); 

                    	    					newLeafNode(otherlv_23, grammarAccess.getReferenceAccess().getCommaKeyword_20_3_0());
                    	    				
                    	    // InternalKM3.g:2226:5: ( (otherlv_24= RULE_STRING ) )
                    	    // InternalKM3.g:2227:6: (otherlv_24= RULE_STRING )
                    	    {
                    	    // InternalKM3.g:2227:6: (otherlv_24= RULE_STRING )
                    	    // InternalKM3.g:2228:7: otherlv_24= RULE_STRING
                    	    {

                    	    							if (current==null) {
                    	    								current = createModelElement(grammarAccess.getReferenceRule());
                    	    							}
                    	    						
                    	    otherlv_24=(Token)match(input,RULE_STRING,FOLLOW_9); 

                    	    							newLeafNode(otherlv_24, grammarAccess.getReferenceAccess().getSubsetOfStructuralFeatureCrossReference_20_3_1_0());
                    	    						

                    	    }


                    	    }


                    	    }
                    	    break;

                    	default :
                    	    break loop24;
                        }
                    } while (true);

                    otherlv_25=(Token)match(input,17,FOLLOW_34); 

                    				newLeafNode(otherlv_25, grammarAccess.getReferenceAccess().getRightParenthesisKeyword_20_4());
                    			

                    }
                    break;

            }

            // InternalKM3.g:2245:3: (otherlv_26= 'derivedFrom' otherlv_27= '(' ( (otherlv_28= RULE_STRING ) ) (otherlv_29= ',' ( (otherlv_30= RULE_STRING ) ) )* otherlv_31= ')' )?
            int alt27=2;
            int LA27_0 = input.LA(1);

            if ( (LA27_0==45) ) {
                alt27=1;
            }
            switch (alt27) {
                case 1 :
                    // InternalKM3.g:2246:4: otherlv_26= 'derivedFrom' otherlv_27= '(' ( (otherlv_28= RULE_STRING ) ) (otherlv_29= ',' ( (otherlv_30= RULE_STRING ) ) )* otherlv_31= ')'
                    {
                    otherlv_26=(Token)match(input,45,FOLLOW_7); 

                    				newLeafNode(otherlv_26, grammarAccess.getReferenceAccess().getDerivedFromKeyword_21_0());
                    			
                    otherlv_27=(Token)match(input,15,FOLLOW_8); 

                    				newLeafNode(otherlv_27, grammarAccess.getReferenceAccess().getLeftParenthesisKeyword_21_1());
                    			
                    // InternalKM3.g:2254:4: ( (otherlv_28= RULE_STRING ) )
                    // InternalKM3.g:2255:5: (otherlv_28= RULE_STRING )
                    {
                    // InternalKM3.g:2255:5: (otherlv_28= RULE_STRING )
                    // InternalKM3.g:2256:6: otherlv_28= RULE_STRING
                    {

                    						if (current==null) {
                    							current = createModelElement(grammarAccess.getReferenceRule());
                    						}
                    					
                    otherlv_28=(Token)match(input,RULE_STRING,FOLLOW_9); 

                    						newLeafNode(otherlv_28, grammarAccess.getReferenceAccess().getDerivedFromStructuralFeatureCrossReference_21_2_0());
                    					

                    }


                    }

                    // InternalKM3.g:2267:4: (otherlv_29= ',' ( (otherlv_30= RULE_STRING ) ) )*
                    loop26:
                    do {
                        int alt26=2;
                        int LA26_0 = input.LA(1);

                        if ( (LA26_0==16) ) {
                            alt26=1;
                        }


                        switch (alt26) {
                    	case 1 :
                    	    // InternalKM3.g:2268:5: otherlv_29= ',' ( (otherlv_30= RULE_STRING ) )
                    	    {
                    	    otherlv_29=(Token)match(input,16,FOLLOW_8); 

                    	    					newLeafNode(otherlv_29, grammarAccess.getReferenceAccess().getCommaKeyword_21_3_0());
                    	    				
                    	    // InternalKM3.g:2272:5: ( (otherlv_30= RULE_STRING ) )
                    	    // InternalKM3.g:2273:6: (otherlv_30= RULE_STRING )
                    	    {
                    	    // InternalKM3.g:2273:6: (otherlv_30= RULE_STRING )
                    	    // InternalKM3.g:2274:7: otherlv_30= RULE_STRING
                    	    {

                    	    							if (current==null) {
                    	    								current = createModelElement(grammarAccess.getReferenceRule());
                    	    							}
                    	    						
                    	    otherlv_30=(Token)match(input,RULE_STRING,FOLLOW_9); 

                    	    							newLeafNode(otherlv_30, grammarAccess.getReferenceAccess().getDerivedFromStructuralFeatureCrossReference_21_3_1_0());
                    	    						

                    	    }


                    	    }


                    	    }
                    	    break;

                    	default :
                    	    break loop26;
                        }
                    } while (true);

                    otherlv_31=(Token)match(input,17,FOLLOW_35); 

                    				newLeafNode(otherlv_31, grammarAccess.getReferenceAccess().getRightParenthesisKeyword_21_4());
                    			

                    }
                    break;

            }

            // InternalKM3.g:2291:3: (otherlv_32= 'opposite' ( (otherlv_33= RULE_STRING ) ) )?
            int alt28=2;
            int LA28_0 = input.LA(1);

            if ( (LA28_0==49) ) {
                alt28=1;
            }
            switch (alt28) {
                case 1 :
                    // InternalKM3.g:2292:4: otherlv_32= 'opposite' ( (otherlv_33= RULE_STRING ) )
                    {
                    otherlv_32=(Token)match(input,49,FOLLOW_8); 

                    				newLeafNode(otherlv_32, grammarAccess.getReferenceAccess().getOppositeKeyword_22_0());
                    			
                    // InternalKM3.g:2296:4: ( (otherlv_33= RULE_STRING ) )
                    // InternalKM3.g:2297:5: (otherlv_33= RULE_STRING )
                    {
                    // InternalKM3.g:2297:5: (otherlv_33= RULE_STRING )
                    // InternalKM3.g:2298:6: otherlv_33= RULE_STRING
                    {

                    						if (current==null) {
                    							current = createModelElement(grammarAccess.getReferenceRule());
                    						}
                    					
                    otherlv_33=(Token)match(input,RULE_STRING,FOLLOW_10); 

                    						newLeafNode(otherlv_33, grammarAccess.getReferenceAccess().getOppositeReferenceCrossReference_22_1_0());
                    					

                    }


                    }


                    }
                    break;

            }

            otherlv_34=(Token)match(input,18,FOLLOW_2); 

            			newLeafNode(otherlv_34, grammarAccess.getReferenceAccess().getRightCurlyBracketKeyword_23());
            		

            }


            }


            	leaveRule();

        }

            catch (RecognitionException re) {
                recover(input,re);
                appendSkippedTokens();
            }
        finally {
        }
        return current;
    }
    // $ANTLR end "ruleReference"


    // $ANTLR start "entryRuleOperation"
    // InternalKM3.g:2318:1: entryRuleOperation returns [EObject current=null] : iv_ruleOperation= ruleOperation EOF ;
    public final EObject entryRuleOperation() throws RecognitionException {
        EObject current = null;

        EObject iv_ruleOperation = null;


        try {
            // InternalKM3.g:2318:50: (iv_ruleOperation= ruleOperation EOF )
            // InternalKM3.g:2319:2: iv_ruleOperation= ruleOperation EOF
            {
             newCompositeNode(grammarAccess.getOperationRule()); 
            pushFollow(FOLLOW_1);
            iv_ruleOperation=ruleOperation();

            state._fsp--;

             current =iv_ruleOperation; 
            match(input,EOF,FOLLOW_2); 

            }

        }

            catch (RecognitionException re) {
                recover(input,re);
                appendSkippedTokens();
            }
        finally {
        }
        return current;
    }
    // $ANTLR end "entryRuleOperation"


    // $ANTLR start "ruleOperation"
    // InternalKM3.g:2325:1: ruleOperation returns [EObject current=null] : (otherlv_0= 'Operation' otherlv_1= '{' otherlv_2= 'location' ( (lv_location_3_0= ruleString0 ) ) otherlv_4= 'name' ( (lv_name_5_0= ruleString0 ) ) otherlv_6= 'lower' ( (lv_lower_7_0= ruleInteger ) ) otherlv_8= 'upper' ( (lv_upper_9_0= ruleInteger ) ) otherlv_10= 'isOrdered' ( (lv_isOrdered_11_0= ruleBoolean ) ) otherlv_12= 'isUnique' ( (lv_isUnique_13_0= ruleBoolean ) ) otherlv_14= 'type' ( (otherlv_15= RULE_STRING ) ) otherlv_16= 'owner' ( (otherlv_17= RULE_STRING ) ) (otherlv_18= 'parameters' otherlv_19= '(' ( (otherlv_20= RULE_STRING ) ) (otherlv_21= ',' ( (otherlv_22= RULE_STRING ) ) )* otherlv_23= ')' )? otherlv_24= '}' ) ;
    public final EObject ruleOperation() throws RecognitionException {
        EObject current = null;

        Token otherlv_0=null;
        Token otherlv_1=null;
        Token otherlv_2=null;
        Token otherlv_4=null;
        Token otherlv_6=null;
        Token otherlv_8=null;
        Token otherlv_10=null;
        Token otherlv_12=null;
        Token otherlv_14=null;
        Token otherlv_15=null;
        Token otherlv_16=null;
        Token otherlv_17=null;
        Token otherlv_18=null;
        Token otherlv_19=null;
        Token otherlv_20=null;
        Token otherlv_21=null;
        Token otherlv_22=null;
        Token otherlv_23=null;
        Token otherlv_24=null;
        AntlrDatatypeRuleToken lv_location_3_0 = null;

        AntlrDatatypeRuleToken lv_name_5_0 = null;

        AntlrDatatypeRuleToken lv_lower_7_0 = null;

        AntlrDatatypeRuleToken lv_upper_9_0 = null;

        AntlrDatatypeRuleToken lv_isOrdered_11_0 = null;

        AntlrDatatypeRuleToken lv_isUnique_13_0 = null;



        	enterRule();

        try {
            // InternalKM3.g:2331:2: ( (otherlv_0= 'Operation' otherlv_1= '{' otherlv_2= 'location' ( (lv_location_3_0= ruleString0 ) ) otherlv_4= 'name' ( (lv_name_5_0= ruleString0 ) ) otherlv_6= 'lower' ( (lv_lower_7_0= ruleInteger ) ) otherlv_8= 'upper' ( (lv_upper_9_0= ruleInteger ) ) otherlv_10= 'isOrdered' ( (lv_isOrdered_11_0= ruleBoolean ) ) otherlv_12= 'isUnique' ( (lv_isUnique_13_0= ruleBoolean ) ) otherlv_14= 'type' ( (otherlv_15= RULE_STRING ) ) otherlv_16= 'owner' ( (otherlv_17= RULE_STRING ) ) (otherlv_18= 'parameters' otherlv_19= '(' ( (otherlv_20= RULE_STRING ) ) (otherlv_21= ',' ( (otherlv_22= RULE_STRING ) ) )* otherlv_23= ')' )? otherlv_24= '}' ) )
            // InternalKM3.g:2332:2: (otherlv_0= 'Operation' otherlv_1= '{' otherlv_2= 'location' ( (lv_location_3_0= ruleString0 ) ) otherlv_4= 'name' ( (lv_name_5_0= ruleString0 ) ) otherlv_6= 'lower' ( (lv_lower_7_0= ruleInteger ) ) otherlv_8= 'upper' ( (lv_upper_9_0= ruleInteger ) ) otherlv_10= 'isOrdered' ( (lv_isOrdered_11_0= ruleBoolean ) ) otherlv_12= 'isUnique' ( (lv_isUnique_13_0= ruleBoolean ) ) otherlv_14= 'type' ( (otherlv_15= RULE_STRING ) ) otherlv_16= 'owner' ( (otherlv_17= RULE_STRING ) ) (otherlv_18= 'parameters' otherlv_19= '(' ( (otherlv_20= RULE_STRING ) ) (otherlv_21= ',' ( (otherlv_22= RULE_STRING ) ) )* otherlv_23= ')' )? otherlv_24= '}' )
            {
            // InternalKM3.g:2332:2: (otherlv_0= 'Operation' otherlv_1= '{' otherlv_2= 'location' ( (lv_location_3_0= ruleString0 ) ) otherlv_4= 'name' ( (lv_name_5_0= ruleString0 ) ) otherlv_6= 'lower' ( (lv_lower_7_0= ruleInteger ) ) otherlv_8= 'upper' ( (lv_upper_9_0= ruleInteger ) ) otherlv_10= 'isOrdered' ( (lv_isOrdered_11_0= ruleBoolean ) ) otherlv_12= 'isUnique' ( (lv_isUnique_13_0= ruleBoolean ) ) otherlv_14= 'type' ( (otherlv_15= RULE_STRING ) ) otherlv_16= 'owner' ( (otherlv_17= RULE_STRING ) ) (otherlv_18= 'parameters' otherlv_19= '(' ( (otherlv_20= RULE_STRING ) ) (otherlv_21= ',' ( (otherlv_22= RULE_STRING ) ) )* otherlv_23= ')' )? otherlv_24= '}' )
            // InternalKM3.g:2333:3: otherlv_0= 'Operation' otherlv_1= '{' otherlv_2= 'location' ( (lv_location_3_0= ruleString0 ) ) otherlv_4= 'name' ( (lv_name_5_0= ruleString0 ) ) otherlv_6= 'lower' ( (lv_lower_7_0= ruleInteger ) ) otherlv_8= 'upper' ( (lv_upper_9_0= ruleInteger ) ) otherlv_10= 'isOrdered' ( (lv_isOrdered_11_0= ruleBoolean ) ) otherlv_12= 'isUnique' ( (lv_isUnique_13_0= ruleBoolean ) ) otherlv_14= 'type' ( (otherlv_15= RULE_STRING ) ) otherlv_16= 'owner' ( (otherlv_17= RULE_STRING ) ) (otherlv_18= 'parameters' otherlv_19= '(' ( (otherlv_20= RULE_STRING ) ) (otherlv_21= ',' ( (otherlv_22= RULE_STRING ) ) )* otherlv_23= ')' )? otherlv_24= '}'
            {
            otherlv_0=(Token)match(input,50,FOLLOW_3); 

            			newLeafNode(otherlv_0, grammarAccess.getOperationAccess().getOperationKeyword_0());
            		
            otherlv_1=(Token)match(input,12,FOLLOW_4); 

            			newLeafNode(otherlv_1, grammarAccess.getOperationAccess().getLeftCurlyBracketKeyword_1());
            		
            otherlv_2=(Token)match(input,13,FOLLOW_5); 

            			newLeafNode(otherlv_2, grammarAccess.getOperationAccess().getLocationKeyword_2());
            		
            // InternalKM3.g:2345:3: ( (lv_location_3_0= ruleString0 ) )
            // InternalKM3.g:2346:4: (lv_location_3_0= ruleString0 )
            {
            // InternalKM3.g:2346:4: (lv_location_3_0= ruleString0 )
            // InternalKM3.g:2347:5: lv_location_3_0= ruleString0
            {

            					newCompositeNode(grammarAccess.getOperationAccess().getLocationString0ParserRuleCall_3_0());
            				
            pushFollow(FOLLOW_11);
            lv_location_3_0=ruleString0();

            state._fsp--;


            					if (current==null) {
            						current = createModelElementForParent(grammarAccess.getOperationRule());
            					}
            					set(
            						current,
            						"location",
            						lv_location_3_0,
            						"org.eclipse.m2m.km3.xtext.KM3.String0");
            					afterParserOrEnumRuleCall();
            				

            }


            }

            otherlv_4=(Token)match(input,21,FOLLOW_5); 

            			newLeafNode(otherlv_4, grammarAccess.getOperationAccess().getNameKeyword_4());
            		
            // InternalKM3.g:2368:3: ( (lv_name_5_0= ruleString0 ) )
            // InternalKM3.g:2369:4: (lv_name_5_0= ruleString0 )
            {
            // InternalKM3.g:2369:4: (lv_name_5_0= ruleString0 )
            // InternalKM3.g:2370:5: lv_name_5_0= ruleString0
            {

            					newCompositeNode(grammarAccess.getOperationAccess().getNameString0ParserRuleCall_5_0());
            				
            pushFollow(FOLLOW_23);
            lv_name_5_0=ruleString0();

            state._fsp--;


            					if (current==null) {
            						current = createModelElementForParent(grammarAccess.getOperationRule());
            					}
            					set(
            						current,
            						"name",
            						lv_name_5_0,
            						"org.eclipse.m2m.km3.xtext.KM3.String0");
            					afterParserOrEnumRuleCall();
            				

            }


            }

            otherlv_6=(Token)match(input,37,FOLLOW_24); 

            			newLeafNode(otherlv_6, grammarAccess.getOperationAccess().getLowerKeyword_6());
            		
            // InternalKM3.g:2391:3: ( (lv_lower_7_0= ruleInteger ) )
            // InternalKM3.g:2392:4: (lv_lower_7_0= ruleInteger )
            {
            // InternalKM3.g:2392:4: (lv_lower_7_0= ruleInteger )
            // InternalKM3.g:2393:5: lv_lower_7_0= ruleInteger
            {

            					newCompositeNode(grammarAccess.getOperationAccess().getLowerIntegerParserRuleCall_7_0());
            				
            pushFollow(FOLLOW_25);
            lv_lower_7_0=ruleInteger();

            state._fsp--;


            					if (current==null) {
            						current = createModelElementForParent(grammarAccess.getOperationRule());
            					}
            					set(
            						current,
            						"lower",
            						lv_lower_7_0,
            						"org.eclipse.m2m.km3.xtext.KM3.Integer");
            					afterParserOrEnumRuleCall();
            				

            }


            }

            otherlv_8=(Token)match(input,38,FOLLOW_24); 

            			newLeafNode(otherlv_8, grammarAccess.getOperationAccess().getUpperKeyword_8());
            		
            // InternalKM3.g:2414:3: ( (lv_upper_9_0= ruleInteger ) )
            // InternalKM3.g:2415:4: (lv_upper_9_0= ruleInteger )
            {
            // InternalKM3.g:2415:4: (lv_upper_9_0= ruleInteger )
            // InternalKM3.g:2416:5: lv_upper_9_0= ruleInteger
            {

            					newCompositeNode(grammarAccess.getOperationAccess().getUpperIntegerParserRuleCall_9_0());
            				
            pushFollow(FOLLOW_26);
            lv_upper_9_0=ruleInteger();

            state._fsp--;


            					if (current==null) {
            						current = createModelElementForParent(grammarAccess.getOperationRule());
            					}
            					set(
            						current,
            						"upper",
            						lv_upper_9_0,
            						"org.eclipse.m2m.km3.xtext.KM3.Integer");
            					afterParserOrEnumRuleCall();
            				

            }


            }

            otherlv_10=(Token)match(input,39,FOLLOW_18); 

            			newLeafNode(otherlv_10, grammarAccess.getOperationAccess().getIsOrderedKeyword_10());
            		
            // InternalKM3.g:2437:3: ( (lv_isOrdered_11_0= ruleBoolean ) )
            // InternalKM3.g:2438:4: (lv_isOrdered_11_0= ruleBoolean )
            {
            // InternalKM3.g:2438:4: (lv_isOrdered_11_0= ruleBoolean )
            // InternalKM3.g:2439:5: lv_isOrdered_11_0= ruleBoolean
            {

            					newCompositeNode(grammarAccess.getOperationAccess().getIsOrderedBooleanParserRuleCall_11_0());
            				
            pushFollow(FOLLOW_27);
            lv_isOrdered_11_0=ruleBoolean();

            state._fsp--;


            					if (current==null) {
            						current = createModelElementForParent(grammarAccess.getOperationRule());
            					}
            					set(
            						current,
            						"isOrdered",
            						lv_isOrdered_11_0,
            						"org.eclipse.m2m.km3.xtext.KM3.Boolean");
            					afterParserOrEnumRuleCall();
            				

            }


            }

            otherlv_12=(Token)match(input,40,FOLLOW_18); 

            			newLeafNode(otherlv_12, grammarAccess.getOperationAccess().getIsUniqueKeyword_12());
            		
            // InternalKM3.g:2460:3: ( (lv_isUnique_13_0= ruleBoolean ) )
            // InternalKM3.g:2461:4: (lv_isUnique_13_0= ruleBoolean )
            {
            // InternalKM3.g:2461:4: (lv_isUnique_13_0= ruleBoolean )
            // InternalKM3.g:2462:5: lv_isUnique_13_0= ruleBoolean
            {

            					newCompositeNode(grammarAccess.getOperationAccess().getIsUniqueBooleanParserRuleCall_13_0());
            				
            pushFollow(FOLLOW_28);
            lv_isUnique_13_0=ruleBoolean();

            state._fsp--;


            					if (current==null) {
            						current = createModelElementForParent(grammarAccess.getOperationRule());
            					}
            					set(
            						current,
            						"isUnique",
            						lv_isUnique_13_0,
            						"org.eclipse.m2m.km3.xtext.KM3.Boolean");
            					afterParserOrEnumRuleCall();
            				

            }


            }

            otherlv_14=(Token)match(input,41,FOLLOW_8); 

            			newLeafNode(otherlv_14, grammarAccess.getOperationAccess().getTypeKeyword_14());
            		
            // InternalKM3.g:2483:3: ( (otherlv_15= RULE_STRING ) )
            // InternalKM3.g:2484:4: (otherlv_15= RULE_STRING )
            {
            // InternalKM3.g:2484:4: (otherlv_15= RULE_STRING )
            // InternalKM3.g:2485:5: otherlv_15= RULE_STRING
            {

            					if (current==null) {
            						current = createModelElement(grammarAccess.getOperationRule());
            					}
            				
            otherlv_15=(Token)match(input,RULE_STRING,FOLLOW_29); 

            					newLeafNode(otherlv_15, grammarAccess.getOperationAccess().getTypeClassifierCrossReference_15_0());
            				

            }


            }

            otherlv_16=(Token)match(input,43,FOLLOW_8); 

            			newLeafNode(otherlv_16, grammarAccess.getOperationAccess().getOwnerKeyword_16());
            		
            // InternalKM3.g:2500:3: ( (otherlv_17= RULE_STRING ) )
            // InternalKM3.g:2501:4: (otherlv_17= RULE_STRING )
            {
            // InternalKM3.g:2501:4: (otherlv_17= RULE_STRING )
            // InternalKM3.g:2502:5: otherlv_17= RULE_STRING
            {

            					if (current==null) {
            						current = createModelElement(grammarAccess.getOperationRule());
            					}
            				
            otherlv_17=(Token)match(input,RULE_STRING,FOLLOW_36); 

            					newLeafNode(otherlv_17, grammarAccess.getOperationAccess().getOwnerClassCrossReference_17_0());
            				

            }


            }

            // InternalKM3.g:2513:3: (otherlv_18= 'parameters' otherlv_19= '(' ( (otherlv_20= RULE_STRING ) ) (otherlv_21= ',' ( (otherlv_22= RULE_STRING ) ) )* otherlv_23= ')' )?
            int alt30=2;
            int LA30_0 = input.LA(1);

            if ( (LA30_0==32) ) {
                alt30=1;
            }
            switch (alt30) {
                case 1 :
                    // InternalKM3.g:2514:4: otherlv_18= 'parameters' otherlv_19= '(' ( (otherlv_20= RULE_STRING ) ) (otherlv_21= ',' ( (otherlv_22= RULE_STRING ) ) )* otherlv_23= ')'
                    {
                    otherlv_18=(Token)match(input,32,FOLLOW_7); 

                    				newLeafNode(otherlv_18, grammarAccess.getOperationAccess().getParametersKeyword_18_0());
                    			
                    otherlv_19=(Token)match(input,15,FOLLOW_8); 

                    				newLeafNode(otherlv_19, grammarAccess.getOperationAccess().getLeftParenthesisKeyword_18_1());
                    			
                    // InternalKM3.g:2522:4: ( (otherlv_20= RULE_STRING ) )
                    // InternalKM3.g:2523:5: (otherlv_20= RULE_STRING )
                    {
                    // InternalKM3.g:2523:5: (otherlv_20= RULE_STRING )
                    // InternalKM3.g:2524:6: otherlv_20= RULE_STRING
                    {

                    						if (current==null) {
                    							current = createModelElement(grammarAccess.getOperationRule());
                    						}
                    					
                    otherlv_20=(Token)match(input,RULE_STRING,FOLLOW_9); 

                    						newLeafNode(otherlv_20, grammarAccess.getOperationAccess().getParametersParameterCrossReference_18_2_0());
                    					

                    }


                    }

                    // InternalKM3.g:2535:4: (otherlv_21= ',' ( (otherlv_22= RULE_STRING ) ) )*
                    loop29:
                    do {
                        int alt29=2;
                        int LA29_0 = input.LA(1);

                        if ( (LA29_0==16) ) {
                            alt29=1;
                        }


                        switch (alt29) {
                    	case 1 :
                    	    // InternalKM3.g:2536:5: otherlv_21= ',' ( (otherlv_22= RULE_STRING ) )
                    	    {
                    	    otherlv_21=(Token)match(input,16,FOLLOW_8); 

                    	    					newLeafNode(otherlv_21, grammarAccess.getOperationAccess().getCommaKeyword_18_3_0());
                    	    				
                    	    // InternalKM3.g:2540:5: ( (otherlv_22= RULE_STRING ) )
                    	    // InternalKM3.g:2541:6: (otherlv_22= RULE_STRING )
                    	    {
                    	    // InternalKM3.g:2541:6: (otherlv_22= RULE_STRING )
                    	    // InternalKM3.g:2542:7: otherlv_22= RULE_STRING
                    	    {

                    	    							if (current==null) {
                    	    								current = createModelElement(grammarAccess.getOperationRule());
                    	    							}
                    	    						
                    	    otherlv_22=(Token)match(input,RULE_STRING,FOLLOW_9); 

                    	    							newLeafNode(otherlv_22, grammarAccess.getOperationAccess().getParametersParameterCrossReference_18_3_1_0());
                    	    						

                    	    }


                    	    }


                    	    }
                    	    break;

                    	default :
                    	    break loop29;
                        }
                    } while (true);

                    otherlv_23=(Token)match(input,17,FOLLOW_10); 

                    				newLeafNode(otherlv_23, grammarAccess.getOperationAccess().getRightParenthesisKeyword_18_4());
                    			

                    }
                    break;

            }

            otherlv_24=(Token)match(input,18,FOLLOW_2); 

            			newLeafNode(otherlv_24, grammarAccess.getOperationAccess().getRightCurlyBracketKeyword_19());
            		

            }


            }


            	leaveRule();

        }

            catch (RecognitionException re) {
                recover(input,re);
                appendSkippedTokens();
            }
        finally {
        }
        return current;
    }
    // $ANTLR end "ruleOperation"


    // $ANTLR start "entryRuleParameter"
    // InternalKM3.g:2567:1: entryRuleParameter returns [EObject current=null] : iv_ruleParameter= ruleParameter EOF ;
    public final EObject entryRuleParameter() throws RecognitionException {
        EObject current = null;

        EObject iv_ruleParameter = null;


        try {
            // InternalKM3.g:2567:50: (iv_ruleParameter= ruleParameter EOF )
            // InternalKM3.g:2568:2: iv_ruleParameter= ruleParameter EOF
            {
             newCompositeNode(grammarAccess.getParameterRule()); 
            pushFollow(FOLLOW_1);
            iv_ruleParameter=ruleParameter();

            state._fsp--;

             current =iv_ruleParameter; 
            match(input,EOF,FOLLOW_2); 

            }

        }

            catch (RecognitionException re) {
                recover(input,re);
                appendSkippedTokens();
            }
        finally {
        }
        return current;
    }
    // $ANTLR end "entryRuleParameter"


    // $ANTLR start "ruleParameter"
    // InternalKM3.g:2574:1: ruleParameter returns [EObject current=null] : (otherlv_0= 'Parameter' otherlv_1= '{' otherlv_2= 'location' ( (lv_location_3_0= ruleString0 ) ) otherlv_4= 'name' ( (lv_name_5_0= ruleString0 ) ) otherlv_6= 'lower' ( (lv_lower_7_0= ruleInteger ) ) otherlv_8= 'upper' ( (lv_upper_9_0= ruleInteger ) ) otherlv_10= 'isOrdered' ( (lv_isOrdered_11_0= ruleBoolean ) ) otherlv_12= 'isUnique' ( (lv_isUnique_13_0= ruleBoolean ) ) otherlv_14= 'type' ( (otherlv_15= RULE_STRING ) ) otherlv_16= 'owner' ( (otherlv_17= RULE_STRING ) ) otherlv_18= '}' ) ;
    public final EObject ruleParameter() throws RecognitionException {
        EObject current = null;

        Token otherlv_0=null;
        Token otherlv_1=null;
        Token otherlv_2=null;
        Token otherlv_4=null;
        Token otherlv_6=null;
        Token otherlv_8=null;
        Token otherlv_10=null;
        Token otherlv_12=null;
        Token otherlv_14=null;
        Token otherlv_15=null;
        Token otherlv_16=null;
        Token otherlv_17=null;
        Token otherlv_18=null;
        AntlrDatatypeRuleToken lv_location_3_0 = null;

        AntlrDatatypeRuleToken lv_name_5_0 = null;

        AntlrDatatypeRuleToken lv_lower_7_0 = null;

        AntlrDatatypeRuleToken lv_upper_9_0 = null;

        AntlrDatatypeRuleToken lv_isOrdered_11_0 = null;

        AntlrDatatypeRuleToken lv_isUnique_13_0 = null;



        	enterRule();

        try {
            // InternalKM3.g:2580:2: ( (otherlv_0= 'Parameter' otherlv_1= '{' otherlv_2= 'location' ( (lv_location_3_0= ruleString0 ) ) otherlv_4= 'name' ( (lv_name_5_0= ruleString0 ) ) otherlv_6= 'lower' ( (lv_lower_7_0= ruleInteger ) ) otherlv_8= 'upper' ( (lv_upper_9_0= ruleInteger ) ) otherlv_10= 'isOrdered' ( (lv_isOrdered_11_0= ruleBoolean ) ) otherlv_12= 'isUnique' ( (lv_isUnique_13_0= ruleBoolean ) ) otherlv_14= 'type' ( (otherlv_15= RULE_STRING ) ) otherlv_16= 'owner' ( (otherlv_17= RULE_STRING ) ) otherlv_18= '}' ) )
            // InternalKM3.g:2581:2: (otherlv_0= 'Parameter' otherlv_1= '{' otherlv_2= 'location' ( (lv_location_3_0= ruleString0 ) ) otherlv_4= 'name' ( (lv_name_5_0= ruleString0 ) ) otherlv_6= 'lower' ( (lv_lower_7_0= ruleInteger ) ) otherlv_8= 'upper' ( (lv_upper_9_0= ruleInteger ) ) otherlv_10= 'isOrdered' ( (lv_isOrdered_11_0= ruleBoolean ) ) otherlv_12= 'isUnique' ( (lv_isUnique_13_0= ruleBoolean ) ) otherlv_14= 'type' ( (otherlv_15= RULE_STRING ) ) otherlv_16= 'owner' ( (otherlv_17= RULE_STRING ) ) otherlv_18= '}' )
            {
            // InternalKM3.g:2581:2: (otherlv_0= 'Parameter' otherlv_1= '{' otherlv_2= 'location' ( (lv_location_3_0= ruleString0 ) ) otherlv_4= 'name' ( (lv_name_5_0= ruleString0 ) ) otherlv_6= 'lower' ( (lv_lower_7_0= ruleInteger ) ) otherlv_8= 'upper' ( (lv_upper_9_0= ruleInteger ) ) otherlv_10= 'isOrdered' ( (lv_isOrdered_11_0= ruleBoolean ) ) otherlv_12= 'isUnique' ( (lv_isUnique_13_0= ruleBoolean ) ) otherlv_14= 'type' ( (otherlv_15= RULE_STRING ) ) otherlv_16= 'owner' ( (otherlv_17= RULE_STRING ) ) otherlv_18= '}' )
            // InternalKM3.g:2582:3: otherlv_0= 'Parameter' otherlv_1= '{' otherlv_2= 'location' ( (lv_location_3_0= ruleString0 ) ) otherlv_4= 'name' ( (lv_name_5_0= ruleString0 ) ) otherlv_6= 'lower' ( (lv_lower_7_0= ruleInteger ) ) otherlv_8= 'upper' ( (lv_upper_9_0= ruleInteger ) ) otherlv_10= 'isOrdered' ( (lv_isOrdered_11_0= ruleBoolean ) ) otherlv_12= 'isUnique' ( (lv_isUnique_13_0= ruleBoolean ) ) otherlv_14= 'type' ( (otherlv_15= RULE_STRING ) ) otherlv_16= 'owner' ( (otherlv_17= RULE_STRING ) ) otherlv_18= '}'
            {
            otherlv_0=(Token)match(input,51,FOLLOW_3); 

            			newLeafNode(otherlv_0, grammarAccess.getParameterAccess().getParameterKeyword_0());
            		
            otherlv_1=(Token)match(input,12,FOLLOW_4); 

            			newLeafNode(otherlv_1, grammarAccess.getParameterAccess().getLeftCurlyBracketKeyword_1());
            		
            otherlv_2=(Token)match(input,13,FOLLOW_5); 

            			newLeafNode(otherlv_2, grammarAccess.getParameterAccess().getLocationKeyword_2());
            		
            // InternalKM3.g:2594:3: ( (lv_location_3_0= ruleString0 ) )
            // InternalKM3.g:2595:4: (lv_location_3_0= ruleString0 )
            {
            // InternalKM3.g:2595:4: (lv_location_3_0= ruleString0 )
            // InternalKM3.g:2596:5: lv_location_3_0= ruleString0
            {

            					newCompositeNode(grammarAccess.getParameterAccess().getLocationString0ParserRuleCall_3_0());
            				
            pushFollow(FOLLOW_11);
            lv_location_3_0=ruleString0();

            state._fsp--;


            					if (current==null) {
            						current = createModelElementForParent(grammarAccess.getParameterRule());
            					}
            					set(
            						current,
            						"location",
            						lv_location_3_0,
            						"org.eclipse.m2m.km3.xtext.KM3.String0");
            					afterParserOrEnumRuleCall();
            				

            }


            }

            otherlv_4=(Token)match(input,21,FOLLOW_5); 

            			newLeafNode(otherlv_4, grammarAccess.getParameterAccess().getNameKeyword_4());
            		
            // InternalKM3.g:2617:3: ( (lv_name_5_0= ruleString0 ) )
            // InternalKM3.g:2618:4: (lv_name_5_0= ruleString0 )
            {
            // InternalKM3.g:2618:4: (lv_name_5_0= ruleString0 )
            // InternalKM3.g:2619:5: lv_name_5_0= ruleString0
            {

            					newCompositeNode(grammarAccess.getParameterAccess().getNameString0ParserRuleCall_5_0());
            				
            pushFollow(FOLLOW_23);
            lv_name_5_0=ruleString0();

            state._fsp--;


            					if (current==null) {
            						current = createModelElementForParent(grammarAccess.getParameterRule());
            					}
            					set(
            						current,
            						"name",
            						lv_name_5_0,
            						"org.eclipse.m2m.km3.xtext.KM3.String0");
            					afterParserOrEnumRuleCall();
            				

            }


            }

            otherlv_6=(Token)match(input,37,FOLLOW_24); 

            			newLeafNode(otherlv_6, grammarAccess.getParameterAccess().getLowerKeyword_6());
            		
            // InternalKM3.g:2640:3: ( (lv_lower_7_0= ruleInteger ) )
            // InternalKM3.g:2641:4: (lv_lower_7_0= ruleInteger )
            {
            // InternalKM3.g:2641:4: (lv_lower_7_0= ruleInteger )
            // InternalKM3.g:2642:5: lv_lower_7_0= ruleInteger
            {

            					newCompositeNode(grammarAccess.getParameterAccess().getLowerIntegerParserRuleCall_7_0());
            				
            pushFollow(FOLLOW_25);
            lv_lower_7_0=ruleInteger();

            state._fsp--;


            					if (current==null) {
            						current = createModelElementForParent(grammarAccess.getParameterRule());
            					}
            					set(
            						current,
            						"lower",
            						lv_lower_7_0,
            						"org.eclipse.m2m.km3.xtext.KM3.Integer");
            					afterParserOrEnumRuleCall();
            				

            }


            }

            otherlv_8=(Token)match(input,38,FOLLOW_24); 

            			newLeafNode(otherlv_8, grammarAccess.getParameterAccess().getUpperKeyword_8());
            		
            // InternalKM3.g:2663:3: ( (lv_upper_9_0= ruleInteger ) )
            // InternalKM3.g:2664:4: (lv_upper_9_0= ruleInteger )
            {
            // InternalKM3.g:2664:4: (lv_upper_9_0= ruleInteger )
            // InternalKM3.g:2665:5: lv_upper_9_0= ruleInteger
            {

            					newCompositeNode(grammarAccess.getParameterAccess().getUpperIntegerParserRuleCall_9_0());
            				
            pushFollow(FOLLOW_26);
            lv_upper_9_0=ruleInteger();

            state._fsp--;


            					if (current==null) {
            						current = createModelElementForParent(grammarAccess.getParameterRule());
            					}
            					set(
            						current,
            						"upper",
            						lv_upper_9_0,
            						"org.eclipse.m2m.km3.xtext.KM3.Integer");
            					afterParserOrEnumRuleCall();
            				

            }


            }

            otherlv_10=(Token)match(input,39,FOLLOW_18); 

            			newLeafNode(otherlv_10, grammarAccess.getParameterAccess().getIsOrderedKeyword_10());
            		
            // InternalKM3.g:2686:3: ( (lv_isOrdered_11_0= ruleBoolean ) )
            // InternalKM3.g:2687:4: (lv_isOrdered_11_0= ruleBoolean )
            {
            // InternalKM3.g:2687:4: (lv_isOrdered_11_0= ruleBoolean )
            // InternalKM3.g:2688:5: lv_isOrdered_11_0= ruleBoolean
            {

            					newCompositeNode(grammarAccess.getParameterAccess().getIsOrderedBooleanParserRuleCall_11_0());
            				
            pushFollow(FOLLOW_27);
            lv_isOrdered_11_0=ruleBoolean();

            state._fsp--;


            					if (current==null) {
            						current = createModelElementForParent(grammarAccess.getParameterRule());
            					}
            					set(
            						current,
            						"isOrdered",
            						lv_isOrdered_11_0,
            						"org.eclipse.m2m.km3.xtext.KM3.Boolean");
            					afterParserOrEnumRuleCall();
            				

            }


            }

            otherlv_12=(Token)match(input,40,FOLLOW_18); 

            			newLeafNode(otherlv_12, grammarAccess.getParameterAccess().getIsUniqueKeyword_12());
            		
            // InternalKM3.g:2709:3: ( (lv_isUnique_13_0= ruleBoolean ) )
            // InternalKM3.g:2710:4: (lv_isUnique_13_0= ruleBoolean )
            {
            // InternalKM3.g:2710:4: (lv_isUnique_13_0= ruleBoolean )
            // InternalKM3.g:2711:5: lv_isUnique_13_0= ruleBoolean
            {

            					newCompositeNode(grammarAccess.getParameterAccess().getIsUniqueBooleanParserRuleCall_13_0());
            				
            pushFollow(FOLLOW_28);
            lv_isUnique_13_0=ruleBoolean();

            state._fsp--;


            					if (current==null) {
            						current = createModelElementForParent(grammarAccess.getParameterRule());
            					}
            					set(
            						current,
            						"isUnique",
            						lv_isUnique_13_0,
            						"org.eclipse.m2m.km3.xtext.KM3.Boolean");
            					afterParserOrEnumRuleCall();
            				

            }


            }

            otherlv_14=(Token)match(input,41,FOLLOW_8); 

            			newLeafNode(otherlv_14, grammarAccess.getParameterAccess().getTypeKeyword_14());
            		
            // InternalKM3.g:2732:3: ( (otherlv_15= RULE_STRING ) )
            // InternalKM3.g:2733:4: (otherlv_15= RULE_STRING )
            {
            // InternalKM3.g:2733:4: (otherlv_15= RULE_STRING )
            // InternalKM3.g:2734:5: otherlv_15= RULE_STRING
            {

            					if (current==null) {
            						current = createModelElement(grammarAccess.getParameterRule());
            					}
            				
            otherlv_15=(Token)match(input,RULE_STRING,FOLLOW_29); 

            					newLeafNode(otherlv_15, grammarAccess.getParameterAccess().getTypeClassifierCrossReference_15_0());
            				

            }


            }

            otherlv_16=(Token)match(input,43,FOLLOW_8); 

            			newLeafNode(otherlv_16, grammarAccess.getParameterAccess().getOwnerKeyword_16());
            		
            // InternalKM3.g:2749:3: ( (otherlv_17= RULE_STRING ) )
            // InternalKM3.g:2750:4: (otherlv_17= RULE_STRING )
            {
            // InternalKM3.g:2750:4: (otherlv_17= RULE_STRING )
            // InternalKM3.g:2751:5: otherlv_17= RULE_STRING
            {

            					if (current==null) {
            						current = createModelElement(grammarAccess.getParameterRule());
            					}
            				
            otherlv_17=(Token)match(input,RULE_STRING,FOLLOW_10); 

            					newLeafNode(otherlv_17, grammarAccess.getParameterAccess().getOwnerOperationCrossReference_17_0());
            				

            }


            }

            otherlv_18=(Token)match(input,18,FOLLOW_2); 

            			newLeafNode(otherlv_18, grammarAccess.getParameterAccess().getRightCurlyBracketKeyword_18());
            		

            }


            }


            	leaveRule();

        }

            catch (RecognitionException re) {
                recover(input,re);
                appendSkippedTokens();
            }
        finally {
        }
        return current;
    }
    // $ANTLR end "ruleParameter"


    // $ANTLR start "entryRuleBoolean"
    // InternalKM3.g:2770:1: entryRuleBoolean returns [String current=null] : iv_ruleBoolean= ruleBoolean EOF ;
    public final String entryRuleBoolean() throws RecognitionException {
        String current = null;

        AntlrDatatypeRuleToken iv_ruleBoolean = null;


        try {
            // InternalKM3.g:2770:47: (iv_ruleBoolean= ruleBoolean EOF )
            // InternalKM3.g:2771:2: iv_ruleBoolean= ruleBoolean EOF
            {
             newCompositeNode(grammarAccess.getBooleanRule()); 
            pushFollow(FOLLOW_1);
            iv_ruleBoolean=ruleBoolean();

            state._fsp--;

             current =iv_ruleBoolean.getText(); 
            match(input,EOF,FOLLOW_2); 

            }

        }

            catch (RecognitionException re) {
                recover(input,re);
                appendSkippedTokens();
            }
        finally {
        }
        return current;
    }
    // $ANTLR end "entryRuleBoolean"


    // $ANTLR start "ruleBoolean"
    // InternalKM3.g:2777:1: ruleBoolean returns [AntlrDatatypeRuleToken current=new AntlrDatatypeRuleToken()] : kw= 'Boolean' ;
    public final AntlrDatatypeRuleToken ruleBoolean() throws RecognitionException {
        AntlrDatatypeRuleToken current = new AntlrDatatypeRuleToken();

        Token kw=null;


        	enterRule();

        try {
            // InternalKM3.g:2783:2: (kw= 'Boolean' )
            // InternalKM3.g:2784:2: kw= 'Boolean'
            {
            kw=(Token)match(input,52,FOLLOW_2); 

            		current.merge(kw);
            		newLeafNode(kw, grammarAccess.getBooleanAccess().getBooleanKeyword());
            	

            }


            	leaveRule();

        }

            catch (RecognitionException re) {
                recover(input,re);
                appendSkippedTokens();
            }
        finally {
        }
        return current;
    }
    // $ANTLR end "ruleBoolean"


    // $ANTLR start "entryRuleInteger"
    // InternalKM3.g:2792:1: entryRuleInteger returns [String current=null] : iv_ruleInteger= ruleInteger EOF ;
    public final String entryRuleInteger() throws RecognitionException {
        String current = null;

        AntlrDatatypeRuleToken iv_ruleInteger = null;


        try {
            // InternalKM3.g:2792:47: (iv_ruleInteger= ruleInteger EOF )
            // InternalKM3.g:2793:2: iv_ruleInteger= ruleInteger EOF
            {
             newCompositeNode(grammarAccess.getIntegerRule()); 
            pushFollow(FOLLOW_1);
            iv_ruleInteger=ruleInteger();

            state._fsp--;

             current =iv_ruleInteger.getText(); 
            match(input,EOF,FOLLOW_2); 

            }

        }

            catch (RecognitionException re) {
                recover(input,re);
                appendSkippedTokens();
            }
        finally {
        }
        return current;
    }
    // $ANTLR end "entryRuleInteger"


    // $ANTLR start "ruleInteger"
    // InternalKM3.g:2799:1: ruleInteger returns [AntlrDatatypeRuleToken current=new AntlrDatatypeRuleToken()] : kw= 'Integer' ;
    public final AntlrDatatypeRuleToken ruleInteger() throws RecognitionException {
        AntlrDatatypeRuleToken current = new AntlrDatatypeRuleToken();

        Token kw=null;


        	enterRule();

        try {
            // InternalKM3.g:2805:2: (kw= 'Integer' )
            // InternalKM3.g:2806:2: kw= 'Integer'
            {
            kw=(Token)match(input,53,FOLLOW_2); 

            		current.merge(kw);
            		newLeafNode(kw, grammarAccess.getIntegerAccess().getIntegerKeyword());
            	

            }


            	leaveRule();

        }

            catch (RecognitionException re) {
                recover(input,re);
                appendSkippedTokens();
            }
        finally {
        }
        return current;
    }
    // $ANTLR end "ruleInteger"

    // Delegated rules


 

    public static final BitSet FOLLOW_1 = new BitSet(new long[]{0x0000000000000000L});
    public static final BitSet FOLLOW_2 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_3 = new BitSet(new long[]{0x0000000000001000L});
    public static final BitSet FOLLOW_4 = new BitSet(new long[]{0x0000000000002000L});
    public static final BitSet FOLLOW_5 = new BitSet(new long[]{0x0000000000080000L});
    public static final BitSet FOLLOW_6 = new BitSet(new long[]{0x0000000000044000L});
    public static final BitSet FOLLOW_7 = new BitSet(new long[]{0x0000000000008000L});
    public static final BitSet FOLLOW_8 = new BitSet(new long[]{0x0000000000000010L});
    public static final BitSet FOLLOW_9 = new BitSet(new long[]{0x0000000000030000L});
    public static final BitSet FOLLOW_10 = new BitSet(new long[]{0x0000000000040000L});
    public static final BitSet FOLLOW_11 = new BitSet(new long[]{0x0000000000200000L});
    public static final BitSet FOLLOW_12 = new BitSet(new long[]{0x0000000000400000L});
    public static final BitSet FOLLOW_13 = new BitSet(new long[]{0x000CC4106B900000L});
    public static final BitSet FOLLOW_14 = new BitSet(new long[]{0x0000000000050000L});
    public static final BitSet FOLLOW_15 = new BitSet(new long[]{0x0000000004040000L});
    public static final BitSet FOLLOW_16 = new BitSet(new long[]{0x0000000010000000L});
    public static final BitSet FOLLOW_17 = new BitSet(new long[]{0x0000000080000000L});
    public static final BitSet FOLLOW_18 = new BitSet(new long[]{0x0010000000000000L});
    public static final BitSet FOLLOW_19 = new BitSet(new long[]{0x0000000F00040000L});
    public static final BitSet FOLLOW_20 = new BitSet(new long[]{0x0000000E00040000L});
    public static final BitSet FOLLOW_21 = new BitSet(new long[]{0x0000000C00040000L});
    public static final BitSet FOLLOW_22 = new BitSet(new long[]{0x0000000800040000L});
    public static final BitSet FOLLOW_23 = new BitSet(new long[]{0x0000002000000000L});
    public static final BitSet FOLLOW_24 = new BitSet(new long[]{0x0020000000000000L});
    public static final BitSet FOLLOW_25 = new BitSet(new long[]{0x0000004000000000L});
    public static final BitSet FOLLOW_26 = new BitSet(new long[]{0x0000008000000000L});
    public static final BitSet FOLLOW_27 = new BitSet(new long[]{0x0000010000000000L});
    public static final BitSet FOLLOW_28 = new BitSet(new long[]{0x0000020000000000L});
    public static final BitSet FOLLOW_29 = new BitSet(new long[]{0x0000080000000000L});
    public static final BitSet FOLLOW_30 = new BitSet(new long[]{0x0000300000040000L});
    public static final BitSet FOLLOW_31 = new BitSet(new long[]{0x0000200000040000L});
    public static final BitSet FOLLOW_32 = new BitSet(new long[]{0x0001000000000000L});
    public static final BitSet FOLLOW_33 = new BitSet(new long[]{0x0002300000040000L});
    public static final BitSet FOLLOW_34 = new BitSet(new long[]{0x0002200000040000L});
    public static final BitSet FOLLOW_35 = new BitSet(new long[]{0x0002000000040000L});
    public static final BitSet FOLLOW_36 = new BitSet(new long[]{0x0000000100040000L});

}