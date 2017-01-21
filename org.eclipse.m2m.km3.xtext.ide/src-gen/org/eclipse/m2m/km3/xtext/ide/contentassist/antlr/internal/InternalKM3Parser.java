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
        "<invalid>", "<EOR>", "<DOWN>", "<UP>", "RULE_ID", "RULE_COMMENT", "RULE_INT", "RULE_STRING", "RULE_ML_COMMENT", "RULE_SL_COMMENT", "RULE_WS", "RULE_ANY_OTHER", "'package'", "'{'", "'}'", "'datatype'", "';'", "'class'", "'extends'", "','", "'attribute'", "':'", "'reference'", "'['", "']'", "'oppositeOf'", "'abstract'", "'unique'", "'ordered'", "'container'"
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
    public static final int RULE_ID=4;
    public static final int RULE_WS=10;
    public static final int RULE_COMMENT=5;
    public static final int RULE_ANY_OTHER=11;
    public static final int T__26=26;
    public static final int T__27=27;
    public static final int T__28=28;
    public static final int RULE_INT=6;
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



    // $ANTLR start "entryRuleMetamodel"
    // InternalKM3.g:53:1: entryRuleMetamodel : ruleMetamodel EOF ;
    public final void entryRuleMetamodel() throws RecognitionException {
        try {
            // InternalKM3.g:54:1: ( ruleMetamodel EOF )
            // InternalKM3.g:55:1: ruleMetamodel EOF
            {
             before(grammarAccess.getMetamodelRule()); 
            pushFollow(FOLLOW_1);
            ruleMetamodel();

            state._fsp--;

             after(grammarAccess.getMetamodelRule()); 
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
    // $ANTLR end "entryRuleMetamodel"


    // $ANTLR start "ruleMetamodel"
    // InternalKM3.g:62:1: ruleMetamodel : ( ( rule__Metamodel__Group__0 ) ) ;
    public final void ruleMetamodel() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:66:2: ( ( ( rule__Metamodel__Group__0 ) ) )
            // InternalKM3.g:67:2: ( ( rule__Metamodel__Group__0 ) )
            {
            // InternalKM3.g:67:2: ( ( rule__Metamodel__Group__0 ) )
            // InternalKM3.g:68:3: ( rule__Metamodel__Group__0 )
            {
             before(grammarAccess.getMetamodelAccess().getGroup()); 
            // InternalKM3.g:69:3: ( rule__Metamodel__Group__0 )
            // InternalKM3.g:69:4: rule__Metamodel__Group__0
            {
            pushFollow(FOLLOW_2);
            rule__Metamodel__Group__0();

            state._fsp--;


            }

             after(grammarAccess.getMetamodelAccess().getGroup()); 

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
    // $ANTLR end "ruleMetamodel"


    // $ANTLR start "entryRulePackage"
    // InternalKM3.g:78:1: entryRulePackage : rulePackage EOF ;
    public final void entryRulePackage() throws RecognitionException {
        try {
            // InternalKM3.g:79:1: ( rulePackage EOF )
            // InternalKM3.g:80:1: rulePackage EOF
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
    // InternalKM3.g:87:1: rulePackage : ( ( rule__Package__Group__0 ) ) ;
    public final void rulePackage() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:91:2: ( ( ( rule__Package__Group__0 ) ) )
            // InternalKM3.g:92:2: ( ( rule__Package__Group__0 ) )
            {
            // InternalKM3.g:92:2: ( ( rule__Package__Group__0 ) )
            // InternalKM3.g:93:3: ( rule__Package__Group__0 )
            {
             before(grammarAccess.getPackageAccess().getGroup()); 
            // InternalKM3.g:94:3: ( rule__Package__Group__0 )
            // InternalKM3.g:94:4: rule__Package__Group__0
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
    // InternalKM3.g:103:1: entryRuleModelElement : ruleModelElement EOF ;
    public final void entryRuleModelElement() throws RecognitionException {
        try {
            // InternalKM3.g:104:1: ( ruleModelElement EOF )
            // InternalKM3.g:105:1: ruleModelElement EOF
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
    // InternalKM3.g:112:1: ruleModelElement : ( ( rule__ModelElement__Alternatives ) ) ;
    public final void ruleModelElement() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:116:2: ( ( ( rule__ModelElement__Alternatives ) ) )
            // InternalKM3.g:117:2: ( ( rule__ModelElement__Alternatives ) )
            {
            // InternalKM3.g:117:2: ( ( rule__ModelElement__Alternatives ) )
            // InternalKM3.g:118:3: ( rule__ModelElement__Alternatives )
            {
             before(grammarAccess.getModelElementAccess().getAlternatives()); 
            // InternalKM3.g:119:3: ( rule__ModelElement__Alternatives )
            // InternalKM3.g:119:4: rule__ModelElement__Alternatives
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
    // InternalKM3.g:128:1: entryRuleDataType : ruleDataType EOF ;
    public final void entryRuleDataType() throws RecognitionException {
        try {
            // InternalKM3.g:129:1: ( ruleDataType EOF )
            // InternalKM3.g:130:1: ruleDataType EOF
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
    // InternalKM3.g:137:1: ruleDataType : ( ( rule__DataType__Group__0 ) ) ;
    public final void ruleDataType() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:141:2: ( ( ( rule__DataType__Group__0 ) ) )
            // InternalKM3.g:142:2: ( ( rule__DataType__Group__0 ) )
            {
            // InternalKM3.g:142:2: ( ( rule__DataType__Group__0 ) )
            // InternalKM3.g:143:3: ( rule__DataType__Group__0 )
            {
             before(grammarAccess.getDataTypeAccess().getGroup()); 
            // InternalKM3.g:144:3: ( rule__DataType__Group__0 )
            // InternalKM3.g:144:4: rule__DataType__Group__0
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
    // InternalKM3.g:162:1: ruleStructuralFeature : ( ( rule__StructuralFeature__Alternatives ) ) ;
    public final void ruleStructuralFeature() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:166:2: ( ( ( rule__StructuralFeature__Alternatives ) ) )
            // InternalKM3.g:167:2: ( ( rule__StructuralFeature__Alternatives ) )
            {
            // InternalKM3.g:167:2: ( ( rule__StructuralFeature__Alternatives ) )
            // InternalKM3.g:168:3: ( rule__StructuralFeature__Alternatives )
            {
             before(grammarAccess.getStructuralFeatureAccess().getAlternatives()); 
            // InternalKM3.g:169:3: ( rule__StructuralFeature__Alternatives )
            // InternalKM3.g:169:4: rule__StructuralFeature__Alternatives
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
    // InternalKM3.g:178:1: entryRuleClass : ruleClass EOF ;
    public final void entryRuleClass() throws RecognitionException {
        try {
            // InternalKM3.g:179:1: ( ruleClass EOF )
            // InternalKM3.g:180:1: ruleClass EOF
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
    // InternalKM3.g:187:1: ruleClass : ( ( rule__Class__Group__0 ) ) ;
    public final void ruleClass() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:191:2: ( ( ( rule__Class__Group__0 ) ) )
            // InternalKM3.g:192:2: ( ( rule__Class__Group__0 ) )
            {
            // InternalKM3.g:192:2: ( ( rule__Class__Group__0 ) )
            // InternalKM3.g:193:3: ( rule__Class__Group__0 )
            {
             before(grammarAccess.getClassAccess().getGroup()); 
            // InternalKM3.g:194:3: ( rule__Class__Group__0 )
            // InternalKM3.g:194:4: rule__Class__Group__0
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
    // InternalKM3.g:203:1: entryRuleAttribute : ruleAttribute EOF ;
    public final void entryRuleAttribute() throws RecognitionException {
        try {
            // InternalKM3.g:204:1: ( ruleAttribute EOF )
            // InternalKM3.g:205:1: ruleAttribute EOF
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
    // InternalKM3.g:212:1: ruleAttribute : ( ( rule__Attribute__Group__0 ) ) ;
    public final void ruleAttribute() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:216:2: ( ( ( rule__Attribute__Group__0 ) ) )
            // InternalKM3.g:217:2: ( ( rule__Attribute__Group__0 ) )
            {
            // InternalKM3.g:217:2: ( ( rule__Attribute__Group__0 ) )
            // InternalKM3.g:218:3: ( rule__Attribute__Group__0 )
            {
             before(grammarAccess.getAttributeAccess().getGroup()); 
            // InternalKM3.g:219:3: ( rule__Attribute__Group__0 )
            // InternalKM3.g:219:4: rule__Attribute__Group__0
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
    // InternalKM3.g:228:1: entryRuleReference : ruleReference EOF ;
    public final void entryRuleReference() throws RecognitionException {
        try {
            // InternalKM3.g:229:1: ( ruleReference EOF )
            // InternalKM3.g:230:1: ruleReference EOF
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
    // InternalKM3.g:237:1: ruleReference : ( ( rule__Reference__Group__0 ) ) ;
    public final void ruleReference() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:241:2: ( ( ( rule__Reference__Group__0 ) ) )
            // InternalKM3.g:242:2: ( ( rule__Reference__Group__0 ) )
            {
            // InternalKM3.g:242:2: ( ( rule__Reference__Group__0 ) )
            // InternalKM3.g:243:3: ( rule__Reference__Group__0 )
            {
             before(grammarAccess.getReferenceAccess().getGroup()); 
            // InternalKM3.g:244:3: ( rule__Reference__Group__0 )
            // InternalKM3.g:244:4: rule__Reference__Group__0
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


    // $ANTLR start "rule__ModelElement__Alternatives"
    // InternalKM3.g:252:1: rule__ModelElement__Alternatives : ( ( ruleDataType ) | ( ruleClass ) );
    public final void rule__ModelElement__Alternatives() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:256:1: ( ( ruleDataType ) | ( ruleClass ) )
            int alt1=2;
            int LA1_0 = input.LA(1);

            if ( (LA1_0==15) ) {
                alt1=1;
            }
            else if ( (LA1_0==17||LA1_0==26) ) {
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

            if ( (LA2_0==20||LA2_0==27) ) {
                alt2=1;
            }
            else if ( (LA2_0==22) ) {
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


    // $ANTLR start "rule__Metamodel__Group__0"
    // InternalKM3.g:294:1: rule__Metamodel__Group__0 : rule__Metamodel__Group__0__Impl rule__Metamodel__Group__1 ;
    public final void rule__Metamodel__Group__0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:298:1: ( rule__Metamodel__Group__0__Impl rule__Metamodel__Group__1 )
            // InternalKM3.g:299:2: rule__Metamodel__Group__0__Impl rule__Metamodel__Group__1
            {
            pushFollow(FOLLOW_3);
            rule__Metamodel__Group__0__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__Metamodel__Group__1();

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
    // $ANTLR end "rule__Metamodel__Group__0"


    // $ANTLR start "rule__Metamodel__Group__0__Impl"
    // InternalKM3.g:306:1: rule__Metamodel__Group__0__Impl : ( () ) ;
    public final void rule__Metamodel__Group__0__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:310:1: ( ( () ) )
            // InternalKM3.g:311:1: ( () )
            {
            // InternalKM3.g:311:1: ( () )
            // InternalKM3.g:312:2: ()
            {
             before(grammarAccess.getMetamodelAccess().getMetamodelAction_0()); 
            // InternalKM3.g:313:2: ()
            // InternalKM3.g:313:3: 
            {
            }

             after(grammarAccess.getMetamodelAccess().getMetamodelAction_0()); 

            }


            }

        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__Metamodel__Group__0__Impl"


    // $ANTLR start "rule__Metamodel__Group__1"
    // InternalKM3.g:321:1: rule__Metamodel__Group__1 : rule__Metamodel__Group__1__Impl ;
    public final void rule__Metamodel__Group__1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:325:1: ( rule__Metamodel__Group__1__Impl )
            // InternalKM3.g:326:2: rule__Metamodel__Group__1__Impl
            {
            pushFollow(FOLLOW_2);
            rule__Metamodel__Group__1__Impl();

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
    // $ANTLR end "rule__Metamodel__Group__1"


    // $ANTLR start "rule__Metamodel__Group__1__Impl"
    // InternalKM3.g:332:1: rule__Metamodel__Group__1__Impl : ( ( rule__Metamodel__ContentsAssignment_1 )* ) ;
    public final void rule__Metamodel__Group__1__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:336:1: ( ( ( rule__Metamodel__ContentsAssignment_1 )* ) )
            // InternalKM3.g:337:1: ( ( rule__Metamodel__ContentsAssignment_1 )* )
            {
            // InternalKM3.g:337:1: ( ( rule__Metamodel__ContentsAssignment_1 )* )
            // InternalKM3.g:338:2: ( rule__Metamodel__ContentsAssignment_1 )*
            {
             before(grammarAccess.getMetamodelAccess().getContentsAssignment_1()); 
            // InternalKM3.g:339:2: ( rule__Metamodel__ContentsAssignment_1 )*
            loop3:
            do {
                int alt3=2;
                int LA3_0 = input.LA(1);

                if ( (LA3_0==12) ) {
                    alt3=1;
                }


                switch (alt3) {
            	case 1 :
            	    // InternalKM3.g:339:3: rule__Metamodel__ContentsAssignment_1
            	    {
            	    pushFollow(FOLLOW_4);
            	    rule__Metamodel__ContentsAssignment_1();

            	    state._fsp--;


            	    }
            	    break;

            	default :
            	    break loop3;
                }
            } while (true);

             after(grammarAccess.getMetamodelAccess().getContentsAssignment_1()); 

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
    // $ANTLR end "rule__Metamodel__Group__1__Impl"


    // $ANTLR start "rule__Package__Group__0"
    // InternalKM3.g:348:1: rule__Package__Group__0 : rule__Package__Group__0__Impl rule__Package__Group__1 ;
    public final void rule__Package__Group__0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:352:1: ( rule__Package__Group__0__Impl rule__Package__Group__1 )
            // InternalKM3.g:353:2: rule__Package__Group__0__Impl rule__Package__Group__1
            {
            pushFollow(FOLLOW_5);
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
    // InternalKM3.g:360:1: rule__Package__Group__0__Impl : ( 'package' ) ;
    public final void rule__Package__Group__0__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:364:1: ( ( 'package' ) )
            // InternalKM3.g:365:1: ( 'package' )
            {
            // InternalKM3.g:365:1: ( 'package' )
            // InternalKM3.g:366:2: 'package'
            {
             before(grammarAccess.getPackageAccess().getPackageKeyword_0()); 
            match(input,12,FOLLOW_2); 
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
    // InternalKM3.g:375:1: rule__Package__Group__1 : rule__Package__Group__1__Impl rule__Package__Group__2 ;
    public final void rule__Package__Group__1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:379:1: ( rule__Package__Group__1__Impl rule__Package__Group__2 )
            // InternalKM3.g:380:2: rule__Package__Group__1__Impl rule__Package__Group__2
            {
            pushFollow(FOLLOW_6);
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
    // InternalKM3.g:387:1: rule__Package__Group__1__Impl : ( ( rule__Package__NameAssignment_1 ) ) ;
    public final void rule__Package__Group__1__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:391:1: ( ( ( rule__Package__NameAssignment_1 ) ) )
            // InternalKM3.g:392:1: ( ( rule__Package__NameAssignment_1 ) )
            {
            // InternalKM3.g:392:1: ( ( rule__Package__NameAssignment_1 ) )
            // InternalKM3.g:393:2: ( rule__Package__NameAssignment_1 )
            {
             before(grammarAccess.getPackageAccess().getNameAssignment_1()); 
            // InternalKM3.g:394:2: ( rule__Package__NameAssignment_1 )
            // InternalKM3.g:394:3: rule__Package__NameAssignment_1
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
    // InternalKM3.g:402:1: rule__Package__Group__2 : rule__Package__Group__2__Impl rule__Package__Group__3 ;
    public final void rule__Package__Group__2() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:406:1: ( rule__Package__Group__2__Impl rule__Package__Group__3 )
            // InternalKM3.g:407:2: rule__Package__Group__2__Impl rule__Package__Group__3
            {
            pushFollow(FOLLOW_7);
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
    // InternalKM3.g:414:1: rule__Package__Group__2__Impl : ( '{' ) ;
    public final void rule__Package__Group__2__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:418:1: ( ( '{' ) )
            // InternalKM3.g:419:1: ( '{' )
            {
            // InternalKM3.g:419:1: ( '{' )
            // InternalKM3.g:420:2: '{'
            {
             before(grammarAccess.getPackageAccess().getLeftCurlyBracketKeyword_2()); 
            match(input,13,FOLLOW_2); 
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
    // InternalKM3.g:429:1: rule__Package__Group__3 : rule__Package__Group__3__Impl rule__Package__Group__4 ;
    public final void rule__Package__Group__3() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:433:1: ( rule__Package__Group__3__Impl rule__Package__Group__4 )
            // InternalKM3.g:434:2: rule__Package__Group__3__Impl rule__Package__Group__4
            {
            pushFollow(FOLLOW_7);
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
    // InternalKM3.g:441:1: rule__Package__Group__3__Impl : ( ( rule__Package__ContentsAssignment_3 )* ) ;
    public final void rule__Package__Group__3__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:445:1: ( ( ( rule__Package__ContentsAssignment_3 )* ) )
            // InternalKM3.g:446:1: ( ( rule__Package__ContentsAssignment_3 )* )
            {
            // InternalKM3.g:446:1: ( ( rule__Package__ContentsAssignment_3 )* )
            // InternalKM3.g:447:2: ( rule__Package__ContentsAssignment_3 )*
            {
             before(grammarAccess.getPackageAccess().getContentsAssignment_3()); 
            // InternalKM3.g:448:2: ( rule__Package__ContentsAssignment_3 )*
            loop4:
            do {
                int alt4=2;
                int LA4_0 = input.LA(1);

                if ( (LA4_0==15||LA4_0==17||LA4_0==26) ) {
                    alt4=1;
                }


                switch (alt4) {
            	case 1 :
            	    // InternalKM3.g:448:3: rule__Package__ContentsAssignment_3
            	    {
            	    pushFollow(FOLLOW_8);
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
    // InternalKM3.g:456:1: rule__Package__Group__4 : rule__Package__Group__4__Impl ;
    public final void rule__Package__Group__4() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:460:1: ( rule__Package__Group__4__Impl )
            // InternalKM3.g:461:2: rule__Package__Group__4__Impl
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
    // InternalKM3.g:467:1: rule__Package__Group__4__Impl : ( '}' ) ;
    public final void rule__Package__Group__4__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:471:1: ( ( '}' ) )
            // InternalKM3.g:472:1: ( '}' )
            {
            // InternalKM3.g:472:1: ( '}' )
            // InternalKM3.g:473:2: '}'
            {
             before(grammarAccess.getPackageAccess().getRightCurlyBracketKeyword_4()); 
            match(input,14,FOLLOW_2); 
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
    // InternalKM3.g:483:1: rule__DataType__Group__0 : rule__DataType__Group__0__Impl rule__DataType__Group__1 ;
    public final void rule__DataType__Group__0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:487:1: ( rule__DataType__Group__0__Impl rule__DataType__Group__1 )
            // InternalKM3.g:488:2: rule__DataType__Group__0__Impl rule__DataType__Group__1
            {
            pushFollow(FOLLOW_5);
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
    // InternalKM3.g:495:1: rule__DataType__Group__0__Impl : ( 'datatype' ) ;
    public final void rule__DataType__Group__0__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:499:1: ( ( 'datatype' ) )
            // InternalKM3.g:500:1: ( 'datatype' )
            {
            // InternalKM3.g:500:1: ( 'datatype' )
            // InternalKM3.g:501:2: 'datatype'
            {
             before(grammarAccess.getDataTypeAccess().getDatatypeKeyword_0()); 
            match(input,15,FOLLOW_2); 
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
    // InternalKM3.g:510:1: rule__DataType__Group__1 : rule__DataType__Group__1__Impl rule__DataType__Group__2 ;
    public final void rule__DataType__Group__1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:514:1: ( rule__DataType__Group__1__Impl rule__DataType__Group__2 )
            // InternalKM3.g:515:2: rule__DataType__Group__1__Impl rule__DataType__Group__2
            {
            pushFollow(FOLLOW_9);
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
    // InternalKM3.g:522:1: rule__DataType__Group__1__Impl : ( ( rule__DataType__NameAssignment_1 ) ) ;
    public final void rule__DataType__Group__1__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:526:1: ( ( ( rule__DataType__NameAssignment_1 ) ) )
            // InternalKM3.g:527:1: ( ( rule__DataType__NameAssignment_1 ) )
            {
            // InternalKM3.g:527:1: ( ( rule__DataType__NameAssignment_1 ) )
            // InternalKM3.g:528:2: ( rule__DataType__NameAssignment_1 )
            {
             before(grammarAccess.getDataTypeAccess().getNameAssignment_1()); 
            // InternalKM3.g:529:2: ( rule__DataType__NameAssignment_1 )
            // InternalKM3.g:529:3: rule__DataType__NameAssignment_1
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
    // InternalKM3.g:537:1: rule__DataType__Group__2 : rule__DataType__Group__2__Impl ;
    public final void rule__DataType__Group__2() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:541:1: ( rule__DataType__Group__2__Impl )
            // InternalKM3.g:542:2: rule__DataType__Group__2__Impl
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
    // InternalKM3.g:548:1: rule__DataType__Group__2__Impl : ( ';' ) ;
    public final void rule__DataType__Group__2__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:552:1: ( ( ';' ) )
            // InternalKM3.g:553:1: ( ';' )
            {
            // InternalKM3.g:553:1: ( ';' )
            // InternalKM3.g:554:2: ';'
            {
             before(grammarAccess.getDataTypeAccess().getSemicolonKeyword_2()); 
            match(input,16,FOLLOW_2); 
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
    // InternalKM3.g:564:1: rule__Class__Group__0 : rule__Class__Group__0__Impl rule__Class__Group__1 ;
    public final void rule__Class__Group__0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:568:1: ( rule__Class__Group__0__Impl rule__Class__Group__1 )
            // InternalKM3.g:569:2: rule__Class__Group__0__Impl rule__Class__Group__1
            {
            pushFollow(FOLLOW_10);
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
    // InternalKM3.g:576:1: rule__Class__Group__0__Impl : ( ( rule__Class__IsAbstractAssignment_0 )? ) ;
    public final void rule__Class__Group__0__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:580:1: ( ( ( rule__Class__IsAbstractAssignment_0 )? ) )
            // InternalKM3.g:581:1: ( ( rule__Class__IsAbstractAssignment_0 )? )
            {
            // InternalKM3.g:581:1: ( ( rule__Class__IsAbstractAssignment_0 )? )
            // InternalKM3.g:582:2: ( rule__Class__IsAbstractAssignment_0 )?
            {
             before(grammarAccess.getClassAccess().getIsAbstractAssignment_0()); 
            // InternalKM3.g:583:2: ( rule__Class__IsAbstractAssignment_0 )?
            int alt5=2;
            int LA5_0 = input.LA(1);

            if ( (LA5_0==26) ) {
                alt5=1;
            }
            switch (alt5) {
                case 1 :
                    // InternalKM3.g:583:3: rule__Class__IsAbstractAssignment_0
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
    // InternalKM3.g:591:1: rule__Class__Group__1 : rule__Class__Group__1__Impl rule__Class__Group__2 ;
    public final void rule__Class__Group__1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:595:1: ( rule__Class__Group__1__Impl rule__Class__Group__2 )
            // InternalKM3.g:596:2: rule__Class__Group__1__Impl rule__Class__Group__2
            {
            pushFollow(FOLLOW_5);
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
    // InternalKM3.g:603:1: rule__Class__Group__1__Impl : ( 'class' ) ;
    public final void rule__Class__Group__1__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:607:1: ( ( 'class' ) )
            // InternalKM3.g:608:1: ( 'class' )
            {
            // InternalKM3.g:608:1: ( 'class' )
            // InternalKM3.g:609:2: 'class'
            {
             before(grammarAccess.getClassAccess().getClassKeyword_1()); 
            match(input,17,FOLLOW_2); 
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
    // InternalKM3.g:618:1: rule__Class__Group__2 : rule__Class__Group__2__Impl rule__Class__Group__3 ;
    public final void rule__Class__Group__2() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:622:1: ( rule__Class__Group__2__Impl rule__Class__Group__3 )
            // InternalKM3.g:623:2: rule__Class__Group__2__Impl rule__Class__Group__3
            {
            pushFollow(FOLLOW_11);
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
    // InternalKM3.g:630:1: rule__Class__Group__2__Impl : ( ( rule__Class__NameAssignment_2 ) ) ;
    public final void rule__Class__Group__2__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:634:1: ( ( ( rule__Class__NameAssignment_2 ) ) )
            // InternalKM3.g:635:1: ( ( rule__Class__NameAssignment_2 ) )
            {
            // InternalKM3.g:635:1: ( ( rule__Class__NameAssignment_2 ) )
            // InternalKM3.g:636:2: ( rule__Class__NameAssignment_2 )
            {
             before(grammarAccess.getClassAccess().getNameAssignment_2()); 
            // InternalKM3.g:637:2: ( rule__Class__NameAssignment_2 )
            // InternalKM3.g:637:3: rule__Class__NameAssignment_2
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
    // InternalKM3.g:645:1: rule__Class__Group__3 : rule__Class__Group__3__Impl rule__Class__Group__4 ;
    public final void rule__Class__Group__3() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:649:1: ( rule__Class__Group__3__Impl rule__Class__Group__4 )
            // InternalKM3.g:650:2: rule__Class__Group__3__Impl rule__Class__Group__4
            {
            pushFollow(FOLLOW_11);
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
    // InternalKM3.g:657:1: rule__Class__Group__3__Impl : ( ( rule__Class__Group_3__0 )? ) ;
    public final void rule__Class__Group__3__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:661:1: ( ( ( rule__Class__Group_3__0 )? ) )
            // InternalKM3.g:662:1: ( ( rule__Class__Group_3__0 )? )
            {
            // InternalKM3.g:662:1: ( ( rule__Class__Group_3__0 )? )
            // InternalKM3.g:663:2: ( rule__Class__Group_3__0 )?
            {
             before(grammarAccess.getClassAccess().getGroup_3()); 
            // InternalKM3.g:664:2: ( rule__Class__Group_3__0 )?
            int alt6=2;
            int LA6_0 = input.LA(1);

            if ( (LA6_0==18) ) {
                alt6=1;
            }
            switch (alt6) {
                case 1 :
                    // InternalKM3.g:664:3: rule__Class__Group_3__0
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
    // InternalKM3.g:672:1: rule__Class__Group__4 : rule__Class__Group__4__Impl rule__Class__Group__5 ;
    public final void rule__Class__Group__4() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:676:1: ( rule__Class__Group__4__Impl rule__Class__Group__5 )
            // InternalKM3.g:677:2: rule__Class__Group__4__Impl rule__Class__Group__5
            {
            pushFollow(FOLLOW_12);
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
    // InternalKM3.g:684:1: rule__Class__Group__4__Impl : ( '{' ) ;
    public final void rule__Class__Group__4__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:688:1: ( ( '{' ) )
            // InternalKM3.g:689:1: ( '{' )
            {
            // InternalKM3.g:689:1: ( '{' )
            // InternalKM3.g:690:2: '{'
            {
             before(grammarAccess.getClassAccess().getLeftCurlyBracketKeyword_4()); 
            match(input,13,FOLLOW_2); 
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
    // InternalKM3.g:699:1: rule__Class__Group__5 : rule__Class__Group__5__Impl rule__Class__Group__6 ;
    public final void rule__Class__Group__5() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:703:1: ( rule__Class__Group__5__Impl rule__Class__Group__6 )
            // InternalKM3.g:704:2: rule__Class__Group__5__Impl rule__Class__Group__6
            {
            pushFollow(FOLLOW_12);
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
    // InternalKM3.g:711:1: rule__Class__Group__5__Impl : ( ( rule__Class__StructuralFeaturesAssignment_5 )* ) ;
    public final void rule__Class__Group__5__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:715:1: ( ( ( rule__Class__StructuralFeaturesAssignment_5 )* ) )
            // InternalKM3.g:716:1: ( ( rule__Class__StructuralFeaturesAssignment_5 )* )
            {
            // InternalKM3.g:716:1: ( ( rule__Class__StructuralFeaturesAssignment_5 )* )
            // InternalKM3.g:717:2: ( rule__Class__StructuralFeaturesAssignment_5 )*
            {
             before(grammarAccess.getClassAccess().getStructuralFeaturesAssignment_5()); 
            // InternalKM3.g:718:2: ( rule__Class__StructuralFeaturesAssignment_5 )*
            loop7:
            do {
                int alt7=2;
                int LA7_0 = input.LA(1);

                if ( (LA7_0==20||LA7_0==22||LA7_0==27) ) {
                    alt7=1;
                }


                switch (alt7) {
            	case 1 :
            	    // InternalKM3.g:718:3: rule__Class__StructuralFeaturesAssignment_5
            	    {
            	    pushFollow(FOLLOW_13);
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
    // InternalKM3.g:726:1: rule__Class__Group__6 : rule__Class__Group__6__Impl ;
    public final void rule__Class__Group__6() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:730:1: ( rule__Class__Group__6__Impl )
            // InternalKM3.g:731:2: rule__Class__Group__6__Impl
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
    // InternalKM3.g:737:1: rule__Class__Group__6__Impl : ( '}' ) ;
    public final void rule__Class__Group__6__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:741:1: ( ( '}' ) )
            // InternalKM3.g:742:1: ( '}' )
            {
            // InternalKM3.g:742:1: ( '}' )
            // InternalKM3.g:743:2: '}'
            {
             before(grammarAccess.getClassAccess().getRightCurlyBracketKeyword_6()); 
            match(input,14,FOLLOW_2); 
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
    // InternalKM3.g:753:1: rule__Class__Group_3__0 : rule__Class__Group_3__0__Impl rule__Class__Group_3__1 ;
    public final void rule__Class__Group_3__0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:757:1: ( rule__Class__Group_3__0__Impl rule__Class__Group_3__1 )
            // InternalKM3.g:758:2: rule__Class__Group_3__0__Impl rule__Class__Group_3__1
            {
            pushFollow(FOLLOW_5);
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
    // InternalKM3.g:765:1: rule__Class__Group_3__0__Impl : ( 'extends' ) ;
    public final void rule__Class__Group_3__0__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:769:1: ( ( 'extends' ) )
            // InternalKM3.g:770:1: ( 'extends' )
            {
            // InternalKM3.g:770:1: ( 'extends' )
            // InternalKM3.g:771:2: 'extends'
            {
             before(grammarAccess.getClassAccess().getExtendsKeyword_3_0()); 
            match(input,18,FOLLOW_2); 
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
    // InternalKM3.g:780:1: rule__Class__Group_3__1 : rule__Class__Group_3__1__Impl rule__Class__Group_3__2 ;
    public final void rule__Class__Group_3__1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:784:1: ( rule__Class__Group_3__1__Impl rule__Class__Group_3__2 )
            // InternalKM3.g:785:2: rule__Class__Group_3__1__Impl rule__Class__Group_3__2
            {
            pushFollow(FOLLOW_14);
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
    // InternalKM3.g:792:1: rule__Class__Group_3__1__Impl : ( ( rule__Class__SupertypesAssignment_3_1 ) ) ;
    public final void rule__Class__Group_3__1__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:796:1: ( ( ( rule__Class__SupertypesAssignment_3_1 ) ) )
            // InternalKM3.g:797:1: ( ( rule__Class__SupertypesAssignment_3_1 ) )
            {
            // InternalKM3.g:797:1: ( ( rule__Class__SupertypesAssignment_3_1 ) )
            // InternalKM3.g:798:2: ( rule__Class__SupertypesAssignment_3_1 )
            {
             before(grammarAccess.getClassAccess().getSupertypesAssignment_3_1()); 
            // InternalKM3.g:799:2: ( rule__Class__SupertypesAssignment_3_1 )
            // InternalKM3.g:799:3: rule__Class__SupertypesAssignment_3_1
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
    // InternalKM3.g:807:1: rule__Class__Group_3__2 : rule__Class__Group_3__2__Impl ;
    public final void rule__Class__Group_3__2() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:811:1: ( rule__Class__Group_3__2__Impl )
            // InternalKM3.g:812:2: rule__Class__Group_3__2__Impl
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
    // InternalKM3.g:818:1: rule__Class__Group_3__2__Impl : ( ( rule__Class__Group_3_2__0 )* ) ;
    public final void rule__Class__Group_3__2__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:822:1: ( ( ( rule__Class__Group_3_2__0 )* ) )
            // InternalKM3.g:823:1: ( ( rule__Class__Group_3_2__0 )* )
            {
            // InternalKM3.g:823:1: ( ( rule__Class__Group_3_2__0 )* )
            // InternalKM3.g:824:2: ( rule__Class__Group_3_2__0 )*
            {
             before(grammarAccess.getClassAccess().getGroup_3_2()); 
            // InternalKM3.g:825:2: ( rule__Class__Group_3_2__0 )*
            loop8:
            do {
                int alt8=2;
                int LA8_0 = input.LA(1);

                if ( (LA8_0==19) ) {
                    alt8=1;
                }


                switch (alt8) {
            	case 1 :
            	    // InternalKM3.g:825:3: rule__Class__Group_3_2__0
            	    {
            	    pushFollow(FOLLOW_15);
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
    // InternalKM3.g:834:1: rule__Class__Group_3_2__0 : rule__Class__Group_3_2__0__Impl rule__Class__Group_3_2__1 ;
    public final void rule__Class__Group_3_2__0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:838:1: ( rule__Class__Group_3_2__0__Impl rule__Class__Group_3_2__1 )
            // InternalKM3.g:839:2: rule__Class__Group_3_2__0__Impl rule__Class__Group_3_2__1
            {
            pushFollow(FOLLOW_5);
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
    // InternalKM3.g:846:1: rule__Class__Group_3_2__0__Impl : ( ',' ) ;
    public final void rule__Class__Group_3_2__0__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:850:1: ( ( ',' ) )
            // InternalKM3.g:851:1: ( ',' )
            {
            // InternalKM3.g:851:1: ( ',' )
            // InternalKM3.g:852:2: ','
            {
             before(grammarAccess.getClassAccess().getCommaKeyword_3_2_0()); 
            match(input,19,FOLLOW_2); 
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
    // InternalKM3.g:861:1: rule__Class__Group_3_2__1 : rule__Class__Group_3_2__1__Impl ;
    public final void rule__Class__Group_3_2__1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:865:1: ( rule__Class__Group_3_2__1__Impl )
            // InternalKM3.g:866:2: rule__Class__Group_3_2__1__Impl
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
    // InternalKM3.g:872:1: rule__Class__Group_3_2__1__Impl : ( ( rule__Class__SupertypesAssignment_3_2_1 ) ) ;
    public final void rule__Class__Group_3_2__1__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:876:1: ( ( ( rule__Class__SupertypesAssignment_3_2_1 ) ) )
            // InternalKM3.g:877:1: ( ( rule__Class__SupertypesAssignment_3_2_1 ) )
            {
            // InternalKM3.g:877:1: ( ( rule__Class__SupertypesAssignment_3_2_1 ) )
            // InternalKM3.g:878:2: ( rule__Class__SupertypesAssignment_3_2_1 )
            {
             before(grammarAccess.getClassAccess().getSupertypesAssignment_3_2_1()); 
            // InternalKM3.g:879:2: ( rule__Class__SupertypesAssignment_3_2_1 )
            // InternalKM3.g:879:3: rule__Class__SupertypesAssignment_3_2_1
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
    // InternalKM3.g:888:1: rule__Attribute__Group__0 : rule__Attribute__Group__0__Impl rule__Attribute__Group__1 ;
    public final void rule__Attribute__Group__0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:892:1: ( rule__Attribute__Group__0__Impl rule__Attribute__Group__1 )
            // InternalKM3.g:893:2: rule__Attribute__Group__0__Impl rule__Attribute__Group__1
            {
            pushFollow(FOLLOW_16);
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
    // InternalKM3.g:900:1: rule__Attribute__Group__0__Impl : ( ( rule__Attribute__IsUniqueAssignment_0 )? ) ;
    public final void rule__Attribute__Group__0__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:904:1: ( ( ( rule__Attribute__IsUniqueAssignment_0 )? ) )
            // InternalKM3.g:905:1: ( ( rule__Attribute__IsUniqueAssignment_0 )? )
            {
            // InternalKM3.g:905:1: ( ( rule__Attribute__IsUniqueAssignment_0 )? )
            // InternalKM3.g:906:2: ( rule__Attribute__IsUniqueAssignment_0 )?
            {
             before(grammarAccess.getAttributeAccess().getIsUniqueAssignment_0()); 
            // InternalKM3.g:907:2: ( rule__Attribute__IsUniqueAssignment_0 )?
            int alt9=2;
            int LA9_0 = input.LA(1);

            if ( (LA9_0==27) ) {
                alt9=1;
            }
            switch (alt9) {
                case 1 :
                    // InternalKM3.g:907:3: rule__Attribute__IsUniqueAssignment_0
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
    // InternalKM3.g:915:1: rule__Attribute__Group__1 : rule__Attribute__Group__1__Impl rule__Attribute__Group__2 ;
    public final void rule__Attribute__Group__1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:919:1: ( rule__Attribute__Group__1__Impl rule__Attribute__Group__2 )
            // InternalKM3.g:920:2: rule__Attribute__Group__1__Impl rule__Attribute__Group__2
            {
            pushFollow(FOLLOW_5);
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
    // InternalKM3.g:927:1: rule__Attribute__Group__1__Impl : ( 'attribute' ) ;
    public final void rule__Attribute__Group__1__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:931:1: ( ( 'attribute' ) )
            // InternalKM3.g:932:1: ( 'attribute' )
            {
            // InternalKM3.g:932:1: ( 'attribute' )
            // InternalKM3.g:933:2: 'attribute'
            {
             before(grammarAccess.getAttributeAccess().getAttributeKeyword_1()); 
            match(input,20,FOLLOW_2); 
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
    // InternalKM3.g:942:1: rule__Attribute__Group__2 : rule__Attribute__Group__2__Impl rule__Attribute__Group__3 ;
    public final void rule__Attribute__Group__2() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:946:1: ( rule__Attribute__Group__2__Impl rule__Attribute__Group__3 )
            // InternalKM3.g:947:2: rule__Attribute__Group__2__Impl rule__Attribute__Group__3
            {
            pushFollow(FOLLOW_17);
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
    // InternalKM3.g:954:1: rule__Attribute__Group__2__Impl : ( ( rule__Attribute__NameAssignment_2 ) ) ;
    public final void rule__Attribute__Group__2__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:958:1: ( ( ( rule__Attribute__NameAssignment_2 ) ) )
            // InternalKM3.g:959:1: ( ( rule__Attribute__NameAssignment_2 ) )
            {
            // InternalKM3.g:959:1: ( ( rule__Attribute__NameAssignment_2 ) )
            // InternalKM3.g:960:2: ( rule__Attribute__NameAssignment_2 )
            {
             before(grammarAccess.getAttributeAccess().getNameAssignment_2()); 
            // InternalKM3.g:961:2: ( rule__Attribute__NameAssignment_2 )
            // InternalKM3.g:961:3: rule__Attribute__NameAssignment_2
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
    // InternalKM3.g:969:1: rule__Attribute__Group__3 : rule__Attribute__Group__3__Impl rule__Attribute__Group__4 ;
    public final void rule__Attribute__Group__3() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:973:1: ( rule__Attribute__Group__3__Impl rule__Attribute__Group__4 )
            // InternalKM3.g:974:2: rule__Attribute__Group__3__Impl rule__Attribute__Group__4
            {
            pushFollow(FOLLOW_17);
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
    // InternalKM3.g:981:1: rule__Attribute__Group__3__Impl : ( ( rule__Attribute__IsOrderedAssignment_3 )? ) ;
    public final void rule__Attribute__Group__3__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:985:1: ( ( ( rule__Attribute__IsOrderedAssignment_3 )? ) )
            // InternalKM3.g:986:1: ( ( rule__Attribute__IsOrderedAssignment_3 )? )
            {
            // InternalKM3.g:986:1: ( ( rule__Attribute__IsOrderedAssignment_3 )? )
            // InternalKM3.g:987:2: ( rule__Attribute__IsOrderedAssignment_3 )?
            {
             before(grammarAccess.getAttributeAccess().getIsOrderedAssignment_3()); 
            // InternalKM3.g:988:2: ( rule__Attribute__IsOrderedAssignment_3 )?
            int alt10=2;
            int LA10_0 = input.LA(1);

            if ( (LA10_0==28) ) {
                alt10=1;
            }
            switch (alt10) {
                case 1 :
                    // InternalKM3.g:988:3: rule__Attribute__IsOrderedAssignment_3
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
    // InternalKM3.g:996:1: rule__Attribute__Group__4 : rule__Attribute__Group__4__Impl rule__Attribute__Group__5 ;
    public final void rule__Attribute__Group__4() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1000:1: ( rule__Attribute__Group__4__Impl rule__Attribute__Group__5 )
            // InternalKM3.g:1001:2: rule__Attribute__Group__4__Impl rule__Attribute__Group__5
            {
            pushFollow(FOLLOW_5);
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
    // InternalKM3.g:1008:1: rule__Attribute__Group__4__Impl : ( ':' ) ;
    public final void rule__Attribute__Group__4__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1012:1: ( ( ':' ) )
            // InternalKM3.g:1013:1: ( ':' )
            {
            // InternalKM3.g:1013:1: ( ':' )
            // InternalKM3.g:1014:2: ':'
            {
             before(grammarAccess.getAttributeAccess().getColonKeyword_4()); 
            match(input,21,FOLLOW_2); 
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
    // InternalKM3.g:1023:1: rule__Attribute__Group__5 : rule__Attribute__Group__5__Impl rule__Attribute__Group__6 ;
    public final void rule__Attribute__Group__5() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1027:1: ( rule__Attribute__Group__5__Impl rule__Attribute__Group__6 )
            // InternalKM3.g:1028:2: rule__Attribute__Group__5__Impl rule__Attribute__Group__6
            {
            pushFollow(FOLLOW_9);
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
    // InternalKM3.g:1035:1: rule__Attribute__Group__5__Impl : ( ( rule__Attribute__TypeAssignment_5 ) ) ;
    public final void rule__Attribute__Group__5__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1039:1: ( ( ( rule__Attribute__TypeAssignment_5 ) ) )
            // InternalKM3.g:1040:1: ( ( rule__Attribute__TypeAssignment_5 ) )
            {
            // InternalKM3.g:1040:1: ( ( rule__Attribute__TypeAssignment_5 ) )
            // InternalKM3.g:1041:2: ( rule__Attribute__TypeAssignment_5 )
            {
             before(grammarAccess.getAttributeAccess().getTypeAssignment_5()); 
            // InternalKM3.g:1042:2: ( rule__Attribute__TypeAssignment_5 )
            // InternalKM3.g:1042:3: rule__Attribute__TypeAssignment_5
            {
            pushFollow(FOLLOW_2);
            rule__Attribute__TypeAssignment_5();

            state._fsp--;


            }

             after(grammarAccess.getAttributeAccess().getTypeAssignment_5()); 

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
    // InternalKM3.g:1050:1: rule__Attribute__Group__6 : rule__Attribute__Group__6__Impl ;
    public final void rule__Attribute__Group__6() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1054:1: ( rule__Attribute__Group__6__Impl )
            // InternalKM3.g:1055:2: rule__Attribute__Group__6__Impl
            {
            pushFollow(FOLLOW_2);
            rule__Attribute__Group__6__Impl();

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
    // InternalKM3.g:1061:1: rule__Attribute__Group__6__Impl : ( ';' ) ;
    public final void rule__Attribute__Group__6__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1065:1: ( ( ';' ) )
            // InternalKM3.g:1066:1: ( ';' )
            {
            // InternalKM3.g:1066:1: ( ';' )
            // InternalKM3.g:1067:2: ';'
            {
             before(grammarAccess.getAttributeAccess().getSemicolonKeyword_6()); 
            match(input,16,FOLLOW_2); 
             after(grammarAccess.getAttributeAccess().getSemicolonKeyword_6()); 

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


    // $ANTLR start "rule__Reference__Group__0"
    // InternalKM3.g:1077:1: rule__Reference__Group__0 : rule__Reference__Group__0__Impl rule__Reference__Group__1 ;
    public final void rule__Reference__Group__0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1081:1: ( rule__Reference__Group__0__Impl rule__Reference__Group__1 )
            // InternalKM3.g:1082:2: rule__Reference__Group__0__Impl rule__Reference__Group__1
            {
            pushFollow(FOLLOW_5);
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
    // InternalKM3.g:1089:1: rule__Reference__Group__0__Impl : ( 'reference' ) ;
    public final void rule__Reference__Group__0__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1093:1: ( ( 'reference' ) )
            // InternalKM3.g:1094:1: ( 'reference' )
            {
            // InternalKM3.g:1094:1: ( 'reference' )
            // InternalKM3.g:1095:2: 'reference'
            {
             before(grammarAccess.getReferenceAccess().getReferenceKeyword_0()); 
            match(input,22,FOLLOW_2); 
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
    // InternalKM3.g:1104:1: rule__Reference__Group__1 : rule__Reference__Group__1__Impl rule__Reference__Group__2 ;
    public final void rule__Reference__Group__1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1108:1: ( rule__Reference__Group__1__Impl rule__Reference__Group__2 )
            // InternalKM3.g:1109:2: rule__Reference__Group__1__Impl rule__Reference__Group__2
            {
            pushFollow(FOLLOW_18);
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
    // InternalKM3.g:1116:1: rule__Reference__Group__1__Impl : ( ( rule__Reference__NameAssignment_1 ) ) ;
    public final void rule__Reference__Group__1__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1120:1: ( ( ( rule__Reference__NameAssignment_1 ) ) )
            // InternalKM3.g:1121:1: ( ( rule__Reference__NameAssignment_1 ) )
            {
            // InternalKM3.g:1121:1: ( ( rule__Reference__NameAssignment_1 ) )
            // InternalKM3.g:1122:2: ( rule__Reference__NameAssignment_1 )
            {
             before(grammarAccess.getReferenceAccess().getNameAssignment_1()); 
            // InternalKM3.g:1123:2: ( rule__Reference__NameAssignment_1 )
            // InternalKM3.g:1123:3: rule__Reference__NameAssignment_1
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
    // InternalKM3.g:1131:1: rule__Reference__Group__2 : rule__Reference__Group__2__Impl rule__Reference__Group__3 ;
    public final void rule__Reference__Group__2() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1135:1: ( rule__Reference__Group__2__Impl rule__Reference__Group__3 )
            // InternalKM3.g:1136:2: rule__Reference__Group__2__Impl rule__Reference__Group__3
            {
            pushFollow(FOLLOW_18);
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
    // InternalKM3.g:1143:1: rule__Reference__Group__2__Impl : ( ( rule__Reference__Group_2__0 )? ) ;
    public final void rule__Reference__Group__2__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1147:1: ( ( ( rule__Reference__Group_2__0 )? ) )
            // InternalKM3.g:1148:1: ( ( rule__Reference__Group_2__0 )? )
            {
            // InternalKM3.g:1148:1: ( ( rule__Reference__Group_2__0 )? )
            // InternalKM3.g:1149:2: ( rule__Reference__Group_2__0 )?
            {
             before(grammarAccess.getReferenceAccess().getGroup_2()); 
            // InternalKM3.g:1150:2: ( rule__Reference__Group_2__0 )?
            int alt11=2;
            int LA11_0 = input.LA(1);

            if ( (LA11_0==23) ) {
                alt11=1;
            }
            switch (alt11) {
                case 1 :
                    // InternalKM3.g:1150:3: rule__Reference__Group_2__0
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
    // InternalKM3.g:1158:1: rule__Reference__Group__3 : rule__Reference__Group__3__Impl rule__Reference__Group__4 ;
    public final void rule__Reference__Group__3() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1162:1: ( rule__Reference__Group__3__Impl rule__Reference__Group__4 )
            // InternalKM3.g:1163:2: rule__Reference__Group__3__Impl rule__Reference__Group__4
            {
            pushFollow(FOLLOW_18);
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
    // InternalKM3.g:1170:1: rule__Reference__Group__3__Impl : ( ( rule__Reference__IsOrderedAssignment_3 )? ) ;
    public final void rule__Reference__Group__3__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1174:1: ( ( ( rule__Reference__IsOrderedAssignment_3 )? ) )
            // InternalKM3.g:1175:1: ( ( rule__Reference__IsOrderedAssignment_3 )? )
            {
            // InternalKM3.g:1175:1: ( ( rule__Reference__IsOrderedAssignment_3 )? )
            // InternalKM3.g:1176:2: ( rule__Reference__IsOrderedAssignment_3 )?
            {
             before(grammarAccess.getReferenceAccess().getIsOrderedAssignment_3()); 
            // InternalKM3.g:1177:2: ( rule__Reference__IsOrderedAssignment_3 )?
            int alt12=2;
            int LA12_0 = input.LA(1);

            if ( (LA12_0==28) ) {
                alt12=1;
            }
            switch (alt12) {
                case 1 :
                    // InternalKM3.g:1177:3: rule__Reference__IsOrderedAssignment_3
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
    // InternalKM3.g:1185:1: rule__Reference__Group__4 : rule__Reference__Group__4__Impl rule__Reference__Group__5 ;
    public final void rule__Reference__Group__4() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1189:1: ( rule__Reference__Group__4__Impl rule__Reference__Group__5 )
            // InternalKM3.g:1190:2: rule__Reference__Group__4__Impl rule__Reference__Group__5
            {
            pushFollow(FOLLOW_18);
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
    // InternalKM3.g:1197:1: rule__Reference__Group__4__Impl : ( ( rule__Reference__IsContainerAssignment_4 )? ) ;
    public final void rule__Reference__Group__4__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1201:1: ( ( ( rule__Reference__IsContainerAssignment_4 )? ) )
            // InternalKM3.g:1202:1: ( ( rule__Reference__IsContainerAssignment_4 )? )
            {
            // InternalKM3.g:1202:1: ( ( rule__Reference__IsContainerAssignment_4 )? )
            // InternalKM3.g:1203:2: ( rule__Reference__IsContainerAssignment_4 )?
            {
             before(grammarAccess.getReferenceAccess().getIsContainerAssignment_4()); 
            // InternalKM3.g:1204:2: ( rule__Reference__IsContainerAssignment_4 )?
            int alt13=2;
            int LA13_0 = input.LA(1);

            if ( (LA13_0==29) ) {
                alt13=1;
            }
            switch (alt13) {
                case 1 :
                    // InternalKM3.g:1204:3: rule__Reference__IsContainerAssignment_4
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
    // InternalKM3.g:1212:1: rule__Reference__Group__5 : rule__Reference__Group__5__Impl rule__Reference__Group__6 ;
    public final void rule__Reference__Group__5() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1216:1: ( rule__Reference__Group__5__Impl rule__Reference__Group__6 )
            // InternalKM3.g:1217:2: rule__Reference__Group__5__Impl rule__Reference__Group__6
            {
            pushFollow(FOLLOW_5);
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
    // InternalKM3.g:1224:1: rule__Reference__Group__5__Impl : ( ':' ) ;
    public final void rule__Reference__Group__5__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1228:1: ( ( ':' ) )
            // InternalKM3.g:1229:1: ( ':' )
            {
            // InternalKM3.g:1229:1: ( ':' )
            // InternalKM3.g:1230:2: ':'
            {
             before(grammarAccess.getReferenceAccess().getColonKeyword_5()); 
            match(input,21,FOLLOW_2); 
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
    // InternalKM3.g:1239:1: rule__Reference__Group__6 : rule__Reference__Group__6__Impl rule__Reference__Group__7 ;
    public final void rule__Reference__Group__6() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1243:1: ( rule__Reference__Group__6__Impl rule__Reference__Group__7 )
            // InternalKM3.g:1244:2: rule__Reference__Group__6__Impl rule__Reference__Group__7
            {
            pushFollow(FOLLOW_19);
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
    // InternalKM3.g:1251:1: rule__Reference__Group__6__Impl : ( ( rule__Reference__TypeAssignment_6 ) ) ;
    public final void rule__Reference__Group__6__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1255:1: ( ( ( rule__Reference__TypeAssignment_6 ) ) )
            // InternalKM3.g:1256:1: ( ( rule__Reference__TypeAssignment_6 ) )
            {
            // InternalKM3.g:1256:1: ( ( rule__Reference__TypeAssignment_6 ) )
            // InternalKM3.g:1257:2: ( rule__Reference__TypeAssignment_6 )
            {
             before(grammarAccess.getReferenceAccess().getTypeAssignment_6()); 
            // InternalKM3.g:1258:2: ( rule__Reference__TypeAssignment_6 )
            // InternalKM3.g:1258:3: rule__Reference__TypeAssignment_6
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
    // InternalKM3.g:1266:1: rule__Reference__Group__7 : rule__Reference__Group__7__Impl rule__Reference__Group__8 ;
    public final void rule__Reference__Group__7() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1270:1: ( rule__Reference__Group__7__Impl rule__Reference__Group__8 )
            // InternalKM3.g:1271:2: rule__Reference__Group__7__Impl rule__Reference__Group__8
            {
            pushFollow(FOLLOW_19);
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
    // InternalKM3.g:1278:1: rule__Reference__Group__7__Impl : ( ( rule__Reference__Group_7__0 )? ) ;
    public final void rule__Reference__Group__7__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1282:1: ( ( ( rule__Reference__Group_7__0 )? ) )
            // InternalKM3.g:1283:1: ( ( rule__Reference__Group_7__0 )? )
            {
            // InternalKM3.g:1283:1: ( ( rule__Reference__Group_7__0 )? )
            // InternalKM3.g:1284:2: ( rule__Reference__Group_7__0 )?
            {
             before(grammarAccess.getReferenceAccess().getGroup_7()); 
            // InternalKM3.g:1285:2: ( rule__Reference__Group_7__0 )?
            int alt14=2;
            int LA14_0 = input.LA(1);

            if ( (LA14_0==25) ) {
                alt14=1;
            }
            switch (alt14) {
                case 1 :
                    // InternalKM3.g:1285:3: rule__Reference__Group_7__0
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
    // InternalKM3.g:1293:1: rule__Reference__Group__8 : rule__Reference__Group__8__Impl ;
    public final void rule__Reference__Group__8() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1297:1: ( rule__Reference__Group__8__Impl )
            // InternalKM3.g:1298:2: rule__Reference__Group__8__Impl
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
    // InternalKM3.g:1304:1: rule__Reference__Group__8__Impl : ( ';' ) ;
    public final void rule__Reference__Group__8__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1308:1: ( ( ';' ) )
            // InternalKM3.g:1309:1: ( ';' )
            {
            // InternalKM3.g:1309:1: ( ';' )
            // InternalKM3.g:1310:2: ';'
            {
             before(grammarAccess.getReferenceAccess().getSemicolonKeyword_8()); 
            match(input,16,FOLLOW_2); 
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
    // InternalKM3.g:1320:1: rule__Reference__Group_2__0 : rule__Reference__Group_2__0__Impl rule__Reference__Group_2__1 ;
    public final void rule__Reference__Group_2__0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1324:1: ( rule__Reference__Group_2__0__Impl rule__Reference__Group_2__1 )
            // InternalKM3.g:1325:2: rule__Reference__Group_2__0__Impl rule__Reference__Group_2__1
            {
            pushFollow(FOLLOW_20);
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
    // InternalKM3.g:1332:1: rule__Reference__Group_2__0__Impl : ( '[' ) ;
    public final void rule__Reference__Group_2__0__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1336:1: ( ( '[' ) )
            // InternalKM3.g:1337:1: ( '[' )
            {
            // InternalKM3.g:1337:1: ( '[' )
            // InternalKM3.g:1338:2: '['
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
    // InternalKM3.g:1347:1: rule__Reference__Group_2__1 : rule__Reference__Group_2__1__Impl ;
    public final void rule__Reference__Group_2__1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1351:1: ( rule__Reference__Group_2__1__Impl )
            // InternalKM3.g:1352:2: rule__Reference__Group_2__1__Impl
            {
            pushFollow(FOLLOW_2);
            rule__Reference__Group_2__1__Impl();

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
    // InternalKM3.g:1358:1: rule__Reference__Group_2__1__Impl : ( ']' ) ;
    public final void rule__Reference__Group_2__1__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1362:1: ( ( ']' ) )
            // InternalKM3.g:1363:1: ( ']' )
            {
            // InternalKM3.g:1363:1: ( ']' )
            // InternalKM3.g:1364:2: ']'
            {
             before(grammarAccess.getReferenceAccess().getRightSquareBracketKeyword_2_1()); 
            match(input,24,FOLLOW_2); 
             after(grammarAccess.getReferenceAccess().getRightSquareBracketKeyword_2_1()); 

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


    // $ANTLR start "rule__Reference__Group_7__0"
    // InternalKM3.g:1374:1: rule__Reference__Group_7__0 : rule__Reference__Group_7__0__Impl rule__Reference__Group_7__1 ;
    public final void rule__Reference__Group_7__0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1378:1: ( rule__Reference__Group_7__0__Impl rule__Reference__Group_7__1 )
            // InternalKM3.g:1379:2: rule__Reference__Group_7__0__Impl rule__Reference__Group_7__1
            {
            pushFollow(FOLLOW_5);
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
    // InternalKM3.g:1386:1: rule__Reference__Group_7__0__Impl : ( 'oppositeOf' ) ;
    public final void rule__Reference__Group_7__0__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1390:1: ( ( 'oppositeOf' ) )
            // InternalKM3.g:1391:1: ( 'oppositeOf' )
            {
            // InternalKM3.g:1391:1: ( 'oppositeOf' )
            // InternalKM3.g:1392:2: 'oppositeOf'
            {
             before(grammarAccess.getReferenceAccess().getOppositeOfKeyword_7_0()); 
            match(input,25,FOLLOW_2); 
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
    // InternalKM3.g:1401:1: rule__Reference__Group_7__1 : rule__Reference__Group_7__1__Impl ;
    public final void rule__Reference__Group_7__1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1405:1: ( rule__Reference__Group_7__1__Impl )
            // InternalKM3.g:1406:2: rule__Reference__Group_7__1__Impl
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
    // InternalKM3.g:1412:1: rule__Reference__Group_7__1__Impl : ( ( rule__Reference__OppositeAssignment_7_1 ) ) ;
    public final void rule__Reference__Group_7__1__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1416:1: ( ( ( rule__Reference__OppositeAssignment_7_1 ) ) )
            // InternalKM3.g:1417:1: ( ( rule__Reference__OppositeAssignment_7_1 ) )
            {
            // InternalKM3.g:1417:1: ( ( rule__Reference__OppositeAssignment_7_1 ) )
            // InternalKM3.g:1418:2: ( rule__Reference__OppositeAssignment_7_1 )
            {
             before(grammarAccess.getReferenceAccess().getOppositeAssignment_7_1()); 
            // InternalKM3.g:1419:2: ( rule__Reference__OppositeAssignment_7_1 )
            // InternalKM3.g:1419:3: rule__Reference__OppositeAssignment_7_1
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


    // $ANTLR start "rule__Metamodel__ContentsAssignment_1"
    // InternalKM3.g:1428:1: rule__Metamodel__ContentsAssignment_1 : ( rulePackage ) ;
    public final void rule__Metamodel__ContentsAssignment_1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1432:1: ( ( rulePackage ) )
            // InternalKM3.g:1433:2: ( rulePackage )
            {
            // InternalKM3.g:1433:2: ( rulePackage )
            // InternalKM3.g:1434:3: rulePackage
            {
             before(grammarAccess.getMetamodelAccess().getContentsPackageParserRuleCall_1_0()); 
            pushFollow(FOLLOW_2);
            rulePackage();

            state._fsp--;

             after(grammarAccess.getMetamodelAccess().getContentsPackageParserRuleCall_1_0()); 

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
    // $ANTLR end "rule__Metamodel__ContentsAssignment_1"


    // $ANTLR start "rule__Package__NameAssignment_1"
    // InternalKM3.g:1443:1: rule__Package__NameAssignment_1 : ( RULE_ID ) ;
    public final void rule__Package__NameAssignment_1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1447:1: ( ( RULE_ID ) )
            // InternalKM3.g:1448:2: ( RULE_ID )
            {
            // InternalKM3.g:1448:2: ( RULE_ID )
            // InternalKM3.g:1449:3: RULE_ID
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
    // InternalKM3.g:1458:1: rule__Package__ContentsAssignment_3 : ( ruleModelElement ) ;
    public final void rule__Package__ContentsAssignment_3() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1462:1: ( ( ruleModelElement ) )
            // InternalKM3.g:1463:2: ( ruleModelElement )
            {
            // InternalKM3.g:1463:2: ( ruleModelElement )
            // InternalKM3.g:1464:3: ruleModelElement
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
    // InternalKM3.g:1473:1: rule__DataType__NameAssignment_1 : ( RULE_ID ) ;
    public final void rule__DataType__NameAssignment_1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1477:1: ( ( RULE_ID ) )
            // InternalKM3.g:1478:2: ( RULE_ID )
            {
            // InternalKM3.g:1478:2: ( RULE_ID )
            // InternalKM3.g:1479:3: RULE_ID
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
    // InternalKM3.g:1488:1: rule__Class__IsAbstractAssignment_0 : ( ( 'abstract' ) ) ;
    public final void rule__Class__IsAbstractAssignment_0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1492:1: ( ( ( 'abstract' ) ) )
            // InternalKM3.g:1493:2: ( ( 'abstract' ) )
            {
            // InternalKM3.g:1493:2: ( ( 'abstract' ) )
            // InternalKM3.g:1494:3: ( 'abstract' )
            {
             before(grammarAccess.getClassAccess().getIsAbstractAbstractKeyword_0_0()); 
            // InternalKM3.g:1495:3: ( 'abstract' )
            // InternalKM3.g:1496:4: 'abstract'
            {
             before(grammarAccess.getClassAccess().getIsAbstractAbstractKeyword_0_0()); 
            match(input,26,FOLLOW_2); 
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
    // InternalKM3.g:1507:1: rule__Class__NameAssignment_2 : ( RULE_ID ) ;
    public final void rule__Class__NameAssignment_2() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1511:1: ( ( RULE_ID ) )
            // InternalKM3.g:1512:2: ( RULE_ID )
            {
            // InternalKM3.g:1512:2: ( RULE_ID )
            // InternalKM3.g:1513:3: RULE_ID
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
    // InternalKM3.g:1522:1: rule__Class__SupertypesAssignment_3_1 : ( ( RULE_ID ) ) ;
    public final void rule__Class__SupertypesAssignment_3_1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1526:1: ( ( ( RULE_ID ) ) )
            // InternalKM3.g:1527:2: ( ( RULE_ID ) )
            {
            // InternalKM3.g:1527:2: ( ( RULE_ID ) )
            // InternalKM3.g:1528:3: ( RULE_ID )
            {
             before(grammarAccess.getClassAccess().getSupertypesClassCrossReference_3_1_0()); 
            // InternalKM3.g:1529:3: ( RULE_ID )
            // InternalKM3.g:1530:4: RULE_ID
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
    // InternalKM3.g:1541:1: rule__Class__SupertypesAssignment_3_2_1 : ( ( RULE_ID ) ) ;
    public final void rule__Class__SupertypesAssignment_3_2_1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1545:1: ( ( ( RULE_ID ) ) )
            // InternalKM3.g:1546:2: ( ( RULE_ID ) )
            {
            // InternalKM3.g:1546:2: ( ( RULE_ID ) )
            // InternalKM3.g:1547:3: ( RULE_ID )
            {
             before(grammarAccess.getClassAccess().getSupertypesClassCrossReference_3_2_1_0()); 
            // InternalKM3.g:1548:3: ( RULE_ID )
            // InternalKM3.g:1549:4: RULE_ID
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
    // InternalKM3.g:1560:1: rule__Class__StructuralFeaturesAssignment_5 : ( ruleStructuralFeature ) ;
    public final void rule__Class__StructuralFeaturesAssignment_5() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1564:1: ( ( ruleStructuralFeature ) )
            // InternalKM3.g:1565:2: ( ruleStructuralFeature )
            {
            // InternalKM3.g:1565:2: ( ruleStructuralFeature )
            // InternalKM3.g:1566:3: ruleStructuralFeature
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
    // InternalKM3.g:1575:1: rule__Attribute__IsUniqueAssignment_0 : ( ( 'unique' ) ) ;
    public final void rule__Attribute__IsUniqueAssignment_0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1579:1: ( ( ( 'unique' ) ) )
            // InternalKM3.g:1580:2: ( ( 'unique' ) )
            {
            // InternalKM3.g:1580:2: ( ( 'unique' ) )
            // InternalKM3.g:1581:3: ( 'unique' )
            {
             before(grammarAccess.getAttributeAccess().getIsUniqueUniqueKeyword_0_0()); 
            // InternalKM3.g:1582:3: ( 'unique' )
            // InternalKM3.g:1583:4: 'unique'
            {
             before(grammarAccess.getAttributeAccess().getIsUniqueUniqueKeyword_0_0()); 
            match(input,27,FOLLOW_2); 
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
    // InternalKM3.g:1594:1: rule__Attribute__NameAssignment_2 : ( RULE_ID ) ;
    public final void rule__Attribute__NameAssignment_2() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1598:1: ( ( RULE_ID ) )
            // InternalKM3.g:1599:2: ( RULE_ID )
            {
            // InternalKM3.g:1599:2: ( RULE_ID )
            // InternalKM3.g:1600:3: RULE_ID
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
    // InternalKM3.g:1609:1: rule__Attribute__IsOrderedAssignment_3 : ( ( 'ordered' ) ) ;
    public final void rule__Attribute__IsOrderedAssignment_3() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1613:1: ( ( ( 'ordered' ) ) )
            // InternalKM3.g:1614:2: ( ( 'ordered' ) )
            {
            // InternalKM3.g:1614:2: ( ( 'ordered' ) )
            // InternalKM3.g:1615:3: ( 'ordered' )
            {
             before(grammarAccess.getAttributeAccess().getIsOrderedOrderedKeyword_3_0()); 
            // InternalKM3.g:1616:3: ( 'ordered' )
            // InternalKM3.g:1617:4: 'ordered'
            {
             before(grammarAccess.getAttributeAccess().getIsOrderedOrderedKeyword_3_0()); 
            match(input,28,FOLLOW_2); 
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


    // $ANTLR start "rule__Attribute__TypeAssignment_5"
    // InternalKM3.g:1628:1: rule__Attribute__TypeAssignment_5 : ( ( RULE_ID ) ) ;
    public final void rule__Attribute__TypeAssignment_5() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1632:1: ( ( ( RULE_ID ) ) )
            // InternalKM3.g:1633:2: ( ( RULE_ID ) )
            {
            // InternalKM3.g:1633:2: ( ( RULE_ID ) )
            // InternalKM3.g:1634:3: ( RULE_ID )
            {
             before(grammarAccess.getAttributeAccess().getTypeClassifierCrossReference_5_0()); 
            // InternalKM3.g:1635:3: ( RULE_ID )
            // InternalKM3.g:1636:4: RULE_ID
            {
             before(grammarAccess.getAttributeAccess().getTypeClassifierIDTerminalRuleCall_5_0_1()); 
            match(input,RULE_ID,FOLLOW_2); 
             after(grammarAccess.getAttributeAccess().getTypeClassifierIDTerminalRuleCall_5_0_1()); 

            }

             after(grammarAccess.getAttributeAccess().getTypeClassifierCrossReference_5_0()); 

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
    // $ANTLR end "rule__Attribute__TypeAssignment_5"


    // $ANTLR start "rule__Reference__NameAssignment_1"
    // InternalKM3.g:1647:1: rule__Reference__NameAssignment_1 : ( RULE_ID ) ;
    public final void rule__Reference__NameAssignment_1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1651:1: ( ( RULE_ID ) )
            // InternalKM3.g:1652:2: ( RULE_ID )
            {
            // InternalKM3.g:1652:2: ( RULE_ID )
            // InternalKM3.g:1653:3: RULE_ID
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


    // $ANTLR start "rule__Reference__IsOrderedAssignment_3"
    // InternalKM3.g:1662:1: rule__Reference__IsOrderedAssignment_3 : ( ( 'ordered' ) ) ;
    public final void rule__Reference__IsOrderedAssignment_3() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1666:1: ( ( ( 'ordered' ) ) )
            // InternalKM3.g:1667:2: ( ( 'ordered' ) )
            {
            // InternalKM3.g:1667:2: ( ( 'ordered' ) )
            // InternalKM3.g:1668:3: ( 'ordered' )
            {
             before(grammarAccess.getReferenceAccess().getIsOrderedOrderedKeyword_3_0()); 
            // InternalKM3.g:1669:3: ( 'ordered' )
            // InternalKM3.g:1670:4: 'ordered'
            {
             before(grammarAccess.getReferenceAccess().getIsOrderedOrderedKeyword_3_0()); 
            match(input,28,FOLLOW_2); 
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
    // InternalKM3.g:1681:1: rule__Reference__IsContainerAssignment_4 : ( ( 'container' ) ) ;
    public final void rule__Reference__IsContainerAssignment_4() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1685:1: ( ( ( 'container' ) ) )
            // InternalKM3.g:1686:2: ( ( 'container' ) )
            {
            // InternalKM3.g:1686:2: ( ( 'container' ) )
            // InternalKM3.g:1687:3: ( 'container' )
            {
             before(grammarAccess.getReferenceAccess().getIsContainerContainerKeyword_4_0()); 
            // InternalKM3.g:1688:3: ( 'container' )
            // InternalKM3.g:1689:4: 'container'
            {
             before(grammarAccess.getReferenceAccess().getIsContainerContainerKeyword_4_0()); 
            match(input,29,FOLLOW_2); 
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
    // InternalKM3.g:1700:1: rule__Reference__TypeAssignment_6 : ( ( RULE_ID ) ) ;
    public final void rule__Reference__TypeAssignment_6() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1704:1: ( ( ( RULE_ID ) ) )
            // InternalKM3.g:1705:2: ( ( RULE_ID ) )
            {
            // InternalKM3.g:1705:2: ( ( RULE_ID ) )
            // InternalKM3.g:1706:3: ( RULE_ID )
            {
             before(grammarAccess.getReferenceAccess().getTypeClassifierCrossReference_6_0()); 
            // InternalKM3.g:1707:3: ( RULE_ID )
            // InternalKM3.g:1708:4: RULE_ID
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
    // InternalKM3.g:1719:1: rule__Reference__OppositeAssignment_7_1 : ( ( RULE_ID ) ) ;
    public final void rule__Reference__OppositeAssignment_7_1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1723:1: ( ( ( RULE_ID ) ) )
            // InternalKM3.g:1724:2: ( ( RULE_ID ) )
            {
            // InternalKM3.g:1724:2: ( ( RULE_ID ) )
            // InternalKM3.g:1725:3: ( RULE_ID )
            {
             before(grammarAccess.getReferenceAccess().getOppositeReferenceCrossReference_7_1_0()); 
            // InternalKM3.g:1726:3: ( RULE_ID )
            // InternalKM3.g:1727:4: RULE_ID
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
    public static final BitSet FOLLOW_3 = new BitSet(new long[]{0x0000000000001000L});
    public static final BitSet FOLLOW_4 = new BitSet(new long[]{0x0000000000001002L});
    public static final BitSet FOLLOW_5 = new BitSet(new long[]{0x0000000000000010L});
    public static final BitSet FOLLOW_6 = new BitSet(new long[]{0x0000000000002000L});
    public static final BitSet FOLLOW_7 = new BitSet(new long[]{0x000000000402C000L});
    public static final BitSet FOLLOW_8 = new BitSet(new long[]{0x0000000004028002L});
    public static final BitSet FOLLOW_9 = new BitSet(new long[]{0x0000000000010000L});
    public static final BitSet FOLLOW_10 = new BitSet(new long[]{0x0000000004028000L});
    public static final BitSet FOLLOW_11 = new BitSet(new long[]{0x0000000000042000L});
    public static final BitSet FOLLOW_12 = new BitSet(new long[]{0x0000000008504000L});
    public static final BitSet FOLLOW_13 = new BitSet(new long[]{0x0000000008500002L});
    public static final BitSet FOLLOW_14 = new BitSet(new long[]{0x0000000000080000L});
    public static final BitSet FOLLOW_15 = new BitSet(new long[]{0x0000000000080002L});
    public static final BitSet FOLLOW_16 = new BitSet(new long[]{0x0000000008100000L});
    public static final BitSet FOLLOW_17 = new BitSet(new long[]{0x0000000010200000L});
    public static final BitSet FOLLOW_18 = new BitSet(new long[]{0x0000000030A00000L});
    public static final BitSet FOLLOW_19 = new BitSet(new long[]{0x0000000002010000L});
    public static final BitSet FOLLOW_20 = new BitSet(new long[]{0x0000000001000000L});

}