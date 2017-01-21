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



import org.antlr.runtime.*;
import java.util.Stack;
import java.util.List;
import java.util.ArrayList;

@SuppressWarnings("all")
public class InternalKM3Parser extends AbstractInternalContentAssistParser {
    public static final String[] tokenNames = new String[] {
        "<invalid>", "<EOR>", "<DOWN>", "<UP>", "RULE_ID", "RULE_INT", "RULE_STRING", "RULE_ML_COMMENT", "RULE_SL_COMMENT", "RULE_WS", "RULE_ANY_OTHER", "'package'", "'{'", "'}'", "'datatype'", "';'", "'class'", "'extends'", "','", "'attribute'", "':'", "'type'", "'abstract'", "'unique'", "'ordered'"
    };
    public static final int RULE_STRING=6;
    public static final int RULE_SL_COMMENT=8;
    public static final int T__19=19;
    public static final int T__15=15;
    public static final int T__16=16;
    public static final int T__17=17;
    public static final int T__18=18;
    public static final int T__11=11;
    public static final int T__12=12;
    public static final int T__13=13;
    public static final int T__14=14;
    public static final int EOF=-1;
    public static final int RULE_ID=4;
    public static final int RULE_WS=9;
    public static final int RULE_ANY_OTHER=10;
    public static final int RULE_INT=5;
    public static final int T__22=22;
    public static final int RULE_ML_COMMENT=7;
    public static final int T__23=23;
    public static final int T__24=24;
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



    // $ANTLR start "entryRulePackage"
    // InternalKM3.g:53:1: entryRulePackage : rulePackage EOF ;
    public final void entryRulePackage() throws RecognitionException {
        try {
            // InternalKM3.g:54:1: ( rulePackage EOF )
            // InternalKM3.g:55:1: rulePackage EOF
            {
             before(grammarAccess.getPackageRule()); 
            pushFollow(FOLLOW_1);
            rulePackage();

            state._fsp--;

             after(grammarAccess.getPackageRule()); 
            match(input,EOF,FOLLOW_2); 

            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {
        }
        return ;
    }
    // $ANTLR end "entryRulePackage"


    // $ANTLR start "rulePackage"
    // InternalKM3.g:62:1: rulePackage : ( ( rule__Package__Group__0 ) ) ;
    public final void rulePackage() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:66:2: ( ( ( rule__Package__Group__0 ) ) )
            // InternalKM3.g:67:2: ( ( rule__Package__Group__0 ) )
            {
            // InternalKM3.g:67:2: ( ( rule__Package__Group__0 ) )
            // InternalKM3.g:68:3: ( rule__Package__Group__0 )
            {
             before(grammarAccess.getPackageAccess().getGroup()); 
            // InternalKM3.g:69:3: ( rule__Package__Group__0 )
            // InternalKM3.g:69:4: rule__Package__Group__0
            {
            pushFollow(FOLLOW_2);
            rule__Package__Group__0();

            state._fsp--;


            }

             after(grammarAccess.getPackageAccess().getGroup()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rulePackage"


    // $ANTLR start "entryRuleModelElement"
    // InternalKM3.g:78:1: entryRuleModelElement : ruleModelElement EOF ;
    public final void entryRuleModelElement() throws RecognitionException {
        try {
            // InternalKM3.g:79:1: ( ruleModelElement EOF )
            // InternalKM3.g:80:1: ruleModelElement EOF
            {
             before(grammarAccess.getModelElementRule()); 
            pushFollow(FOLLOW_1);
            ruleModelElement();

            state._fsp--;

             after(grammarAccess.getModelElementRule()); 
            match(input,EOF,FOLLOW_2); 

            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {
        }
        return ;
    }
    // $ANTLR end "entryRuleModelElement"


    // $ANTLR start "ruleModelElement"
    // InternalKM3.g:87:1: ruleModelElement : ( ( rule__ModelElement__Alternatives ) ) ;
    public final void ruleModelElement() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:91:2: ( ( ( rule__ModelElement__Alternatives ) ) )
            // InternalKM3.g:92:2: ( ( rule__ModelElement__Alternatives ) )
            {
            // InternalKM3.g:92:2: ( ( rule__ModelElement__Alternatives ) )
            // InternalKM3.g:93:3: ( rule__ModelElement__Alternatives )
            {
             before(grammarAccess.getModelElementAccess().getAlternatives()); 
            // InternalKM3.g:94:3: ( rule__ModelElement__Alternatives )
            // InternalKM3.g:94:4: rule__ModelElement__Alternatives
            {
            pushFollow(FOLLOW_2);
            rule__ModelElement__Alternatives();

            state._fsp--;


            }

             after(grammarAccess.getModelElementAccess().getAlternatives()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "ruleModelElement"


    // $ANTLR start "entryRuleDataType"
    // InternalKM3.g:103:1: entryRuleDataType : ruleDataType EOF ;
    public final void entryRuleDataType() throws RecognitionException {
        try {
            // InternalKM3.g:104:1: ( ruleDataType EOF )
            // InternalKM3.g:105:1: ruleDataType EOF
            {
             before(grammarAccess.getDataTypeRule()); 
            pushFollow(FOLLOW_1);
            ruleDataType();

            state._fsp--;

             after(grammarAccess.getDataTypeRule()); 
            match(input,EOF,FOLLOW_2); 

            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {
        }
        return ;
    }
    // $ANTLR end "entryRuleDataType"


    // $ANTLR start "ruleDataType"
    // InternalKM3.g:112:1: ruleDataType : ( ( rule__DataType__Group__0 ) ) ;
    public final void ruleDataType() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:116:2: ( ( ( rule__DataType__Group__0 ) ) )
            // InternalKM3.g:117:2: ( ( rule__DataType__Group__0 ) )
            {
            // InternalKM3.g:117:2: ( ( rule__DataType__Group__0 ) )
            // InternalKM3.g:118:3: ( rule__DataType__Group__0 )
            {
             before(grammarAccess.getDataTypeAccess().getGroup()); 
            // InternalKM3.g:119:3: ( rule__DataType__Group__0 )
            // InternalKM3.g:119:4: rule__DataType__Group__0
            {
            pushFollow(FOLLOW_2);
            rule__DataType__Group__0();

            state._fsp--;


            }

             after(grammarAccess.getDataTypeAccess().getGroup()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "ruleDataType"


    // $ANTLR start "entryRuleClass"
    // InternalKM3.g:128:1: entryRuleClass : ruleClass EOF ;
    public final void entryRuleClass() throws RecognitionException {
        try {
            // InternalKM3.g:129:1: ( ruleClass EOF )
            // InternalKM3.g:130:1: ruleClass EOF
            {
             before(grammarAccess.getClassRule()); 
            pushFollow(FOLLOW_1);
            ruleClass();

            state._fsp--;

             after(grammarAccess.getClassRule()); 
            match(input,EOF,FOLLOW_2); 

            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {
        }
        return ;
    }
    // $ANTLR end "entryRuleClass"


    // $ANTLR start "ruleClass"
    // InternalKM3.g:137:1: ruleClass : ( ( rule__Class__Group__0 ) ) ;
    public final void ruleClass() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:141:2: ( ( ( rule__Class__Group__0 ) ) )
            // InternalKM3.g:142:2: ( ( rule__Class__Group__0 ) )
            {
            // InternalKM3.g:142:2: ( ( rule__Class__Group__0 ) )
            // InternalKM3.g:143:3: ( rule__Class__Group__0 )
            {
             before(grammarAccess.getClassAccess().getGroup()); 
            // InternalKM3.g:144:3: ( rule__Class__Group__0 )
            // InternalKM3.g:144:4: rule__Class__Group__0
            {
            pushFollow(FOLLOW_2);
            rule__Class__Group__0();

            state._fsp--;


            }

             after(grammarAccess.getClassAccess().getGroup()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "ruleClass"


    // $ANTLR start "entryRuleStructuralFeature"
    // InternalKM3.g:153:1: entryRuleStructuralFeature : ruleStructuralFeature EOF ;
    public final void entryRuleStructuralFeature() throws RecognitionException {
        try {
            // InternalKM3.g:154:1: ( ruleStructuralFeature EOF )
            // InternalKM3.g:155:1: ruleStructuralFeature EOF
            {
             before(grammarAccess.getStructuralFeatureRule()); 
            pushFollow(FOLLOW_1);
            ruleStructuralFeature();

            state._fsp--;

             after(grammarAccess.getStructuralFeatureRule()); 
            match(input,EOF,FOLLOW_2); 

            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {
        }
        return ;
    }
    // $ANTLR end "entryRuleStructuralFeature"


    // $ANTLR start "ruleStructuralFeature"
    // InternalKM3.g:162:1: ruleStructuralFeature : ( ruleAttribute ) ;
    public final void ruleStructuralFeature() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:166:2: ( ( ruleAttribute ) )
            // InternalKM3.g:167:2: ( ruleAttribute )
            {
            // InternalKM3.g:167:2: ( ruleAttribute )
            // InternalKM3.g:168:3: ruleAttribute
            {
             before(grammarAccess.getStructuralFeatureAccess().getAttributeParserRuleCall()); 
            pushFollow(FOLLOW_2);
            ruleAttribute();

            state._fsp--;

             after(grammarAccess.getStructuralFeatureAccess().getAttributeParserRuleCall()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "ruleStructuralFeature"


    // $ANTLR start "entryRuleAttribute"
    // InternalKM3.g:178:1: entryRuleAttribute : ruleAttribute EOF ;
    public final void entryRuleAttribute() throws RecognitionException {
        try {
            // InternalKM3.g:179:1: ( ruleAttribute EOF )
            // InternalKM3.g:180:1: ruleAttribute EOF
            {
             before(grammarAccess.getAttributeRule()); 
            pushFollow(FOLLOW_1);
            ruleAttribute();

            state._fsp--;

             after(grammarAccess.getAttributeRule()); 
            match(input,EOF,FOLLOW_2); 

            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {
        }
        return ;
    }
    // $ANTLR end "entryRuleAttribute"


    // $ANTLR start "ruleAttribute"
    // InternalKM3.g:187:1: ruleAttribute : ( ( rule__Attribute__Group__0 ) ) ;
    public final void ruleAttribute() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:191:2: ( ( ( rule__Attribute__Group__0 ) ) )
            // InternalKM3.g:192:2: ( ( rule__Attribute__Group__0 ) )
            {
            // InternalKM3.g:192:2: ( ( rule__Attribute__Group__0 ) )
            // InternalKM3.g:193:3: ( rule__Attribute__Group__0 )
            {
             before(grammarAccess.getAttributeAccess().getGroup()); 
            // InternalKM3.g:194:3: ( rule__Attribute__Group__0 )
            // InternalKM3.g:194:4: rule__Attribute__Group__0
            {
            pushFollow(FOLLOW_2);
            rule__Attribute__Group__0();

            state._fsp--;


            }

             after(grammarAccess.getAttributeAccess().getGroup()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "ruleAttribute"


    // $ANTLR start "rule__ModelElement__Alternatives"
    // InternalKM3.g:202:1: rule__ModelElement__Alternatives : ( ( ruleDataType ) | ( ruleClass ) );
    public final void rule__ModelElement__Alternatives() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:206:1: ( ( ruleDataType ) | ( ruleClass ) )
            int alt1=2;
            int LA1_0 = input.LA(1);

            if ( (LA1_0==14) ) {
                alt1=1;
            }
            else if ( (LA1_0==16||LA1_0==22) ) {
                alt1=2;
            }
            else {
                NoViableAltException nvae =
                    new NoViableAltException("", 1, 0, input);

                throw nvae;
            }
            switch (alt1) {
                case 1 :
                    // InternalKM3.g:207:2: ( ruleDataType )
                    {
                    // InternalKM3.g:207:2: ( ruleDataType )
                    // InternalKM3.g:208:3: ruleDataType
                    {
                     before(grammarAccess.getModelElementAccess().getDataTypeParserRuleCall_0()); 
                    pushFollow(FOLLOW_2);
                    ruleDataType();

                    state._fsp--;

                     after(grammarAccess.getModelElementAccess().getDataTypeParserRuleCall_0()); 

                    }


                    }
                    break;
                case 2 :
                    // InternalKM3.g:213:2: ( ruleClass )
                    {
                    // InternalKM3.g:213:2: ( ruleClass )
                    // InternalKM3.g:214:3: ruleClass
                    {
                     before(grammarAccess.getModelElementAccess().getClassParserRuleCall_1()); 
                    pushFollow(FOLLOW_2);
                    ruleClass();

                    state._fsp--;

                     after(grammarAccess.getModelElementAccess().getClassParserRuleCall_1()); 

                    }


                    }
                    break;

            }
        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__ModelElement__Alternatives"


    // $ANTLR start "rule__Package__Group__0"
    // InternalKM3.g:223:1: rule__Package__Group__0 : rule__Package__Group__0__Impl rule__Package__Group__1 ;
    public final void rule__Package__Group__0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:227:1: ( rule__Package__Group__0__Impl rule__Package__Group__1 )
            // InternalKM3.g:228:2: rule__Package__Group__0__Impl rule__Package__Group__1
            {
            pushFollow(FOLLOW_3);
            rule__Package__Group__0__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__Package__Group__1();

            state._fsp--;


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__Package__Group__0"


    // $ANTLR start "rule__Package__Group__0__Impl"
    // InternalKM3.g:235:1: rule__Package__Group__0__Impl : ( 'package' ) ;
    public final void rule__Package__Group__0__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:239:1: ( ( 'package' ) )
            // InternalKM3.g:240:1: ( 'package' )
            {
            // InternalKM3.g:240:1: ( 'package' )
            // InternalKM3.g:241:2: 'package'
            {
             before(grammarAccess.getPackageAccess().getPackageKeyword_0()); 
            match(input,11,FOLLOW_2); 
             after(grammarAccess.getPackageAccess().getPackageKeyword_0()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__Package__Group__0__Impl"


    // $ANTLR start "rule__Package__Group__1"
    // InternalKM3.g:250:1: rule__Package__Group__1 : rule__Package__Group__1__Impl rule__Package__Group__2 ;
    public final void rule__Package__Group__1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:254:1: ( rule__Package__Group__1__Impl rule__Package__Group__2 )
            // InternalKM3.g:255:2: rule__Package__Group__1__Impl rule__Package__Group__2
            {
            pushFollow(FOLLOW_4);
            rule__Package__Group__1__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__Package__Group__2();

            state._fsp--;


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__Package__Group__1"


    // $ANTLR start "rule__Package__Group__1__Impl"
    // InternalKM3.g:262:1: rule__Package__Group__1__Impl : ( ( rule__Package__NameAssignment_1 ) ) ;
    public final void rule__Package__Group__1__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:266:1: ( ( ( rule__Package__NameAssignment_1 ) ) )
            // InternalKM3.g:267:1: ( ( rule__Package__NameAssignment_1 ) )
            {
            // InternalKM3.g:267:1: ( ( rule__Package__NameAssignment_1 ) )
            // InternalKM3.g:268:2: ( rule__Package__NameAssignment_1 )
            {
             before(grammarAccess.getPackageAccess().getNameAssignment_1()); 
            // InternalKM3.g:269:2: ( rule__Package__NameAssignment_1 )
            // InternalKM3.g:269:3: rule__Package__NameAssignment_1
            {
            pushFollow(FOLLOW_2);
            rule__Package__NameAssignment_1();

            state._fsp--;


            }

             after(grammarAccess.getPackageAccess().getNameAssignment_1()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__Package__Group__1__Impl"


    // $ANTLR start "rule__Package__Group__2"
    // InternalKM3.g:277:1: rule__Package__Group__2 : rule__Package__Group__2__Impl rule__Package__Group__3 ;
    public final void rule__Package__Group__2() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:281:1: ( rule__Package__Group__2__Impl rule__Package__Group__3 )
            // InternalKM3.g:282:2: rule__Package__Group__2__Impl rule__Package__Group__3
            {
            pushFollow(FOLLOW_5);
            rule__Package__Group__2__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__Package__Group__3();

            state._fsp--;


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__Package__Group__2"


    // $ANTLR start "rule__Package__Group__2__Impl"
    // InternalKM3.g:289:1: rule__Package__Group__2__Impl : ( '{' ) ;
    public final void rule__Package__Group__2__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:293:1: ( ( '{' ) )
            // InternalKM3.g:294:1: ( '{' )
            {
            // InternalKM3.g:294:1: ( '{' )
            // InternalKM3.g:295:2: '{'
            {
             before(grammarAccess.getPackageAccess().getLeftCurlyBracketKeyword_2()); 
            match(input,12,FOLLOW_2); 
             after(grammarAccess.getPackageAccess().getLeftCurlyBracketKeyword_2()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__Package__Group__2__Impl"


    // $ANTLR start "rule__Package__Group__3"
    // InternalKM3.g:304:1: rule__Package__Group__3 : rule__Package__Group__3__Impl rule__Package__Group__4 ;
    public final void rule__Package__Group__3() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:308:1: ( rule__Package__Group__3__Impl rule__Package__Group__4 )
            // InternalKM3.g:309:2: rule__Package__Group__3__Impl rule__Package__Group__4
            {
            pushFollow(FOLLOW_5);
            rule__Package__Group__3__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__Package__Group__4();

            state._fsp--;


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__Package__Group__3"


    // $ANTLR start "rule__Package__Group__3__Impl"
    // InternalKM3.g:316:1: rule__Package__Group__3__Impl : ( ( rule__Package__ContentsAssignment_3 )* ) ;
    public final void rule__Package__Group__3__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:320:1: ( ( ( rule__Package__ContentsAssignment_3 )* ) )
            // InternalKM3.g:321:1: ( ( rule__Package__ContentsAssignment_3 )* )
            {
            // InternalKM3.g:321:1: ( ( rule__Package__ContentsAssignment_3 )* )
            // InternalKM3.g:322:2: ( rule__Package__ContentsAssignment_3 )*
            {
             before(grammarAccess.getPackageAccess().getContentsAssignment_3()); 
            // InternalKM3.g:323:2: ( rule__Package__ContentsAssignment_3 )*
            loop2:
            do {
                int alt2=2;
                int LA2_0 = input.LA(1);

                if ( (LA2_0==14||LA2_0==16||LA2_0==22) ) {
                    alt2=1;
                }


                switch (alt2) {
            	case 1 :
            	    // InternalKM3.g:323:3: rule__Package__ContentsAssignment_3
            	    {
            	    pushFollow(FOLLOW_6);
            	    rule__Package__ContentsAssignment_3();

            	    state._fsp--;


            	    }
            	    break;

            	default :
            	    break loop2;
                }
            } while (true);

             after(grammarAccess.getPackageAccess().getContentsAssignment_3()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__Package__Group__3__Impl"


    // $ANTLR start "rule__Package__Group__4"
    // InternalKM3.g:331:1: rule__Package__Group__4 : rule__Package__Group__4__Impl ;
    public final void rule__Package__Group__4() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:335:1: ( rule__Package__Group__4__Impl )
            // InternalKM3.g:336:2: rule__Package__Group__4__Impl
            {
            pushFollow(FOLLOW_2);
            rule__Package__Group__4__Impl();

            state._fsp--;


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__Package__Group__4"


    // $ANTLR start "rule__Package__Group__4__Impl"
    // InternalKM3.g:342:1: rule__Package__Group__4__Impl : ( '}' ) ;
    public final void rule__Package__Group__4__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:346:1: ( ( '}' ) )
            // InternalKM3.g:347:1: ( '}' )
            {
            // InternalKM3.g:347:1: ( '}' )
            // InternalKM3.g:348:2: '}'
            {
             before(grammarAccess.getPackageAccess().getRightCurlyBracketKeyword_4()); 
            match(input,13,FOLLOW_2); 
             after(grammarAccess.getPackageAccess().getRightCurlyBracketKeyword_4()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__Package__Group__4__Impl"


    // $ANTLR start "rule__DataType__Group__0"
    // InternalKM3.g:358:1: rule__DataType__Group__0 : rule__DataType__Group__0__Impl rule__DataType__Group__1 ;
    public final void rule__DataType__Group__0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:362:1: ( rule__DataType__Group__0__Impl rule__DataType__Group__1 )
            // InternalKM3.g:363:2: rule__DataType__Group__0__Impl rule__DataType__Group__1
            {
            pushFollow(FOLLOW_3);
            rule__DataType__Group__0__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__DataType__Group__1();

            state._fsp--;


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__DataType__Group__0"


    // $ANTLR start "rule__DataType__Group__0__Impl"
    // InternalKM3.g:370:1: rule__DataType__Group__0__Impl : ( 'datatype' ) ;
    public final void rule__DataType__Group__0__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:374:1: ( ( 'datatype' ) )
            // InternalKM3.g:375:1: ( 'datatype' )
            {
            // InternalKM3.g:375:1: ( 'datatype' )
            // InternalKM3.g:376:2: 'datatype'
            {
             before(grammarAccess.getDataTypeAccess().getDatatypeKeyword_0()); 
            match(input,14,FOLLOW_2); 
             after(grammarAccess.getDataTypeAccess().getDatatypeKeyword_0()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__DataType__Group__0__Impl"


    // $ANTLR start "rule__DataType__Group__1"
    // InternalKM3.g:385:1: rule__DataType__Group__1 : rule__DataType__Group__1__Impl rule__DataType__Group__2 ;
    public final void rule__DataType__Group__1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:389:1: ( rule__DataType__Group__1__Impl rule__DataType__Group__2 )
            // InternalKM3.g:390:2: rule__DataType__Group__1__Impl rule__DataType__Group__2
            {
            pushFollow(FOLLOW_7);
            rule__DataType__Group__1__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__DataType__Group__2();

            state._fsp--;


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__DataType__Group__1"


    // $ANTLR start "rule__DataType__Group__1__Impl"
    // InternalKM3.g:397:1: rule__DataType__Group__1__Impl : ( ( rule__DataType__NameAssignment_1 ) ) ;
    public final void rule__DataType__Group__1__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:401:1: ( ( ( rule__DataType__NameAssignment_1 ) ) )
            // InternalKM3.g:402:1: ( ( rule__DataType__NameAssignment_1 ) )
            {
            // InternalKM3.g:402:1: ( ( rule__DataType__NameAssignment_1 ) )
            // InternalKM3.g:403:2: ( rule__DataType__NameAssignment_1 )
            {
             before(grammarAccess.getDataTypeAccess().getNameAssignment_1()); 
            // InternalKM3.g:404:2: ( rule__DataType__NameAssignment_1 )
            // InternalKM3.g:404:3: rule__DataType__NameAssignment_1
            {
            pushFollow(FOLLOW_2);
            rule__DataType__NameAssignment_1();

            state._fsp--;


            }

             after(grammarAccess.getDataTypeAccess().getNameAssignment_1()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__DataType__Group__1__Impl"


    // $ANTLR start "rule__DataType__Group__2"
    // InternalKM3.g:412:1: rule__DataType__Group__2 : rule__DataType__Group__2__Impl ;
    public final void rule__DataType__Group__2() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:416:1: ( rule__DataType__Group__2__Impl )
            // InternalKM3.g:417:2: rule__DataType__Group__2__Impl
            {
            pushFollow(FOLLOW_2);
            rule__DataType__Group__2__Impl();

            state._fsp--;


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__DataType__Group__2"


    // $ANTLR start "rule__DataType__Group__2__Impl"
    // InternalKM3.g:423:1: rule__DataType__Group__2__Impl : ( ';' ) ;
    public final void rule__DataType__Group__2__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:427:1: ( ( ';' ) )
            // InternalKM3.g:428:1: ( ';' )
            {
            // InternalKM3.g:428:1: ( ';' )
            // InternalKM3.g:429:2: ';'
            {
             before(grammarAccess.getDataTypeAccess().getSemicolonKeyword_2()); 
            match(input,15,FOLLOW_2); 
             after(grammarAccess.getDataTypeAccess().getSemicolonKeyword_2()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__DataType__Group__2__Impl"


    // $ANTLR start "rule__Class__Group__0"
    // InternalKM3.g:439:1: rule__Class__Group__0 : rule__Class__Group__0__Impl rule__Class__Group__1 ;
    public final void rule__Class__Group__0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:443:1: ( rule__Class__Group__0__Impl rule__Class__Group__1 )
            // InternalKM3.g:444:2: rule__Class__Group__0__Impl rule__Class__Group__1
            {
            pushFollow(FOLLOW_8);
            rule__Class__Group__0__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__Class__Group__1();

            state._fsp--;


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__Class__Group__0"


    // $ANTLR start "rule__Class__Group__0__Impl"
    // InternalKM3.g:451:1: rule__Class__Group__0__Impl : ( ( rule__Class__IsAbstractAssignment_0 )? ) ;
    public final void rule__Class__Group__0__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:455:1: ( ( ( rule__Class__IsAbstractAssignment_0 )? ) )
            // InternalKM3.g:456:1: ( ( rule__Class__IsAbstractAssignment_0 )? )
            {
            // InternalKM3.g:456:1: ( ( rule__Class__IsAbstractAssignment_0 )? )
            // InternalKM3.g:457:2: ( rule__Class__IsAbstractAssignment_0 )?
            {
             before(grammarAccess.getClassAccess().getIsAbstractAssignment_0()); 
            // InternalKM3.g:458:2: ( rule__Class__IsAbstractAssignment_0 )?
            int alt3=2;
            int LA3_0 = input.LA(1);

            if ( (LA3_0==22) ) {
                alt3=1;
            }
            switch (alt3) {
                case 1 :
                    // InternalKM3.g:458:3: rule__Class__IsAbstractAssignment_0
                    {
                    pushFollow(FOLLOW_2);
                    rule__Class__IsAbstractAssignment_0();

                    state._fsp--;


                    }
                    break;

            }

             after(grammarAccess.getClassAccess().getIsAbstractAssignment_0()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__Class__Group__0__Impl"


    // $ANTLR start "rule__Class__Group__1"
    // InternalKM3.g:466:1: rule__Class__Group__1 : rule__Class__Group__1__Impl rule__Class__Group__2 ;
    public final void rule__Class__Group__1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:470:1: ( rule__Class__Group__1__Impl rule__Class__Group__2 )
            // InternalKM3.g:471:2: rule__Class__Group__1__Impl rule__Class__Group__2
            {
            pushFollow(FOLLOW_3);
            rule__Class__Group__1__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__Class__Group__2();

            state._fsp--;


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__Class__Group__1"


    // $ANTLR start "rule__Class__Group__1__Impl"
    // InternalKM3.g:478:1: rule__Class__Group__1__Impl : ( 'class' ) ;
    public final void rule__Class__Group__1__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:482:1: ( ( 'class' ) )
            // InternalKM3.g:483:1: ( 'class' )
            {
            // InternalKM3.g:483:1: ( 'class' )
            // InternalKM3.g:484:2: 'class'
            {
             before(grammarAccess.getClassAccess().getClassKeyword_1()); 
            match(input,16,FOLLOW_2); 
             after(grammarAccess.getClassAccess().getClassKeyword_1()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__Class__Group__1__Impl"


    // $ANTLR start "rule__Class__Group__2"
    // InternalKM3.g:493:1: rule__Class__Group__2 : rule__Class__Group__2__Impl rule__Class__Group__3 ;
    public final void rule__Class__Group__2() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:497:1: ( rule__Class__Group__2__Impl rule__Class__Group__3 )
            // InternalKM3.g:498:2: rule__Class__Group__2__Impl rule__Class__Group__3
            {
            pushFollow(FOLLOW_9);
            rule__Class__Group__2__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__Class__Group__3();

            state._fsp--;


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__Class__Group__2"


    // $ANTLR start "rule__Class__Group__2__Impl"
    // InternalKM3.g:505:1: rule__Class__Group__2__Impl : ( ( rule__Class__NameAssignment_2 ) ) ;
    public final void rule__Class__Group__2__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:509:1: ( ( ( rule__Class__NameAssignment_2 ) ) )
            // InternalKM3.g:510:1: ( ( rule__Class__NameAssignment_2 ) )
            {
            // InternalKM3.g:510:1: ( ( rule__Class__NameAssignment_2 ) )
            // InternalKM3.g:511:2: ( rule__Class__NameAssignment_2 )
            {
             before(grammarAccess.getClassAccess().getNameAssignment_2()); 
            // InternalKM3.g:512:2: ( rule__Class__NameAssignment_2 )
            // InternalKM3.g:512:3: rule__Class__NameAssignment_2
            {
            pushFollow(FOLLOW_2);
            rule__Class__NameAssignment_2();

            state._fsp--;


            }

             after(grammarAccess.getClassAccess().getNameAssignment_2()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__Class__Group__2__Impl"


    // $ANTLR start "rule__Class__Group__3"
    // InternalKM3.g:520:1: rule__Class__Group__3 : rule__Class__Group__3__Impl rule__Class__Group__4 ;
    public final void rule__Class__Group__3() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:524:1: ( rule__Class__Group__3__Impl rule__Class__Group__4 )
            // InternalKM3.g:525:2: rule__Class__Group__3__Impl rule__Class__Group__4
            {
            pushFollow(FOLLOW_9);
            rule__Class__Group__3__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__Class__Group__4();

            state._fsp--;


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__Class__Group__3"


    // $ANTLR start "rule__Class__Group__3__Impl"
    // InternalKM3.g:532:1: rule__Class__Group__3__Impl : ( ( rule__Class__Group_3__0 )? ) ;
    public final void rule__Class__Group__3__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:536:1: ( ( ( rule__Class__Group_3__0 )? ) )
            // InternalKM3.g:537:1: ( ( rule__Class__Group_3__0 )? )
            {
            // InternalKM3.g:537:1: ( ( rule__Class__Group_3__0 )? )
            // InternalKM3.g:538:2: ( rule__Class__Group_3__0 )?
            {
             before(grammarAccess.getClassAccess().getGroup_3()); 
            // InternalKM3.g:539:2: ( rule__Class__Group_3__0 )?
            int alt4=2;
            int LA4_0 = input.LA(1);

            if ( (LA4_0==17) ) {
                alt4=1;
            }
            switch (alt4) {
                case 1 :
                    // InternalKM3.g:539:3: rule__Class__Group_3__0
                    {
                    pushFollow(FOLLOW_2);
                    rule__Class__Group_3__0();

                    state._fsp--;


                    }
                    break;

            }

             after(grammarAccess.getClassAccess().getGroup_3()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__Class__Group__3__Impl"


    // $ANTLR start "rule__Class__Group__4"
    // InternalKM3.g:547:1: rule__Class__Group__4 : rule__Class__Group__4__Impl rule__Class__Group__5 ;
    public final void rule__Class__Group__4() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:551:1: ( rule__Class__Group__4__Impl rule__Class__Group__5 )
            // InternalKM3.g:552:2: rule__Class__Group__4__Impl rule__Class__Group__5
            {
            pushFollow(FOLLOW_10);
            rule__Class__Group__4__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__Class__Group__5();

            state._fsp--;


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__Class__Group__4"


    // $ANTLR start "rule__Class__Group__4__Impl"
    // InternalKM3.g:559:1: rule__Class__Group__4__Impl : ( '{' ) ;
    public final void rule__Class__Group__4__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:563:1: ( ( '{' ) )
            // InternalKM3.g:564:1: ( '{' )
            {
            // InternalKM3.g:564:1: ( '{' )
            // InternalKM3.g:565:2: '{'
            {
             before(grammarAccess.getClassAccess().getLeftCurlyBracketKeyword_4()); 
            match(input,12,FOLLOW_2); 
             after(grammarAccess.getClassAccess().getLeftCurlyBracketKeyword_4()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__Class__Group__4__Impl"


    // $ANTLR start "rule__Class__Group__5"
    // InternalKM3.g:574:1: rule__Class__Group__5 : rule__Class__Group__5__Impl rule__Class__Group__6 ;
    public final void rule__Class__Group__5() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:578:1: ( rule__Class__Group__5__Impl rule__Class__Group__6 )
            // InternalKM3.g:579:2: rule__Class__Group__5__Impl rule__Class__Group__6
            {
            pushFollow(FOLLOW_10);
            rule__Class__Group__5__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__Class__Group__6();

            state._fsp--;


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__Class__Group__5"


    // $ANTLR start "rule__Class__Group__5__Impl"
    // InternalKM3.g:586:1: rule__Class__Group__5__Impl : ( ( rule__Class__StructuralFeaturesAssignment_5 )* ) ;
    public final void rule__Class__Group__5__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:590:1: ( ( ( rule__Class__StructuralFeaturesAssignment_5 )* ) )
            // InternalKM3.g:591:1: ( ( rule__Class__StructuralFeaturesAssignment_5 )* )
            {
            // InternalKM3.g:591:1: ( ( rule__Class__StructuralFeaturesAssignment_5 )* )
            // InternalKM3.g:592:2: ( rule__Class__StructuralFeaturesAssignment_5 )*
            {
             before(grammarAccess.getClassAccess().getStructuralFeaturesAssignment_5()); 
            // InternalKM3.g:593:2: ( rule__Class__StructuralFeaturesAssignment_5 )*
            loop5:
            do {
                int alt5=2;
                int LA5_0 = input.LA(1);

                if ( (LA5_0==19||LA5_0==23) ) {
                    alt5=1;
                }


                switch (alt5) {
            	case 1 :
            	    // InternalKM3.g:593:3: rule__Class__StructuralFeaturesAssignment_5
            	    {
            	    pushFollow(FOLLOW_11);
            	    rule__Class__StructuralFeaturesAssignment_5();

            	    state._fsp--;


            	    }
            	    break;

            	default :
            	    break loop5;
                }
            } while (true);

             after(grammarAccess.getClassAccess().getStructuralFeaturesAssignment_5()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__Class__Group__5__Impl"


    // $ANTLR start "rule__Class__Group__6"
    // InternalKM3.g:601:1: rule__Class__Group__6 : rule__Class__Group__6__Impl ;
    public final void rule__Class__Group__6() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:605:1: ( rule__Class__Group__6__Impl )
            // InternalKM3.g:606:2: rule__Class__Group__6__Impl
            {
            pushFollow(FOLLOW_2);
            rule__Class__Group__6__Impl();

            state._fsp--;


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__Class__Group__6"


    // $ANTLR start "rule__Class__Group__6__Impl"
    // InternalKM3.g:612:1: rule__Class__Group__6__Impl : ( '}' ) ;
    public final void rule__Class__Group__6__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:616:1: ( ( '}' ) )
            // InternalKM3.g:617:1: ( '}' )
            {
            // InternalKM3.g:617:1: ( '}' )
            // InternalKM3.g:618:2: '}'
            {
             before(grammarAccess.getClassAccess().getRightCurlyBracketKeyword_6()); 
            match(input,13,FOLLOW_2); 
             after(grammarAccess.getClassAccess().getRightCurlyBracketKeyword_6()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__Class__Group__6__Impl"


    // $ANTLR start "rule__Class__Group_3__0"
    // InternalKM3.g:628:1: rule__Class__Group_3__0 : rule__Class__Group_3__0__Impl rule__Class__Group_3__1 ;
    public final void rule__Class__Group_3__0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:632:1: ( rule__Class__Group_3__0__Impl rule__Class__Group_3__1 )
            // InternalKM3.g:633:2: rule__Class__Group_3__0__Impl rule__Class__Group_3__1
            {
            pushFollow(FOLLOW_3);
            rule__Class__Group_3__0__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__Class__Group_3__1();

            state._fsp--;


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__Class__Group_3__0"


    // $ANTLR start "rule__Class__Group_3__0__Impl"
    // InternalKM3.g:640:1: rule__Class__Group_3__0__Impl : ( 'extends' ) ;
    public final void rule__Class__Group_3__0__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:644:1: ( ( 'extends' ) )
            // InternalKM3.g:645:1: ( 'extends' )
            {
            // InternalKM3.g:645:1: ( 'extends' )
            // InternalKM3.g:646:2: 'extends'
            {
             before(grammarAccess.getClassAccess().getExtendsKeyword_3_0()); 
            match(input,17,FOLLOW_2); 
             after(grammarAccess.getClassAccess().getExtendsKeyword_3_0()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__Class__Group_3__0__Impl"


    // $ANTLR start "rule__Class__Group_3__1"
    // InternalKM3.g:655:1: rule__Class__Group_3__1 : rule__Class__Group_3__1__Impl rule__Class__Group_3__2 ;
    public final void rule__Class__Group_3__1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:659:1: ( rule__Class__Group_3__1__Impl rule__Class__Group_3__2 )
            // InternalKM3.g:660:2: rule__Class__Group_3__1__Impl rule__Class__Group_3__2
            {
            pushFollow(FOLLOW_12);
            rule__Class__Group_3__1__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__Class__Group_3__2();

            state._fsp--;


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__Class__Group_3__1"


    // $ANTLR start "rule__Class__Group_3__1__Impl"
    // InternalKM3.g:667:1: rule__Class__Group_3__1__Impl : ( ( rule__Class__SupertypesAssignment_3_1 ) ) ;
    public final void rule__Class__Group_3__1__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:671:1: ( ( ( rule__Class__SupertypesAssignment_3_1 ) ) )
            // InternalKM3.g:672:1: ( ( rule__Class__SupertypesAssignment_3_1 ) )
            {
            // InternalKM3.g:672:1: ( ( rule__Class__SupertypesAssignment_3_1 ) )
            // InternalKM3.g:673:2: ( rule__Class__SupertypesAssignment_3_1 )
            {
             before(grammarAccess.getClassAccess().getSupertypesAssignment_3_1()); 
            // InternalKM3.g:674:2: ( rule__Class__SupertypesAssignment_3_1 )
            // InternalKM3.g:674:3: rule__Class__SupertypesAssignment_3_1
            {
            pushFollow(FOLLOW_2);
            rule__Class__SupertypesAssignment_3_1();

            state._fsp--;


            }

             after(grammarAccess.getClassAccess().getSupertypesAssignment_3_1()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__Class__Group_3__1__Impl"


    // $ANTLR start "rule__Class__Group_3__2"
    // InternalKM3.g:682:1: rule__Class__Group_3__2 : rule__Class__Group_3__2__Impl ;
    public final void rule__Class__Group_3__2() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:686:1: ( rule__Class__Group_3__2__Impl )
            // InternalKM3.g:687:2: rule__Class__Group_3__2__Impl
            {
            pushFollow(FOLLOW_2);
            rule__Class__Group_3__2__Impl();

            state._fsp--;


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__Class__Group_3__2"


    // $ANTLR start "rule__Class__Group_3__2__Impl"
    // InternalKM3.g:693:1: rule__Class__Group_3__2__Impl : ( ( rule__Class__Group_3_2__0 )* ) ;
    public final void rule__Class__Group_3__2__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:697:1: ( ( ( rule__Class__Group_3_2__0 )* ) )
            // InternalKM3.g:698:1: ( ( rule__Class__Group_3_2__0 )* )
            {
            // InternalKM3.g:698:1: ( ( rule__Class__Group_3_2__0 )* )
            // InternalKM3.g:699:2: ( rule__Class__Group_3_2__0 )*
            {
             before(grammarAccess.getClassAccess().getGroup_3_2()); 
            // InternalKM3.g:700:2: ( rule__Class__Group_3_2__0 )*
            loop6:
            do {
                int alt6=2;
                int LA6_0 = input.LA(1);

                if ( (LA6_0==18) ) {
                    alt6=1;
                }


                switch (alt6) {
            	case 1 :
            	    // InternalKM3.g:700:3: rule__Class__Group_3_2__0
            	    {
            	    pushFollow(FOLLOW_13);
            	    rule__Class__Group_3_2__0();

            	    state._fsp--;


            	    }
            	    break;

            	default :
            	    break loop6;
                }
            } while (true);

             after(grammarAccess.getClassAccess().getGroup_3_2()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__Class__Group_3__2__Impl"


    // $ANTLR start "rule__Class__Group_3_2__0"
    // InternalKM3.g:709:1: rule__Class__Group_3_2__0 : rule__Class__Group_3_2__0__Impl rule__Class__Group_3_2__1 ;
    public final void rule__Class__Group_3_2__0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:713:1: ( rule__Class__Group_3_2__0__Impl rule__Class__Group_3_2__1 )
            // InternalKM3.g:714:2: rule__Class__Group_3_2__0__Impl rule__Class__Group_3_2__1
            {
            pushFollow(FOLLOW_3);
            rule__Class__Group_3_2__0__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__Class__Group_3_2__1();

            state._fsp--;


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__Class__Group_3_2__0"


    // $ANTLR start "rule__Class__Group_3_2__0__Impl"
    // InternalKM3.g:721:1: rule__Class__Group_3_2__0__Impl : ( ',' ) ;
    public final void rule__Class__Group_3_2__0__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:725:1: ( ( ',' ) )
            // InternalKM3.g:726:1: ( ',' )
            {
            // InternalKM3.g:726:1: ( ',' )
            // InternalKM3.g:727:2: ','
            {
             before(grammarAccess.getClassAccess().getCommaKeyword_3_2_0()); 
            match(input,18,FOLLOW_2); 
             after(grammarAccess.getClassAccess().getCommaKeyword_3_2_0()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__Class__Group_3_2__0__Impl"


    // $ANTLR start "rule__Class__Group_3_2__1"
    // InternalKM3.g:736:1: rule__Class__Group_3_2__1 : rule__Class__Group_3_2__1__Impl ;
    public final void rule__Class__Group_3_2__1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:740:1: ( rule__Class__Group_3_2__1__Impl )
            // InternalKM3.g:741:2: rule__Class__Group_3_2__1__Impl
            {
            pushFollow(FOLLOW_2);
            rule__Class__Group_3_2__1__Impl();

            state._fsp--;


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__Class__Group_3_2__1"


    // $ANTLR start "rule__Class__Group_3_2__1__Impl"
    // InternalKM3.g:747:1: rule__Class__Group_3_2__1__Impl : ( ( rule__Class__SupertypesAssignment_3_2_1 ) ) ;
    public final void rule__Class__Group_3_2__1__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:751:1: ( ( ( rule__Class__SupertypesAssignment_3_2_1 ) ) )
            // InternalKM3.g:752:1: ( ( rule__Class__SupertypesAssignment_3_2_1 ) )
            {
            // InternalKM3.g:752:1: ( ( rule__Class__SupertypesAssignment_3_2_1 ) )
            // InternalKM3.g:753:2: ( rule__Class__SupertypesAssignment_3_2_1 )
            {
             before(grammarAccess.getClassAccess().getSupertypesAssignment_3_2_1()); 
            // InternalKM3.g:754:2: ( rule__Class__SupertypesAssignment_3_2_1 )
            // InternalKM3.g:754:3: rule__Class__SupertypesAssignment_3_2_1
            {
            pushFollow(FOLLOW_2);
            rule__Class__SupertypesAssignment_3_2_1();

            state._fsp--;


            }

             after(grammarAccess.getClassAccess().getSupertypesAssignment_3_2_1()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__Class__Group_3_2__1__Impl"


    // $ANTLR start "rule__Attribute__Group__0"
    // InternalKM3.g:763:1: rule__Attribute__Group__0 : rule__Attribute__Group__0__Impl rule__Attribute__Group__1 ;
    public final void rule__Attribute__Group__0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:767:1: ( rule__Attribute__Group__0__Impl rule__Attribute__Group__1 )
            // InternalKM3.g:768:2: rule__Attribute__Group__0__Impl rule__Attribute__Group__1
            {
            pushFollow(FOLLOW_14);
            rule__Attribute__Group__0__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__Attribute__Group__1();

            state._fsp--;


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__Attribute__Group__0"


    // $ANTLR start "rule__Attribute__Group__0__Impl"
    // InternalKM3.g:775:1: rule__Attribute__Group__0__Impl : ( ( rule__Attribute__IsUniqueAssignment_0 )? ) ;
    public final void rule__Attribute__Group__0__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:779:1: ( ( ( rule__Attribute__IsUniqueAssignment_0 )? ) )
            // InternalKM3.g:780:1: ( ( rule__Attribute__IsUniqueAssignment_0 )? )
            {
            // InternalKM3.g:780:1: ( ( rule__Attribute__IsUniqueAssignment_0 )? )
            // InternalKM3.g:781:2: ( rule__Attribute__IsUniqueAssignment_0 )?
            {
             before(grammarAccess.getAttributeAccess().getIsUniqueAssignment_0()); 
            // InternalKM3.g:782:2: ( rule__Attribute__IsUniqueAssignment_0 )?
            int alt7=2;
            int LA7_0 = input.LA(1);

            if ( (LA7_0==23) ) {
                alt7=1;
            }
            switch (alt7) {
                case 1 :
                    // InternalKM3.g:782:3: rule__Attribute__IsUniqueAssignment_0
                    {
                    pushFollow(FOLLOW_2);
                    rule__Attribute__IsUniqueAssignment_0();

                    state._fsp--;


                    }
                    break;

            }

             after(grammarAccess.getAttributeAccess().getIsUniqueAssignment_0()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__Attribute__Group__0__Impl"


    // $ANTLR start "rule__Attribute__Group__1"
    // InternalKM3.g:790:1: rule__Attribute__Group__1 : rule__Attribute__Group__1__Impl rule__Attribute__Group__2 ;
    public final void rule__Attribute__Group__1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:794:1: ( rule__Attribute__Group__1__Impl rule__Attribute__Group__2 )
            // InternalKM3.g:795:2: rule__Attribute__Group__1__Impl rule__Attribute__Group__2
            {
            pushFollow(FOLLOW_3);
            rule__Attribute__Group__1__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__Attribute__Group__2();

            state._fsp--;


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__Attribute__Group__1"


    // $ANTLR start "rule__Attribute__Group__1__Impl"
    // InternalKM3.g:802:1: rule__Attribute__Group__1__Impl : ( 'attribute' ) ;
    public final void rule__Attribute__Group__1__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:806:1: ( ( 'attribute' ) )
            // InternalKM3.g:807:1: ( 'attribute' )
            {
            // InternalKM3.g:807:1: ( 'attribute' )
            // InternalKM3.g:808:2: 'attribute'
            {
             before(grammarAccess.getAttributeAccess().getAttributeKeyword_1()); 
            match(input,19,FOLLOW_2); 
             after(grammarAccess.getAttributeAccess().getAttributeKeyword_1()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__Attribute__Group__1__Impl"


    // $ANTLR start "rule__Attribute__Group__2"
    // InternalKM3.g:817:1: rule__Attribute__Group__2 : rule__Attribute__Group__2__Impl rule__Attribute__Group__3 ;
    public final void rule__Attribute__Group__2() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:821:1: ( rule__Attribute__Group__2__Impl rule__Attribute__Group__3 )
            // InternalKM3.g:822:2: rule__Attribute__Group__2__Impl rule__Attribute__Group__3
            {
            pushFollow(FOLLOW_15);
            rule__Attribute__Group__2__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__Attribute__Group__3();

            state._fsp--;


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__Attribute__Group__2"


    // $ANTLR start "rule__Attribute__Group__2__Impl"
    // InternalKM3.g:829:1: rule__Attribute__Group__2__Impl : ( ( rule__Attribute__NameAssignment_2 ) ) ;
    public final void rule__Attribute__Group__2__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:833:1: ( ( ( rule__Attribute__NameAssignment_2 ) ) )
            // InternalKM3.g:834:1: ( ( rule__Attribute__NameAssignment_2 ) )
            {
            // InternalKM3.g:834:1: ( ( rule__Attribute__NameAssignment_2 ) )
            // InternalKM3.g:835:2: ( rule__Attribute__NameAssignment_2 )
            {
             before(grammarAccess.getAttributeAccess().getNameAssignment_2()); 
            // InternalKM3.g:836:2: ( rule__Attribute__NameAssignment_2 )
            // InternalKM3.g:836:3: rule__Attribute__NameAssignment_2
            {
            pushFollow(FOLLOW_2);
            rule__Attribute__NameAssignment_2();

            state._fsp--;


            }

             after(grammarAccess.getAttributeAccess().getNameAssignment_2()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__Attribute__Group__2__Impl"


    // $ANTLR start "rule__Attribute__Group__3"
    // InternalKM3.g:844:1: rule__Attribute__Group__3 : rule__Attribute__Group__3__Impl rule__Attribute__Group__4 ;
    public final void rule__Attribute__Group__3() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:848:1: ( rule__Attribute__Group__3__Impl rule__Attribute__Group__4 )
            // InternalKM3.g:849:2: rule__Attribute__Group__3__Impl rule__Attribute__Group__4
            {
            pushFollow(FOLLOW_15);
            rule__Attribute__Group__3__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__Attribute__Group__4();

            state._fsp--;


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__Attribute__Group__3"


    // $ANTLR start "rule__Attribute__Group__3__Impl"
    // InternalKM3.g:856:1: rule__Attribute__Group__3__Impl : ( ( rule__Attribute__IsOrderedAssignment_3 )? ) ;
    public final void rule__Attribute__Group__3__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:860:1: ( ( ( rule__Attribute__IsOrderedAssignment_3 )? ) )
            // InternalKM3.g:861:1: ( ( rule__Attribute__IsOrderedAssignment_3 )? )
            {
            // InternalKM3.g:861:1: ( ( rule__Attribute__IsOrderedAssignment_3 )? )
            // InternalKM3.g:862:2: ( rule__Attribute__IsOrderedAssignment_3 )?
            {
             before(grammarAccess.getAttributeAccess().getIsOrderedAssignment_3()); 
            // InternalKM3.g:863:2: ( rule__Attribute__IsOrderedAssignment_3 )?
            int alt8=2;
            int LA8_0 = input.LA(1);

            if ( (LA8_0==24) ) {
                alt8=1;
            }
            switch (alt8) {
                case 1 :
                    // InternalKM3.g:863:3: rule__Attribute__IsOrderedAssignment_3
                    {
                    pushFollow(FOLLOW_2);
                    rule__Attribute__IsOrderedAssignment_3();

                    state._fsp--;


                    }
                    break;

            }

             after(grammarAccess.getAttributeAccess().getIsOrderedAssignment_3()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__Attribute__Group__3__Impl"


    // $ANTLR start "rule__Attribute__Group__4"
    // InternalKM3.g:871:1: rule__Attribute__Group__4 : rule__Attribute__Group__4__Impl rule__Attribute__Group__5 ;
    public final void rule__Attribute__Group__4() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:875:1: ( rule__Attribute__Group__4__Impl rule__Attribute__Group__5 )
            // InternalKM3.g:876:2: rule__Attribute__Group__4__Impl rule__Attribute__Group__5
            {
            pushFollow(FOLLOW_16);
            rule__Attribute__Group__4__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__Attribute__Group__5();

            state._fsp--;


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__Attribute__Group__4"


    // $ANTLR start "rule__Attribute__Group__4__Impl"
    // InternalKM3.g:883:1: rule__Attribute__Group__4__Impl : ( ':' ) ;
    public final void rule__Attribute__Group__4__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:887:1: ( ( ':' ) )
            // InternalKM3.g:888:1: ( ':' )
            {
            // InternalKM3.g:888:1: ( ':' )
            // InternalKM3.g:889:2: ':'
            {
             before(grammarAccess.getAttributeAccess().getColonKeyword_4()); 
            match(input,20,FOLLOW_2); 
             after(grammarAccess.getAttributeAccess().getColonKeyword_4()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__Attribute__Group__4__Impl"


    // $ANTLR start "rule__Attribute__Group__5"
    // InternalKM3.g:898:1: rule__Attribute__Group__5 : rule__Attribute__Group__5__Impl rule__Attribute__Group__6 ;
    public final void rule__Attribute__Group__5() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:902:1: ( rule__Attribute__Group__5__Impl rule__Attribute__Group__6 )
            // InternalKM3.g:903:2: rule__Attribute__Group__5__Impl rule__Attribute__Group__6
            {
            pushFollow(FOLLOW_3);
            rule__Attribute__Group__5__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__Attribute__Group__6();

            state._fsp--;


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__Attribute__Group__5"


    // $ANTLR start "rule__Attribute__Group__5__Impl"
    // InternalKM3.g:910:1: rule__Attribute__Group__5__Impl : ( 'type' ) ;
    public final void rule__Attribute__Group__5__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:914:1: ( ( 'type' ) )
            // InternalKM3.g:915:1: ( 'type' )
            {
            // InternalKM3.g:915:1: ( 'type' )
            // InternalKM3.g:916:2: 'type'
            {
             before(grammarAccess.getAttributeAccess().getTypeKeyword_5()); 
            match(input,21,FOLLOW_2); 
             after(grammarAccess.getAttributeAccess().getTypeKeyword_5()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__Attribute__Group__5__Impl"


    // $ANTLR start "rule__Attribute__Group__6"
    // InternalKM3.g:925:1: rule__Attribute__Group__6 : rule__Attribute__Group__6__Impl rule__Attribute__Group__7 ;
    public final void rule__Attribute__Group__6() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:929:1: ( rule__Attribute__Group__6__Impl rule__Attribute__Group__7 )
            // InternalKM3.g:930:2: rule__Attribute__Group__6__Impl rule__Attribute__Group__7
            {
            pushFollow(FOLLOW_7);
            rule__Attribute__Group__6__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__Attribute__Group__7();

            state._fsp--;


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__Attribute__Group__6"


    // $ANTLR start "rule__Attribute__Group__6__Impl"
    // InternalKM3.g:937:1: rule__Attribute__Group__6__Impl : ( ( rule__Attribute__TypeAssignment_6 ) ) ;
    public final void rule__Attribute__Group__6__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:941:1: ( ( ( rule__Attribute__TypeAssignment_6 ) ) )
            // InternalKM3.g:942:1: ( ( rule__Attribute__TypeAssignment_6 ) )
            {
            // InternalKM3.g:942:1: ( ( rule__Attribute__TypeAssignment_6 ) )
            // InternalKM3.g:943:2: ( rule__Attribute__TypeAssignment_6 )
            {
             before(grammarAccess.getAttributeAccess().getTypeAssignment_6()); 
            // InternalKM3.g:944:2: ( rule__Attribute__TypeAssignment_6 )
            // InternalKM3.g:944:3: rule__Attribute__TypeAssignment_6
            {
            pushFollow(FOLLOW_2);
            rule__Attribute__TypeAssignment_6();

            state._fsp--;


            }

             after(grammarAccess.getAttributeAccess().getTypeAssignment_6()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__Attribute__Group__6__Impl"


    // $ANTLR start "rule__Attribute__Group__7"
    // InternalKM3.g:952:1: rule__Attribute__Group__7 : rule__Attribute__Group__7__Impl ;
    public final void rule__Attribute__Group__7() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:956:1: ( rule__Attribute__Group__7__Impl )
            // InternalKM3.g:957:2: rule__Attribute__Group__7__Impl
            {
            pushFollow(FOLLOW_2);
            rule__Attribute__Group__7__Impl();

            state._fsp--;


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__Attribute__Group__7"


    // $ANTLR start "rule__Attribute__Group__7__Impl"
    // InternalKM3.g:963:1: rule__Attribute__Group__7__Impl : ( ';' ) ;
    public final void rule__Attribute__Group__7__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:967:1: ( ( ';' ) )
            // InternalKM3.g:968:1: ( ';' )
            {
            // InternalKM3.g:968:1: ( ';' )
            // InternalKM3.g:969:2: ';'
            {
             before(grammarAccess.getAttributeAccess().getSemicolonKeyword_7()); 
            match(input,15,FOLLOW_2); 
             after(grammarAccess.getAttributeAccess().getSemicolonKeyword_7()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__Attribute__Group__7__Impl"


    // $ANTLR start "rule__Package__NameAssignment_1"
    // InternalKM3.g:979:1: rule__Package__NameAssignment_1 : ( RULE_ID ) ;
    public final void rule__Package__NameAssignment_1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:983:1: ( ( RULE_ID ) )
            // InternalKM3.g:984:2: ( RULE_ID )
            {
            // InternalKM3.g:984:2: ( RULE_ID )
            // InternalKM3.g:985:3: RULE_ID
            {
             before(grammarAccess.getPackageAccess().getNameIDTerminalRuleCall_1_0()); 
            match(input,RULE_ID,FOLLOW_2); 
             after(grammarAccess.getPackageAccess().getNameIDTerminalRuleCall_1_0()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__Package__NameAssignment_1"


    // $ANTLR start "rule__Package__ContentsAssignment_3"
    // InternalKM3.g:994:1: rule__Package__ContentsAssignment_3 : ( ruleModelElement ) ;
    public final void rule__Package__ContentsAssignment_3() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:998:1: ( ( ruleModelElement ) )
            // InternalKM3.g:999:2: ( ruleModelElement )
            {
            // InternalKM3.g:999:2: ( ruleModelElement )
            // InternalKM3.g:1000:3: ruleModelElement
            {
             before(grammarAccess.getPackageAccess().getContentsModelElementParserRuleCall_3_0()); 
            pushFollow(FOLLOW_2);
            ruleModelElement();

            state._fsp--;

             after(grammarAccess.getPackageAccess().getContentsModelElementParserRuleCall_3_0()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__Package__ContentsAssignment_3"


    // $ANTLR start "rule__DataType__NameAssignment_1"
    // InternalKM3.g:1009:1: rule__DataType__NameAssignment_1 : ( RULE_ID ) ;
    public final void rule__DataType__NameAssignment_1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1013:1: ( ( RULE_ID ) )
            // InternalKM3.g:1014:2: ( RULE_ID )
            {
            // InternalKM3.g:1014:2: ( RULE_ID )
            // InternalKM3.g:1015:3: RULE_ID
            {
             before(grammarAccess.getDataTypeAccess().getNameIDTerminalRuleCall_1_0()); 
            match(input,RULE_ID,FOLLOW_2); 
             after(grammarAccess.getDataTypeAccess().getNameIDTerminalRuleCall_1_0()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__DataType__NameAssignment_1"


    // $ANTLR start "rule__Class__IsAbstractAssignment_0"
    // InternalKM3.g:1024:1: rule__Class__IsAbstractAssignment_0 : ( ( 'abstract' ) ) ;
    public final void rule__Class__IsAbstractAssignment_0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1028:1: ( ( ( 'abstract' ) ) )
            // InternalKM3.g:1029:2: ( ( 'abstract' ) )
            {
            // InternalKM3.g:1029:2: ( ( 'abstract' ) )
            // InternalKM3.g:1030:3: ( 'abstract' )
            {
             before(grammarAccess.getClassAccess().getIsAbstractAbstractKeyword_0_0()); 
            // InternalKM3.g:1031:3: ( 'abstract' )
            // InternalKM3.g:1032:4: 'abstract'
            {
             before(grammarAccess.getClassAccess().getIsAbstractAbstractKeyword_0_0()); 
            match(input,22,FOLLOW_2); 
             after(grammarAccess.getClassAccess().getIsAbstractAbstractKeyword_0_0()); 

            }

             after(grammarAccess.getClassAccess().getIsAbstractAbstractKeyword_0_0()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__Class__IsAbstractAssignment_0"


    // $ANTLR start "rule__Class__NameAssignment_2"
    // InternalKM3.g:1043:1: rule__Class__NameAssignment_2 : ( RULE_ID ) ;
    public final void rule__Class__NameAssignment_2() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1047:1: ( ( RULE_ID ) )
            // InternalKM3.g:1048:2: ( RULE_ID )
            {
            // InternalKM3.g:1048:2: ( RULE_ID )
            // InternalKM3.g:1049:3: RULE_ID
            {
             before(grammarAccess.getClassAccess().getNameIDTerminalRuleCall_2_0()); 
            match(input,RULE_ID,FOLLOW_2); 
             after(grammarAccess.getClassAccess().getNameIDTerminalRuleCall_2_0()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__Class__NameAssignment_2"


    // $ANTLR start "rule__Class__SupertypesAssignment_3_1"
    // InternalKM3.g:1058:1: rule__Class__SupertypesAssignment_3_1 : ( ( RULE_ID ) ) ;
    public final void rule__Class__SupertypesAssignment_3_1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1062:1: ( ( ( RULE_ID ) ) )
            // InternalKM3.g:1063:2: ( ( RULE_ID ) )
            {
            // InternalKM3.g:1063:2: ( ( RULE_ID ) )
            // InternalKM3.g:1064:3: ( RULE_ID )
            {
             before(grammarAccess.getClassAccess().getSupertypesClassCrossReference_3_1_0()); 
            // InternalKM3.g:1065:3: ( RULE_ID )
            // InternalKM3.g:1066:4: RULE_ID
            {
             before(grammarAccess.getClassAccess().getSupertypesClassIDTerminalRuleCall_3_1_0_1()); 
            match(input,RULE_ID,FOLLOW_2); 
             after(grammarAccess.getClassAccess().getSupertypesClassIDTerminalRuleCall_3_1_0_1()); 

            }

             after(grammarAccess.getClassAccess().getSupertypesClassCrossReference_3_1_0()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__Class__SupertypesAssignment_3_1"


    // $ANTLR start "rule__Class__SupertypesAssignment_3_2_1"
    // InternalKM3.g:1077:1: rule__Class__SupertypesAssignment_3_2_1 : ( ( RULE_ID ) ) ;
    public final void rule__Class__SupertypesAssignment_3_2_1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1081:1: ( ( ( RULE_ID ) ) )
            // InternalKM3.g:1082:2: ( ( RULE_ID ) )
            {
            // InternalKM3.g:1082:2: ( ( RULE_ID ) )
            // InternalKM3.g:1083:3: ( RULE_ID )
            {
             before(grammarAccess.getClassAccess().getSupertypesClassCrossReference_3_2_1_0()); 
            // InternalKM3.g:1084:3: ( RULE_ID )
            // InternalKM3.g:1085:4: RULE_ID
            {
             before(grammarAccess.getClassAccess().getSupertypesClassIDTerminalRuleCall_3_2_1_0_1()); 
            match(input,RULE_ID,FOLLOW_2); 
             after(grammarAccess.getClassAccess().getSupertypesClassIDTerminalRuleCall_3_2_1_0_1()); 

            }

             after(grammarAccess.getClassAccess().getSupertypesClassCrossReference_3_2_1_0()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__Class__SupertypesAssignment_3_2_1"


    // $ANTLR start "rule__Class__StructuralFeaturesAssignment_5"
    // InternalKM3.g:1096:1: rule__Class__StructuralFeaturesAssignment_5 : ( ruleStructuralFeature ) ;
    public final void rule__Class__StructuralFeaturesAssignment_5() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1100:1: ( ( ruleStructuralFeature ) )
            // InternalKM3.g:1101:2: ( ruleStructuralFeature )
            {
            // InternalKM3.g:1101:2: ( ruleStructuralFeature )
            // InternalKM3.g:1102:3: ruleStructuralFeature
            {
             before(grammarAccess.getClassAccess().getStructuralFeaturesStructuralFeatureParserRuleCall_5_0()); 
            pushFollow(FOLLOW_2);
            ruleStructuralFeature();

            state._fsp--;

             after(grammarAccess.getClassAccess().getStructuralFeaturesStructuralFeatureParserRuleCall_5_0()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__Class__StructuralFeaturesAssignment_5"


    // $ANTLR start "rule__Attribute__IsUniqueAssignment_0"
    // InternalKM3.g:1111:1: rule__Attribute__IsUniqueAssignment_0 : ( ( 'unique' ) ) ;
    public final void rule__Attribute__IsUniqueAssignment_0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1115:1: ( ( ( 'unique' ) ) )
            // InternalKM3.g:1116:2: ( ( 'unique' ) )
            {
            // InternalKM3.g:1116:2: ( ( 'unique' ) )
            // InternalKM3.g:1117:3: ( 'unique' )
            {
             before(grammarAccess.getAttributeAccess().getIsUniqueUniqueKeyword_0_0()); 
            // InternalKM3.g:1118:3: ( 'unique' )
            // InternalKM3.g:1119:4: 'unique'
            {
             before(grammarAccess.getAttributeAccess().getIsUniqueUniqueKeyword_0_0()); 
            match(input,23,FOLLOW_2); 
             after(grammarAccess.getAttributeAccess().getIsUniqueUniqueKeyword_0_0()); 

            }

             after(grammarAccess.getAttributeAccess().getIsUniqueUniqueKeyword_0_0()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__Attribute__IsUniqueAssignment_0"


    // $ANTLR start "rule__Attribute__NameAssignment_2"
    // InternalKM3.g:1130:1: rule__Attribute__NameAssignment_2 : ( RULE_ID ) ;
    public final void rule__Attribute__NameAssignment_2() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1134:1: ( ( RULE_ID ) )
            // InternalKM3.g:1135:2: ( RULE_ID )
            {
            // InternalKM3.g:1135:2: ( RULE_ID )
            // InternalKM3.g:1136:3: RULE_ID
            {
             before(grammarAccess.getAttributeAccess().getNameIDTerminalRuleCall_2_0()); 
            match(input,RULE_ID,FOLLOW_2); 
             after(grammarAccess.getAttributeAccess().getNameIDTerminalRuleCall_2_0()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__Attribute__NameAssignment_2"


    // $ANTLR start "rule__Attribute__IsOrderedAssignment_3"
    // InternalKM3.g:1145:1: rule__Attribute__IsOrderedAssignment_3 : ( ( 'ordered' ) ) ;
    public final void rule__Attribute__IsOrderedAssignment_3() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1149:1: ( ( ( 'ordered' ) ) )
            // InternalKM3.g:1150:2: ( ( 'ordered' ) )
            {
            // InternalKM3.g:1150:2: ( ( 'ordered' ) )
            // InternalKM3.g:1151:3: ( 'ordered' )
            {
             before(grammarAccess.getAttributeAccess().getIsOrderedOrderedKeyword_3_0()); 
            // InternalKM3.g:1152:3: ( 'ordered' )
            // InternalKM3.g:1153:4: 'ordered'
            {
             before(grammarAccess.getAttributeAccess().getIsOrderedOrderedKeyword_3_0()); 
            match(input,24,FOLLOW_2); 
             after(grammarAccess.getAttributeAccess().getIsOrderedOrderedKeyword_3_0()); 

            }

             after(grammarAccess.getAttributeAccess().getIsOrderedOrderedKeyword_3_0()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__Attribute__IsOrderedAssignment_3"


    // $ANTLR start "rule__Attribute__TypeAssignment_6"
    // InternalKM3.g:1164:1: rule__Attribute__TypeAssignment_6 : ( ( RULE_ID ) ) ;
    public final void rule__Attribute__TypeAssignment_6() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1168:1: ( ( ( RULE_ID ) ) )
            // InternalKM3.g:1169:2: ( ( RULE_ID ) )
            {
            // InternalKM3.g:1169:2: ( ( RULE_ID ) )
            // InternalKM3.g:1170:3: ( RULE_ID )
            {
             before(grammarAccess.getAttributeAccess().getTypeClassifierCrossReference_6_0()); 
            // InternalKM3.g:1171:3: ( RULE_ID )
            // InternalKM3.g:1172:4: RULE_ID
            {
             before(grammarAccess.getAttributeAccess().getTypeClassifierIDTerminalRuleCall_6_0_1()); 
            match(input,RULE_ID,FOLLOW_2); 
             after(grammarAccess.getAttributeAccess().getTypeClassifierIDTerminalRuleCall_6_0_1()); 

            }

             after(grammarAccess.getAttributeAccess().getTypeClassifierCrossReference_6_0()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__Attribute__TypeAssignment_6"

    // Delegated rules


 

    public static final BitSet FOLLOW_1 = new BitSet(new long[]{0x0000000000000000L});
    public static final BitSet FOLLOW_2 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_3 = new BitSet(new long[]{0x0000000000000010L});
    public static final BitSet FOLLOW_4 = new BitSet(new long[]{0x0000000000001000L});
    public static final BitSet FOLLOW_5 = new BitSet(new long[]{0x0000000000416000L});
    public static final BitSet FOLLOW_6 = new BitSet(new long[]{0x0000000000414002L});
    public static final BitSet FOLLOW_7 = new BitSet(new long[]{0x0000000000008000L});
    public static final BitSet FOLLOW_8 = new BitSet(new long[]{0x0000000000414000L});
    public static final BitSet FOLLOW_9 = new BitSet(new long[]{0x0000000000021000L});
    public static final BitSet FOLLOW_10 = new BitSet(new long[]{0x0000000000882000L});
    public static final BitSet FOLLOW_11 = new BitSet(new long[]{0x0000000000880002L});
    public static final BitSet FOLLOW_12 = new BitSet(new long[]{0x0000000000040000L});
    public static final BitSet FOLLOW_13 = new BitSet(new long[]{0x0000000000040002L});
    public static final BitSet FOLLOW_14 = new BitSet(new long[]{0x0000000000880000L});
    public static final BitSet FOLLOW_15 = new BitSet(new long[]{0x0000000001100000L});
    public static final BitSet FOLLOW_16 = new BitSet(new long[]{0x0000000000200000L});

}