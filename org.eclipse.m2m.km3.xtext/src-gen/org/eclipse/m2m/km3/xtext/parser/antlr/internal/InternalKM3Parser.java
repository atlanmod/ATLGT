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
        "<invalid>", "<EOR>", "<DOWN>", "<UP>", "RULE_ID", "RULE_INT", "RULE_COMMENT", "RULE_STRING", "RULE_ML_COMMENT", "RULE_SL_COMMENT", "RULE_WS", "RULE_ANY_OTHER", "'package'", "'{'", "'}'", "'datatype'", "';'", "'abstract'", "'class'", "'extends'", "','", "'unique'", "'attribute'", "'ordered'", "':'", "'reference'", "'['", "'|'", "']'", "'container'", "'oppositeOf'", "'*'"
    };
    public static final int RULE_STRING=7;
    public static final int RULE_SL_COMMENT=9;
    public static final int T__19=19;
    public static final int T__15=15;
    public static final int T__16=16;
    public static final int T__17=17;
    public static final int T__18=18;
    public static final int T__12=12;
    public static final int T__13=13;
    public static final int T__14=14;
    public static final int EOF=-1;
    public static final int T__30=30;
    public static final int T__31=31;
    public static final int RULE_ID=4;
    public static final int RULE_WS=10;
    public static final int RULE_COMMENT=6;
    public static final int RULE_ANY_OTHER=11;
    public static final int T__26=26;
    public static final int T__27=27;
    public static final int T__28=28;
    public static final int RULE_INT=5;
    public static final int T__29=29;
    public static final int T__22=22;
    public static final int RULE_ML_COMMENT=8;
    public static final int T__23=23;
    public static final int T__24=24;
    public static final int T__25=25;
    public static final int T__20=20;
    public static final int T__21=21;

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
    // InternalKM3.g:71:1: ruleMetamodel returns [EObject current=null] : ( () ( (lv_contents_1_0= rulePackage ) )* ) ;
    public final EObject ruleMetamodel() throws RecognitionException {
        EObject current = null;

        EObject lv_contents_1_0 = null;



        	enterRule();

        try {
            // InternalKM3.g:77:2: ( ( () ( (lv_contents_1_0= rulePackage ) )* ) )
            // InternalKM3.g:78:2: ( () ( (lv_contents_1_0= rulePackage ) )* )
            {
            // InternalKM3.g:78:2: ( () ( (lv_contents_1_0= rulePackage ) )* )
            // InternalKM3.g:79:3: () ( (lv_contents_1_0= rulePackage ) )*
            {
            // InternalKM3.g:79:3: ()
            // InternalKM3.g:80:4: 
            {

            				current = forceCreateModelElement(
            					grammarAccess.getMetamodelAccess().getMetamodelAction_0(),
            					current);
            			

            }

            // InternalKM3.g:86:3: ( (lv_contents_1_0= rulePackage ) )*
            loop1:
            do {
                int alt1=2;
                int LA1_0 = input.LA(1);

                if ( (LA1_0==12) ) {
                    alt1=1;
                }


                switch (alt1) {
            	case 1 :
            	    // InternalKM3.g:87:4: (lv_contents_1_0= rulePackage )
            	    {
            	    // InternalKM3.g:87:4: (lv_contents_1_0= rulePackage )
            	    // InternalKM3.g:88:5: lv_contents_1_0= rulePackage
            	    {

            	    					newCompositeNode(grammarAccess.getMetamodelAccess().getContentsPackageParserRuleCall_1_0());
            	    				
            	    pushFollow(FOLLOW_3);
            	    lv_contents_1_0=rulePackage();

            	    state._fsp--;


            	    					if (current==null) {
            	    						current = createModelElementForParent(grammarAccess.getMetamodelRule());
            	    					}
            	    					add(
            	    						current,
            	    						"contents",
            	    						lv_contents_1_0,
            	    						"org.eclipse.m2m.km3.xtext.KM3.Package");
            	    					afterParserOrEnumRuleCall();
            	    				

            	    }


            	    }
            	    break;

            	default :
            	    break loop1;
                }
            } while (true);


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


    // $ANTLR start "entryRulePackage"
    // InternalKM3.g:109:1: entryRulePackage returns [EObject current=null] : iv_rulePackage= rulePackage EOF ;
    public final EObject entryRulePackage() throws RecognitionException {
        EObject current = null;

        EObject iv_rulePackage = null;


        try {
            // InternalKM3.g:109:48: (iv_rulePackage= rulePackage EOF )
            // InternalKM3.g:110:2: iv_rulePackage= rulePackage EOF
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
    // InternalKM3.g:116:1: rulePackage returns [EObject current=null] : (otherlv_0= 'package' ( (lv_name_1_0= RULE_ID ) ) otherlv_2= '{' ( (lv_contents_3_0= ruleModelElement ) )* otherlv_4= '}' ) ;
    public final EObject rulePackage() throws RecognitionException {
        EObject current = null;

        Token otherlv_0=null;
        Token lv_name_1_0=null;
        Token otherlv_2=null;
        Token otherlv_4=null;
        EObject lv_contents_3_0 = null;



        	enterRule();

        try {
            // InternalKM3.g:122:2: ( (otherlv_0= 'package' ( (lv_name_1_0= RULE_ID ) ) otherlv_2= '{' ( (lv_contents_3_0= ruleModelElement ) )* otherlv_4= '}' ) )
            // InternalKM3.g:123:2: (otherlv_0= 'package' ( (lv_name_1_0= RULE_ID ) ) otherlv_2= '{' ( (lv_contents_3_0= ruleModelElement ) )* otherlv_4= '}' )
            {
            // InternalKM3.g:123:2: (otherlv_0= 'package' ( (lv_name_1_0= RULE_ID ) ) otherlv_2= '{' ( (lv_contents_3_0= ruleModelElement ) )* otherlv_4= '}' )
            // InternalKM3.g:124:3: otherlv_0= 'package' ( (lv_name_1_0= RULE_ID ) ) otherlv_2= '{' ( (lv_contents_3_0= ruleModelElement ) )* otherlv_4= '}'
            {
            otherlv_0=(Token)match(input,12,FOLLOW_4); 

            			newLeafNode(otherlv_0, grammarAccess.getPackageAccess().getPackageKeyword_0());
            		
            // InternalKM3.g:128:3: ( (lv_name_1_0= RULE_ID ) )
            // InternalKM3.g:129:4: (lv_name_1_0= RULE_ID )
            {
            // InternalKM3.g:129:4: (lv_name_1_0= RULE_ID )
            // InternalKM3.g:130:5: lv_name_1_0= RULE_ID
            {
            lv_name_1_0=(Token)match(input,RULE_ID,FOLLOW_5); 

            					newLeafNode(lv_name_1_0, grammarAccess.getPackageAccess().getNameIDTerminalRuleCall_1_0());
            				

            					if (current==null) {
            						current = createModelElement(grammarAccess.getPackageRule());
            					}
            					setWithLastConsumed(
            						current,
            						"name",
            						lv_name_1_0,
            						"org.eclipse.xtext.common.Terminals.ID");
            				

            }


            }

            otherlv_2=(Token)match(input,13,FOLLOW_6); 

            			newLeafNode(otherlv_2, grammarAccess.getPackageAccess().getLeftCurlyBracketKeyword_2());
            		
            // InternalKM3.g:150:3: ( (lv_contents_3_0= ruleModelElement ) )*
            loop2:
            do {
                int alt2=2;
                int LA2_0 = input.LA(1);

                if ( (LA2_0==15||(LA2_0>=17 && LA2_0<=18)) ) {
                    alt2=1;
                }


                switch (alt2) {
            	case 1 :
            	    // InternalKM3.g:151:4: (lv_contents_3_0= ruleModelElement )
            	    {
            	    // InternalKM3.g:151:4: (lv_contents_3_0= ruleModelElement )
            	    // InternalKM3.g:152:5: lv_contents_3_0= ruleModelElement
            	    {

            	    					newCompositeNode(grammarAccess.getPackageAccess().getContentsModelElementParserRuleCall_3_0());
            	    				
            	    pushFollow(FOLLOW_6);
            	    lv_contents_3_0=ruleModelElement();

            	    state._fsp--;


            	    					if (current==null) {
            	    						current = createModelElementForParent(grammarAccess.getPackageRule());
            	    					}
            	    					add(
            	    						current,
            	    						"contents",
            	    						lv_contents_3_0,
            	    						"org.eclipse.m2m.km3.xtext.KM3.ModelElement");
            	    					afterParserOrEnumRuleCall();
            	    				

            	    }


            	    }
            	    break;

            	default :
            	    break loop2;
                }
            } while (true);

            otherlv_4=(Token)match(input,14,FOLLOW_2); 

            			newLeafNode(otherlv_4, grammarAccess.getPackageAccess().getRightCurlyBracketKeyword_4());
            		

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


    // $ANTLR start "entryRuleModelElement"
    // InternalKM3.g:177:1: entryRuleModelElement returns [EObject current=null] : iv_ruleModelElement= ruleModelElement EOF ;
    public final EObject entryRuleModelElement() throws RecognitionException {
        EObject current = null;

        EObject iv_ruleModelElement = null;


        try {
            // InternalKM3.g:177:53: (iv_ruleModelElement= ruleModelElement EOF )
            // InternalKM3.g:178:2: iv_ruleModelElement= ruleModelElement EOF
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
    // InternalKM3.g:184:1: ruleModelElement returns [EObject current=null] : (this_DataType_0= ruleDataType | this_Class_1= ruleClass ) ;
    public final EObject ruleModelElement() throws RecognitionException {
        EObject current = null;

        EObject this_DataType_0 = null;

        EObject this_Class_1 = null;



        	enterRule();

        try {
            // InternalKM3.g:190:2: ( (this_DataType_0= ruleDataType | this_Class_1= ruleClass ) )
            // InternalKM3.g:191:2: (this_DataType_0= ruleDataType | this_Class_1= ruleClass )
            {
            // InternalKM3.g:191:2: (this_DataType_0= ruleDataType | this_Class_1= ruleClass )
            int alt3=2;
            int LA3_0 = input.LA(1);

            if ( (LA3_0==15) ) {
                alt3=1;
            }
            else if ( ((LA3_0>=17 && LA3_0<=18)) ) {
                alt3=2;
            }
            else {
                NoViableAltException nvae =
                    new NoViableAltException("", 3, 0, input);

                throw nvae;
            }
            switch (alt3) {
                case 1 :
                    // InternalKM3.g:192:3: this_DataType_0= ruleDataType
                    {

                    			newCompositeNode(grammarAccess.getModelElementAccess().getDataTypeParserRuleCall_0());
                    		
                    pushFollow(FOLLOW_2);
                    this_DataType_0=ruleDataType();

                    state._fsp--;


                    			current = this_DataType_0;
                    			afterParserOrEnumRuleCall();
                    		

                    }
                    break;
                case 2 :
                    // InternalKM3.g:201:3: this_Class_1= ruleClass
                    {

                    			newCompositeNode(grammarAccess.getModelElementAccess().getClassParserRuleCall_1());
                    		
                    pushFollow(FOLLOW_2);
                    this_Class_1=ruleClass();

                    state._fsp--;


                    			current = this_Class_1;
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


    // $ANTLR start "entryRuleDataType"
    // InternalKM3.g:213:1: entryRuleDataType returns [EObject current=null] : iv_ruleDataType= ruleDataType EOF ;
    public final EObject entryRuleDataType() throws RecognitionException {
        EObject current = null;

        EObject iv_ruleDataType = null;


        try {
            // InternalKM3.g:213:49: (iv_ruleDataType= ruleDataType EOF )
            // InternalKM3.g:214:2: iv_ruleDataType= ruleDataType EOF
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
    // InternalKM3.g:220:1: ruleDataType returns [EObject current=null] : (otherlv_0= 'datatype' ( (lv_name_1_0= RULE_ID ) ) otherlv_2= ';' ) ;
    public final EObject ruleDataType() throws RecognitionException {
        EObject current = null;

        Token otherlv_0=null;
        Token lv_name_1_0=null;
        Token otherlv_2=null;


        	enterRule();

        try {
            // InternalKM3.g:226:2: ( (otherlv_0= 'datatype' ( (lv_name_1_0= RULE_ID ) ) otherlv_2= ';' ) )
            // InternalKM3.g:227:2: (otherlv_0= 'datatype' ( (lv_name_1_0= RULE_ID ) ) otherlv_2= ';' )
            {
            // InternalKM3.g:227:2: (otherlv_0= 'datatype' ( (lv_name_1_0= RULE_ID ) ) otherlv_2= ';' )
            // InternalKM3.g:228:3: otherlv_0= 'datatype' ( (lv_name_1_0= RULE_ID ) ) otherlv_2= ';'
            {
            otherlv_0=(Token)match(input,15,FOLLOW_4); 

            			newLeafNode(otherlv_0, grammarAccess.getDataTypeAccess().getDatatypeKeyword_0());
            		
            // InternalKM3.g:232:3: ( (lv_name_1_0= RULE_ID ) )
            // InternalKM3.g:233:4: (lv_name_1_0= RULE_ID )
            {
            // InternalKM3.g:233:4: (lv_name_1_0= RULE_ID )
            // InternalKM3.g:234:5: lv_name_1_0= RULE_ID
            {
            lv_name_1_0=(Token)match(input,RULE_ID,FOLLOW_7); 

            					newLeafNode(lv_name_1_0, grammarAccess.getDataTypeAccess().getNameIDTerminalRuleCall_1_0());
            				

            					if (current==null) {
            						current = createModelElement(grammarAccess.getDataTypeRule());
            					}
            					setWithLastConsumed(
            						current,
            						"name",
            						lv_name_1_0,
            						"org.eclipse.xtext.common.Terminals.ID");
            				

            }


            }

            otherlv_2=(Token)match(input,16,FOLLOW_2); 

            			newLeafNode(otherlv_2, grammarAccess.getDataTypeAccess().getSemicolonKeyword_2());
            		

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


    // $ANTLR start "entryRuleStructuralFeature"
    // InternalKM3.g:258:1: entryRuleStructuralFeature returns [EObject current=null] : iv_ruleStructuralFeature= ruleStructuralFeature EOF ;
    public final EObject entryRuleStructuralFeature() throws RecognitionException {
        EObject current = null;

        EObject iv_ruleStructuralFeature = null;


        try {
            // InternalKM3.g:258:58: (iv_ruleStructuralFeature= ruleStructuralFeature EOF )
            // InternalKM3.g:259:2: iv_ruleStructuralFeature= ruleStructuralFeature EOF
            {
             newCompositeNode(grammarAccess.getStructuralFeatureRule()); 
            pushFollow(FOLLOW_1);
            iv_ruleStructuralFeature=ruleStructuralFeature();

            state._fsp--;

             current =iv_ruleStructuralFeature; 
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
    // $ANTLR end "entryRuleStructuralFeature"


    // $ANTLR start "ruleStructuralFeature"
    // InternalKM3.g:265:1: ruleStructuralFeature returns [EObject current=null] : (this_Attribute_0= ruleAttribute | this_Reference_1= ruleReference ) ;
    public final EObject ruleStructuralFeature() throws RecognitionException {
        EObject current = null;

        EObject this_Attribute_0 = null;

        EObject this_Reference_1 = null;



        	enterRule();

        try {
            // InternalKM3.g:271:2: ( (this_Attribute_0= ruleAttribute | this_Reference_1= ruleReference ) )
            // InternalKM3.g:272:2: (this_Attribute_0= ruleAttribute | this_Reference_1= ruleReference )
            {
            // InternalKM3.g:272:2: (this_Attribute_0= ruleAttribute | this_Reference_1= ruleReference )
            int alt4=2;
            int LA4_0 = input.LA(1);

            if ( ((LA4_0>=21 && LA4_0<=22)) ) {
                alt4=1;
            }
            else if ( (LA4_0==25) ) {
                alt4=2;
            }
            else {
                NoViableAltException nvae =
                    new NoViableAltException("", 4, 0, input);

                throw nvae;
            }
            switch (alt4) {
                case 1 :
                    // InternalKM3.g:273:3: this_Attribute_0= ruleAttribute
                    {

                    			newCompositeNode(grammarAccess.getStructuralFeatureAccess().getAttributeParserRuleCall_0());
                    		
                    pushFollow(FOLLOW_2);
                    this_Attribute_0=ruleAttribute();

                    state._fsp--;


                    			current = this_Attribute_0;
                    			afterParserOrEnumRuleCall();
                    		

                    }
                    break;
                case 2 :
                    // InternalKM3.g:282:3: this_Reference_1= ruleReference
                    {

                    			newCompositeNode(grammarAccess.getStructuralFeatureAccess().getReferenceParserRuleCall_1());
                    		
                    pushFollow(FOLLOW_2);
                    this_Reference_1=ruleReference();

                    state._fsp--;


                    			current = this_Reference_1;
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
    // $ANTLR end "ruleStructuralFeature"


    // $ANTLR start "entryRuleClass"
    // InternalKM3.g:294:1: entryRuleClass returns [EObject current=null] : iv_ruleClass= ruleClass EOF ;
    public final EObject entryRuleClass() throws RecognitionException {
        EObject current = null;

        EObject iv_ruleClass = null;


        try {
            // InternalKM3.g:294:46: (iv_ruleClass= ruleClass EOF )
            // InternalKM3.g:295:2: iv_ruleClass= ruleClass EOF
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
    // InternalKM3.g:301:1: ruleClass returns [EObject current=null] : ( ( (lv_isAbstract_0_0= 'abstract' ) )? otherlv_1= 'class' ( (lv_name_2_0= RULE_ID ) ) (otherlv_3= 'extends' ( (otherlv_4= RULE_ID ) ) (otherlv_5= ',' ( (otherlv_6= RULE_ID ) ) )* )? otherlv_7= '{' ( (lv_structuralFeatures_8_0= ruleStructuralFeature ) )* otherlv_9= '}' ) ;
    public final EObject ruleClass() throws RecognitionException {
        EObject current = null;

        Token lv_isAbstract_0_0=null;
        Token otherlv_1=null;
        Token lv_name_2_0=null;
        Token otherlv_3=null;
        Token otherlv_4=null;
        Token otherlv_5=null;
        Token otherlv_6=null;
        Token otherlv_7=null;
        Token otherlv_9=null;
        EObject lv_structuralFeatures_8_0 = null;



        	enterRule();

        try {
            // InternalKM3.g:307:2: ( ( ( (lv_isAbstract_0_0= 'abstract' ) )? otherlv_1= 'class' ( (lv_name_2_0= RULE_ID ) ) (otherlv_3= 'extends' ( (otherlv_4= RULE_ID ) ) (otherlv_5= ',' ( (otherlv_6= RULE_ID ) ) )* )? otherlv_7= '{' ( (lv_structuralFeatures_8_0= ruleStructuralFeature ) )* otherlv_9= '}' ) )
            // InternalKM3.g:308:2: ( ( (lv_isAbstract_0_0= 'abstract' ) )? otherlv_1= 'class' ( (lv_name_2_0= RULE_ID ) ) (otherlv_3= 'extends' ( (otherlv_4= RULE_ID ) ) (otherlv_5= ',' ( (otherlv_6= RULE_ID ) ) )* )? otherlv_7= '{' ( (lv_structuralFeatures_8_0= ruleStructuralFeature ) )* otherlv_9= '}' )
            {
            // InternalKM3.g:308:2: ( ( (lv_isAbstract_0_0= 'abstract' ) )? otherlv_1= 'class' ( (lv_name_2_0= RULE_ID ) ) (otherlv_3= 'extends' ( (otherlv_4= RULE_ID ) ) (otherlv_5= ',' ( (otherlv_6= RULE_ID ) ) )* )? otherlv_7= '{' ( (lv_structuralFeatures_8_0= ruleStructuralFeature ) )* otherlv_9= '}' )
            // InternalKM3.g:309:3: ( (lv_isAbstract_0_0= 'abstract' ) )? otherlv_1= 'class' ( (lv_name_2_0= RULE_ID ) ) (otherlv_3= 'extends' ( (otherlv_4= RULE_ID ) ) (otherlv_5= ',' ( (otherlv_6= RULE_ID ) ) )* )? otherlv_7= '{' ( (lv_structuralFeatures_8_0= ruleStructuralFeature ) )* otherlv_9= '}'
            {
            // InternalKM3.g:309:3: ( (lv_isAbstract_0_0= 'abstract' ) )?
            int alt5=2;
            int LA5_0 = input.LA(1);

            if ( (LA5_0==17) ) {
                alt5=1;
            }
            switch (alt5) {
                case 1 :
                    // InternalKM3.g:310:4: (lv_isAbstract_0_0= 'abstract' )
                    {
                    // InternalKM3.g:310:4: (lv_isAbstract_0_0= 'abstract' )
                    // InternalKM3.g:311:5: lv_isAbstract_0_0= 'abstract'
                    {
                    lv_isAbstract_0_0=(Token)match(input,17,FOLLOW_8); 

                    					newLeafNode(lv_isAbstract_0_0, grammarAccess.getClassAccess().getIsAbstractAbstractKeyword_0_0());
                    				

                    					if (current==null) {
                    						current = createModelElement(grammarAccess.getClassRule());
                    					}
                    					setWithLastConsumed(current, "isAbstract", true, "abstract");
                    				

                    }


                    }
                    break;

            }

            otherlv_1=(Token)match(input,18,FOLLOW_4); 

            			newLeafNode(otherlv_1, grammarAccess.getClassAccess().getClassKeyword_1());
            		
            // InternalKM3.g:327:3: ( (lv_name_2_0= RULE_ID ) )
            // InternalKM3.g:328:4: (lv_name_2_0= RULE_ID )
            {
            // InternalKM3.g:328:4: (lv_name_2_0= RULE_ID )
            // InternalKM3.g:329:5: lv_name_2_0= RULE_ID
            {
            lv_name_2_0=(Token)match(input,RULE_ID,FOLLOW_9); 

            					newLeafNode(lv_name_2_0, grammarAccess.getClassAccess().getNameIDTerminalRuleCall_2_0());
            				

            					if (current==null) {
            						current = createModelElement(grammarAccess.getClassRule());
            					}
            					setWithLastConsumed(
            						current,
            						"name",
            						lv_name_2_0,
            						"org.eclipse.xtext.common.Terminals.ID");
            				

            }


            }

            // InternalKM3.g:345:3: (otherlv_3= 'extends' ( (otherlv_4= RULE_ID ) ) (otherlv_5= ',' ( (otherlv_6= RULE_ID ) ) )* )?
            int alt7=2;
            int LA7_0 = input.LA(1);

            if ( (LA7_0==19) ) {
                alt7=1;
            }
            switch (alt7) {
                case 1 :
                    // InternalKM3.g:346:4: otherlv_3= 'extends' ( (otherlv_4= RULE_ID ) ) (otherlv_5= ',' ( (otherlv_6= RULE_ID ) ) )*
                    {
                    otherlv_3=(Token)match(input,19,FOLLOW_4); 

                    				newLeafNode(otherlv_3, grammarAccess.getClassAccess().getExtendsKeyword_3_0());
                    			
                    // InternalKM3.g:350:4: ( (otherlv_4= RULE_ID ) )
                    // InternalKM3.g:351:5: (otherlv_4= RULE_ID )
                    {
                    // InternalKM3.g:351:5: (otherlv_4= RULE_ID )
                    // InternalKM3.g:352:6: otherlv_4= RULE_ID
                    {

                    						if (current==null) {
                    							current = createModelElement(grammarAccess.getClassRule());
                    						}
                    					
                    otherlv_4=(Token)match(input,RULE_ID,FOLLOW_10); 

                    						newLeafNode(otherlv_4, grammarAccess.getClassAccess().getSupertypesClassCrossReference_3_1_0());
                    					

                    }


                    }

                    // InternalKM3.g:363:4: (otherlv_5= ',' ( (otherlv_6= RULE_ID ) ) )*
                    loop6:
                    do {
                        int alt6=2;
                        int LA6_0 = input.LA(1);

                        if ( (LA6_0==20) ) {
                            alt6=1;
                        }


                        switch (alt6) {
                    	case 1 :
                    	    // InternalKM3.g:364:5: otherlv_5= ',' ( (otherlv_6= RULE_ID ) )
                    	    {
                    	    otherlv_5=(Token)match(input,20,FOLLOW_4); 

                    	    					newLeafNode(otherlv_5, grammarAccess.getClassAccess().getCommaKeyword_3_2_0());
                    	    				
                    	    // InternalKM3.g:368:5: ( (otherlv_6= RULE_ID ) )
                    	    // InternalKM3.g:369:6: (otherlv_6= RULE_ID )
                    	    {
                    	    // InternalKM3.g:369:6: (otherlv_6= RULE_ID )
                    	    // InternalKM3.g:370:7: otherlv_6= RULE_ID
                    	    {

                    	    							if (current==null) {
                    	    								current = createModelElement(grammarAccess.getClassRule());
                    	    							}
                    	    						
                    	    otherlv_6=(Token)match(input,RULE_ID,FOLLOW_10); 

                    	    							newLeafNode(otherlv_6, grammarAccess.getClassAccess().getSupertypesClassCrossReference_3_2_1_0());
                    	    						

                    	    }


                    	    }


                    	    }
                    	    break;

                    	default :
                    	    break loop6;
                        }
                    } while (true);


                    }
                    break;

            }

            otherlv_7=(Token)match(input,13,FOLLOW_11); 

            			newLeafNode(otherlv_7, grammarAccess.getClassAccess().getLeftCurlyBracketKeyword_4());
            		
            // InternalKM3.g:387:3: ( (lv_structuralFeatures_8_0= ruleStructuralFeature ) )*
            loop8:
            do {
                int alt8=2;
                int LA8_0 = input.LA(1);

                if ( ((LA8_0>=21 && LA8_0<=22)||LA8_0==25) ) {
                    alt8=1;
                }


                switch (alt8) {
            	case 1 :
            	    // InternalKM3.g:388:4: (lv_structuralFeatures_8_0= ruleStructuralFeature )
            	    {
            	    // InternalKM3.g:388:4: (lv_structuralFeatures_8_0= ruleStructuralFeature )
            	    // InternalKM3.g:389:5: lv_structuralFeatures_8_0= ruleStructuralFeature
            	    {

            	    					newCompositeNode(grammarAccess.getClassAccess().getStructuralFeaturesStructuralFeatureParserRuleCall_5_0());
            	    				
            	    pushFollow(FOLLOW_11);
            	    lv_structuralFeatures_8_0=ruleStructuralFeature();

            	    state._fsp--;


            	    					if (current==null) {
            	    						current = createModelElementForParent(grammarAccess.getClassRule());
            	    					}
            	    					add(
            	    						current,
            	    						"structuralFeatures",
            	    						lv_structuralFeatures_8_0,
            	    						"org.eclipse.m2m.km3.xtext.KM3.StructuralFeature");
            	    					afterParserOrEnumRuleCall();
            	    				

            	    }


            	    }
            	    break;

            	default :
            	    break loop8;
                }
            } while (true);

            otherlv_9=(Token)match(input,14,FOLLOW_2); 

            			newLeafNode(otherlv_9, grammarAccess.getClassAccess().getRightCurlyBracketKeyword_6());
            		

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


    // $ANTLR start "entryRuleAttribute"
    // InternalKM3.g:414:1: entryRuleAttribute returns [EObject current=null] : iv_ruleAttribute= ruleAttribute EOF ;
    public final EObject entryRuleAttribute() throws RecognitionException {
        EObject current = null;

        EObject iv_ruleAttribute = null;


        try {
            // InternalKM3.g:414:50: (iv_ruleAttribute= ruleAttribute EOF )
            // InternalKM3.g:415:2: iv_ruleAttribute= ruleAttribute EOF
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
    // InternalKM3.g:421:1: ruleAttribute returns [EObject current=null] : ( ( (lv_isUnique_0_0= 'unique' ) )? otherlv_1= 'attribute' ( (lv_name_2_0= RULE_ID ) ) ( (lv_isOrdered_3_0= 'ordered' ) )? otherlv_4= ':' ( (otherlv_5= RULE_ID ) ) otherlv_6= ';' ) ;
    public final EObject ruleAttribute() throws RecognitionException {
        EObject current = null;

        Token lv_isUnique_0_0=null;
        Token otherlv_1=null;
        Token lv_name_2_0=null;
        Token lv_isOrdered_3_0=null;
        Token otherlv_4=null;
        Token otherlv_5=null;
        Token otherlv_6=null;


        	enterRule();

        try {
            // InternalKM3.g:427:2: ( ( ( (lv_isUnique_0_0= 'unique' ) )? otherlv_1= 'attribute' ( (lv_name_2_0= RULE_ID ) ) ( (lv_isOrdered_3_0= 'ordered' ) )? otherlv_4= ':' ( (otherlv_5= RULE_ID ) ) otherlv_6= ';' ) )
            // InternalKM3.g:428:2: ( ( (lv_isUnique_0_0= 'unique' ) )? otherlv_1= 'attribute' ( (lv_name_2_0= RULE_ID ) ) ( (lv_isOrdered_3_0= 'ordered' ) )? otherlv_4= ':' ( (otherlv_5= RULE_ID ) ) otherlv_6= ';' )
            {
            // InternalKM3.g:428:2: ( ( (lv_isUnique_0_0= 'unique' ) )? otherlv_1= 'attribute' ( (lv_name_2_0= RULE_ID ) ) ( (lv_isOrdered_3_0= 'ordered' ) )? otherlv_4= ':' ( (otherlv_5= RULE_ID ) ) otherlv_6= ';' )
            // InternalKM3.g:429:3: ( (lv_isUnique_0_0= 'unique' ) )? otherlv_1= 'attribute' ( (lv_name_2_0= RULE_ID ) ) ( (lv_isOrdered_3_0= 'ordered' ) )? otherlv_4= ':' ( (otherlv_5= RULE_ID ) ) otherlv_6= ';'
            {
            // InternalKM3.g:429:3: ( (lv_isUnique_0_0= 'unique' ) )?
            int alt9=2;
            int LA9_0 = input.LA(1);

            if ( (LA9_0==21) ) {
                alt9=1;
            }
            switch (alt9) {
                case 1 :
                    // InternalKM3.g:430:4: (lv_isUnique_0_0= 'unique' )
                    {
                    // InternalKM3.g:430:4: (lv_isUnique_0_0= 'unique' )
                    // InternalKM3.g:431:5: lv_isUnique_0_0= 'unique'
                    {
                    lv_isUnique_0_0=(Token)match(input,21,FOLLOW_12); 

                    					newLeafNode(lv_isUnique_0_0, grammarAccess.getAttributeAccess().getIsUniqueUniqueKeyword_0_0());
                    				

                    					if (current==null) {
                    						current = createModelElement(grammarAccess.getAttributeRule());
                    					}
                    					setWithLastConsumed(current, "isUnique", true, "unique");
                    				

                    }


                    }
                    break;

            }

            otherlv_1=(Token)match(input,22,FOLLOW_4); 

            			newLeafNode(otherlv_1, grammarAccess.getAttributeAccess().getAttributeKeyword_1());
            		
            // InternalKM3.g:447:3: ( (lv_name_2_0= RULE_ID ) )
            // InternalKM3.g:448:4: (lv_name_2_0= RULE_ID )
            {
            // InternalKM3.g:448:4: (lv_name_2_0= RULE_ID )
            // InternalKM3.g:449:5: lv_name_2_0= RULE_ID
            {
            lv_name_2_0=(Token)match(input,RULE_ID,FOLLOW_13); 

            					newLeafNode(lv_name_2_0, grammarAccess.getAttributeAccess().getNameIDTerminalRuleCall_2_0());
            				

            					if (current==null) {
            						current = createModelElement(grammarAccess.getAttributeRule());
            					}
            					setWithLastConsumed(
            						current,
            						"name",
            						lv_name_2_0,
            						"org.eclipse.xtext.common.Terminals.ID");
            				

            }


            }

            // InternalKM3.g:465:3: ( (lv_isOrdered_3_0= 'ordered' ) )?
            int alt10=2;
            int LA10_0 = input.LA(1);

            if ( (LA10_0==23) ) {
                alt10=1;
            }
            switch (alt10) {
                case 1 :
                    // InternalKM3.g:466:4: (lv_isOrdered_3_0= 'ordered' )
                    {
                    // InternalKM3.g:466:4: (lv_isOrdered_3_0= 'ordered' )
                    // InternalKM3.g:467:5: lv_isOrdered_3_0= 'ordered'
                    {
                    lv_isOrdered_3_0=(Token)match(input,23,FOLLOW_14); 

                    					newLeafNode(lv_isOrdered_3_0, grammarAccess.getAttributeAccess().getIsOrderedOrderedKeyword_3_0());
                    				

                    					if (current==null) {
                    						current = createModelElement(grammarAccess.getAttributeRule());
                    					}
                    					setWithLastConsumed(current, "isOrdered", true, "ordered");
                    				

                    }


                    }
                    break;

            }

            otherlv_4=(Token)match(input,24,FOLLOW_4); 

            			newLeafNode(otherlv_4, grammarAccess.getAttributeAccess().getColonKeyword_4());
            		
            // InternalKM3.g:483:3: ( (otherlv_5= RULE_ID ) )
            // InternalKM3.g:484:4: (otherlv_5= RULE_ID )
            {
            // InternalKM3.g:484:4: (otherlv_5= RULE_ID )
            // InternalKM3.g:485:5: otherlv_5= RULE_ID
            {

            					if (current==null) {
            						current = createModelElement(grammarAccess.getAttributeRule());
            					}
            				
            otherlv_5=(Token)match(input,RULE_ID,FOLLOW_7); 

            					newLeafNode(otherlv_5, grammarAccess.getAttributeAccess().getTypeClassifierCrossReference_5_0());
            				

            }


            }

            otherlv_6=(Token)match(input,16,FOLLOW_2); 

            			newLeafNode(otherlv_6, grammarAccess.getAttributeAccess().getSemicolonKeyword_6());
            		

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
    // InternalKM3.g:504:1: entryRuleReference returns [EObject current=null] : iv_ruleReference= ruleReference EOF ;
    public final EObject entryRuleReference() throws RecognitionException {
        EObject current = null;

        EObject iv_ruleReference = null;


        try {
            // InternalKM3.g:504:50: (iv_ruleReference= ruleReference EOF )
            // InternalKM3.g:505:2: iv_ruleReference= ruleReference EOF
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
    // InternalKM3.g:511:1: ruleReference returns [EObject current=null] : (otherlv_0= 'reference' ( (lv_name_1_0= RULE_ID ) ) (otherlv_2= '[' ( ( (lv_lower_3_0= ruleElementBound ) ) otherlv_4= '|' )? ( (lv_upper_5_0= ruleElementBound ) ) otherlv_6= ']' )? ( (lv_isOrdered_7_0= 'ordered' ) )? ( (lv_isContainer_8_0= 'container' ) )? otherlv_9= ':' ( (otherlv_10= RULE_ID ) ) (otherlv_11= 'oppositeOf' ( (otherlv_12= RULE_ID ) ) )? otherlv_13= ';' ) ;
    public final EObject ruleReference() throws RecognitionException {
        EObject current = null;

        Token otherlv_0=null;
        Token lv_name_1_0=null;
        Token otherlv_2=null;
        Token otherlv_4=null;
        Token otherlv_6=null;
        Token lv_isOrdered_7_0=null;
        Token lv_isContainer_8_0=null;
        Token otherlv_9=null;
        Token otherlv_10=null;
        Token otherlv_11=null;
        Token otherlv_12=null;
        Token otherlv_13=null;
        AntlrDatatypeRuleToken lv_lower_3_0 = null;

        AntlrDatatypeRuleToken lv_upper_5_0 = null;



        	enterRule();

        try {
            // InternalKM3.g:517:2: ( (otherlv_0= 'reference' ( (lv_name_1_0= RULE_ID ) ) (otherlv_2= '[' ( ( (lv_lower_3_0= ruleElementBound ) ) otherlv_4= '|' )? ( (lv_upper_5_0= ruleElementBound ) ) otherlv_6= ']' )? ( (lv_isOrdered_7_0= 'ordered' ) )? ( (lv_isContainer_8_0= 'container' ) )? otherlv_9= ':' ( (otherlv_10= RULE_ID ) ) (otherlv_11= 'oppositeOf' ( (otherlv_12= RULE_ID ) ) )? otherlv_13= ';' ) )
            // InternalKM3.g:518:2: (otherlv_0= 'reference' ( (lv_name_1_0= RULE_ID ) ) (otherlv_2= '[' ( ( (lv_lower_3_0= ruleElementBound ) ) otherlv_4= '|' )? ( (lv_upper_5_0= ruleElementBound ) ) otherlv_6= ']' )? ( (lv_isOrdered_7_0= 'ordered' ) )? ( (lv_isContainer_8_0= 'container' ) )? otherlv_9= ':' ( (otherlv_10= RULE_ID ) ) (otherlv_11= 'oppositeOf' ( (otherlv_12= RULE_ID ) ) )? otherlv_13= ';' )
            {
            // InternalKM3.g:518:2: (otherlv_0= 'reference' ( (lv_name_1_0= RULE_ID ) ) (otherlv_2= '[' ( ( (lv_lower_3_0= ruleElementBound ) ) otherlv_4= '|' )? ( (lv_upper_5_0= ruleElementBound ) ) otherlv_6= ']' )? ( (lv_isOrdered_7_0= 'ordered' ) )? ( (lv_isContainer_8_0= 'container' ) )? otherlv_9= ':' ( (otherlv_10= RULE_ID ) ) (otherlv_11= 'oppositeOf' ( (otherlv_12= RULE_ID ) ) )? otherlv_13= ';' )
            // InternalKM3.g:519:3: otherlv_0= 'reference' ( (lv_name_1_0= RULE_ID ) ) (otherlv_2= '[' ( ( (lv_lower_3_0= ruleElementBound ) ) otherlv_4= '|' )? ( (lv_upper_5_0= ruleElementBound ) ) otherlv_6= ']' )? ( (lv_isOrdered_7_0= 'ordered' ) )? ( (lv_isContainer_8_0= 'container' ) )? otherlv_9= ':' ( (otherlv_10= RULE_ID ) ) (otherlv_11= 'oppositeOf' ( (otherlv_12= RULE_ID ) ) )? otherlv_13= ';'
            {
            otherlv_0=(Token)match(input,25,FOLLOW_4); 

            			newLeafNode(otherlv_0, grammarAccess.getReferenceAccess().getReferenceKeyword_0());
            		
            // InternalKM3.g:523:3: ( (lv_name_1_0= RULE_ID ) )
            // InternalKM3.g:524:4: (lv_name_1_0= RULE_ID )
            {
            // InternalKM3.g:524:4: (lv_name_1_0= RULE_ID )
            // InternalKM3.g:525:5: lv_name_1_0= RULE_ID
            {
            lv_name_1_0=(Token)match(input,RULE_ID,FOLLOW_15); 

            					newLeafNode(lv_name_1_0, grammarAccess.getReferenceAccess().getNameIDTerminalRuleCall_1_0());
            				

            					if (current==null) {
            						current = createModelElement(grammarAccess.getReferenceRule());
            					}
            					setWithLastConsumed(
            						current,
            						"name",
            						lv_name_1_0,
            						"org.eclipse.xtext.common.Terminals.ID");
            				

            }


            }

            // InternalKM3.g:541:3: (otherlv_2= '[' ( ( (lv_lower_3_0= ruleElementBound ) ) otherlv_4= '|' )? ( (lv_upper_5_0= ruleElementBound ) ) otherlv_6= ']' )?
            int alt12=2;
            int LA12_0 = input.LA(1);

            if ( (LA12_0==26) ) {
                alt12=1;
            }
            switch (alt12) {
                case 1 :
                    // InternalKM3.g:542:4: otherlv_2= '[' ( ( (lv_lower_3_0= ruleElementBound ) ) otherlv_4= '|' )? ( (lv_upper_5_0= ruleElementBound ) ) otherlv_6= ']'
                    {
                    otherlv_2=(Token)match(input,26,FOLLOW_16); 

                    				newLeafNode(otherlv_2, grammarAccess.getReferenceAccess().getLeftSquareBracketKeyword_2_0());
                    			
                    // InternalKM3.g:546:4: ( ( (lv_lower_3_0= ruleElementBound ) ) otherlv_4= '|' )?
                    int alt11=2;
                    int LA11_0 = input.LA(1);

                    if ( (LA11_0==31) ) {
                        int LA11_1 = input.LA(2);

                        if ( (LA11_1==27) ) {
                            alt11=1;
                        }
                    }
                    else if ( (LA11_0==RULE_INT) ) {
                        int LA11_2 = input.LA(2);

                        if ( (LA11_2==27) ) {
                            alt11=1;
                        }
                    }
                    switch (alt11) {
                        case 1 :
                            // InternalKM3.g:547:5: ( (lv_lower_3_0= ruleElementBound ) ) otherlv_4= '|'
                            {
                            // InternalKM3.g:547:5: ( (lv_lower_3_0= ruleElementBound ) )
                            // InternalKM3.g:548:6: (lv_lower_3_0= ruleElementBound )
                            {
                            // InternalKM3.g:548:6: (lv_lower_3_0= ruleElementBound )
                            // InternalKM3.g:549:7: lv_lower_3_0= ruleElementBound
                            {

                            							newCompositeNode(grammarAccess.getReferenceAccess().getLowerElementBoundParserRuleCall_2_1_0_0());
                            						
                            pushFollow(FOLLOW_17);
                            lv_lower_3_0=ruleElementBound();

                            state._fsp--;


                            							if (current==null) {
                            								current = createModelElementForParent(grammarAccess.getReferenceRule());
                            							}
                            							set(
                            								current,
                            								"lower",
                            								lv_lower_3_0,
                            								"org.eclipse.m2m.km3.xtext.KM3.ElementBound");
                            							afterParserOrEnumRuleCall();
                            						

                            }


                            }

                            otherlv_4=(Token)match(input,27,FOLLOW_16); 

                            					newLeafNode(otherlv_4, grammarAccess.getReferenceAccess().getVerticalLineKeyword_2_1_1());
                            				

                            }
                            break;

                    }

                    // InternalKM3.g:571:4: ( (lv_upper_5_0= ruleElementBound ) )
                    // InternalKM3.g:572:5: (lv_upper_5_0= ruleElementBound )
                    {
                    // InternalKM3.g:572:5: (lv_upper_5_0= ruleElementBound )
                    // InternalKM3.g:573:6: lv_upper_5_0= ruleElementBound
                    {

                    						newCompositeNode(grammarAccess.getReferenceAccess().getUpperElementBoundParserRuleCall_2_2_0());
                    					
                    pushFollow(FOLLOW_18);
                    lv_upper_5_0=ruleElementBound();

                    state._fsp--;


                    						if (current==null) {
                    							current = createModelElementForParent(grammarAccess.getReferenceRule());
                    						}
                    						set(
                    							current,
                    							"upper",
                    							lv_upper_5_0,
                    							"org.eclipse.m2m.km3.xtext.KM3.ElementBound");
                    						afterParserOrEnumRuleCall();
                    					

                    }


                    }

                    otherlv_6=(Token)match(input,28,FOLLOW_19); 

                    				newLeafNode(otherlv_6, grammarAccess.getReferenceAccess().getRightSquareBracketKeyword_2_3());
                    			

                    }
                    break;

            }

            // InternalKM3.g:595:3: ( (lv_isOrdered_7_0= 'ordered' ) )?
            int alt13=2;
            int LA13_0 = input.LA(1);

            if ( (LA13_0==23) ) {
                alt13=1;
            }
            switch (alt13) {
                case 1 :
                    // InternalKM3.g:596:4: (lv_isOrdered_7_0= 'ordered' )
                    {
                    // InternalKM3.g:596:4: (lv_isOrdered_7_0= 'ordered' )
                    // InternalKM3.g:597:5: lv_isOrdered_7_0= 'ordered'
                    {
                    lv_isOrdered_7_0=(Token)match(input,23,FOLLOW_20); 

                    					newLeafNode(lv_isOrdered_7_0, grammarAccess.getReferenceAccess().getIsOrderedOrderedKeyword_3_0());
                    				

                    					if (current==null) {
                    						current = createModelElement(grammarAccess.getReferenceRule());
                    					}
                    					setWithLastConsumed(current, "isOrdered", true, "ordered");
                    				

                    }


                    }
                    break;

            }

            // InternalKM3.g:609:3: ( (lv_isContainer_8_0= 'container' ) )?
            int alt14=2;
            int LA14_0 = input.LA(1);

            if ( (LA14_0==29) ) {
                alt14=1;
            }
            switch (alt14) {
                case 1 :
                    // InternalKM3.g:610:4: (lv_isContainer_8_0= 'container' )
                    {
                    // InternalKM3.g:610:4: (lv_isContainer_8_0= 'container' )
                    // InternalKM3.g:611:5: lv_isContainer_8_0= 'container'
                    {
                    lv_isContainer_8_0=(Token)match(input,29,FOLLOW_14); 

                    					newLeafNode(lv_isContainer_8_0, grammarAccess.getReferenceAccess().getIsContainerContainerKeyword_4_0());
                    				

                    					if (current==null) {
                    						current = createModelElement(grammarAccess.getReferenceRule());
                    					}
                    					setWithLastConsumed(current, "isContainer", true, "container");
                    				

                    }


                    }
                    break;

            }

            otherlv_9=(Token)match(input,24,FOLLOW_4); 

            			newLeafNode(otherlv_9, grammarAccess.getReferenceAccess().getColonKeyword_5());
            		
            // InternalKM3.g:627:3: ( (otherlv_10= RULE_ID ) )
            // InternalKM3.g:628:4: (otherlv_10= RULE_ID )
            {
            // InternalKM3.g:628:4: (otherlv_10= RULE_ID )
            // InternalKM3.g:629:5: otherlv_10= RULE_ID
            {

            					if (current==null) {
            						current = createModelElement(grammarAccess.getReferenceRule());
            					}
            				
            otherlv_10=(Token)match(input,RULE_ID,FOLLOW_21); 

            					newLeafNode(otherlv_10, grammarAccess.getReferenceAccess().getTypeClassifierCrossReference_6_0());
            				

            }


            }

            // InternalKM3.g:640:3: (otherlv_11= 'oppositeOf' ( (otherlv_12= RULE_ID ) ) )?
            int alt15=2;
            int LA15_0 = input.LA(1);

            if ( (LA15_0==30) ) {
                alt15=1;
            }
            switch (alt15) {
                case 1 :
                    // InternalKM3.g:641:4: otherlv_11= 'oppositeOf' ( (otherlv_12= RULE_ID ) )
                    {
                    otherlv_11=(Token)match(input,30,FOLLOW_4); 

                    				newLeafNode(otherlv_11, grammarAccess.getReferenceAccess().getOppositeOfKeyword_7_0());
                    			
                    // InternalKM3.g:645:4: ( (otherlv_12= RULE_ID ) )
                    // InternalKM3.g:646:5: (otherlv_12= RULE_ID )
                    {
                    // InternalKM3.g:646:5: (otherlv_12= RULE_ID )
                    // InternalKM3.g:647:6: otherlv_12= RULE_ID
                    {

                    						if (current==null) {
                    							current = createModelElement(grammarAccess.getReferenceRule());
                    						}
                    					
                    otherlv_12=(Token)match(input,RULE_ID,FOLLOW_7); 

                    						newLeafNode(otherlv_12, grammarAccess.getReferenceAccess().getOppositeReferenceCrossReference_7_1_0());
                    					

                    }


                    }


                    }
                    break;

            }

            otherlv_13=(Token)match(input,16,FOLLOW_2); 

            			newLeafNode(otherlv_13, grammarAccess.getReferenceAccess().getSemicolonKeyword_8());
            		

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


    // $ANTLR start "entryRuleElementBound"
    // InternalKM3.g:667:1: entryRuleElementBound returns [String current=null] : iv_ruleElementBound= ruleElementBound EOF ;
    public final String entryRuleElementBound() throws RecognitionException {
        String current = null;

        AntlrDatatypeRuleToken iv_ruleElementBound = null;


        try {
            // InternalKM3.g:667:52: (iv_ruleElementBound= ruleElementBound EOF )
            // InternalKM3.g:668:2: iv_ruleElementBound= ruleElementBound EOF
            {
             newCompositeNode(grammarAccess.getElementBoundRule()); 
            pushFollow(FOLLOW_1);
            iv_ruleElementBound=ruleElementBound();

            state._fsp--;

             current =iv_ruleElementBound.getText(); 
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
    // $ANTLR end "entryRuleElementBound"


    // $ANTLR start "ruleElementBound"
    // InternalKM3.g:674:1: ruleElementBound returns [AntlrDatatypeRuleToken current=new AntlrDatatypeRuleToken()] : (kw= '*' | this_INT_1= RULE_INT ) ;
    public final AntlrDatatypeRuleToken ruleElementBound() throws RecognitionException {
        AntlrDatatypeRuleToken current = new AntlrDatatypeRuleToken();

        Token kw=null;
        Token this_INT_1=null;


        	enterRule();

        try {
            // InternalKM3.g:680:2: ( (kw= '*' | this_INT_1= RULE_INT ) )
            // InternalKM3.g:681:2: (kw= '*' | this_INT_1= RULE_INT )
            {
            // InternalKM3.g:681:2: (kw= '*' | this_INT_1= RULE_INT )
            int alt16=2;
            int LA16_0 = input.LA(1);

            if ( (LA16_0==31) ) {
                alt16=1;
            }
            else if ( (LA16_0==RULE_INT) ) {
                alt16=2;
            }
            else {
                NoViableAltException nvae =
                    new NoViableAltException("", 16, 0, input);

                throw nvae;
            }
            switch (alt16) {
                case 1 :
                    // InternalKM3.g:682:3: kw= '*'
                    {
                    kw=(Token)match(input,31,FOLLOW_2); 

                    			current.merge(kw);
                    			newLeafNode(kw, grammarAccess.getElementBoundAccess().getAsteriskKeyword_0());
                    		

                    }
                    break;
                case 2 :
                    // InternalKM3.g:688:3: this_INT_1= RULE_INT
                    {
                    this_INT_1=(Token)match(input,RULE_INT,FOLLOW_2); 

                    			current.merge(this_INT_1);
                    		

                    			newLeafNode(this_INT_1, grammarAccess.getElementBoundAccess().getINTTerminalRuleCall_1());
                    		

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
    // $ANTLR end "ruleElementBound"

    // Delegated rules


 

    public static final BitSet FOLLOW_1 = new BitSet(new long[]{0x0000000000000000L});
    public static final BitSet FOLLOW_2 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_3 = new BitSet(new long[]{0x0000000000001002L});
    public static final BitSet FOLLOW_4 = new BitSet(new long[]{0x0000000000000010L});
    public static final BitSet FOLLOW_5 = new BitSet(new long[]{0x0000000000002000L});
    public static final BitSet FOLLOW_6 = new BitSet(new long[]{0x000000000006C000L});
    public static final BitSet FOLLOW_7 = new BitSet(new long[]{0x0000000000010000L});
    public static final BitSet FOLLOW_8 = new BitSet(new long[]{0x0000000000040000L});
    public static final BitSet FOLLOW_9 = new BitSet(new long[]{0x0000000000082000L});
    public static final BitSet FOLLOW_10 = new BitSet(new long[]{0x0000000000102000L});
    public static final BitSet FOLLOW_11 = new BitSet(new long[]{0x0000000002604000L});
    public static final BitSet FOLLOW_12 = new BitSet(new long[]{0x0000000000400000L});
    public static final BitSet FOLLOW_13 = new BitSet(new long[]{0x0000000001800000L});
    public static final BitSet FOLLOW_14 = new BitSet(new long[]{0x0000000001000000L});
    public static final BitSet FOLLOW_15 = new BitSet(new long[]{0x0000000025800000L});
    public static final BitSet FOLLOW_16 = new BitSet(new long[]{0x0000000080000020L});
    public static final BitSet FOLLOW_17 = new BitSet(new long[]{0x0000000008000000L});
    public static final BitSet FOLLOW_18 = new BitSet(new long[]{0x0000000010000000L});
    public static final BitSet FOLLOW_19 = new BitSet(new long[]{0x0000000021800000L});
    public static final BitSet FOLLOW_20 = new BitSet(new long[]{0x0000000021000000L});
    public static final BitSet FOLLOW_21 = new BitSet(new long[]{0x0000000040010000L});

}