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
        "<invalid>", "<EOR>", "<DOWN>", "<UP>", "RULE_ID", "RULE_INT", "RULE_STRING", "RULE_ML_COMMENT", "RULE_SL_COMMENT", "RULE_WS", "RULE_ANY_OTHER", "'package'", "'{'", "'}'", "'datatype'", "';'"
    };
    public static final int RULE_ID=4;
    public static final int RULE_WS=9;
    public static final int RULE_STRING=6;
    public static final int RULE_ANY_OTHER=10;
    public static final int RULE_SL_COMMENT=8;
    public static final int T__15=15;
    public static final int RULE_INT=5;
    public static final int T__11=11;
    public static final int RULE_ML_COMMENT=7;
    public static final int T__12=12;
    public static final int T__13=13;
    public static final int T__14=14;
    public static final int EOF=-1;

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
        	return "Package";
       	}

       	@Override
       	protected KM3GrammarAccess getGrammarAccess() {
       		return grammarAccess;
       	}




    // $ANTLR start "entryRulePackage"
    // InternalKM3.g:64:1: entryRulePackage returns [EObject current=null] : iv_rulePackage= rulePackage EOF ;
    public final EObject entryRulePackage() throws RecognitionException {
        EObject current = null;

        EObject iv_rulePackage = null;


        try {
            // InternalKM3.g:64:48: (iv_rulePackage= rulePackage EOF )
            // InternalKM3.g:65:2: iv_rulePackage= rulePackage EOF
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
    // InternalKM3.g:71:1: rulePackage returns [EObject current=null] : (otherlv_0= 'package' ( (lv_name_1_0= RULE_ID ) ) otherlv_2= '{' ( (lv_contents_3_0= ruleModelElement ) )* otherlv_4= '}' ) ;
    public final EObject rulePackage() throws RecognitionException {
        EObject current = null;

        Token otherlv_0=null;
        Token lv_name_1_0=null;
        Token otherlv_2=null;
        Token otherlv_4=null;
        EObject lv_contents_3_0 = null;



        	enterRule();

        try {
            // InternalKM3.g:77:2: ( (otherlv_0= 'package' ( (lv_name_1_0= RULE_ID ) ) otherlv_2= '{' ( (lv_contents_3_0= ruleModelElement ) )* otherlv_4= '}' ) )
            // InternalKM3.g:78:2: (otherlv_0= 'package' ( (lv_name_1_0= RULE_ID ) ) otherlv_2= '{' ( (lv_contents_3_0= ruleModelElement ) )* otherlv_4= '}' )
            {
            // InternalKM3.g:78:2: (otherlv_0= 'package' ( (lv_name_1_0= RULE_ID ) ) otherlv_2= '{' ( (lv_contents_3_0= ruleModelElement ) )* otherlv_4= '}' )
            // InternalKM3.g:79:3: otherlv_0= 'package' ( (lv_name_1_0= RULE_ID ) ) otherlv_2= '{' ( (lv_contents_3_0= ruleModelElement ) )* otherlv_4= '}'
            {
            otherlv_0=(Token)match(input,11,FOLLOW_3); 

            			newLeafNode(otherlv_0, grammarAccess.getPackageAccess().getPackageKeyword_0());
            		
            // InternalKM3.g:83:3: ( (lv_name_1_0= RULE_ID ) )
            // InternalKM3.g:84:4: (lv_name_1_0= RULE_ID )
            {
            // InternalKM3.g:84:4: (lv_name_1_0= RULE_ID )
            // InternalKM3.g:85:5: lv_name_1_0= RULE_ID
            {
            lv_name_1_0=(Token)match(input,RULE_ID,FOLLOW_4); 

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

            otherlv_2=(Token)match(input,12,FOLLOW_5); 

            			newLeafNode(otherlv_2, grammarAccess.getPackageAccess().getLeftCurlyBracketKeyword_2());
            		
            // InternalKM3.g:105:3: ( (lv_contents_3_0= ruleModelElement ) )*
            loop1:
            do {
                int alt1=2;
                int LA1_0 = input.LA(1);

                if ( (LA1_0==14) ) {
                    alt1=1;
                }


                switch (alt1) {
            	case 1 :
            	    // InternalKM3.g:106:4: (lv_contents_3_0= ruleModelElement )
            	    {
            	    // InternalKM3.g:106:4: (lv_contents_3_0= ruleModelElement )
            	    // InternalKM3.g:107:5: lv_contents_3_0= ruleModelElement
            	    {

            	    					newCompositeNode(grammarAccess.getPackageAccess().getContentsModelElementParserRuleCall_3_0());
            	    				
            	    pushFollow(FOLLOW_5);
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
            	    break loop1;
                }
            } while (true);

            otherlv_4=(Token)match(input,13,FOLLOW_2); 

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
    // InternalKM3.g:132:1: entryRuleModelElement returns [EObject current=null] : iv_ruleModelElement= ruleModelElement EOF ;
    public final EObject entryRuleModelElement() throws RecognitionException {
        EObject current = null;

        EObject iv_ruleModelElement = null;


        try {
            // InternalKM3.g:132:53: (iv_ruleModelElement= ruleModelElement EOF )
            // InternalKM3.g:133:2: iv_ruleModelElement= ruleModelElement EOF
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
    // InternalKM3.g:139:1: ruleModelElement returns [EObject current=null] : this_DataType_0= ruleDataType ;
    public final EObject ruleModelElement() throws RecognitionException {
        EObject current = null;

        EObject this_DataType_0 = null;



        	enterRule();

        try {
            // InternalKM3.g:145:2: (this_DataType_0= ruleDataType )
            // InternalKM3.g:146:2: this_DataType_0= ruleDataType
            {

            		newCompositeNode(grammarAccess.getModelElementAccess().getDataTypeParserRuleCall());
            	
            pushFollow(FOLLOW_2);
            this_DataType_0=ruleDataType();

            state._fsp--;


            		current = this_DataType_0;
            		afterParserOrEnumRuleCall();
            	

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
    // InternalKM3.g:157:1: entryRuleDataType returns [EObject current=null] : iv_ruleDataType= ruleDataType EOF ;
    public final EObject entryRuleDataType() throws RecognitionException {
        EObject current = null;

        EObject iv_ruleDataType = null;


        try {
            // InternalKM3.g:157:49: (iv_ruleDataType= ruleDataType EOF )
            // InternalKM3.g:158:2: iv_ruleDataType= ruleDataType EOF
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
    // InternalKM3.g:164:1: ruleDataType returns [EObject current=null] : (otherlv_0= 'datatype' ( (lv_name_1_0= RULE_ID ) ) otherlv_2= ';' ) ;
    public final EObject ruleDataType() throws RecognitionException {
        EObject current = null;

        Token otherlv_0=null;
        Token lv_name_1_0=null;
        Token otherlv_2=null;


        	enterRule();

        try {
            // InternalKM3.g:170:2: ( (otherlv_0= 'datatype' ( (lv_name_1_0= RULE_ID ) ) otherlv_2= ';' ) )
            // InternalKM3.g:171:2: (otherlv_0= 'datatype' ( (lv_name_1_0= RULE_ID ) ) otherlv_2= ';' )
            {
            // InternalKM3.g:171:2: (otherlv_0= 'datatype' ( (lv_name_1_0= RULE_ID ) ) otherlv_2= ';' )
            // InternalKM3.g:172:3: otherlv_0= 'datatype' ( (lv_name_1_0= RULE_ID ) ) otherlv_2= ';'
            {
            otherlv_0=(Token)match(input,14,FOLLOW_3); 

            			newLeafNode(otherlv_0, grammarAccess.getDataTypeAccess().getDatatypeKeyword_0());
            		
            // InternalKM3.g:176:3: ( (lv_name_1_0= RULE_ID ) )
            // InternalKM3.g:177:4: (lv_name_1_0= RULE_ID )
            {
            // InternalKM3.g:177:4: (lv_name_1_0= RULE_ID )
            // InternalKM3.g:178:5: lv_name_1_0= RULE_ID
            {
            lv_name_1_0=(Token)match(input,RULE_ID,FOLLOW_6); 

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

            otherlv_2=(Token)match(input,15,FOLLOW_2); 

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

    // Delegated rules


 

    public static final BitSet FOLLOW_1 = new BitSet(new long[]{0x0000000000000000L});
    public static final BitSet FOLLOW_2 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_3 = new BitSet(new long[]{0x0000000000000010L});
    public static final BitSet FOLLOW_4 = new BitSet(new long[]{0x0000000000001000L});
    public static final BitSet FOLLOW_5 = new BitSet(new long[]{0x0000000000006000L});
    public static final BitSet FOLLOW_6 = new BitSet(new long[]{0x0000000000008000L});

}