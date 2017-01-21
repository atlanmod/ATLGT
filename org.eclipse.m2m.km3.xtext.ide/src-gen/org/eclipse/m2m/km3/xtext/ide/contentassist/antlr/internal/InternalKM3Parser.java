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
        "<invalid>", "<EOR>", "<DOWN>", "<UP>", "RULE_INT", "RULE_ID", "RULE_COMMENT", "RULE_STRING", "RULE_ML_COMMENT", "RULE_SL_COMMENT", "RULE_WS", "RULE_ANY_OTHER", "'*'", "'package'", "'{'", "'}'", "'datatype'", "';'", "'class'", "'extends'", "','", "'attribute'", "':'", "'['", "']'", "'-'", "'reference'", "'oppositeOf'", "'abstract'", "'unique'", "'ordered'", "'container'"
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
    public static final int RULE_ID=5;
    public static final int RULE_WS=10;
    public static final int RULE_COMMENT=6;
    public static final int RULE_ANY_OTHER=11;
    public static final int T__26=26;
    public static final int T__27=27;
    public static final int T__28=28;
    public static final int RULE_INT=4;
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


    // $ANTLR start "entryRuleStructuralFeature"
    // InternalKM3.g:128:1: entryRuleStructuralFeature : ruleStructuralFeature EOF ;
    public final void entryRuleStructuralFeature() throws RecognitionException {
        try {
            // InternalKM3.g:129:1: ( ruleStructuralFeature EOF )
            // InternalKM3.g:130:1: ruleStructuralFeature EOF
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
    // InternalKM3.g:137:1: ruleStructuralFeature : ( ( rule__StructuralFeature__Alternatives ) ) ;
    public final void ruleStructuralFeature() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:141:2: ( ( ( rule__StructuralFeature__Alternatives ) ) )
            // InternalKM3.g:142:2: ( ( rule__StructuralFeature__Alternatives ) )
            {
            // InternalKM3.g:142:2: ( ( rule__StructuralFeature__Alternatives ) )
            // InternalKM3.g:143:3: ( rule__StructuralFeature__Alternatives )
            {
             before(grammarAccess.getStructuralFeatureAccess().getAlternatives()); 
            // InternalKM3.g:144:3: ( rule__StructuralFeature__Alternatives )
            // InternalKM3.g:144:4: rule__StructuralFeature__Alternatives
            {
            pushFollow(FOLLOW_2);
            rule__StructuralFeature__Alternatives();

            state._fsp--;


            }

             after(grammarAccess.getStructuralFeatureAccess().getAlternatives()); 

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


    // $ANTLR start "entryRuleClass"
    // InternalKM3.g:153:1: entryRuleClass : ruleClass EOF ;
    public final void entryRuleClass() throws RecognitionException {
        try {
            // InternalKM3.g:154:1: ( ruleClass EOF )
            // InternalKM3.g:155:1: ruleClass EOF
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
    // InternalKM3.g:162:1: ruleClass : ( ( rule__Class__Group__0 ) ) ;
    public final void ruleClass() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:166:2: ( ( ( rule__Class__Group__0 ) ) )
            // InternalKM3.g:167:2: ( ( rule__Class__Group__0 ) )
            {
            // InternalKM3.g:167:2: ( ( rule__Class__Group__0 ) )
            // InternalKM3.g:168:3: ( rule__Class__Group__0 )
            {
             before(grammarAccess.getClassAccess().getGroup()); 
            // InternalKM3.g:169:3: ( rule__Class__Group__0 )
            // InternalKM3.g:169:4: rule__Class__Group__0
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


    // $ANTLR start "entryRuleReference"
    // InternalKM3.g:203:1: entryRuleReference : ruleReference EOF ;
    public final void entryRuleReference() throws RecognitionException {
        try {
            // InternalKM3.g:204:1: ( ruleReference EOF )
            // InternalKM3.g:205:1: ruleReference EOF
            {
             before(grammarAccess.getReferenceRule()); 
            pushFollow(FOLLOW_1);
            ruleReference();

            state._fsp--;

             after(grammarAccess.getReferenceRule()); 
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
    // $ANTLR end "entryRuleReference"


    // $ANTLR start "ruleReference"
    // InternalKM3.g:212:1: ruleReference : ( ( rule__Reference__Group__0 ) ) ;
    public final void ruleReference() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:216:2: ( ( ( rule__Reference__Group__0 ) ) )
            // InternalKM3.g:217:2: ( ( rule__Reference__Group__0 ) )
            {
            // InternalKM3.g:217:2: ( ( rule__Reference__Group__0 ) )
            // InternalKM3.g:218:3: ( rule__Reference__Group__0 )
            {
             before(grammarAccess.getReferenceAccess().getGroup()); 
            // InternalKM3.g:219:3: ( rule__Reference__Group__0 )
            // InternalKM3.g:219:4: rule__Reference__Group__0
            {
            pushFollow(FOLLOW_2);
            rule__Reference__Group__0();

            state._fsp--;


            }

             after(grammarAccess.getReferenceAccess().getGroup()); 

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
    // $ANTLR end "ruleReference"


    // $ANTLR start "entryRuleElementBound"
    // InternalKM3.g:228:1: entryRuleElementBound : ruleElementBound EOF ;
    public final void entryRuleElementBound() throws RecognitionException {
        try {
            // InternalKM3.g:229:1: ( ruleElementBound EOF )
            // InternalKM3.g:230:1: ruleElementBound EOF
            {
             before(grammarAccess.getElementBoundRule()); 
            pushFollow(FOLLOW_1);
            ruleElementBound();

            state._fsp--;

             after(grammarAccess.getElementBoundRule()); 
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
    // $ANTLR end "entryRuleElementBound"


    // $ANTLR start "ruleElementBound"
    // InternalKM3.g:237:1: ruleElementBound : ( ( rule__ElementBound__Alternatives ) ) ;
    public final void ruleElementBound() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:241:2: ( ( ( rule__ElementBound__Alternatives ) ) )
            // InternalKM3.g:242:2: ( ( rule__ElementBound__Alternatives ) )
            {
            // InternalKM3.g:242:2: ( ( rule__ElementBound__Alternatives ) )
            // InternalKM3.g:243:3: ( rule__ElementBound__Alternatives )
            {
             before(grammarAccess.getElementBoundAccess().getAlternatives()); 
            // InternalKM3.g:244:3: ( rule__ElementBound__Alternatives )
            // InternalKM3.g:244:4: rule__ElementBound__Alternatives
            {
            pushFollow(FOLLOW_2);
            rule__ElementBound__Alternatives();

            state._fsp--;


            }

             after(grammarAccess.getElementBoundAccess().getAlternatives()); 

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
    // $ANTLR end "ruleElementBound"


    // $ANTLR start "rule__ModelElement__Alternatives"
    // InternalKM3.g:252:1: rule__ModelElement__Alternatives : ( ( ruleDataType ) | ( ruleClass ) );
    public final void rule__ModelElement__Alternatives() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:256:1: ( ( ruleDataType ) | ( ruleClass ) )
            int alt1=2;
            int LA1_0 = input.LA(1);

            if ( (LA1_0==16) ) {
                alt1=1;
            }
            else if ( (LA1_0==18||LA1_0==28) ) {
                alt1=2;
            }
            else {
                NoViableAltException nvae =
                    new NoViableAltException("", 1, 0, input);

                throw nvae;
            }
            switch (alt1) {
                case 1 :
                    // InternalKM3.g:257:2: ( ruleDataType )
                    {
                    // InternalKM3.g:257:2: ( ruleDataType )
                    // InternalKM3.g:258:3: ruleDataType
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
                    // InternalKM3.g:263:2: ( ruleClass )
                    {
                    // InternalKM3.g:263:2: ( ruleClass )
                    // InternalKM3.g:264:3: ruleClass
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


    // $ANTLR start "rule__StructuralFeature__Alternatives"
    // InternalKM3.g:273:1: rule__StructuralFeature__Alternatives : ( ( ruleAttribute ) | ( ruleReference ) );
    public final void rule__StructuralFeature__Alternatives() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:277:1: ( ( ruleAttribute ) | ( ruleReference ) )
            int alt2=2;
            int LA2_0 = input.LA(1);

            if ( (LA2_0==21||LA2_0==29) ) {
                alt2=1;
            }
            else if ( (LA2_0==26) ) {
                alt2=2;
            }
            else {
                NoViableAltException nvae =
                    new NoViableAltException("", 2, 0, input);

                throw nvae;
            }
            switch (alt2) {
                case 1 :
                    // InternalKM3.g:278:2: ( ruleAttribute )
                    {
                    // InternalKM3.g:278:2: ( ruleAttribute )
                    // InternalKM3.g:279:3: ruleAttribute
                    {
                     before(grammarAccess.getStructuralFeatureAccess().getAttributeParserRuleCall_0()); 
                    pushFollow(FOLLOW_2);
                    ruleAttribute();

                    state._fsp--;

                     after(grammarAccess.getStructuralFeatureAccess().getAttributeParserRuleCall_0()); 

                    }


                    }
                    break;
                case 2 :
                    // InternalKM3.g:284:2: ( ruleReference )
                    {
                    // InternalKM3.g:284:2: ( ruleReference )
                    // InternalKM3.g:285:3: ruleReference
                    {
                     before(grammarAccess.getStructuralFeatureAccess().getReferenceParserRuleCall_1()); 
                    pushFollow(FOLLOW_2);
                    ruleReference();

                    state._fsp--;

                     after(grammarAccess.getStructuralFeatureAccess().getReferenceParserRuleCall_1()); 

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
    // $ANTLR end "rule__StructuralFeature__Alternatives"


    // $ANTLR start "rule__ElementBound__Alternatives"
    // InternalKM3.g:294:1: rule__ElementBound__Alternatives : ( ( '*' ) | ( RULE_INT ) );
    public final void rule__ElementBound__Alternatives() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:298:1: ( ( '*' ) | ( RULE_INT ) )
            int alt3=2;
            int LA3_0 = input.LA(1);

            if ( (LA3_0==12) ) {
                alt3=1;
            }
            else if ( (LA3_0==RULE_INT) ) {
                alt3=2;
            }
            else {
                NoViableAltException nvae =
                    new NoViableAltException("", 3, 0, input);

                throw nvae;
            }
            switch (alt3) {
                case 1 :
                    // InternalKM3.g:299:2: ( '*' )
                    {
                    // InternalKM3.g:299:2: ( '*' )
                    // InternalKM3.g:300:3: '*'
                    {
                     before(grammarAccess.getElementBoundAccess().getAsteriskKeyword_0()); 
                    match(input,12,FOLLOW_2); 
                     after(grammarAccess.getElementBoundAccess().getAsteriskKeyword_0()); 

                    }


                    }
                    break;
                case 2 :
                    // InternalKM3.g:305:2: ( RULE_INT )
                    {
                    // InternalKM3.g:305:2: ( RULE_INT )
                    // InternalKM3.g:306:3: RULE_INT
                    {
                     before(grammarAccess.getElementBoundAccess().getINTTerminalRuleCall_1()); 
                    match(input,RULE_INT,FOLLOW_2); 
                     after(grammarAccess.getElementBoundAccess().getINTTerminalRuleCall_1()); 

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
    // $ANTLR end "rule__ElementBound__Alternatives"


    // $ANTLR start "rule__Package__Group__0"
    // InternalKM3.g:315:1: rule__Package__Group__0 : rule__Package__Group__0__Impl rule__Package__Group__1 ;
    public final void rule__Package__Group__0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:319:1: ( rule__Package__Group__0__Impl rule__Package__Group__1 )
            // InternalKM3.g:320:2: rule__Package__Group__0__Impl rule__Package__Group__1
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
    // InternalKM3.g:327:1: rule__Package__Group__0__Impl : ( 'package' ) ;
    public final void rule__Package__Group__0__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:331:1: ( ( 'package' ) )
            // InternalKM3.g:332:1: ( 'package' )
            {
            // InternalKM3.g:332:1: ( 'package' )
            // InternalKM3.g:333:2: 'package'
            {
             before(grammarAccess.getPackageAccess().getPackageKeyword_0()); 
            match(input,13,FOLLOW_2); 
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
    // InternalKM3.g:342:1: rule__Package__Group__1 : rule__Package__Group__1__Impl rule__Package__Group__2 ;
    public final void rule__Package__Group__1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:346:1: ( rule__Package__Group__1__Impl rule__Package__Group__2 )
            // InternalKM3.g:347:2: rule__Package__Group__1__Impl rule__Package__Group__2
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
    // InternalKM3.g:354:1: rule__Package__Group__1__Impl : ( ( rule__Package__NameAssignment_1 ) ) ;
    public final void rule__Package__Group__1__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:358:1: ( ( ( rule__Package__NameAssignment_1 ) ) )
            // InternalKM3.g:359:1: ( ( rule__Package__NameAssignment_1 ) )
            {
            // InternalKM3.g:359:1: ( ( rule__Package__NameAssignment_1 ) )
            // InternalKM3.g:360:2: ( rule__Package__NameAssignment_1 )
            {
             before(grammarAccess.getPackageAccess().getNameAssignment_1()); 
            // InternalKM3.g:361:2: ( rule__Package__NameAssignment_1 )
            // InternalKM3.g:361:3: rule__Package__NameAssignment_1
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
    // InternalKM3.g:369:1: rule__Package__Group__2 : rule__Package__Group__2__Impl rule__Package__Group__3 ;
    public final void rule__Package__Group__2() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:373:1: ( rule__Package__Group__2__Impl rule__Package__Group__3 )
            // InternalKM3.g:374:2: rule__Package__Group__2__Impl rule__Package__Group__3
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
    // InternalKM3.g:381:1: rule__Package__Group__2__Impl : ( '{' ) ;
    public final void rule__Package__Group__2__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:385:1: ( ( '{' ) )
            // InternalKM3.g:386:1: ( '{' )
            {
            // InternalKM3.g:386:1: ( '{' )
            // InternalKM3.g:387:2: '{'
            {
             before(grammarAccess.getPackageAccess().getLeftCurlyBracketKeyword_2()); 
            match(input,14,FOLLOW_2); 
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
    // InternalKM3.g:396:1: rule__Package__Group__3 : rule__Package__Group__3__Impl rule__Package__Group__4 ;
    public final void rule__Package__Group__3() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:400:1: ( rule__Package__Group__3__Impl rule__Package__Group__4 )
            // InternalKM3.g:401:2: rule__Package__Group__3__Impl rule__Package__Group__4
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
    // InternalKM3.g:408:1: rule__Package__Group__3__Impl : ( ( rule__Package__ContentsAssignment_3 )* ) ;
    public final void rule__Package__Group__3__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:412:1: ( ( ( rule__Package__ContentsAssignment_3 )* ) )
            // InternalKM3.g:413:1: ( ( rule__Package__ContentsAssignment_3 )* )
            {
            // InternalKM3.g:413:1: ( ( rule__Package__ContentsAssignment_3 )* )
            // InternalKM3.g:414:2: ( rule__Package__ContentsAssignment_3 )*
            {
             before(grammarAccess.getPackageAccess().getContentsAssignment_3()); 
            // InternalKM3.g:415:2: ( rule__Package__ContentsAssignment_3 )*
            loop4:
            do {
                int alt4=2;
                int LA4_0 = input.LA(1);

                if ( (LA4_0==16||LA4_0==18||LA4_0==28) ) {
                    alt4=1;
                }


                switch (alt4) {
            	case 1 :
            	    // InternalKM3.g:415:3: rule__Package__ContentsAssignment_3
            	    {
            	    pushFollow(FOLLOW_6);
            	    rule__Package__ContentsAssignment_3();

            	    state._fsp--;


            	    }
            	    break;

            	default :
            	    break loop4;
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
    // InternalKM3.g:423:1: rule__Package__Group__4 : rule__Package__Group__4__Impl ;
    public final void rule__Package__Group__4() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:427:1: ( rule__Package__Group__4__Impl )
            // InternalKM3.g:428:2: rule__Package__Group__4__Impl
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
    // InternalKM3.g:434:1: rule__Package__Group__4__Impl : ( '}' ) ;
    public final void rule__Package__Group__4__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:438:1: ( ( '}' ) )
            // InternalKM3.g:439:1: ( '}' )
            {
            // InternalKM3.g:439:1: ( '}' )
            // InternalKM3.g:440:2: '}'
            {
             before(grammarAccess.getPackageAccess().getRightCurlyBracketKeyword_4()); 
            match(input,15,FOLLOW_2); 
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
    // InternalKM3.g:450:1: rule__DataType__Group__0 : rule__DataType__Group__0__Impl rule__DataType__Group__1 ;
    public final void rule__DataType__Group__0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:454:1: ( rule__DataType__Group__0__Impl rule__DataType__Group__1 )
            // InternalKM3.g:455:2: rule__DataType__Group__0__Impl rule__DataType__Group__1
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
    // InternalKM3.g:462:1: rule__DataType__Group__0__Impl : ( 'datatype' ) ;
    public final void rule__DataType__Group__0__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:466:1: ( ( 'datatype' ) )
            // InternalKM3.g:467:1: ( 'datatype' )
            {
            // InternalKM3.g:467:1: ( 'datatype' )
            // InternalKM3.g:468:2: 'datatype'
            {
             before(grammarAccess.getDataTypeAccess().getDatatypeKeyword_0()); 
            match(input,16,FOLLOW_2); 
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
    // InternalKM3.g:477:1: rule__DataType__Group__1 : rule__DataType__Group__1__Impl rule__DataType__Group__2 ;
    public final void rule__DataType__Group__1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:481:1: ( rule__DataType__Group__1__Impl rule__DataType__Group__2 )
            // InternalKM3.g:482:2: rule__DataType__Group__1__Impl rule__DataType__Group__2
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
    // InternalKM3.g:489:1: rule__DataType__Group__1__Impl : ( ( rule__DataType__NameAssignment_1 ) ) ;
    public final void rule__DataType__Group__1__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:493:1: ( ( ( rule__DataType__NameAssignment_1 ) ) )
            // InternalKM3.g:494:1: ( ( rule__DataType__NameAssignment_1 ) )
            {
            // InternalKM3.g:494:1: ( ( rule__DataType__NameAssignment_1 ) )
            // InternalKM3.g:495:2: ( rule__DataType__NameAssignment_1 )
            {
             before(grammarAccess.getDataTypeAccess().getNameAssignment_1()); 
            // InternalKM3.g:496:2: ( rule__DataType__NameAssignment_1 )
            // InternalKM3.g:496:3: rule__DataType__NameAssignment_1
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
    // InternalKM3.g:504:1: rule__DataType__Group__2 : rule__DataType__Group__2__Impl ;
    public final void rule__DataType__Group__2() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:508:1: ( rule__DataType__Group__2__Impl )
            // InternalKM3.g:509:2: rule__DataType__Group__2__Impl
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
    // InternalKM3.g:515:1: rule__DataType__Group__2__Impl : ( ';' ) ;
    public final void rule__DataType__Group__2__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:519:1: ( ( ';' ) )
            // InternalKM3.g:520:1: ( ';' )
            {
            // InternalKM3.g:520:1: ( ';' )
            // InternalKM3.g:521:2: ';'
            {
             before(grammarAccess.getDataTypeAccess().getSemicolonKeyword_2()); 
            match(input,17,FOLLOW_2); 
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
    // InternalKM3.g:531:1: rule__Class__Group__0 : rule__Class__Group__0__Impl rule__Class__Group__1 ;
    public final void rule__Class__Group__0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:535:1: ( rule__Class__Group__0__Impl rule__Class__Group__1 )
            // InternalKM3.g:536:2: rule__Class__Group__0__Impl rule__Class__Group__1
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
    // InternalKM3.g:543:1: rule__Class__Group__0__Impl : ( ( rule__Class__IsAbstractAssignment_0 )? ) ;
    public final void rule__Class__Group__0__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:547:1: ( ( ( rule__Class__IsAbstractAssignment_0 )? ) )
            // InternalKM3.g:548:1: ( ( rule__Class__IsAbstractAssignment_0 )? )
            {
            // InternalKM3.g:548:1: ( ( rule__Class__IsAbstractAssignment_0 )? )
            // InternalKM3.g:549:2: ( rule__Class__IsAbstractAssignment_0 )?
            {
             before(grammarAccess.getClassAccess().getIsAbstractAssignment_0()); 
            // InternalKM3.g:550:2: ( rule__Class__IsAbstractAssignment_0 )?
            int alt5=2;
            int LA5_0 = input.LA(1);

            if ( (LA5_0==28) ) {
                alt5=1;
            }
            switch (alt5) {
                case 1 :
                    // InternalKM3.g:550:3: rule__Class__IsAbstractAssignment_0
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
    // InternalKM3.g:558:1: rule__Class__Group__1 : rule__Class__Group__1__Impl rule__Class__Group__2 ;
    public final void rule__Class__Group__1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:562:1: ( rule__Class__Group__1__Impl rule__Class__Group__2 )
            // InternalKM3.g:563:2: rule__Class__Group__1__Impl rule__Class__Group__2
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
    // InternalKM3.g:570:1: rule__Class__Group__1__Impl : ( 'class' ) ;
    public final void rule__Class__Group__1__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:574:1: ( ( 'class' ) )
            // InternalKM3.g:575:1: ( 'class' )
            {
            // InternalKM3.g:575:1: ( 'class' )
            // InternalKM3.g:576:2: 'class'
            {
             before(grammarAccess.getClassAccess().getClassKeyword_1()); 
            match(input,18,FOLLOW_2); 
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
    // InternalKM3.g:585:1: rule__Class__Group__2 : rule__Class__Group__2__Impl rule__Class__Group__3 ;
    public final void rule__Class__Group__2() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:589:1: ( rule__Class__Group__2__Impl rule__Class__Group__3 )
            // InternalKM3.g:590:2: rule__Class__Group__2__Impl rule__Class__Group__3
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
    // InternalKM3.g:597:1: rule__Class__Group__2__Impl : ( ( rule__Class__NameAssignment_2 ) ) ;
    public final void rule__Class__Group__2__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:601:1: ( ( ( rule__Class__NameAssignment_2 ) ) )
            // InternalKM3.g:602:1: ( ( rule__Class__NameAssignment_2 ) )
            {
            // InternalKM3.g:602:1: ( ( rule__Class__NameAssignment_2 ) )
            // InternalKM3.g:603:2: ( rule__Class__NameAssignment_2 )
            {
             before(grammarAccess.getClassAccess().getNameAssignment_2()); 
            // InternalKM3.g:604:2: ( rule__Class__NameAssignment_2 )
            // InternalKM3.g:604:3: rule__Class__NameAssignment_2
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
    // InternalKM3.g:612:1: rule__Class__Group__3 : rule__Class__Group__3__Impl rule__Class__Group__4 ;
    public final void rule__Class__Group__3() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:616:1: ( rule__Class__Group__3__Impl rule__Class__Group__4 )
            // InternalKM3.g:617:2: rule__Class__Group__3__Impl rule__Class__Group__4
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
    // InternalKM3.g:624:1: rule__Class__Group__3__Impl : ( ( rule__Class__Group_3__0 )? ) ;
    public final void rule__Class__Group__3__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:628:1: ( ( ( rule__Class__Group_3__0 )? ) )
            // InternalKM3.g:629:1: ( ( rule__Class__Group_3__0 )? )
            {
            // InternalKM3.g:629:1: ( ( rule__Class__Group_3__0 )? )
            // InternalKM3.g:630:2: ( rule__Class__Group_3__0 )?
            {
             before(grammarAccess.getClassAccess().getGroup_3()); 
            // InternalKM3.g:631:2: ( rule__Class__Group_3__0 )?
            int alt6=2;
            int LA6_0 = input.LA(1);

            if ( (LA6_0==19) ) {
                alt6=1;
            }
            switch (alt6) {
                case 1 :
                    // InternalKM3.g:631:3: rule__Class__Group_3__0
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
    // InternalKM3.g:639:1: rule__Class__Group__4 : rule__Class__Group__4__Impl rule__Class__Group__5 ;
    public final void rule__Class__Group__4() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:643:1: ( rule__Class__Group__4__Impl rule__Class__Group__5 )
            // InternalKM3.g:644:2: rule__Class__Group__4__Impl rule__Class__Group__5
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
    // InternalKM3.g:651:1: rule__Class__Group__4__Impl : ( '{' ) ;
    public final void rule__Class__Group__4__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:655:1: ( ( '{' ) )
            // InternalKM3.g:656:1: ( '{' )
            {
            // InternalKM3.g:656:1: ( '{' )
            // InternalKM3.g:657:2: '{'
            {
             before(grammarAccess.getClassAccess().getLeftCurlyBracketKeyword_4()); 
            match(input,14,FOLLOW_2); 
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
    // InternalKM3.g:666:1: rule__Class__Group__5 : rule__Class__Group__5__Impl rule__Class__Group__6 ;
    public final void rule__Class__Group__5() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:670:1: ( rule__Class__Group__5__Impl rule__Class__Group__6 )
            // InternalKM3.g:671:2: rule__Class__Group__5__Impl rule__Class__Group__6
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
    // InternalKM3.g:678:1: rule__Class__Group__5__Impl : ( ( rule__Class__StructuralFeaturesAssignment_5 )* ) ;
    public final void rule__Class__Group__5__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:682:1: ( ( ( rule__Class__StructuralFeaturesAssignment_5 )* ) )
            // InternalKM3.g:683:1: ( ( rule__Class__StructuralFeaturesAssignment_5 )* )
            {
            // InternalKM3.g:683:1: ( ( rule__Class__StructuralFeaturesAssignment_5 )* )
            // InternalKM3.g:684:2: ( rule__Class__StructuralFeaturesAssignment_5 )*
            {
             before(grammarAccess.getClassAccess().getStructuralFeaturesAssignment_5()); 
            // InternalKM3.g:685:2: ( rule__Class__StructuralFeaturesAssignment_5 )*
            loop7:
            do {
                int alt7=2;
                int LA7_0 = input.LA(1);

                if ( (LA7_0==21||LA7_0==26||LA7_0==29) ) {
                    alt7=1;
                }


                switch (alt7) {
            	case 1 :
            	    // InternalKM3.g:685:3: rule__Class__StructuralFeaturesAssignment_5
            	    {
            	    pushFollow(FOLLOW_11);
            	    rule__Class__StructuralFeaturesAssignment_5();

            	    state._fsp--;


            	    }
            	    break;

            	default :
            	    break loop7;
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
    // InternalKM3.g:693:1: rule__Class__Group__6 : rule__Class__Group__6__Impl ;
    public final void rule__Class__Group__6() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:697:1: ( rule__Class__Group__6__Impl )
            // InternalKM3.g:698:2: rule__Class__Group__6__Impl
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
    // InternalKM3.g:704:1: rule__Class__Group__6__Impl : ( '}' ) ;
    public final void rule__Class__Group__6__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:708:1: ( ( '}' ) )
            // InternalKM3.g:709:1: ( '}' )
            {
            // InternalKM3.g:709:1: ( '}' )
            // InternalKM3.g:710:2: '}'
            {
             before(grammarAccess.getClassAccess().getRightCurlyBracketKeyword_6()); 
            match(input,15,FOLLOW_2); 
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
    // InternalKM3.g:720:1: rule__Class__Group_3__0 : rule__Class__Group_3__0__Impl rule__Class__Group_3__1 ;
    public final void rule__Class__Group_3__0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:724:1: ( rule__Class__Group_3__0__Impl rule__Class__Group_3__1 )
            // InternalKM3.g:725:2: rule__Class__Group_3__0__Impl rule__Class__Group_3__1
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
    // InternalKM3.g:732:1: rule__Class__Group_3__0__Impl : ( 'extends' ) ;
    public final void rule__Class__Group_3__0__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:736:1: ( ( 'extends' ) )
            // InternalKM3.g:737:1: ( 'extends' )
            {
            // InternalKM3.g:737:1: ( 'extends' )
            // InternalKM3.g:738:2: 'extends'
            {
             before(grammarAccess.getClassAccess().getExtendsKeyword_3_0()); 
            match(input,19,FOLLOW_2); 
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
    // InternalKM3.g:747:1: rule__Class__Group_3__1 : rule__Class__Group_3__1__Impl rule__Class__Group_3__2 ;
    public final void rule__Class__Group_3__1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:751:1: ( rule__Class__Group_3__1__Impl rule__Class__Group_3__2 )
            // InternalKM3.g:752:2: rule__Class__Group_3__1__Impl rule__Class__Group_3__2
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
    // InternalKM3.g:759:1: rule__Class__Group_3__1__Impl : ( ( rule__Class__SupertypesAssignment_3_1 ) ) ;
    public final void rule__Class__Group_3__1__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:763:1: ( ( ( rule__Class__SupertypesAssignment_3_1 ) ) )
            // InternalKM3.g:764:1: ( ( rule__Class__SupertypesAssignment_3_1 ) )
            {
            // InternalKM3.g:764:1: ( ( rule__Class__SupertypesAssignment_3_1 ) )
            // InternalKM3.g:765:2: ( rule__Class__SupertypesAssignment_3_1 )
            {
             before(grammarAccess.getClassAccess().getSupertypesAssignment_3_1()); 
            // InternalKM3.g:766:2: ( rule__Class__SupertypesAssignment_3_1 )
            // InternalKM3.g:766:3: rule__Class__SupertypesAssignment_3_1
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
    // InternalKM3.g:774:1: rule__Class__Group_3__2 : rule__Class__Group_3__2__Impl ;
    public final void rule__Class__Group_3__2() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:778:1: ( rule__Class__Group_3__2__Impl )
            // InternalKM3.g:779:2: rule__Class__Group_3__2__Impl
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
    // InternalKM3.g:785:1: rule__Class__Group_3__2__Impl : ( ( rule__Class__Group_3_2__0 )* ) ;
    public final void rule__Class__Group_3__2__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:789:1: ( ( ( rule__Class__Group_3_2__0 )* ) )
            // InternalKM3.g:790:1: ( ( rule__Class__Group_3_2__0 )* )
            {
            // InternalKM3.g:790:1: ( ( rule__Class__Group_3_2__0 )* )
            // InternalKM3.g:791:2: ( rule__Class__Group_3_2__0 )*
            {
             before(grammarAccess.getClassAccess().getGroup_3_2()); 
            // InternalKM3.g:792:2: ( rule__Class__Group_3_2__0 )*
            loop8:
            do {
                int alt8=2;
                int LA8_0 = input.LA(1);

                if ( (LA8_0==20) ) {
                    alt8=1;
                }


                switch (alt8) {
            	case 1 :
            	    // InternalKM3.g:792:3: rule__Class__Group_3_2__0
            	    {
            	    pushFollow(FOLLOW_13);
            	    rule__Class__Group_3_2__0();

            	    state._fsp--;


            	    }
            	    break;

            	default :
            	    break loop8;
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
    // InternalKM3.g:801:1: rule__Class__Group_3_2__0 : rule__Class__Group_3_2__0__Impl rule__Class__Group_3_2__1 ;
    public final void rule__Class__Group_3_2__0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:805:1: ( rule__Class__Group_3_2__0__Impl rule__Class__Group_3_2__1 )
            // InternalKM3.g:806:2: rule__Class__Group_3_2__0__Impl rule__Class__Group_3_2__1
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
    // InternalKM3.g:813:1: rule__Class__Group_3_2__0__Impl : ( ',' ) ;
    public final void rule__Class__Group_3_2__0__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:817:1: ( ( ',' ) )
            // InternalKM3.g:818:1: ( ',' )
            {
            // InternalKM3.g:818:1: ( ',' )
            // InternalKM3.g:819:2: ','
            {
             before(grammarAccess.getClassAccess().getCommaKeyword_3_2_0()); 
            match(input,20,FOLLOW_2); 
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
    // InternalKM3.g:828:1: rule__Class__Group_3_2__1 : rule__Class__Group_3_2__1__Impl ;
    public final void rule__Class__Group_3_2__1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:832:1: ( rule__Class__Group_3_2__1__Impl )
            // InternalKM3.g:833:2: rule__Class__Group_3_2__1__Impl
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
    // InternalKM3.g:839:1: rule__Class__Group_3_2__1__Impl : ( ( rule__Class__SupertypesAssignment_3_2_1 ) ) ;
    public final void rule__Class__Group_3_2__1__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:843:1: ( ( ( rule__Class__SupertypesAssignment_3_2_1 ) ) )
            // InternalKM3.g:844:1: ( ( rule__Class__SupertypesAssignment_3_2_1 ) )
            {
            // InternalKM3.g:844:1: ( ( rule__Class__SupertypesAssignment_3_2_1 ) )
            // InternalKM3.g:845:2: ( rule__Class__SupertypesAssignment_3_2_1 )
            {
             before(grammarAccess.getClassAccess().getSupertypesAssignment_3_2_1()); 
            // InternalKM3.g:846:2: ( rule__Class__SupertypesAssignment_3_2_1 )
            // InternalKM3.g:846:3: rule__Class__SupertypesAssignment_3_2_1
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
    // InternalKM3.g:855:1: rule__Attribute__Group__0 : rule__Attribute__Group__0__Impl rule__Attribute__Group__1 ;
    public final void rule__Attribute__Group__0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:859:1: ( rule__Attribute__Group__0__Impl rule__Attribute__Group__1 )
            // InternalKM3.g:860:2: rule__Attribute__Group__0__Impl rule__Attribute__Group__1
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
    // InternalKM3.g:867:1: rule__Attribute__Group__0__Impl : ( ( rule__Attribute__IsUniqueAssignment_0 )? ) ;
    public final void rule__Attribute__Group__0__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:871:1: ( ( ( rule__Attribute__IsUniqueAssignment_0 )? ) )
            // InternalKM3.g:872:1: ( ( rule__Attribute__IsUniqueAssignment_0 )? )
            {
            // InternalKM3.g:872:1: ( ( rule__Attribute__IsUniqueAssignment_0 )? )
            // InternalKM3.g:873:2: ( rule__Attribute__IsUniqueAssignment_0 )?
            {
             before(grammarAccess.getAttributeAccess().getIsUniqueAssignment_0()); 
            // InternalKM3.g:874:2: ( rule__Attribute__IsUniqueAssignment_0 )?
            int alt9=2;
            int LA9_0 = input.LA(1);

            if ( (LA9_0==29) ) {
                alt9=1;
            }
            switch (alt9) {
                case 1 :
                    // InternalKM3.g:874:3: rule__Attribute__IsUniqueAssignment_0
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
    // InternalKM3.g:882:1: rule__Attribute__Group__1 : rule__Attribute__Group__1__Impl rule__Attribute__Group__2 ;
    public final void rule__Attribute__Group__1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:886:1: ( rule__Attribute__Group__1__Impl rule__Attribute__Group__2 )
            // InternalKM3.g:887:2: rule__Attribute__Group__1__Impl rule__Attribute__Group__2
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
    // InternalKM3.g:894:1: rule__Attribute__Group__1__Impl : ( 'attribute' ) ;
    public final void rule__Attribute__Group__1__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:898:1: ( ( 'attribute' ) )
            // InternalKM3.g:899:1: ( 'attribute' )
            {
            // InternalKM3.g:899:1: ( 'attribute' )
            // InternalKM3.g:900:2: 'attribute'
            {
             before(grammarAccess.getAttributeAccess().getAttributeKeyword_1()); 
            match(input,21,FOLLOW_2); 
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
    // InternalKM3.g:909:1: rule__Attribute__Group__2 : rule__Attribute__Group__2__Impl rule__Attribute__Group__3 ;
    public final void rule__Attribute__Group__2() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:913:1: ( rule__Attribute__Group__2__Impl rule__Attribute__Group__3 )
            // InternalKM3.g:914:2: rule__Attribute__Group__2__Impl rule__Attribute__Group__3
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
    // InternalKM3.g:921:1: rule__Attribute__Group__2__Impl : ( ( rule__Attribute__NameAssignment_2 ) ) ;
    public final void rule__Attribute__Group__2__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:925:1: ( ( ( rule__Attribute__NameAssignment_2 ) ) )
            // InternalKM3.g:926:1: ( ( rule__Attribute__NameAssignment_2 ) )
            {
            // InternalKM3.g:926:1: ( ( rule__Attribute__NameAssignment_2 ) )
            // InternalKM3.g:927:2: ( rule__Attribute__NameAssignment_2 )
            {
             before(grammarAccess.getAttributeAccess().getNameAssignment_2()); 
            // InternalKM3.g:928:2: ( rule__Attribute__NameAssignment_2 )
            // InternalKM3.g:928:3: rule__Attribute__NameAssignment_2
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
    // InternalKM3.g:936:1: rule__Attribute__Group__3 : rule__Attribute__Group__3__Impl rule__Attribute__Group__4 ;
    public final void rule__Attribute__Group__3() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:940:1: ( rule__Attribute__Group__3__Impl rule__Attribute__Group__4 )
            // InternalKM3.g:941:2: rule__Attribute__Group__3__Impl rule__Attribute__Group__4
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
    // InternalKM3.g:948:1: rule__Attribute__Group__3__Impl : ( ( rule__Attribute__Group_3__0 )? ) ;
    public final void rule__Attribute__Group__3__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:952:1: ( ( ( rule__Attribute__Group_3__0 )? ) )
            // InternalKM3.g:953:1: ( ( rule__Attribute__Group_3__0 )? )
            {
            // InternalKM3.g:953:1: ( ( rule__Attribute__Group_3__0 )? )
            // InternalKM3.g:954:2: ( rule__Attribute__Group_3__0 )?
            {
             before(grammarAccess.getAttributeAccess().getGroup_3()); 
            // InternalKM3.g:955:2: ( rule__Attribute__Group_3__0 )?
            int alt10=2;
            int LA10_0 = input.LA(1);

            if ( (LA10_0==23) ) {
                alt10=1;
            }
            switch (alt10) {
                case 1 :
                    // InternalKM3.g:955:3: rule__Attribute__Group_3__0
                    {
                    pushFollow(FOLLOW_2);
                    rule__Attribute__Group_3__0();

                    state._fsp--;


                    }
                    break;

            }

             after(grammarAccess.getAttributeAccess().getGroup_3()); 

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
    // InternalKM3.g:963:1: rule__Attribute__Group__4 : rule__Attribute__Group__4__Impl rule__Attribute__Group__5 ;
    public final void rule__Attribute__Group__4() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:967:1: ( rule__Attribute__Group__4__Impl rule__Attribute__Group__5 )
            // InternalKM3.g:968:2: rule__Attribute__Group__4__Impl rule__Attribute__Group__5
            {
            pushFollow(FOLLOW_15);
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
    // InternalKM3.g:975:1: rule__Attribute__Group__4__Impl : ( ( rule__Attribute__IsOrderedAssignment_4 )? ) ;
    public final void rule__Attribute__Group__4__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:979:1: ( ( ( rule__Attribute__IsOrderedAssignment_4 )? ) )
            // InternalKM3.g:980:1: ( ( rule__Attribute__IsOrderedAssignment_4 )? )
            {
            // InternalKM3.g:980:1: ( ( rule__Attribute__IsOrderedAssignment_4 )? )
            // InternalKM3.g:981:2: ( rule__Attribute__IsOrderedAssignment_4 )?
            {
             before(grammarAccess.getAttributeAccess().getIsOrderedAssignment_4()); 
            // InternalKM3.g:982:2: ( rule__Attribute__IsOrderedAssignment_4 )?
            int alt11=2;
            int LA11_0 = input.LA(1);

            if ( (LA11_0==30) ) {
                alt11=1;
            }
            switch (alt11) {
                case 1 :
                    // InternalKM3.g:982:3: rule__Attribute__IsOrderedAssignment_4
                    {
                    pushFollow(FOLLOW_2);
                    rule__Attribute__IsOrderedAssignment_4();

                    state._fsp--;


                    }
                    break;

            }

             after(grammarAccess.getAttributeAccess().getIsOrderedAssignment_4()); 

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
    // InternalKM3.g:990:1: rule__Attribute__Group__5 : rule__Attribute__Group__5__Impl rule__Attribute__Group__6 ;
    public final void rule__Attribute__Group__5() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:994:1: ( rule__Attribute__Group__5__Impl rule__Attribute__Group__6 )
            // InternalKM3.g:995:2: rule__Attribute__Group__5__Impl rule__Attribute__Group__6
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
    // InternalKM3.g:1002:1: rule__Attribute__Group__5__Impl : ( ':' ) ;
    public final void rule__Attribute__Group__5__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1006:1: ( ( ':' ) )
            // InternalKM3.g:1007:1: ( ':' )
            {
            // InternalKM3.g:1007:1: ( ':' )
            // InternalKM3.g:1008:2: ':'
            {
             before(grammarAccess.getAttributeAccess().getColonKeyword_5()); 
            match(input,22,FOLLOW_2); 
             after(grammarAccess.getAttributeAccess().getColonKeyword_5()); 

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
    // InternalKM3.g:1017:1: rule__Attribute__Group__6 : rule__Attribute__Group__6__Impl rule__Attribute__Group__7 ;
    public final void rule__Attribute__Group__6() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1021:1: ( rule__Attribute__Group__6__Impl rule__Attribute__Group__7 )
            // InternalKM3.g:1022:2: rule__Attribute__Group__6__Impl rule__Attribute__Group__7
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
    // InternalKM3.g:1029:1: rule__Attribute__Group__6__Impl : ( ( rule__Attribute__TypeAssignment_6 ) ) ;
    public final void rule__Attribute__Group__6__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1033:1: ( ( ( rule__Attribute__TypeAssignment_6 ) ) )
            // InternalKM3.g:1034:1: ( ( rule__Attribute__TypeAssignment_6 ) )
            {
            // InternalKM3.g:1034:1: ( ( rule__Attribute__TypeAssignment_6 ) )
            // InternalKM3.g:1035:2: ( rule__Attribute__TypeAssignment_6 )
            {
             before(grammarAccess.getAttributeAccess().getTypeAssignment_6()); 
            // InternalKM3.g:1036:2: ( rule__Attribute__TypeAssignment_6 )
            // InternalKM3.g:1036:3: rule__Attribute__TypeAssignment_6
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
    // InternalKM3.g:1044:1: rule__Attribute__Group__7 : rule__Attribute__Group__7__Impl ;
    public final void rule__Attribute__Group__7() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1048:1: ( rule__Attribute__Group__7__Impl )
            // InternalKM3.g:1049:2: rule__Attribute__Group__7__Impl
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
    // InternalKM3.g:1055:1: rule__Attribute__Group__7__Impl : ( ';' ) ;
    public final void rule__Attribute__Group__7__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1059:1: ( ( ';' ) )
            // InternalKM3.g:1060:1: ( ';' )
            {
            // InternalKM3.g:1060:1: ( ';' )
            // InternalKM3.g:1061:2: ';'
            {
             before(grammarAccess.getAttributeAccess().getSemicolonKeyword_7()); 
            match(input,17,FOLLOW_2); 
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


    // $ANTLR start "rule__Attribute__Group_3__0"
    // InternalKM3.g:1071:1: rule__Attribute__Group_3__0 : rule__Attribute__Group_3__0__Impl rule__Attribute__Group_3__1 ;
    public final void rule__Attribute__Group_3__0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1075:1: ( rule__Attribute__Group_3__0__Impl rule__Attribute__Group_3__1 )
            // InternalKM3.g:1076:2: rule__Attribute__Group_3__0__Impl rule__Attribute__Group_3__1
            {
            pushFollow(FOLLOW_16);
            rule__Attribute__Group_3__0__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__Attribute__Group_3__1();

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
    // $ANTLR end "rule__Attribute__Group_3__0"


    // $ANTLR start "rule__Attribute__Group_3__0__Impl"
    // InternalKM3.g:1083:1: rule__Attribute__Group_3__0__Impl : ( '[' ) ;
    public final void rule__Attribute__Group_3__0__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1087:1: ( ( '[' ) )
            // InternalKM3.g:1088:1: ( '[' )
            {
            // InternalKM3.g:1088:1: ( '[' )
            // InternalKM3.g:1089:2: '['
            {
             before(grammarAccess.getAttributeAccess().getLeftSquareBracketKeyword_3_0()); 
            match(input,23,FOLLOW_2); 
             after(grammarAccess.getAttributeAccess().getLeftSquareBracketKeyword_3_0()); 

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
    // $ANTLR end "rule__Attribute__Group_3__0__Impl"


    // $ANTLR start "rule__Attribute__Group_3__1"
    // InternalKM3.g:1098:1: rule__Attribute__Group_3__1 : rule__Attribute__Group_3__1__Impl rule__Attribute__Group_3__2 ;
    public final void rule__Attribute__Group_3__1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1102:1: ( rule__Attribute__Group_3__1__Impl rule__Attribute__Group_3__2 )
            // InternalKM3.g:1103:2: rule__Attribute__Group_3__1__Impl rule__Attribute__Group_3__2
            {
            pushFollow(FOLLOW_16);
            rule__Attribute__Group_3__1__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__Attribute__Group_3__2();

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
    // $ANTLR end "rule__Attribute__Group_3__1"


    // $ANTLR start "rule__Attribute__Group_3__1__Impl"
    // InternalKM3.g:1110:1: rule__Attribute__Group_3__1__Impl : ( ( rule__Attribute__Group_3_1__0 )? ) ;
    public final void rule__Attribute__Group_3__1__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1114:1: ( ( ( rule__Attribute__Group_3_1__0 )? ) )
            // InternalKM3.g:1115:1: ( ( rule__Attribute__Group_3_1__0 )? )
            {
            // InternalKM3.g:1115:1: ( ( rule__Attribute__Group_3_1__0 )? )
            // InternalKM3.g:1116:2: ( rule__Attribute__Group_3_1__0 )?
            {
             before(grammarAccess.getAttributeAccess().getGroup_3_1()); 
            // InternalKM3.g:1117:2: ( rule__Attribute__Group_3_1__0 )?
            int alt12=2;
            int LA12_0 = input.LA(1);

            if ( (LA12_0==12) ) {
                int LA12_1 = input.LA(2);

                if ( (LA12_1==25) ) {
                    alt12=1;
                }
            }
            else if ( (LA12_0==RULE_INT) ) {
                int LA12_2 = input.LA(2);

                if ( (LA12_2==25) ) {
                    alt12=1;
                }
            }
            switch (alt12) {
                case 1 :
                    // InternalKM3.g:1117:3: rule__Attribute__Group_3_1__0
                    {
                    pushFollow(FOLLOW_2);
                    rule__Attribute__Group_3_1__0();

                    state._fsp--;


                    }
                    break;

            }

             after(grammarAccess.getAttributeAccess().getGroup_3_1()); 

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
    // $ANTLR end "rule__Attribute__Group_3__1__Impl"


    // $ANTLR start "rule__Attribute__Group_3__2"
    // InternalKM3.g:1125:1: rule__Attribute__Group_3__2 : rule__Attribute__Group_3__2__Impl rule__Attribute__Group_3__3 ;
    public final void rule__Attribute__Group_3__2() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1129:1: ( rule__Attribute__Group_3__2__Impl rule__Attribute__Group_3__3 )
            // InternalKM3.g:1130:2: rule__Attribute__Group_3__2__Impl rule__Attribute__Group_3__3
            {
            pushFollow(FOLLOW_17);
            rule__Attribute__Group_3__2__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__Attribute__Group_3__3();

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
    // $ANTLR end "rule__Attribute__Group_3__2"


    // $ANTLR start "rule__Attribute__Group_3__2__Impl"
    // InternalKM3.g:1137:1: rule__Attribute__Group_3__2__Impl : ( ( rule__Attribute__UpperAssignment_3_2 ) ) ;
    public final void rule__Attribute__Group_3__2__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1141:1: ( ( ( rule__Attribute__UpperAssignment_3_2 ) ) )
            // InternalKM3.g:1142:1: ( ( rule__Attribute__UpperAssignment_3_2 ) )
            {
            // InternalKM3.g:1142:1: ( ( rule__Attribute__UpperAssignment_3_2 ) )
            // InternalKM3.g:1143:2: ( rule__Attribute__UpperAssignment_3_2 )
            {
             before(grammarAccess.getAttributeAccess().getUpperAssignment_3_2()); 
            // InternalKM3.g:1144:2: ( rule__Attribute__UpperAssignment_3_2 )
            // InternalKM3.g:1144:3: rule__Attribute__UpperAssignment_3_2
            {
            pushFollow(FOLLOW_2);
            rule__Attribute__UpperAssignment_3_2();

            state._fsp--;


            }

             after(grammarAccess.getAttributeAccess().getUpperAssignment_3_2()); 

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
    // $ANTLR end "rule__Attribute__Group_3__2__Impl"


    // $ANTLR start "rule__Attribute__Group_3__3"
    // InternalKM3.g:1152:1: rule__Attribute__Group_3__3 : rule__Attribute__Group_3__3__Impl ;
    public final void rule__Attribute__Group_3__3() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1156:1: ( rule__Attribute__Group_3__3__Impl )
            // InternalKM3.g:1157:2: rule__Attribute__Group_3__3__Impl
            {
            pushFollow(FOLLOW_2);
            rule__Attribute__Group_3__3__Impl();

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
    // $ANTLR end "rule__Attribute__Group_3__3"


    // $ANTLR start "rule__Attribute__Group_3__3__Impl"
    // InternalKM3.g:1163:1: rule__Attribute__Group_3__3__Impl : ( ']' ) ;
    public final void rule__Attribute__Group_3__3__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1167:1: ( ( ']' ) )
            // InternalKM3.g:1168:1: ( ']' )
            {
            // InternalKM3.g:1168:1: ( ']' )
            // InternalKM3.g:1169:2: ']'
            {
             before(grammarAccess.getAttributeAccess().getRightSquareBracketKeyword_3_3()); 
            match(input,24,FOLLOW_2); 
             after(grammarAccess.getAttributeAccess().getRightSquareBracketKeyword_3_3()); 

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
    // $ANTLR end "rule__Attribute__Group_3__3__Impl"


    // $ANTLR start "rule__Attribute__Group_3_1__0"
    // InternalKM3.g:1179:1: rule__Attribute__Group_3_1__0 : rule__Attribute__Group_3_1__0__Impl rule__Attribute__Group_3_1__1 ;
    public final void rule__Attribute__Group_3_1__0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1183:1: ( rule__Attribute__Group_3_1__0__Impl rule__Attribute__Group_3_1__1 )
            // InternalKM3.g:1184:2: rule__Attribute__Group_3_1__0__Impl rule__Attribute__Group_3_1__1
            {
            pushFollow(FOLLOW_18);
            rule__Attribute__Group_3_1__0__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__Attribute__Group_3_1__1();

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
    // $ANTLR end "rule__Attribute__Group_3_1__0"


    // $ANTLR start "rule__Attribute__Group_3_1__0__Impl"
    // InternalKM3.g:1191:1: rule__Attribute__Group_3_1__0__Impl : ( ( rule__Attribute__LowerAssignment_3_1_0 ) ) ;
    public final void rule__Attribute__Group_3_1__0__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1195:1: ( ( ( rule__Attribute__LowerAssignment_3_1_0 ) ) )
            // InternalKM3.g:1196:1: ( ( rule__Attribute__LowerAssignment_3_1_0 ) )
            {
            // InternalKM3.g:1196:1: ( ( rule__Attribute__LowerAssignment_3_1_0 ) )
            // InternalKM3.g:1197:2: ( rule__Attribute__LowerAssignment_3_1_0 )
            {
             before(grammarAccess.getAttributeAccess().getLowerAssignment_3_1_0()); 
            // InternalKM3.g:1198:2: ( rule__Attribute__LowerAssignment_3_1_0 )
            // InternalKM3.g:1198:3: rule__Attribute__LowerAssignment_3_1_0
            {
            pushFollow(FOLLOW_2);
            rule__Attribute__LowerAssignment_3_1_0();

            state._fsp--;


            }

             after(grammarAccess.getAttributeAccess().getLowerAssignment_3_1_0()); 

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
    // $ANTLR end "rule__Attribute__Group_3_1__0__Impl"


    // $ANTLR start "rule__Attribute__Group_3_1__1"
    // InternalKM3.g:1206:1: rule__Attribute__Group_3_1__1 : rule__Attribute__Group_3_1__1__Impl ;
    public final void rule__Attribute__Group_3_1__1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1210:1: ( rule__Attribute__Group_3_1__1__Impl )
            // InternalKM3.g:1211:2: rule__Attribute__Group_3_1__1__Impl
            {
            pushFollow(FOLLOW_2);
            rule__Attribute__Group_3_1__1__Impl();

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
    // $ANTLR end "rule__Attribute__Group_3_1__1"


    // $ANTLR start "rule__Attribute__Group_3_1__1__Impl"
    // InternalKM3.g:1217:1: rule__Attribute__Group_3_1__1__Impl : ( '-' ) ;
    public final void rule__Attribute__Group_3_1__1__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1221:1: ( ( '-' ) )
            // InternalKM3.g:1222:1: ( '-' )
            {
            // InternalKM3.g:1222:1: ( '-' )
            // InternalKM3.g:1223:2: '-'
            {
             before(grammarAccess.getAttributeAccess().getHyphenMinusKeyword_3_1_1()); 
            match(input,25,FOLLOW_2); 
             after(grammarAccess.getAttributeAccess().getHyphenMinusKeyword_3_1_1()); 

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
    // $ANTLR end "rule__Attribute__Group_3_1__1__Impl"


    // $ANTLR start "rule__Reference__Group__0"
    // InternalKM3.g:1233:1: rule__Reference__Group__0 : rule__Reference__Group__0__Impl rule__Reference__Group__1 ;
    public final void rule__Reference__Group__0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1237:1: ( rule__Reference__Group__0__Impl rule__Reference__Group__1 )
            // InternalKM3.g:1238:2: rule__Reference__Group__0__Impl rule__Reference__Group__1
            {
            pushFollow(FOLLOW_3);
            rule__Reference__Group__0__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__Reference__Group__1();

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
    // $ANTLR end "rule__Reference__Group__0"


    // $ANTLR start "rule__Reference__Group__0__Impl"
    // InternalKM3.g:1245:1: rule__Reference__Group__0__Impl : ( 'reference' ) ;
    public final void rule__Reference__Group__0__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1249:1: ( ( 'reference' ) )
            // InternalKM3.g:1250:1: ( 'reference' )
            {
            // InternalKM3.g:1250:1: ( 'reference' )
            // InternalKM3.g:1251:2: 'reference'
            {
             before(grammarAccess.getReferenceAccess().getReferenceKeyword_0()); 
            match(input,26,FOLLOW_2); 
             after(grammarAccess.getReferenceAccess().getReferenceKeyword_0()); 

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
    // $ANTLR end "rule__Reference__Group__0__Impl"


    // $ANTLR start "rule__Reference__Group__1"
    // InternalKM3.g:1260:1: rule__Reference__Group__1 : rule__Reference__Group__1__Impl rule__Reference__Group__2 ;
    public final void rule__Reference__Group__1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1264:1: ( rule__Reference__Group__1__Impl rule__Reference__Group__2 )
            // InternalKM3.g:1265:2: rule__Reference__Group__1__Impl rule__Reference__Group__2
            {
            pushFollow(FOLLOW_19);
            rule__Reference__Group__1__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__Reference__Group__2();

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
    // $ANTLR end "rule__Reference__Group__1"


    // $ANTLR start "rule__Reference__Group__1__Impl"
    // InternalKM3.g:1272:1: rule__Reference__Group__1__Impl : ( ( rule__Reference__NameAssignment_1 ) ) ;
    public final void rule__Reference__Group__1__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1276:1: ( ( ( rule__Reference__NameAssignment_1 ) ) )
            // InternalKM3.g:1277:1: ( ( rule__Reference__NameAssignment_1 ) )
            {
            // InternalKM3.g:1277:1: ( ( rule__Reference__NameAssignment_1 ) )
            // InternalKM3.g:1278:2: ( rule__Reference__NameAssignment_1 )
            {
             before(grammarAccess.getReferenceAccess().getNameAssignment_1()); 
            // InternalKM3.g:1279:2: ( rule__Reference__NameAssignment_1 )
            // InternalKM3.g:1279:3: rule__Reference__NameAssignment_1
            {
            pushFollow(FOLLOW_2);
            rule__Reference__NameAssignment_1();

            state._fsp--;


            }

             after(grammarAccess.getReferenceAccess().getNameAssignment_1()); 

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
    // $ANTLR end "rule__Reference__Group__1__Impl"


    // $ANTLR start "rule__Reference__Group__2"
    // InternalKM3.g:1287:1: rule__Reference__Group__2 : rule__Reference__Group__2__Impl rule__Reference__Group__3 ;
    public final void rule__Reference__Group__2() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1291:1: ( rule__Reference__Group__2__Impl rule__Reference__Group__3 )
            // InternalKM3.g:1292:2: rule__Reference__Group__2__Impl rule__Reference__Group__3
            {
            pushFollow(FOLLOW_19);
            rule__Reference__Group__2__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__Reference__Group__3();

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
    // $ANTLR end "rule__Reference__Group__2"


    // $ANTLR start "rule__Reference__Group__2__Impl"
    // InternalKM3.g:1299:1: rule__Reference__Group__2__Impl : ( ( rule__Reference__Group_2__0 )? ) ;
    public final void rule__Reference__Group__2__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1303:1: ( ( ( rule__Reference__Group_2__0 )? ) )
            // InternalKM3.g:1304:1: ( ( rule__Reference__Group_2__0 )? )
            {
            // InternalKM3.g:1304:1: ( ( rule__Reference__Group_2__0 )? )
            // InternalKM3.g:1305:2: ( rule__Reference__Group_2__0 )?
            {
             before(grammarAccess.getReferenceAccess().getGroup_2()); 
            // InternalKM3.g:1306:2: ( rule__Reference__Group_2__0 )?
            int alt13=2;
            int LA13_0 = input.LA(1);

            if ( (LA13_0==23) ) {
                alt13=1;
            }
            switch (alt13) {
                case 1 :
                    // InternalKM3.g:1306:3: rule__Reference__Group_2__0
                    {
                    pushFollow(FOLLOW_2);
                    rule__Reference__Group_2__0();

                    state._fsp--;


                    }
                    break;

            }

             after(grammarAccess.getReferenceAccess().getGroup_2()); 

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
    // $ANTLR end "rule__Reference__Group__2__Impl"


    // $ANTLR start "rule__Reference__Group__3"
    // InternalKM3.g:1314:1: rule__Reference__Group__3 : rule__Reference__Group__3__Impl rule__Reference__Group__4 ;
    public final void rule__Reference__Group__3() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1318:1: ( rule__Reference__Group__3__Impl rule__Reference__Group__4 )
            // InternalKM3.g:1319:2: rule__Reference__Group__3__Impl rule__Reference__Group__4
            {
            pushFollow(FOLLOW_19);
            rule__Reference__Group__3__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__Reference__Group__4();

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
    // $ANTLR end "rule__Reference__Group__3"


    // $ANTLR start "rule__Reference__Group__3__Impl"
    // InternalKM3.g:1326:1: rule__Reference__Group__3__Impl : ( ( rule__Reference__IsOrderedAssignment_3 )? ) ;
    public final void rule__Reference__Group__3__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1330:1: ( ( ( rule__Reference__IsOrderedAssignment_3 )? ) )
            // InternalKM3.g:1331:1: ( ( rule__Reference__IsOrderedAssignment_3 )? )
            {
            // InternalKM3.g:1331:1: ( ( rule__Reference__IsOrderedAssignment_3 )? )
            // InternalKM3.g:1332:2: ( rule__Reference__IsOrderedAssignment_3 )?
            {
             before(grammarAccess.getReferenceAccess().getIsOrderedAssignment_3()); 
            // InternalKM3.g:1333:2: ( rule__Reference__IsOrderedAssignment_3 )?
            int alt14=2;
            int LA14_0 = input.LA(1);

            if ( (LA14_0==30) ) {
                alt14=1;
            }
            switch (alt14) {
                case 1 :
                    // InternalKM3.g:1333:3: rule__Reference__IsOrderedAssignment_3
                    {
                    pushFollow(FOLLOW_2);
                    rule__Reference__IsOrderedAssignment_3();

                    state._fsp--;


                    }
                    break;

            }

             after(grammarAccess.getReferenceAccess().getIsOrderedAssignment_3()); 

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
    // $ANTLR end "rule__Reference__Group__3__Impl"


    // $ANTLR start "rule__Reference__Group__4"
    // InternalKM3.g:1341:1: rule__Reference__Group__4 : rule__Reference__Group__4__Impl rule__Reference__Group__5 ;
    public final void rule__Reference__Group__4() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1345:1: ( rule__Reference__Group__4__Impl rule__Reference__Group__5 )
            // InternalKM3.g:1346:2: rule__Reference__Group__4__Impl rule__Reference__Group__5
            {
            pushFollow(FOLLOW_19);
            rule__Reference__Group__4__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__Reference__Group__5();

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
    // $ANTLR end "rule__Reference__Group__4"


    // $ANTLR start "rule__Reference__Group__4__Impl"
    // InternalKM3.g:1353:1: rule__Reference__Group__4__Impl : ( ( rule__Reference__IsContainerAssignment_4 )? ) ;
    public final void rule__Reference__Group__4__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1357:1: ( ( ( rule__Reference__IsContainerAssignment_4 )? ) )
            // InternalKM3.g:1358:1: ( ( rule__Reference__IsContainerAssignment_4 )? )
            {
            // InternalKM3.g:1358:1: ( ( rule__Reference__IsContainerAssignment_4 )? )
            // InternalKM3.g:1359:2: ( rule__Reference__IsContainerAssignment_4 )?
            {
             before(grammarAccess.getReferenceAccess().getIsContainerAssignment_4()); 
            // InternalKM3.g:1360:2: ( rule__Reference__IsContainerAssignment_4 )?
            int alt15=2;
            int LA15_0 = input.LA(1);

            if ( (LA15_0==31) ) {
                alt15=1;
            }
            switch (alt15) {
                case 1 :
                    // InternalKM3.g:1360:3: rule__Reference__IsContainerAssignment_4
                    {
                    pushFollow(FOLLOW_2);
                    rule__Reference__IsContainerAssignment_4();

                    state._fsp--;


                    }
                    break;

            }

             after(grammarAccess.getReferenceAccess().getIsContainerAssignment_4()); 

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
    // $ANTLR end "rule__Reference__Group__4__Impl"


    // $ANTLR start "rule__Reference__Group__5"
    // InternalKM3.g:1368:1: rule__Reference__Group__5 : rule__Reference__Group__5__Impl rule__Reference__Group__6 ;
    public final void rule__Reference__Group__5() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1372:1: ( rule__Reference__Group__5__Impl rule__Reference__Group__6 )
            // InternalKM3.g:1373:2: rule__Reference__Group__5__Impl rule__Reference__Group__6
            {
            pushFollow(FOLLOW_3);
            rule__Reference__Group__5__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__Reference__Group__6();

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
    // $ANTLR end "rule__Reference__Group__5"


    // $ANTLR start "rule__Reference__Group__5__Impl"
    // InternalKM3.g:1380:1: rule__Reference__Group__5__Impl : ( ':' ) ;
    public final void rule__Reference__Group__5__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1384:1: ( ( ':' ) )
            // InternalKM3.g:1385:1: ( ':' )
            {
            // InternalKM3.g:1385:1: ( ':' )
            // InternalKM3.g:1386:2: ':'
            {
             before(grammarAccess.getReferenceAccess().getColonKeyword_5()); 
            match(input,22,FOLLOW_2); 
             after(grammarAccess.getReferenceAccess().getColonKeyword_5()); 

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
    // $ANTLR end "rule__Reference__Group__5__Impl"


    // $ANTLR start "rule__Reference__Group__6"
    // InternalKM3.g:1395:1: rule__Reference__Group__6 : rule__Reference__Group__6__Impl rule__Reference__Group__7 ;
    public final void rule__Reference__Group__6() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1399:1: ( rule__Reference__Group__6__Impl rule__Reference__Group__7 )
            // InternalKM3.g:1400:2: rule__Reference__Group__6__Impl rule__Reference__Group__7
            {
            pushFollow(FOLLOW_20);
            rule__Reference__Group__6__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__Reference__Group__7();

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
    // $ANTLR end "rule__Reference__Group__6"


    // $ANTLR start "rule__Reference__Group__6__Impl"
    // InternalKM3.g:1407:1: rule__Reference__Group__6__Impl : ( ( rule__Reference__TypeAssignment_6 ) ) ;
    public final void rule__Reference__Group__6__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1411:1: ( ( ( rule__Reference__TypeAssignment_6 ) ) )
            // InternalKM3.g:1412:1: ( ( rule__Reference__TypeAssignment_6 ) )
            {
            // InternalKM3.g:1412:1: ( ( rule__Reference__TypeAssignment_6 ) )
            // InternalKM3.g:1413:2: ( rule__Reference__TypeAssignment_6 )
            {
             before(grammarAccess.getReferenceAccess().getTypeAssignment_6()); 
            // InternalKM3.g:1414:2: ( rule__Reference__TypeAssignment_6 )
            // InternalKM3.g:1414:3: rule__Reference__TypeAssignment_6
            {
            pushFollow(FOLLOW_2);
            rule__Reference__TypeAssignment_6();

            state._fsp--;


            }

             after(grammarAccess.getReferenceAccess().getTypeAssignment_6()); 

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
    // $ANTLR end "rule__Reference__Group__6__Impl"


    // $ANTLR start "rule__Reference__Group__7"
    // InternalKM3.g:1422:1: rule__Reference__Group__7 : rule__Reference__Group__7__Impl rule__Reference__Group__8 ;
    public final void rule__Reference__Group__7() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1426:1: ( rule__Reference__Group__7__Impl rule__Reference__Group__8 )
            // InternalKM3.g:1427:2: rule__Reference__Group__7__Impl rule__Reference__Group__8
            {
            pushFollow(FOLLOW_20);
            rule__Reference__Group__7__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__Reference__Group__8();

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
    // $ANTLR end "rule__Reference__Group__7"


    // $ANTLR start "rule__Reference__Group__7__Impl"
    // InternalKM3.g:1434:1: rule__Reference__Group__7__Impl : ( ( rule__Reference__Group_7__0 )? ) ;
    public final void rule__Reference__Group__7__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1438:1: ( ( ( rule__Reference__Group_7__0 )? ) )
            // InternalKM3.g:1439:1: ( ( rule__Reference__Group_7__0 )? )
            {
            // InternalKM3.g:1439:1: ( ( rule__Reference__Group_7__0 )? )
            // InternalKM3.g:1440:2: ( rule__Reference__Group_7__0 )?
            {
             before(grammarAccess.getReferenceAccess().getGroup_7()); 
            // InternalKM3.g:1441:2: ( rule__Reference__Group_7__0 )?
            int alt16=2;
            int LA16_0 = input.LA(1);

            if ( (LA16_0==27) ) {
                alt16=1;
            }
            switch (alt16) {
                case 1 :
                    // InternalKM3.g:1441:3: rule__Reference__Group_7__0
                    {
                    pushFollow(FOLLOW_2);
                    rule__Reference__Group_7__0();

                    state._fsp--;


                    }
                    break;

            }

             after(grammarAccess.getReferenceAccess().getGroup_7()); 

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
    // $ANTLR end "rule__Reference__Group__7__Impl"


    // $ANTLR start "rule__Reference__Group__8"
    // InternalKM3.g:1449:1: rule__Reference__Group__8 : rule__Reference__Group__8__Impl ;
    public final void rule__Reference__Group__8() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1453:1: ( rule__Reference__Group__8__Impl )
            // InternalKM3.g:1454:2: rule__Reference__Group__8__Impl
            {
            pushFollow(FOLLOW_2);
            rule__Reference__Group__8__Impl();

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
    // $ANTLR end "rule__Reference__Group__8"


    // $ANTLR start "rule__Reference__Group__8__Impl"
    // InternalKM3.g:1460:1: rule__Reference__Group__8__Impl : ( ';' ) ;
    public final void rule__Reference__Group__8__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1464:1: ( ( ';' ) )
            // InternalKM3.g:1465:1: ( ';' )
            {
            // InternalKM3.g:1465:1: ( ';' )
            // InternalKM3.g:1466:2: ';'
            {
             before(grammarAccess.getReferenceAccess().getSemicolonKeyword_8()); 
            match(input,17,FOLLOW_2); 
             after(grammarAccess.getReferenceAccess().getSemicolonKeyword_8()); 

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
    // $ANTLR end "rule__Reference__Group__8__Impl"


    // $ANTLR start "rule__Reference__Group_2__0"
    // InternalKM3.g:1476:1: rule__Reference__Group_2__0 : rule__Reference__Group_2__0__Impl rule__Reference__Group_2__1 ;
    public final void rule__Reference__Group_2__0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1480:1: ( rule__Reference__Group_2__0__Impl rule__Reference__Group_2__1 )
            // InternalKM3.g:1481:2: rule__Reference__Group_2__0__Impl rule__Reference__Group_2__1
            {
            pushFollow(FOLLOW_16);
            rule__Reference__Group_2__0__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__Reference__Group_2__1();

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
    // $ANTLR end "rule__Reference__Group_2__0"


    // $ANTLR start "rule__Reference__Group_2__0__Impl"
    // InternalKM3.g:1488:1: rule__Reference__Group_2__0__Impl : ( '[' ) ;
    public final void rule__Reference__Group_2__0__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1492:1: ( ( '[' ) )
            // InternalKM3.g:1493:1: ( '[' )
            {
            // InternalKM3.g:1493:1: ( '[' )
            // InternalKM3.g:1494:2: '['
            {
             before(grammarAccess.getReferenceAccess().getLeftSquareBracketKeyword_2_0()); 
            match(input,23,FOLLOW_2); 
             after(grammarAccess.getReferenceAccess().getLeftSquareBracketKeyword_2_0()); 

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
    // $ANTLR end "rule__Reference__Group_2__0__Impl"


    // $ANTLR start "rule__Reference__Group_2__1"
    // InternalKM3.g:1503:1: rule__Reference__Group_2__1 : rule__Reference__Group_2__1__Impl rule__Reference__Group_2__2 ;
    public final void rule__Reference__Group_2__1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1507:1: ( rule__Reference__Group_2__1__Impl rule__Reference__Group_2__2 )
            // InternalKM3.g:1508:2: rule__Reference__Group_2__1__Impl rule__Reference__Group_2__2
            {
            pushFollow(FOLLOW_16);
            rule__Reference__Group_2__1__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__Reference__Group_2__2();

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
    // $ANTLR end "rule__Reference__Group_2__1"


    // $ANTLR start "rule__Reference__Group_2__1__Impl"
    // InternalKM3.g:1515:1: rule__Reference__Group_2__1__Impl : ( ( rule__Reference__Group_2_1__0 )? ) ;
    public final void rule__Reference__Group_2__1__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1519:1: ( ( ( rule__Reference__Group_2_1__0 )? ) )
            // InternalKM3.g:1520:1: ( ( rule__Reference__Group_2_1__0 )? )
            {
            // InternalKM3.g:1520:1: ( ( rule__Reference__Group_2_1__0 )? )
            // InternalKM3.g:1521:2: ( rule__Reference__Group_2_1__0 )?
            {
             before(grammarAccess.getReferenceAccess().getGroup_2_1()); 
            // InternalKM3.g:1522:2: ( rule__Reference__Group_2_1__0 )?
            int alt17=2;
            int LA17_0 = input.LA(1);

            if ( (LA17_0==12) ) {
                int LA17_1 = input.LA(2);

                if ( (LA17_1==25) ) {
                    alt17=1;
                }
            }
            else if ( (LA17_0==RULE_INT) ) {
                int LA17_2 = input.LA(2);

                if ( (LA17_2==25) ) {
                    alt17=1;
                }
            }
            switch (alt17) {
                case 1 :
                    // InternalKM3.g:1522:3: rule__Reference__Group_2_1__0
                    {
                    pushFollow(FOLLOW_2);
                    rule__Reference__Group_2_1__0();

                    state._fsp--;


                    }
                    break;

            }

             after(grammarAccess.getReferenceAccess().getGroup_2_1()); 

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
    // $ANTLR end "rule__Reference__Group_2__1__Impl"


    // $ANTLR start "rule__Reference__Group_2__2"
    // InternalKM3.g:1530:1: rule__Reference__Group_2__2 : rule__Reference__Group_2__2__Impl rule__Reference__Group_2__3 ;
    public final void rule__Reference__Group_2__2() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1534:1: ( rule__Reference__Group_2__2__Impl rule__Reference__Group_2__3 )
            // InternalKM3.g:1535:2: rule__Reference__Group_2__2__Impl rule__Reference__Group_2__3
            {
            pushFollow(FOLLOW_17);
            rule__Reference__Group_2__2__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__Reference__Group_2__3();

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
    // $ANTLR end "rule__Reference__Group_2__2"


    // $ANTLR start "rule__Reference__Group_2__2__Impl"
    // InternalKM3.g:1542:1: rule__Reference__Group_2__2__Impl : ( ( rule__Reference__UpperAssignment_2_2 ) ) ;
    public final void rule__Reference__Group_2__2__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1546:1: ( ( ( rule__Reference__UpperAssignment_2_2 ) ) )
            // InternalKM3.g:1547:1: ( ( rule__Reference__UpperAssignment_2_2 ) )
            {
            // InternalKM3.g:1547:1: ( ( rule__Reference__UpperAssignment_2_2 ) )
            // InternalKM3.g:1548:2: ( rule__Reference__UpperAssignment_2_2 )
            {
             before(grammarAccess.getReferenceAccess().getUpperAssignment_2_2()); 
            // InternalKM3.g:1549:2: ( rule__Reference__UpperAssignment_2_2 )
            // InternalKM3.g:1549:3: rule__Reference__UpperAssignment_2_2
            {
            pushFollow(FOLLOW_2);
            rule__Reference__UpperAssignment_2_2();

            state._fsp--;


            }

             after(grammarAccess.getReferenceAccess().getUpperAssignment_2_2()); 

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
    // $ANTLR end "rule__Reference__Group_2__2__Impl"


    // $ANTLR start "rule__Reference__Group_2__3"
    // InternalKM3.g:1557:1: rule__Reference__Group_2__3 : rule__Reference__Group_2__3__Impl ;
    public final void rule__Reference__Group_2__3() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1561:1: ( rule__Reference__Group_2__3__Impl )
            // InternalKM3.g:1562:2: rule__Reference__Group_2__3__Impl
            {
            pushFollow(FOLLOW_2);
            rule__Reference__Group_2__3__Impl();

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
    // $ANTLR end "rule__Reference__Group_2__3"


    // $ANTLR start "rule__Reference__Group_2__3__Impl"
    // InternalKM3.g:1568:1: rule__Reference__Group_2__3__Impl : ( ']' ) ;
    public final void rule__Reference__Group_2__3__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1572:1: ( ( ']' ) )
            // InternalKM3.g:1573:1: ( ']' )
            {
            // InternalKM3.g:1573:1: ( ']' )
            // InternalKM3.g:1574:2: ']'
            {
             before(grammarAccess.getReferenceAccess().getRightSquareBracketKeyword_2_3()); 
            match(input,24,FOLLOW_2); 
             after(grammarAccess.getReferenceAccess().getRightSquareBracketKeyword_2_3()); 

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
    // $ANTLR end "rule__Reference__Group_2__3__Impl"


    // $ANTLR start "rule__Reference__Group_2_1__0"
    // InternalKM3.g:1584:1: rule__Reference__Group_2_1__0 : rule__Reference__Group_2_1__0__Impl rule__Reference__Group_2_1__1 ;
    public final void rule__Reference__Group_2_1__0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1588:1: ( rule__Reference__Group_2_1__0__Impl rule__Reference__Group_2_1__1 )
            // InternalKM3.g:1589:2: rule__Reference__Group_2_1__0__Impl rule__Reference__Group_2_1__1
            {
            pushFollow(FOLLOW_18);
            rule__Reference__Group_2_1__0__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__Reference__Group_2_1__1();

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
    // $ANTLR end "rule__Reference__Group_2_1__0"


    // $ANTLR start "rule__Reference__Group_2_1__0__Impl"
    // InternalKM3.g:1596:1: rule__Reference__Group_2_1__0__Impl : ( ( rule__Reference__LowerAssignment_2_1_0 ) ) ;
    public final void rule__Reference__Group_2_1__0__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1600:1: ( ( ( rule__Reference__LowerAssignment_2_1_0 ) ) )
            // InternalKM3.g:1601:1: ( ( rule__Reference__LowerAssignment_2_1_0 ) )
            {
            // InternalKM3.g:1601:1: ( ( rule__Reference__LowerAssignment_2_1_0 ) )
            // InternalKM3.g:1602:2: ( rule__Reference__LowerAssignment_2_1_0 )
            {
             before(grammarAccess.getReferenceAccess().getLowerAssignment_2_1_0()); 
            // InternalKM3.g:1603:2: ( rule__Reference__LowerAssignment_2_1_0 )
            // InternalKM3.g:1603:3: rule__Reference__LowerAssignment_2_1_0
            {
            pushFollow(FOLLOW_2);
            rule__Reference__LowerAssignment_2_1_0();

            state._fsp--;


            }

             after(grammarAccess.getReferenceAccess().getLowerAssignment_2_1_0()); 

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
    // $ANTLR end "rule__Reference__Group_2_1__0__Impl"


    // $ANTLR start "rule__Reference__Group_2_1__1"
    // InternalKM3.g:1611:1: rule__Reference__Group_2_1__1 : rule__Reference__Group_2_1__1__Impl ;
    public final void rule__Reference__Group_2_1__1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1615:1: ( rule__Reference__Group_2_1__1__Impl )
            // InternalKM3.g:1616:2: rule__Reference__Group_2_1__1__Impl
            {
            pushFollow(FOLLOW_2);
            rule__Reference__Group_2_1__1__Impl();

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
    // $ANTLR end "rule__Reference__Group_2_1__1"


    // $ANTLR start "rule__Reference__Group_2_1__1__Impl"
    // InternalKM3.g:1622:1: rule__Reference__Group_2_1__1__Impl : ( '-' ) ;
    public final void rule__Reference__Group_2_1__1__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1626:1: ( ( '-' ) )
            // InternalKM3.g:1627:1: ( '-' )
            {
            // InternalKM3.g:1627:1: ( '-' )
            // InternalKM3.g:1628:2: '-'
            {
             before(grammarAccess.getReferenceAccess().getHyphenMinusKeyword_2_1_1()); 
            match(input,25,FOLLOW_2); 
             after(grammarAccess.getReferenceAccess().getHyphenMinusKeyword_2_1_1()); 

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
    // $ANTLR end "rule__Reference__Group_2_1__1__Impl"


    // $ANTLR start "rule__Reference__Group_7__0"
    // InternalKM3.g:1638:1: rule__Reference__Group_7__0 : rule__Reference__Group_7__0__Impl rule__Reference__Group_7__1 ;
    public final void rule__Reference__Group_7__0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1642:1: ( rule__Reference__Group_7__0__Impl rule__Reference__Group_7__1 )
            // InternalKM3.g:1643:2: rule__Reference__Group_7__0__Impl rule__Reference__Group_7__1
            {
            pushFollow(FOLLOW_3);
            rule__Reference__Group_7__0__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__Reference__Group_7__1();

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
    // $ANTLR end "rule__Reference__Group_7__0"


    // $ANTLR start "rule__Reference__Group_7__0__Impl"
    // InternalKM3.g:1650:1: rule__Reference__Group_7__0__Impl : ( 'oppositeOf' ) ;
    public final void rule__Reference__Group_7__0__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1654:1: ( ( 'oppositeOf' ) )
            // InternalKM3.g:1655:1: ( 'oppositeOf' )
            {
            // InternalKM3.g:1655:1: ( 'oppositeOf' )
            // InternalKM3.g:1656:2: 'oppositeOf'
            {
             before(grammarAccess.getReferenceAccess().getOppositeOfKeyword_7_0()); 
            match(input,27,FOLLOW_2); 
             after(grammarAccess.getReferenceAccess().getOppositeOfKeyword_7_0()); 

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
    // $ANTLR end "rule__Reference__Group_7__0__Impl"


    // $ANTLR start "rule__Reference__Group_7__1"
    // InternalKM3.g:1665:1: rule__Reference__Group_7__1 : rule__Reference__Group_7__1__Impl ;
    public final void rule__Reference__Group_7__1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1669:1: ( rule__Reference__Group_7__1__Impl )
            // InternalKM3.g:1670:2: rule__Reference__Group_7__1__Impl
            {
            pushFollow(FOLLOW_2);
            rule__Reference__Group_7__1__Impl();

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
    // $ANTLR end "rule__Reference__Group_7__1"


    // $ANTLR start "rule__Reference__Group_7__1__Impl"
    // InternalKM3.g:1676:1: rule__Reference__Group_7__1__Impl : ( ( rule__Reference__OppositeAssignment_7_1 ) ) ;
    public final void rule__Reference__Group_7__1__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1680:1: ( ( ( rule__Reference__OppositeAssignment_7_1 ) ) )
            // InternalKM3.g:1681:1: ( ( rule__Reference__OppositeAssignment_7_1 ) )
            {
            // InternalKM3.g:1681:1: ( ( rule__Reference__OppositeAssignment_7_1 ) )
            // InternalKM3.g:1682:2: ( rule__Reference__OppositeAssignment_7_1 )
            {
             before(grammarAccess.getReferenceAccess().getOppositeAssignment_7_1()); 
            // InternalKM3.g:1683:2: ( rule__Reference__OppositeAssignment_7_1 )
            // InternalKM3.g:1683:3: rule__Reference__OppositeAssignment_7_1
            {
            pushFollow(FOLLOW_2);
            rule__Reference__OppositeAssignment_7_1();

            state._fsp--;


            }

             after(grammarAccess.getReferenceAccess().getOppositeAssignment_7_1()); 

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
    // $ANTLR end "rule__Reference__Group_7__1__Impl"


    // $ANTLR start "rule__Package__NameAssignment_1"
    // InternalKM3.g:1692:1: rule__Package__NameAssignment_1 : ( RULE_ID ) ;
    public final void rule__Package__NameAssignment_1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1696:1: ( ( RULE_ID ) )
            // InternalKM3.g:1697:2: ( RULE_ID )
            {
            // InternalKM3.g:1697:2: ( RULE_ID )
            // InternalKM3.g:1698:3: RULE_ID
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
    // InternalKM3.g:1707:1: rule__Package__ContentsAssignment_3 : ( ruleModelElement ) ;
    public final void rule__Package__ContentsAssignment_3() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1711:1: ( ( ruleModelElement ) )
            // InternalKM3.g:1712:2: ( ruleModelElement )
            {
            // InternalKM3.g:1712:2: ( ruleModelElement )
            // InternalKM3.g:1713:3: ruleModelElement
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
    // InternalKM3.g:1722:1: rule__DataType__NameAssignment_1 : ( RULE_ID ) ;
    public final void rule__DataType__NameAssignment_1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1726:1: ( ( RULE_ID ) )
            // InternalKM3.g:1727:2: ( RULE_ID )
            {
            // InternalKM3.g:1727:2: ( RULE_ID )
            // InternalKM3.g:1728:3: RULE_ID
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
    // InternalKM3.g:1737:1: rule__Class__IsAbstractAssignment_0 : ( ( 'abstract' ) ) ;
    public final void rule__Class__IsAbstractAssignment_0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1741:1: ( ( ( 'abstract' ) ) )
            // InternalKM3.g:1742:2: ( ( 'abstract' ) )
            {
            // InternalKM3.g:1742:2: ( ( 'abstract' ) )
            // InternalKM3.g:1743:3: ( 'abstract' )
            {
             before(grammarAccess.getClassAccess().getIsAbstractAbstractKeyword_0_0()); 
            // InternalKM3.g:1744:3: ( 'abstract' )
            // InternalKM3.g:1745:4: 'abstract'
            {
             before(grammarAccess.getClassAccess().getIsAbstractAbstractKeyword_0_0()); 
            match(input,28,FOLLOW_2); 
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
    // InternalKM3.g:1756:1: rule__Class__NameAssignment_2 : ( RULE_ID ) ;
    public final void rule__Class__NameAssignment_2() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1760:1: ( ( RULE_ID ) )
            // InternalKM3.g:1761:2: ( RULE_ID )
            {
            // InternalKM3.g:1761:2: ( RULE_ID )
            // InternalKM3.g:1762:3: RULE_ID
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
    // InternalKM3.g:1771:1: rule__Class__SupertypesAssignment_3_1 : ( ( RULE_ID ) ) ;
    public final void rule__Class__SupertypesAssignment_3_1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1775:1: ( ( ( RULE_ID ) ) )
            // InternalKM3.g:1776:2: ( ( RULE_ID ) )
            {
            // InternalKM3.g:1776:2: ( ( RULE_ID ) )
            // InternalKM3.g:1777:3: ( RULE_ID )
            {
             before(grammarAccess.getClassAccess().getSupertypesClassCrossReference_3_1_0()); 
            // InternalKM3.g:1778:3: ( RULE_ID )
            // InternalKM3.g:1779:4: RULE_ID
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
    // InternalKM3.g:1790:1: rule__Class__SupertypesAssignment_3_2_1 : ( ( RULE_ID ) ) ;
    public final void rule__Class__SupertypesAssignment_3_2_1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1794:1: ( ( ( RULE_ID ) ) )
            // InternalKM3.g:1795:2: ( ( RULE_ID ) )
            {
            // InternalKM3.g:1795:2: ( ( RULE_ID ) )
            // InternalKM3.g:1796:3: ( RULE_ID )
            {
             before(grammarAccess.getClassAccess().getSupertypesClassCrossReference_3_2_1_0()); 
            // InternalKM3.g:1797:3: ( RULE_ID )
            // InternalKM3.g:1798:4: RULE_ID
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
    // InternalKM3.g:1809:1: rule__Class__StructuralFeaturesAssignment_5 : ( ruleStructuralFeature ) ;
    public final void rule__Class__StructuralFeaturesAssignment_5() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1813:1: ( ( ruleStructuralFeature ) )
            // InternalKM3.g:1814:2: ( ruleStructuralFeature )
            {
            // InternalKM3.g:1814:2: ( ruleStructuralFeature )
            // InternalKM3.g:1815:3: ruleStructuralFeature
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
    // InternalKM3.g:1824:1: rule__Attribute__IsUniqueAssignment_0 : ( ( 'unique' ) ) ;
    public final void rule__Attribute__IsUniqueAssignment_0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1828:1: ( ( ( 'unique' ) ) )
            // InternalKM3.g:1829:2: ( ( 'unique' ) )
            {
            // InternalKM3.g:1829:2: ( ( 'unique' ) )
            // InternalKM3.g:1830:3: ( 'unique' )
            {
             before(grammarAccess.getAttributeAccess().getIsUniqueUniqueKeyword_0_0()); 
            // InternalKM3.g:1831:3: ( 'unique' )
            // InternalKM3.g:1832:4: 'unique'
            {
             before(grammarAccess.getAttributeAccess().getIsUniqueUniqueKeyword_0_0()); 
            match(input,29,FOLLOW_2); 
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
    // InternalKM3.g:1843:1: rule__Attribute__NameAssignment_2 : ( RULE_ID ) ;
    public final void rule__Attribute__NameAssignment_2() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1847:1: ( ( RULE_ID ) )
            // InternalKM3.g:1848:2: ( RULE_ID )
            {
            // InternalKM3.g:1848:2: ( RULE_ID )
            // InternalKM3.g:1849:3: RULE_ID
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


    // $ANTLR start "rule__Attribute__LowerAssignment_3_1_0"
    // InternalKM3.g:1858:1: rule__Attribute__LowerAssignment_3_1_0 : ( ruleElementBound ) ;
    public final void rule__Attribute__LowerAssignment_3_1_0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1862:1: ( ( ruleElementBound ) )
            // InternalKM3.g:1863:2: ( ruleElementBound )
            {
            // InternalKM3.g:1863:2: ( ruleElementBound )
            // InternalKM3.g:1864:3: ruleElementBound
            {
             before(grammarAccess.getAttributeAccess().getLowerElementBoundParserRuleCall_3_1_0_0()); 
            pushFollow(FOLLOW_2);
            ruleElementBound();

            state._fsp--;

             after(grammarAccess.getAttributeAccess().getLowerElementBoundParserRuleCall_3_1_0_0()); 

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
    // $ANTLR end "rule__Attribute__LowerAssignment_3_1_0"


    // $ANTLR start "rule__Attribute__UpperAssignment_3_2"
    // InternalKM3.g:1873:1: rule__Attribute__UpperAssignment_3_2 : ( ruleElementBound ) ;
    public final void rule__Attribute__UpperAssignment_3_2() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1877:1: ( ( ruleElementBound ) )
            // InternalKM3.g:1878:2: ( ruleElementBound )
            {
            // InternalKM3.g:1878:2: ( ruleElementBound )
            // InternalKM3.g:1879:3: ruleElementBound
            {
             before(grammarAccess.getAttributeAccess().getUpperElementBoundParserRuleCall_3_2_0()); 
            pushFollow(FOLLOW_2);
            ruleElementBound();

            state._fsp--;

             after(grammarAccess.getAttributeAccess().getUpperElementBoundParserRuleCall_3_2_0()); 

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
    // $ANTLR end "rule__Attribute__UpperAssignment_3_2"


    // $ANTLR start "rule__Attribute__IsOrderedAssignment_4"
    // InternalKM3.g:1888:1: rule__Attribute__IsOrderedAssignment_4 : ( ( 'ordered' ) ) ;
    public final void rule__Attribute__IsOrderedAssignment_4() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1892:1: ( ( ( 'ordered' ) ) )
            // InternalKM3.g:1893:2: ( ( 'ordered' ) )
            {
            // InternalKM3.g:1893:2: ( ( 'ordered' ) )
            // InternalKM3.g:1894:3: ( 'ordered' )
            {
             before(grammarAccess.getAttributeAccess().getIsOrderedOrderedKeyword_4_0()); 
            // InternalKM3.g:1895:3: ( 'ordered' )
            // InternalKM3.g:1896:4: 'ordered'
            {
             before(grammarAccess.getAttributeAccess().getIsOrderedOrderedKeyword_4_0()); 
            match(input,30,FOLLOW_2); 
             after(grammarAccess.getAttributeAccess().getIsOrderedOrderedKeyword_4_0()); 

            }

             after(grammarAccess.getAttributeAccess().getIsOrderedOrderedKeyword_4_0()); 

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
    // $ANTLR end "rule__Attribute__IsOrderedAssignment_4"


    // $ANTLR start "rule__Attribute__TypeAssignment_6"
    // InternalKM3.g:1907:1: rule__Attribute__TypeAssignment_6 : ( ( RULE_ID ) ) ;
    public final void rule__Attribute__TypeAssignment_6() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1911:1: ( ( ( RULE_ID ) ) )
            // InternalKM3.g:1912:2: ( ( RULE_ID ) )
            {
            // InternalKM3.g:1912:2: ( ( RULE_ID ) )
            // InternalKM3.g:1913:3: ( RULE_ID )
            {
             before(grammarAccess.getAttributeAccess().getTypeClassifierCrossReference_6_0()); 
            // InternalKM3.g:1914:3: ( RULE_ID )
            // InternalKM3.g:1915:4: RULE_ID
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


    // $ANTLR start "rule__Reference__NameAssignment_1"
    // InternalKM3.g:1926:1: rule__Reference__NameAssignment_1 : ( RULE_ID ) ;
    public final void rule__Reference__NameAssignment_1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1930:1: ( ( RULE_ID ) )
            // InternalKM3.g:1931:2: ( RULE_ID )
            {
            // InternalKM3.g:1931:2: ( RULE_ID )
            // InternalKM3.g:1932:3: RULE_ID
            {
             before(grammarAccess.getReferenceAccess().getNameIDTerminalRuleCall_1_0()); 
            match(input,RULE_ID,FOLLOW_2); 
             after(grammarAccess.getReferenceAccess().getNameIDTerminalRuleCall_1_0()); 

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
    // $ANTLR end "rule__Reference__NameAssignment_1"


    // $ANTLR start "rule__Reference__LowerAssignment_2_1_0"
    // InternalKM3.g:1941:1: rule__Reference__LowerAssignment_2_1_0 : ( ruleElementBound ) ;
    public final void rule__Reference__LowerAssignment_2_1_0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1945:1: ( ( ruleElementBound ) )
            // InternalKM3.g:1946:2: ( ruleElementBound )
            {
            // InternalKM3.g:1946:2: ( ruleElementBound )
            // InternalKM3.g:1947:3: ruleElementBound
            {
             before(grammarAccess.getReferenceAccess().getLowerElementBoundParserRuleCall_2_1_0_0()); 
            pushFollow(FOLLOW_2);
            ruleElementBound();

            state._fsp--;

             after(grammarAccess.getReferenceAccess().getLowerElementBoundParserRuleCall_2_1_0_0()); 

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
    // $ANTLR end "rule__Reference__LowerAssignment_2_1_0"


    // $ANTLR start "rule__Reference__UpperAssignment_2_2"
    // InternalKM3.g:1956:1: rule__Reference__UpperAssignment_2_2 : ( ruleElementBound ) ;
    public final void rule__Reference__UpperAssignment_2_2() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1960:1: ( ( ruleElementBound ) )
            // InternalKM3.g:1961:2: ( ruleElementBound )
            {
            // InternalKM3.g:1961:2: ( ruleElementBound )
            // InternalKM3.g:1962:3: ruleElementBound
            {
             before(grammarAccess.getReferenceAccess().getUpperElementBoundParserRuleCall_2_2_0()); 
            pushFollow(FOLLOW_2);
            ruleElementBound();

            state._fsp--;

             after(grammarAccess.getReferenceAccess().getUpperElementBoundParserRuleCall_2_2_0()); 

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
    // $ANTLR end "rule__Reference__UpperAssignment_2_2"


    // $ANTLR start "rule__Reference__IsOrderedAssignment_3"
    // InternalKM3.g:1971:1: rule__Reference__IsOrderedAssignment_3 : ( ( 'ordered' ) ) ;
    public final void rule__Reference__IsOrderedAssignment_3() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1975:1: ( ( ( 'ordered' ) ) )
            // InternalKM3.g:1976:2: ( ( 'ordered' ) )
            {
            // InternalKM3.g:1976:2: ( ( 'ordered' ) )
            // InternalKM3.g:1977:3: ( 'ordered' )
            {
             before(grammarAccess.getReferenceAccess().getIsOrderedOrderedKeyword_3_0()); 
            // InternalKM3.g:1978:3: ( 'ordered' )
            // InternalKM3.g:1979:4: 'ordered'
            {
             before(grammarAccess.getReferenceAccess().getIsOrderedOrderedKeyword_3_0()); 
            match(input,30,FOLLOW_2); 
             after(grammarAccess.getReferenceAccess().getIsOrderedOrderedKeyword_3_0()); 

            }

             after(grammarAccess.getReferenceAccess().getIsOrderedOrderedKeyword_3_0()); 

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
    // $ANTLR end "rule__Reference__IsOrderedAssignment_3"


    // $ANTLR start "rule__Reference__IsContainerAssignment_4"
    // InternalKM3.g:1990:1: rule__Reference__IsContainerAssignment_4 : ( ( 'container' ) ) ;
    public final void rule__Reference__IsContainerAssignment_4() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1994:1: ( ( ( 'container' ) ) )
            // InternalKM3.g:1995:2: ( ( 'container' ) )
            {
            // InternalKM3.g:1995:2: ( ( 'container' ) )
            // InternalKM3.g:1996:3: ( 'container' )
            {
             before(grammarAccess.getReferenceAccess().getIsContainerContainerKeyword_4_0()); 
            // InternalKM3.g:1997:3: ( 'container' )
            // InternalKM3.g:1998:4: 'container'
            {
             before(grammarAccess.getReferenceAccess().getIsContainerContainerKeyword_4_0()); 
            match(input,31,FOLLOW_2); 
             after(grammarAccess.getReferenceAccess().getIsContainerContainerKeyword_4_0()); 

            }

             after(grammarAccess.getReferenceAccess().getIsContainerContainerKeyword_4_0()); 

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
    // $ANTLR end "rule__Reference__IsContainerAssignment_4"


    // $ANTLR start "rule__Reference__TypeAssignment_6"
    // InternalKM3.g:2009:1: rule__Reference__TypeAssignment_6 : ( ( RULE_ID ) ) ;
    public final void rule__Reference__TypeAssignment_6() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:2013:1: ( ( ( RULE_ID ) ) )
            // InternalKM3.g:2014:2: ( ( RULE_ID ) )
            {
            // InternalKM3.g:2014:2: ( ( RULE_ID ) )
            // InternalKM3.g:2015:3: ( RULE_ID )
            {
             before(grammarAccess.getReferenceAccess().getTypeClassifierCrossReference_6_0()); 
            // InternalKM3.g:2016:3: ( RULE_ID )
            // InternalKM3.g:2017:4: RULE_ID
            {
             before(grammarAccess.getReferenceAccess().getTypeClassifierIDTerminalRuleCall_6_0_1()); 
            match(input,RULE_ID,FOLLOW_2); 
             after(grammarAccess.getReferenceAccess().getTypeClassifierIDTerminalRuleCall_6_0_1()); 

            }

             after(grammarAccess.getReferenceAccess().getTypeClassifierCrossReference_6_0()); 

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
    // $ANTLR end "rule__Reference__TypeAssignment_6"


    // $ANTLR start "rule__Reference__OppositeAssignment_7_1"
    // InternalKM3.g:2028:1: rule__Reference__OppositeAssignment_7_1 : ( ( RULE_ID ) ) ;
    public final void rule__Reference__OppositeAssignment_7_1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:2032:1: ( ( ( RULE_ID ) ) )
            // InternalKM3.g:2033:2: ( ( RULE_ID ) )
            {
            // InternalKM3.g:2033:2: ( ( RULE_ID ) )
            // InternalKM3.g:2034:3: ( RULE_ID )
            {
             before(grammarAccess.getReferenceAccess().getOppositeReferenceCrossReference_7_1_0()); 
            // InternalKM3.g:2035:3: ( RULE_ID )
            // InternalKM3.g:2036:4: RULE_ID
            {
             before(grammarAccess.getReferenceAccess().getOppositeReferenceIDTerminalRuleCall_7_1_0_1()); 
            match(input,RULE_ID,FOLLOW_2); 
             after(grammarAccess.getReferenceAccess().getOppositeReferenceIDTerminalRuleCall_7_1_0_1()); 

            }

             after(grammarAccess.getReferenceAccess().getOppositeReferenceCrossReference_7_1_0()); 

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
    // $ANTLR end "rule__Reference__OppositeAssignment_7_1"

    // Delegated rules


 

    public static final BitSet FOLLOW_1 = new BitSet(new long[]{0x0000000000000000L});
    public static final BitSet FOLLOW_2 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_3 = new BitSet(new long[]{0x0000000000000020L});
    public static final BitSet FOLLOW_4 = new BitSet(new long[]{0x0000000000004000L});
    public static final BitSet FOLLOW_5 = new BitSet(new long[]{0x0000000010058000L});
    public static final BitSet FOLLOW_6 = new BitSet(new long[]{0x0000000010050002L});
    public static final BitSet FOLLOW_7 = new BitSet(new long[]{0x0000000000020000L});
    public static final BitSet FOLLOW_8 = new BitSet(new long[]{0x0000000010050000L});
    public static final BitSet FOLLOW_9 = new BitSet(new long[]{0x0000000000084000L});
    public static final BitSet FOLLOW_10 = new BitSet(new long[]{0x0000000024208000L});
    public static final BitSet FOLLOW_11 = new BitSet(new long[]{0x0000000024200002L});
    public static final BitSet FOLLOW_12 = new BitSet(new long[]{0x0000000000100000L});
    public static final BitSet FOLLOW_13 = new BitSet(new long[]{0x0000000000100002L});
    public static final BitSet FOLLOW_14 = new BitSet(new long[]{0x0000000020200000L});
    public static final BitSet FOLLOW_15 = new BitSet(new long[]{0x0000000040C00000L});
    public static final BitSet FOLLOW_16 = new BitSet(new long[]{0x0000000000001010L});
    public static final BitSet FOLLOW_17 = new BitSet(new long[]{0x0000000001000000L});
    public static final BitSet FOLLOW_18 = new BitSet(new long[]{0x0000000002000000L});
    public static final BitSet FOLLOW_19 = new BitSet(new long[]{0x00000000C0C00000L});
    public static final BitSet FOLLOW_20 = new BitSet(new long[]{0x0000000008020000L});

}