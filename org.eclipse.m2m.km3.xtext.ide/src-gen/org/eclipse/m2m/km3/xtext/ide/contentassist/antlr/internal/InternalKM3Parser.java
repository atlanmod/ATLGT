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


    // $ANTLR start "entryRuleElementBound"
    // InternalKM3.g:253:1: entryRuleElementBound : ruleElementBound EOF ;
    public final void entryRuleElementBound() throws RecognitionException {
        try {
            // InternalKM3.g:254:1: ( ruleElementBound EOF )
            // InternalKM3.g:255:1: ruleElementBound EOF
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
    // InternalKM3.g:262:1: ruleElementBound : ( ( rule__ElementBound__Alternatives ) ) ;
    public final void ruleElementBound() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:266:2: ( ( ( rule__ElementBound__Alternatives ) ) )
            // InternalKM3.g:267:2: ( ( rule__ElementBound__Alternatives ) )
            {
            // InternalKM3.g:267:2: ( ( rule__ElementBound__Alternatives ) )
            // InternalKM3.g:268:3: ( rule__ElementBound__Alternatives )
            {
             before(grammarAccess.getElementBoundAccess().getAlternatives()); 
            // InternalKM3.g:269:3: ( rule__ElementBound__Alternatives )
            // InternalKM3.g:269:4: rule__ElementBound__Alternatives
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
    // InternalKM3.g:277:1: rule__ModelElement__Alternatives : ( ( ruleDataType ) | ( ruleClass ) );
    public final void rule__ModelElement__Alternatives() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:281:1: ( ( ruleDataType ) | ( ruleClass ) )
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
                    // InternalKM3.g:282:2: ( ruleDataType )
                    {
                    // InternalKM3.g:282:2: ( ruleDataType )
                    // InternalKM3.g:283:3: ruleDataType
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
                    // InternalKM3.g:288:2: ( ruleClass )
                    {
                    // InternalKM3.g:288:2: ( ruleClass )
                    // InternalKM3.g:289:3: ruleClass
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
    // InternalKM3.g:298:1: rule__StructuralFeature__Alternatives : ( ( ruleAttribute ) | ( ruleReference ) );
    public final void rule__StructuralFeature__Alternatives() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:302:1: ( ( ruleAttribute ) | ( ruleReference ) )
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
                    // InternalKM3.g:303:2: ( ruleAttribute )
                    {
                    // InternalKM3.g:303:2: ( ruleAttribute )
                    // InternalKM3.g:304:3: ruleAttribute
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
                    // InternalKM3.g:309:2: ( ruleReference )
                    {
                    // InternalKM3.g:309:2: ( ruleReference )
                    // InternalKM3.g:310:3: ruleReference
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
    // InternalKM3.g:319:1: rule__ElementBound__Alternatives : ( ( '*' ) | ( RULE_INT ) );
    public final void rule__ElementBound__Alternatives() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:323:1: ( ( '*' ) | ( RULE_INT ) )
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
                    // InternalKM3.g:324:2: ( '*' )
                    {
                    // InternalKM3.g:324:2: ( '*' )
                    // InternalKM3.g:325:3: '*'
                    {
                     before(grammarAccess.getElementBoundAccess().getAsteriskKeyword_0()); 
                    match(input,12,FOLLOW_2); 
                     after(grammarAccess.getElementBoundAccess().getAsteriskKeyword_0()); 

                    }


                    }
                    break;
                case 2 :
                    // InternalKM3.g:330:2: ( RULE_INT )
                    {
                    // InternalKM3.g:330:2: ( RULE_INT )
                    // InternalKM3.g:331:3: RULE_INT
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


    // $ANTLR start "rule__Metamodel__Group__0"
    // InternalKM3.g:340:1: rule__Metamodel__Group__0 : rule__Metamodel__Group__0__Impl rule__Metamodel__Group__1 ;
    public final void rule__Metamodel__Group__0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:344:1: ( rule__Metamodel__Group__0__Impl rule__Metamodel__Group__1 )
            // InternalKM3.g:345:2: rule__Metamodel__Group__0__Impl rule__Metamodel__Group__1
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
    // InternalKM3.g:352:1: rule__Metamodel__Group__0__Impl : ( () ) ;
    public final void rule__Metamodel__Group__0__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:356:1: ( ( () ) )
            // InternalKM3.g:357:1: ( () )
            {
            // InternalKM3.g:357:1: ( () )
            // InternalKM3.g:358:2: ()
            {
             before(grammarAccess.getMetamodelAccess().getMetamodelAction_0()); 
            // InternalKM3.g:359:2: ()
            // InternalKM3.g:359:3: 
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
    // InternalKM3.g:367:1: rule__Metamodel__Group__1 : rule__Metamodel__Group__1__Impl ;
    public final void rule__Metamodel__Group__1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:371:1: ( rule__Metamodel__Group__1__Impl )
            // InternalKM3.g:372:2: rule__Metamodel__Group__1__Impl
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
    // InternalKM3.g:378:1: rule__Metamodel__Group__1__Impl : ( ( rule__Metamodel__ContentsAssignment_1 )* ) ;
    public final void rule__Metamodel__Group__1__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:382:1: ( ( ( rule__Metamodel__ContentsAssignment_1 )* ) )
            // InternalKM3.g:383:1: ( ( rule__Metamodel__ContentsAssignment_1 )* )
            {
            // InternalKM3.g:383:1: ( ( rule__Metamodel__ContentsAssignment_1 )* )
            // InternalKM3.g:384:2: ( rule__Metamodel__ContentsAssignment_1 )*
            {
             before(grammarAccess.getMetamodelAccess().getContentsAssignment_1()); 
            // InternalKM3.g:385:2: ( rule__Metamodel__ContentsAssignment_1 )*
            loop4:
            do {
                int alt4=2;
                int LA4_0 = input.LA(1);

                if ( (LA4_0==13) ) {
                    alt4=1;
                }


                switch (alt4) {
            	case 1 :
            	    // InternalKM3.g:385:3: rule__Metamodel__ContentsAssignment_1
            	    {
            	    pushFollow(FOLLOW_4);
            	    rule__Metamodel__ContentsAssignment_1();

            	    state._fsp--;


            	    }
            	    break;

            	default :
            	    break loop4;
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
    // InternalKM3.g:394:1: rule__Package__Group__0 : rule__Package__Group__0__Impl rule__Package__Group__1 ;
    public final void rule__Package__Group__0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:398:1: ( rule__Package__Group__0__Impl rule__Package__Group__1 )
            // InternalKM3.g:399:2: rule__Package__Group__0__Impl rule__Package__Group__1
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
    // InternalKM3.g:406:1: rule__Package__Group__0__Impl : ( 'package' ) ;
    public final void rule__Package__Group__0__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:410:1: ( ( 'package' ) )
            // InternalKM3.g:411:1: ( 'package' )
            {
            // InternalKM3.g:411:1: ( 'package' )
            // InternalKM3.g:412:2: 'package'
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
    // InternalKM3.g:421:1: rule__Package__Group__1 : rule__Package__Group__1__Impl rule__Package__Group__2 ;
    public final void rule__Package__Group__1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:425:1: ( rule__Package__Group__1__Impl rule__Package__Group__2 )
            // InternalKM3.g:426:2: rule__Package__Group__1__Impl rule__Package__Group__2
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
    // InternalKM3.g:433:1: rule__Package__Group__1__Impl : ( ( rule__Package__NameAssignment_1 ) ) ;
    public final void rule__Package__Group__1__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:437:1: ( ( ( rule__Package__NameAssignment_1 ) ) )
            // InternalKM3.g:438:1: ( ( rule__Package__NameAssignment_1 ) )
            {
            // InternalKM3.g:438:1: ( ( rule__Package__NameAssignment_1 ) )
            // InternalKM3.g:439:2: ( rule__Package__NameAssignment_1 )
            {
             before(grammarAccess.getPackageAccess().getNameAssignment_1()); 
            // InternalKM3.g:440:2: ( rule__Package__NameAssignment_1 )
            // InternalKM3.g:440:3: rule__Package__NameAssignment_1
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
    // InternalKM3.g:448:1: rule__Package__Group__2 : rule__Package__Group__2__Impl rule__Package__Group__3 ;
    public final void rule__Package__Group__2() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:452:1: ( rule__Package__Group__2__Impl rule__Package__Group__3 )
            // InternalKM3.g:453:2: rule__Package__Group__2__Impl rule__Package__Group__3
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
    // InternalKM3.g:460:1: rule__Package__Group__2__Impl : ( '{' ) ;
    public final void rule__Package__Group__2__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:464:1: ( ( '{' ) )
            // InternalKM3.g:465:1: ( '{' )
            {
            // InternalKM3.g:465:1: ( '{' )
            // InternalKM3.g:466:2: '{'
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
    // InternalKM3.g:475:1: rule__Package__Group__3 : rule__Package__Group__3__Impl rule__Package__Group__4 ;
    public final void rule__Package__Group__3() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:479:1: ( rule__Package__Group__3__Impl rule__Package__Group__4 )
            // InternalKM3.g:480:2: rule__Package__Group__3__Impl rule__Package__Group__4
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
    // InternalKM3.g:487:1: rule__Package__Group__3__Impl : ( ( rule__Package__ContentsAssignment_3 )* ) ;
    public final void rule__Package__Group__3__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:491:1: ( ( ( rule__Package__ContentsAssignment_3 )* ) )
            // InternalKM3.g:492:1: ( ( rule__Package__ContentsAssignment_3 )* )
            {
            // InternalKM3.g:492:1: ( ( rule__Package__ContentsAssignment_3 )* )
            // InternalKM3.g:493:2: ( rule__Package__ContentsAssignment_3 )*
            {
             before(grammarAccess.getPackageAccess().getContentsAssignment_3()); 
            // InternalKM3.g:494:2: ( rule__Package__ContentsAssignment_3 )*
            loop5:
            do {
                int alt5=2;
                int LA5_0 = input.LA(1);

                if ( (LA5_0==16||LA5_0==18||LA5_0==28) ) {
                    alt5=1;
                }


                switch (alt5) {
            	case 1 :
            	    // InternalKM3.g:494:3: rule__Package__ContentsAssignment_3
            	    {
            	    pushFollow(FOLLOW_8);
            	    rule__Package__ContentsAssignment_3();

            	    state._fsp--;


            	    }
            	    break;

            	default :
            	    break loop5;
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
    // InternalKM3.g:502:1: rule__Package__Group__4 : rule__Package__Group__4__Impl ;
    public final void rule__Package__Group__4() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:506:1: ( rule__Package__Group__4__Impl )
            // InternalKM3.g:507:2: rule__Package__Group__4__Impl
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
    // InternalKM3.g:513:1: rule__Package__Group__4__Impl : ( '}' ) ;
    public final void rule__Package__Group__4__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:517:1: ( ( '}' ) )
            // InternalKM3.g:518:1: ( '}' )
            {
            // InternalKM3.g:518:1: ( '}' )
            // InternalKM3.g:519:2: '}'
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
    // InternalKM3.g:529:1: rule__DataType__Group__0 : rule__DataType__Group__0__Impl rule__DataType__Group__1 ;
    public final void rule__DataType__Group__0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:533:1: ( rule__DataType__Group__0__Impl rule__DataType__Group__1 )
            // InternalKM3.g:534:2: rule__DataType__Group__0__Impl rule__DataType__Group__1
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
    // InternalKM3.g:541:1: rule__DataType__Group__0__Impl : ( 'datatype' ) ;
    public final void rule__DataType__Group__0__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:545:1: ( ( 'datatype' ) )
            // InternalKM3.g:546:1: ( 'datatype' )
            {
            // InternalKM3.g:546:1: ( 'datatype' )
            // InternalKM3.g:547:2: 'datatype'
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
    // InternalKM3.g:556:1: rule__DataType__Group__1 : rule__DataType__Group__1__Impl rule__DataType__Group__2 ;
    public final void rule__DataType__Group__1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:560:1: ( rule__DataType__Group__1__Impl rule__DataType__Group__2 )
            // InternalKM3.g:561:2: rule__DataType__Group__1__Impl rule__DataType__Group__2
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
    // InternalKM3.g:568:1: rule__DataType__Group__1__Impl : ( ( rule__DataType__NameAssignment_1 ) ) ;
    public final void rule__DataType__Group__1__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:572:1: ( ( ( rule__DataType__NameAssignment_1 ) ) )
            // InternalKM3.g:573:1: ( ( rule__DataType__NameAssignment_1 ) )
            {
            // InternalKM3.g:573:1: ( ( rule__DataType__NameAssignment_1 ) )
            // InternalKM3.g:574:2: ( rule__DataType__NameAssignment_1 )
            {
             before(grammarAccess.getDataTypeAccess().getNameAssignment_1()); 
            // InternalKM3.g:575:2: ( rule__DataType__NameAssignment_1 )
            // InternalKM3.g:575:3: rule__DataType__NameAssignment_1
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
    // InternalKM3.g:583:1: rule__DataType__Group__2 : rule__DataType__Group__2__Impl ;
    public final void rule__DataType__Group__2() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:587:1: ( rule__DataType__Group__2__Impl )
            // InternalKM3.g:588:2: rule__DataType__Group__2__Impl
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
    // InternalKM3.g:594:1: rule__DataType__Group__2__Impl : ( ';' ) ;
    public final void rule__DataType__Group__2__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:598:1: ( ( ';' ) )
            // InternalKM3.g:599:1: ( ';' )
            {
            // InternalKM3.g:599:1: ( ';' )
            // InternalKM3.g:600:2: ';'
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
    // InternalKM3.g:610:1: rule__Class__Group__0 : rule__Class__Group__0__Impl rule__Class__Group__1 ;
    public final void rule__Class__Group__0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:614:1: ( rule__Class__Group__0__Impl rule__Class__Group__1 )
            // InternalKM3.g:615:2: rule__Class__Group__0__Impl rule__Class__Group__1
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
    // InternalKM3.g:622:1: rule__Class__Group__0__Impl : ( ( rule__Class__IsAbstractAssignment_0 )? ) ;
    public final void rule__Class__Group__0__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:626:1: ( ( ( rule__Class__IsAbstractAssignment_0 )? ) )
            // InternalKM3.g:627:1: ( ( rule__Class__IsAbstractAssignment_0 )? )
            {
            // InternalKM3.g:627:1: ( ( rule__Class__IsAbstractAssignment_0 )? )
            // InternalKM3.g:628:2: ( rule__Class__IsAbstractAssignment_0 )?
            {
             before(grammarAccess.getClassAccess().getIsAbstractAssignment_0()); 
            // InternalKM3.g:629:2: ( rule__Class__IsAbstractAssignment_0 )?
            int alt6=2;
            int LA6_0 = input.LA(1);

            if ( (LA6_0==28) ) {
                alt6=1;
            }
            switch (alt6) {
                case 1 :
                    // InternalKM3.g:629:3: rule__Class__IsAbstractAssignment_0
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
    // InternalKM3.g:637:1: rule__Class__Group__1 : rule__Class__Group__1__Impl rule__Class__Group__2 ;
    public final void rule__Class__Group__1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:641:1: ( rule__Class__Group__1__Impl rule__Class__Group__2 )
            // InternalKM3.g:642:2: rule__Class__Group__1__Impl rule__Class__Group__2
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
    // InternalKM3.g:649:1: rule__Class__Group__1__Impl : ( 'class' ) ;
    public final void rule__Class__Group__1__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:653:1: ( ( 'class' ) )
            // InternalKM3.g:654:1: ( 'class' )
            {
            // InternalKM3.g:654:1: ( 'class' )
            // InternalKM3.g:655:2: 'class'
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
    // InternalKM3.g:664:1: rule__Class__Group__2 : rule__Class__Group__2__Impl rule__Class__Group__3 ;
    public final void rule__Class__Group__2() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:668:1: ( rule__Class__Group__2__Impl rule__Class__Group__3 )
            // InternalKM3.g:669:2: rule__Class__Group__2__Impl rule__Class__Group__3
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
    // InternalKM3.g:676:1: rule__Class__Group__2__Impl : ( ( rule__Class__NameAssignment_2 ) ) ;
    public final void rule__Class__Group__2__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:680:1: ( ( ( rule__Class__NameAssignment_2 ) ) )
            // InternalKM3.g:681:1: ( ( rule__Class__NameAssignment_2 ) )
            {
            // InternalKM3.g:681:1: ( ( rule__Class__NameAssignment_2 ) )
            // InternalKM3.g:682:2: ( rule__Class__NameAssignment_2 )
            {
             before(grammarAccess.getClassAccess().getNameAssignment_2()); 
            // InternalKM3.g:683:2: ( rule__Class__NameAssignment_2 )
            // InternalKM3.g:683:3: rule__Class__NameAssignment_2
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
    // InternalKM3.g:691:1: rule__Class__Group__3 : rule__Class__Group__3__Impl rule__Class__Group__4 ;
    public final void rule__Class__Group__3() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:695:1: ( rule__Class__Group__3__Impl rule__Class__Group__4 )
            // InternalKM3.g:696:2: rule__Class__Group__3__Impl rule__Class__Group__4
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
    // InternalKM3.g:703:1: rule__Class__Group__3__Impl : ( ( rule__Class__Group_3__0 )? ) ;
    public final void rule__Class__Group__3__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:707:1: ( ( ( rule__Class__Group_3__0 )? ) )
            // InternalKM3.g:708:1: ( ( rule__Class__Group_3__0 )? )
            {
            // InternalKM3.g:708:1: ( ( rule__Class__Group_3__0 )? )
            // InternalKM3.g:709:2: ( rule__Class__Group_3__0 )?
            {
             before(grammarAccess.getClassAccess().getGroup_3()); 
            // InternalKM3.g:710:2: ( rule__Class__Group_3__0 )?
            int alt7=2;
            int LA7_0 = input.LA(1);

            if ( (LA7_0==19) ) {
                alt7=1;
            }
            switch (alt7) {
                case 1 :
                    // InternalKM3.g:710:3: rule__Class__Group_3__0
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
    // InternalKM3.g:718:1: rule__Class__Group__4 : rule__Class__Group__4__Impl rule__Class__Group__5 ;
    public final void rule__Class__Group__4() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:722:1: ( rule__Class__Group__4__Impl rule__Class__Group__5 )
            // InternalKM3.g:723:2: rule__Class__Group__4__Impl rule__Class__Group__5
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
    // InternalKM3.g:730:1: rule__Class__Group__4__Impl : ( '{' ) ;
    public final void rule__Class__Group__4__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:734:1: ( ( '{' ) )
            // InternalKM3.g:735:1: ( '{' )
            {
            // InternalKM3.g:735:1: ( '{' )
            // InternalKM3.g:736:2: '{'
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
    // InternalKM3.g:745:1: rule__Class__Group__5 : rule__Class__Group__5__Impl rule__Class__Group__6 ;
    public final void rule__Class__Group__5() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:749:1: ( rule__Class__Group__5__Impl rule__Class__Group__6 )
            // InternalKM3.g:750:2: rule__Class__Group__5__Impl rule__Class__Group__6
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
    // InternalKM3.g:757:1: rule__Class__Group__5__Impl : ( ( rule__Class__StructuralFeaturesAssignment_5 )* ) ;
    public final void rule__Class__Group__5__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:761:1: ( ( ( rule__Class__StructuralFeaturesAssignment_5 )* ) )
            // InternalKM3.g:762:1: ( ( rule__Class__StructuralFeaturesAssignment_5 )* )
            {
            // InternalKM3.g:762:1: ( ( rule__Class__StructuralFeaturesAssignment_5 )* )
            // InternalKM3.g:763:2: ( rule__Class__StructuralFeaturesAssignment_5 )*
            {
             before(grammarAccess.getClassAccess().getStructuralFeaturesAssignment_5()); 
            // InternalKM3.g:764:2: ( rule__Class__StructuralFeaturesAssignment_5 )*
            loop8:
            do {
                int alt8=2;
                int LA8_0 = input.LA(1);

                if ( (LA8_0==21||LA8_0==26||LA8_0==29) ) {
                    alt8=1;
                }


                switch (alt8) {
            	case 1 :
            	    // InternalKM3.g:764:3: rule__Class__StructuralFeaturesAssignment_5
            	    {
            	    pushFollow(FOLLOW_13);
            	    rule__Class__StructuralFeaturesAssignment_5();

            	    state._fsp--;


            	    }
            	    break;

            	default :
            	    break loop8;
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
    // InternalKM3.g:772:1: rule__Class__Group__6 : rule__Class__Group__6__Impl ;
    public final void rule__Class__Group__6() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:776:1: ( rule__Class__Group__6__Impl )
            // InternalKM3.g:777:2: rule__Class__Group__6__Impl
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
    // InternalKM3.g:783:1: rule__Class__Group__6__Impl : ( '}' ) ;
    public final void rule__Class__Group__6__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:787:1: ( ( '}' ) )
            // InternalKM3.g:788:1: ( '}' )
            {
            // InternalKM3.g:788:1: ( '}' )
            // InternalKM3.g:789:2: '}'
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
    // InternalKM3.g:799:1: rule__Class__Group_3__0 : rule__Class__Group_3__0__Impl rule__Class__Group_3__1 ;
    public final void rule__Class__Group_3__0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:803:1: ( rule__Class__Group_3__0__Impl rule__Class__Group_3__1 )
            // InternalKM3.g:804:2: rule__Class__Group_3__0__Impl rule__Class__Group_3__1
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
    // InternalKM3.g:811:1: rule__Class__Group_3__0__Impl : ( 'extends' ) ;
    public final void rule__Class__Group_3__0__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:815:1: ( ( 'extends' ) )
            // InternalKM3.g:816:1: ( 'extends' )
            {
            // InternalKM3.g:816:1: ( 'extends' )
            // InternalKM3.g:817:2: 'extends'
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
    // InternalKM3.g:826:1: rule__Class__Group_3__1 : rule__Class__Group_3__1__Impl rule__Class__Group_3__2 ;
    public final void rule__Class__Group_3__1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:830:1: ( rule__Class__Group_3__1__Impl rule__Class__Group_3__2 )
            // InternalKM3.g:831:2: rule__Class__Group_3__1__Impl rule__Class__Group_3__2
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
    // InternalKM3.g:838:1: rule__Class__Group_3__1__Impl : ( ( rule__Class__SupertypesAssignment_3_1 ) ) ;
    public final void rule__Class__Group_3__1__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:842:1: ( ( ( rule__Class__SupertypesAssignment_3_1 ) ) )
            // InternalKM3.g:843:1: ( ( rule__Class__SupertypesAssignment_3_1 ) )
            {
            // InternalKM3.g:843:1: ( ( rule__Class__SupertypesAssignment_3_1 ) )
            // InternalKM3.g:844:2: ( rule__Class__SupertypesAssignment_3_1 )
            {
             before(grammarAccess.getClassAccess().getSupertypesAssignment_3_1()); 
            // InternalKM3.g:845:2: ( rule__Class__SupertypesAssignment_3_1 )
            // InternalKM3.g:845:3: rule__Class__SupertypesAssignment_3_1
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
    // InternalKM3.g:853:1: rule__Class__Group_3__2 : rule__Class__Group_3__2__Impl ;
    public final void rule__Class__Group_3__2() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:857:1: ( rule__Class__Group_3__2__Impl )
            // InternalKM3.g:858:2: rule__Class__Group_3__2__Impl
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
    // InternalKM3.g:864:1: rule__Class__Group_3__2__Impl : ( ( rule__Class__Group_3_2__0 )* ) ;
    public final void rule__Class__Group_3__2__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:868:1: ( ( ( rule__Class__Group_3_2__0 )* ) )
            // InternalKM3.g:869:1: ( ( rule__Class__Group_3_2__0 )* )
            {
            // InternalKM3.g:869:1: ( ( rule__Class__Group_3_2__0 )* )
            // InternalKM3.g:870:2: ( rule__Class__Group_3_2__0 )*
            {
             before(grammarAccess.getClassAccess().getGroup_3_2()); 
            // InternalKM3.g:871:2: ( rule__Class__Group_3_2__0 )*
            loop9:
            do {
                int alt9=2;
                int LA9_0 = input.LA(1);

                if ( (LA9_0==20) ) {
                    alt9=1;
                }


                switch (alt9) {
            	case 1 :
            	    // InternalKM3.g:871:3: rule__Class__Group_3_2__0
            	    {
            	    pushFollow(FOLLOW_15);
            	    rule__Class__Group_3_2__0();

            	    state._fsp--;


            	    }
            	    break;

            	default :
            	    break loop9;
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
    // InternalKM3.g:880:1: rule__Class__Group_3_2__0 : rule__Class__Group_3_2__0__Impl rule__Class__Group_3_2__1 ;
    public final void rule__Class__Group_3_2__0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:884:1: ( rule__Class__Group_3_2__0__Impl rule__Class__Group_3_2__1 )
            // InternalKM3.g:885:2: rule__Class__Group_3_2__0__Impl rule__Class__Group_3_2__1
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
    // InternalKM3.g:892:1: rule__Class__Group_3_2__0__Impl : ( ',' ) ;
    public final void rule__Class__Group_3_2__0__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:896:1: ( ( ',' ) )
            // InternalKM3.g:897:1: ( ',' )
            {
            // InternalKM3.g:897:1: ( ',' )
            // InternalKM3.g:898:2: ','
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
    // InternalKM3.g:907:1: rule__Class__Group_3_2__1 : rule__Class__Group_3_2__1__Impl ;
    public final void rule__Class__Group_3_2__1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:911:1: ( rule__Class__Group_3_2__1__Impl )
            // InternalKM3.g:912:2: rule__Class__Group_3_2__1__Impl
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
    // InternalKM3.g:918:1: rule__Class__Group_3_2__1__Impl : ( ( rule__Class__SupertypesAssignment_3_2_1 ) ) ;
    public final void rule__Class__Group_3_2__1__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:922:1: ( ( ( rule__Class__SupertypesAssignment_3_2_1 ) ) )
            // InternalKM3.g:923:1: ( ( rule__Class__SupertypesAssignment_3_2_1 ) )
            {
            // InternalKM3.g:923:1: ( ( rule__Class__SupertypesAssignment_3_2_1 ) )
            // InternalKM3.g:924:2: ( rule__Class__SupertypesAssignment_3_2_1 )
            {
             before(grammarAccess.getClassAccess().getSupertypesAssignment_3_2_1()); 
            // InternalKM3.g:925:2: ( rule__Class__SupertypesAssignment_3_2_1 )
            // InternalKM3.g:925:3: rule__Class__SupertypesAssignment_3_2_1
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
    // InternalKM3.g:934:1: rule__Attribute__Group__0 : rule__Attribute__Group__0__Impl rule__Attribute__Group__1 ;
    public final void rule__Attribute__Group__0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:938:1: ( rule__Attribute__Group__0__Impl rule__Attribute__Group__1 )
            // InternalKM3.g:939:2: rule__Attribute__Group__0__Impl rule__Attribute__Group__1
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
    // InternalKM3.g:946:1: rule__Attribute__Group__0__Impl : ( ( rule__Attribute__IsUniqueAssignment_0 )? ) ;
    public final void rule__Attribute__Group__0__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:950:1: ( ( ( rule__Attribute__IsUniqueAssignment_0 )? ) )
            // InternalKM3.g:951:1: ( ( rule__Attribute__IsUniqueAssignment_0 )? )
            {
            // InternalKM3.g:951:1: ( ( rule__Attribute__IsUniqueAssignment_0 )? )
            // InternalKM3.g:952:2: ( rule__Attribute__IsUniqueAssignment_0 )?
            {
             before(grammarAccess.getAttributeAccess().getIsUniqueAssignment_0()); 
            // InternalKM3.g:953:2: ( rule__Attribute__IsUniqueAssignment_0 )?
            int alt10=2;
            int LA10_0 = input.LA(1);

            if ( (LA10_0==29) ) {
                alt10=1;
            }
            switch (alt10) {
                case 1 :
                    // InternalKM3.g:953:3: rule__Attribute__IsUniqueAssignment_0
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
    // InternalKM3.g:961:1: rule__Attribute__Group__1 : rule__Attribute__Group__1__Impl rule__Attribute__Group__2 ;
    public final void rule__Attribute__Group__1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:965:1: ( rule__Attribute__Group__1__Impl rule__Attribute__Group__2 )
            // InternalKM3.g:966:2: rule__Attribute__Group__1__Impl rule__Attribute__Group__2
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
    // InternalKM3.g:973:1: rule__Attribute__Group__1__Impl : ( 'attribute' ) ;
    public final void rule__Attribute__Group__1__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:977:1: ( ( 'attribute' ) )
            // InternalKM3.g:978:1: ( 'attribute' )
            {
            // InternalKM3.g:978:1: ( 'attribute' )
            // InternalKM3.g:979:2: 'attribute'
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
    // InternalKM3.g:988:1: rule__Attribute__Group__2 : rule__Attribute__Group__2__Impl rule__Attribute__Group__3 ;
    public final void rule__Attribute__Group__2() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:992:1: ( rule__Attribute__Group__2__Impl rule__Attribute__Group__3 )
            // InternalKM3.g:993:2: rule__Attribute__Group__2__Impl rule__Attribute__Group__3
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
    // InternalKM3.g:1000:1: rule__Attribute__Group__2__Impl : ( ( rule__Attribute__NameAssignment_2 ) ) ;
    public final void rule__Attribute__Group__2__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1004:1: ( ( ( rule__Attribute__NameAssignment_2 ) ) )
            // InternalKM3.g:1005:1: ( ( rule__Attribute__NameAssignment_2 ) )
            {
            // InternalKM3.g:1005:1: ( ( rule__Attribute__NameAssignment_2 ) )
            // InternalKM3.g:1006:2: ( rule__Attribute__NameAssignment_2 )
            {
             before(grammarAccess.getAttributeAccess().getNameAssignment_2()); 
            // InternalKM3.g:1007:2: ( rule__Attribute__NameAssignment_2 )
            // InternalKM3.g:1007:3: rule__Attribute__NameAssignment_2
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
    // InternalKM3.g:1015:1: rule__Attribute__Group__3 : rule__Attribute__Group__3__Impl rule__Attribute__Group__4 ;
    public final void rule__Attribute__Group__3() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1019:1: ( rule__Attribute__Group__3__Impl rule__Attribute__Group__4 )
            // InternalKM3.g:1020:2: rule__Attribute__Group__3__Impl rule__Attribute__Group__4
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
    // InternalKM3.g:1027:1: rule__Attribute__Group__3__Impl : ( ( rule__Attribute__Group_3__0 )? ) ;
    public final void rule__Attribute__Group__3__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1031:1: ( ( ( rule__Attribute__Group_3__0 )? ) )
            // InternalKM3.g:1032:1: ( ( rule__Attribute__Group_3__0 )? )
            {
            // InternalKM3.g:1032:1: ( ( rule__Attribute__Group_3__0 )? )
            // InternalKM3.g:1033:2: ( rule__Attribute__Group_3__0 )?
            {
             before(grammarAccess.getAttributeAccess().getGroup_3()); 
            // InternalKM3.g:1034:2: ( rule__Attribute__Group_3__0 )?
            int alt11=2;
            int LA11_0 = input.LA(1);

            if ( (LA11_0==23) ) {
                alt11=1;
            }
            switch (alt11) {
                case 1 :
                    // InternalKM3.g:1034:3: rule__Attribute__Group_3__0
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
    // InternalKM3.g:1042:1: rule__Attribute__Group__4 : rule__Attribute__Group__4__Impl rule__Attribute__Group__5 ;
    public final void rule__Attribute__Group__4() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1046:1: ( rule__Attribute__Group__4__Impl rule__Attribute__Group__5 )
            // InternalKM3.g:1047:2: rule__Attribute__Group__4__Impl rule__Attribute__Group__5
            {
            pushFollow(FOLLOW_17);
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
    // InternalKM3.g:1054:1: rule__Attribute__Group__4__Impl : ( ( rule__Attribute__IsOrderedAssignment_4 )? ) ;
    public final void rule__Attribute__Group__4__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1058:1: ( ( ( rule__Attribute__IsOrderedAssignment_4 )? ) )
            // InternalKM3.g:1059:1: ( ( rule__Attribute__IsOrderedAssignment_4 )? )
            {
            // InternalKM3.g:1059:1: ( ( rule__Attribute__IsOrderedAssignment_4 )? )
            // InternalKM3.g:1060:2: ( rule__Attribute__IsOrderedAssignment_4 )?
            {
             before(grammarAccess.getAttributeAccess().getIsOrderedAssignment_4()); 
            // InternalKM3.g:1061:2: ( rule__Attribute__IsOrderedAssignment_4 )?
            int alt12=2;
            int LA12_0 = input.LA(1);

            if ( (LA12_0==30) ) {
                alt12=1;
            }
            switch (alt12) {
                case 1 :
                    // InternalKM3.g:1061:3: rule__Attribute__IsOrderedAssignment_4
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
    // InternalKM3.g:1069:1: rule__Attribute__Group__5 : rule__Attribute__Group__5__Impl rule__Attribute__Group__6 ;
    public final void rule__Attribute__Group__5() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1073:1: ( rule__Attribute__Group__5__Impl rule__Attribute__Group__6 )
            // InternalKM3.g:1074:2: rule__Attribute__Group__5__Impl rule__Attribute__Group__6
            {
            pushFollow(FOLLOW_5);
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
    // InternalKM3.g:1081:1: rule__Attribute__Group__5__Impl : ( ':' ) ;
    public final void rule__Attribute__Group__5__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1085:1: ( ( ':' ) )
            // InternalKM3.g:1086:1: ( ':' )
            {
            // InternalKM3.g:1086:1: ( ':' )
            // InternalKM3.g:1087:2: ':'
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
    // InternalKM3.g:1096:1: rule__Attribute__Group__6 : rule__Attribute__Group__6__Impl rule__Attribute__Group__7 ;
    public final void rule__Attribute__Group__6() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1100:1: ( rule__Attribute__Group__6__Impl rule__Attribute__Group__7 )
            // InternalKM3.g:1101:2: rule__Attribute__Group__6__Impl rule__Attribute__Group__7
            {
            pushFollow(FOLLOW_9);
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
    // InternalKM3.g:1108:1: rule__Attribute__Group__6__Impl : ( ( rule__Attribute__TypeAssignment_6 ) ) ;
    public final void rule__Attribute__Group__6__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1112:1: ( ( ( rule__Attribute__TypeAssignment_6 ) ) )
            // InternalKM3.g:1113:1: ( ( rule__Attribute__TypeAssignment_6 ) )
            {
            // InternalKM3.g:1113:1: ( ( rule__Attribute__TypeAssignment_6 ) )
            // InternalKM3.g:1114:2: ( rule__Attribute__TypeAssignment_6 )
            {
             before(grammarAccess.getAttributeAccess().getTypeAssignment_6()); 
            // InternalKM3.g:1115:2: ( rule__Attribute__TypeAssignment_6 )
            // InternalKM3.g:1115:3: rule__Attribute__TypeAssignment_6
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
    // InternalKM3.g:1123:1: rule__Attribute__Group__7 : rule__Attribute__Group__7__Impl ;
    public final void rule__Attribute__Group__7() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1127:1: ( rule__Attribute__Group__7__Impl )
            // InternalKM3.g:1128:2: rule__Attribute__Group__7__Impl
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
    // InternalKM3.g:1134:1: rule__Attribute__Group__7__Impl : ( ';' ) ;
    public final void rule__Attribute__Group__7__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1138:1: ( ( ';' ) )
            // InternalKM3.g:1139:1: ( ';' )
            {
            // InternalKM3.g:1139:1: ( ';' )
            // InternalKM3.g:1140:2: ';'
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
    // InternalKM3.g:1150:1: rule__Attribute__Group_3__0 : rule__Attribute__Group_3__0__Impl rule__Attribute__Group_3__1 ;
    public final void rule__Attribute__Group_3__0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1154:1: ( rule__Attribute__Group_3__0__Impl rule__Attribute__Group_3__1 )
            // InternalKM3.g:1155:2: rule__Attribute__Group_3__0__Impl rule__Attribute__Group_3__1
            {
            pushFollow(FOLLOW_18);
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
    // InternalKM3.g:1162:1: rule__Attribute__Group_3__0__Impl : ( '[' ) ;
    public final void rule__Attribute__Group_3__0__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1166:1: ( ( '[' ) )
            // InternalKM3.g:1167:1: ( '[' )
            {
            // InternalKM3.g:1167:1: ( '[' )
            // InternalKM3.g:1168:2: '['
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
    // InternalKM3.g:1177:1: rule__Attribute__Group_3__1 : rule__Attribute__Group_3__1__Impl rule__Attribute__Group_3__2 ;
    public final void rule__Attribute__Group_3__1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1181:1: ( rule__Attribute__Group_3__1__Impl rule__Attribute__Group_3__2 )
            // InternalKM3.g:1182:2: rule__Attribute__Group_3__1__Impl rule__Attribute__Group_3__2
            {
            pushFollow(FOLLOW_18);
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
    // InternalKM3.g:1189:1: rule__Attribute__Group_3__1__Impl : ( ( rule__Attribute__Group_3_1__0 )? ) ;
    public final void rule__Attribute__Group_3__1__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1193:1: ( ( ( rule__Attribute__Group_3_1__0 )? ) )
            // InternalKM3.g:1194:1: ( ( rule__Attribute__Group_3_1__0 )? )
            {
            // InternalKM3.g:1194:1: ( ( rule__Attribute__Group_3_1__0 )? )
            // InternalKM3.g:1195:2: ( rule__Attribute__Group_3_1__0 )?
            {
             before(grammarAccess.getAttributeAccess().getGroup_3_1()); 
            // InternalKM3.g:1196:2: ( rule__Attribute__Group_3_1__0 )?
            int alt13=2;
            int LA13_0 = input.LA(1);

            if ( (LA13_0==12) ) {
                int LA13_1 = input.LA(2);

                if ( (LA13_1==25) ) {
                    alt13=1;
                }
            }
            else if ( (LA13_0==RULE_INT) ) {
                int LA13_2 = input.LA(2);

                if ( (LA13_2==25) ) {
                    alt13=1;
                }
            }
            switch (alt13) {
                case 1 :
                    // InternalKM3.g:1196:3: rule__Attribute__Group_3_1__0
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
    // InternalKM3.g:1204:1: rule__Attribute__Group_3__2 : rule__Attribute__Group_3__2__Impl rule__Attribute__Group_3__3 ;
    public final void rule__Attribute__Group_3__2() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1208:1: ( rule__Attribute__Group_3__2__Impl rule__Attribute__Group_3__3 )
            // InternalKM3.g:1209:2: rule__Attribute__Group_3__2__Impl rule__Attribute__Group_3__3
            {
            pushFollow(FOLLOW_19);
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
    // InternalKM3.g:1216:1: rule__Attribute__Group_3__2__Impl : ( ( rule__Attribute__UpperAssignment_3_2 ) ) ;
    public final void rule__Attribute__Group_3__2__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1220:1: ( ( ( rule__Attribute__UpperAssignment_3_2 ) ) )
            // InternalKM3.g:1221:1: ( ( rule__Attribute__UpperAssignment_3_2 ) )
            {
            // InternalKM3.g:1221:1: ( ( rule__Attribute__UpperAssignment_3_2 ) )
            // InternalKM3.g:1222:2: ( rule__Attribute__UpperAssignment_3_2 )
            {
             before(grammarAccess.getAttributeAccess().getUpperAssignment_3_2()); 
            // InternalKM3.g:1223:2: ( rule__Attribute__UpperAssignment_3_2 )
            // InternalKM3.g:1223:3: rule__Attribute__UpperAssignment_3_2
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
    // InternalKM3.g:1231:1: rule__Attribute__Group_3__3 : rule__Attribute__Group_3__3__Impl ;
    public final void rule__Attribute__Group_3__3() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1235:1: ( rule__Attribute__Group_3__3__Impl )
            // InternalKM3.g:1236:2: rule__Attribute__Group_3__3__Impl
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
    // InternalKM3.g:1242:1: rule__Attribute__Group_3__3__Impl : ( ']' ) ;
    public final void rule__Attribute__Group_3__3__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1246:1: ( ( ']' ) )
            // InternalKM3.g:1247:1: ( ']' )
            {
            // InternalKM3.g:1247:1: ( ']' )
            // InternalKM3.g:1248:2: ']'
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
    // InternalKM3.g:1258:1: rule__Attribute__Group_3_1__0 : rule__Attribute__Group_3_1__0__Impl rule__Attribute__Group_3_1__1 ;
    public final void rule__Attribute__Group_3_1__0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1262:1: ( rule__Attribute__Group_3_1__0__Impl rule__Attribute__Group_3_1__1 )
            // InternalKM3.g:1263:2: rule__Attribute__Group_3_1__0__Impl rule__Attribute__Group_3_1__1
            {
            pushFollow(FOLLOW_20);
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
    // InternalKM3.g:1270:1: rule__Attribute__Group_3_1__0__Impl : ( ( rule__Attribute__LowerAssignment_3_1_0 ) ) ;
    public final void rule__Attribute__Group_3_1__0__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1274:1: ( ( ( rule__Attribute__LowerAssignment_3_1_0 ) ) )
            // InternalKM3.g:1275:1: ( ( rule__Attribute__LowerAssignment_3_1_0 ) )
            {
            // InternalKM3.g:1275:1: ( ( rule__Attribute__LowerAssignment_3_1_0 ) )
            // InternalKM3.g:1276:2: ( rule__Attribute__LowerAssignment_3_1_0 )
            {
             before(grammarAccess.getAttributeAccess().getLowerAssignment_3_1_0()); 
            // InternalKM3.g:1277:2: ( rule__Attribute__LowerAssignment_3_1_0 )
            // InternalKM3.g:1277:3: rule__Attribute__LowerAssignment_3_1_0
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
    // InternalKM3.g:1285:1: rule__Attribute__Group_3_1__1 : rule__Attribute__Group_3_1__1__Impl ;
    public final void rule__Attribute__Group_3_1__1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1289:1: ( rule__Attribute__Group_3_1__1__Impl )
            // InternalKM3.g:1290:2: rule__Attribute__Group_3_1__1__Impl
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
    // InternalKM3.g:1296:1: rule__Attribute__Group_3_1__1__Impl : ( '-' ) ;
    public final void rule__Attribute__Group_3_1__1__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1300:1: ( ( '-' ) )
            // InternalKM3.g:1301:1: ( '-' )
            {
            // InternalKM3.g:1301:1: ( '-' )
            // InternalKM3.g:1302:2: '-'
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
    // InternalKM3.g:1312:1: rule__Reference__Group__0 : rule__Reference__Group__0__Impl rule__Reference__Group__1 ;
    public final void rule__Reference__Group__0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1316:1: ( rule__Reference__Group__0__Impl rule__Reference__Group__1 )
            // InternalKM3.g:1317:2: rule__Reference__Group__0__Impl rule__Reference__Group__1
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
    // InternalKM3.g:1324:1: rule__Reference__Group__0__Impl : ( 'reference' ) ;
    public final void rule__Reference__Group__0__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1328:1: ( ( 'reference' ) )
            // InternalKM3.g:1329:1: ( 'reference' )
            {
            // InternalKM3.g:1329:1: ( 'reference' )
            // InternalKM3.g:1330:2: 'reference'
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
    // InternalKM3.g:1339:1: rule__Reference__Group__1 : rule__Reference__Group__1__Impl rule__Reference__Group__2 ;
    public final void rule__Reference__Group__1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1343:1: ( rule__Reference__Group__1__Impl rule__Reference__Group__2 )
            // InternalKM3.g:1344:2: rule__Reference__Group__1__Impl rule__Reference__Group__2
            {
            pushFollow(FOLLOW_21);
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
    // InternalKM3.g:1351:1: rule__Reference__Group__1__Impl : ( ( rule__Reference__NameAssignment_1 ) ) ;
    public final void rule__Reference__Group__1__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1355:1: ( ( ( rule__Reference__NameAssignment_1 ) ) )
            // InternalKM3.g:1356:1: ( ( rule__Reference__NameAssignment_1 ) )
            {
            // InternalKM3.g:1356:1: ( ( rule__Reference__NameAssignment_1 ) )
            // InternalKM3.g:1357:2: ( rule__Reference__NameAssignment_1 )
            {
             before(grammarAccess.getReferenceAccess().getNameAssignment_1()); 
            // InternalKM3.g:1358:2: ( rule__Reference__NameAssignment_1 )
            // InternalKM3.g:1358:3: rule__Reference__NameAssignment_1
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
    // InternalKM3.g:1366:1: rule__Reference__Group__2 : rule__Reference__Group__2__Impl rule__Reference__Group__3 ;
    public final void rule__Reference__Group__2() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1370:1: ( rule__Reference__Group__2__Impl rule__Reference__Group__3 )
            // InternalKM3.g:1371:2: rule__Reference__Group__2__Impl rule__Reference__Group__3
            {
            pushFollow(FOLLOW_21);
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
    // InternalKM3.g:1378:1: rule__Reference__Group__2__Impl : ( ( rule__Reference__Group_2__0 )? ) ;
    public final void rule__Reference__Group__2__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1382:1: ( ( ( rule__Reference__Group_2__0 )? ) )
            // InternalKM3.g:1383:1: ( ( rule__Reference__Group_2__0 )? )
            {
            // InternalKM3.g:1383:1: ( ( rule__Reference__Group_2__0 )? )
            // InternalKM3.g:1384:2: ( rule__Reference__Group_2__0 )?
            {
             before(grammarAccess.getReferenceAccess().getGroup_2()); 
            // InternalKM3.g:1385:2: ( rule__Reference__Group_2__0 )?
            int alt14=2;
            int LA14_0 = input.LA(1);

            if ( (LA14_0==23) ) {
                alt14=1;
            }
            switch (alt14) {
                case 1 :
                    // InternalKM3.g:1385:3: rule__Reference__Group_2__0
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
    // InternalKM3.g:1393:1: rule__Reference__Group__3 : rule__Reference__Group__3__Impl rule__Reference__Group__4 ;
    public final void rule__Reference__Group__3() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1397:1: ( rule__Reference__Group__3__Impl rule__Reference__Group__4 )
            // InternalKM3.g:1398:2: rule__Reference__Group__3__Impl rule__Reference__Group__4
            {
            pushFollow(FOLLOW_21);
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
    // InternalKM3.g:1405:1: rule__Reference__Group__3__Impl : ( ( rule__Reference__IsOrderedAssignment_3 )? ) ;
    public final void rule__Reference__Group__3__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1409:1: ( ( ( rule__Reference__IsOrderedAssignment_3 )? ) )
            // InternalKM3.g:1410:1: ( ( rule__Reference__IsOrderedAssignment_3 )? )
            {
            // InternalKM3.g:1410:1: ( ( rule__Reference__IsOrderedAssignment_3 )? )
            // InternalKM3.g:1411:2: ( rule__Reference__IsOrderedAssignment_3 )?
            {
             before(grammarAccess.getReferenceAccess().getIsOrderedAssignment_3()); 
            // InternalKM3.g:1412:2: ( rule__Reference__IsOrderedAssignment_3 )?
            int alt15=2;
            int LA15_0 = input.LA(1);

            if ( (LA15_0==30) ) {
                alt15=1;
            }
            switch (alt15) {
                case 1 :
                    // InternalKM3.g:1412:3: rule__Reference__IsOrderedAssignment_3
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
    // InternalKM3.g:1420:1: rule__Reference__Group__4 : rule__Reference__Group__4__Impl rule__Reference__Group__5 ;
    public final void rule__Reference__Group__4() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1424:1: ( rule__Reference__Group__4__Impl rule__Reference__Group__5 )
            // InternalKM3.g:1425:2: rule__Reference__Group__4__Impl rule__Reference__Group__5
            {
            pushFollow(FOLLOW_21);
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
    // InternalKM3.g:1432:1: rule__Reference__Group__4__Impl : ( ( rule__Reference__IsContainerAssignment_4 )? ) ;
    public final void rule__Reference__Group__4__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1436:1: ( ( ( rule__Reference__IsContainerAssignment_4 )? ) )
            // InternalKM3.g:1437:1: ( ( rule__Reference__IsContainerAssignment_4 )? )
            {
            // InternalKM3.g:1437:1: ( ( rule__Reference__IsContainerAssignment_4 )? )
            // InternalKM3.g:1438:2: ( rule__Reference__IsContainerAssignment_4 )?
            {
             before(grammarAccess.getReferenceAccess().getIsContainerAssignment_4()); 
            // InternalKM3.g:1439:2: ( rule__Reference__IsContainerAssignment_4 )?
            int alt16=2;
            int LA16_0 = input.LA(1);

            if ( (LA16_0==31) ) {
                alt16=1;
            }
            switch (alt16) {
                case 1 :
                    // InternalKM3.g:1439:3: rule__Reference__IsContainerAssignment_4
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
    // InternalKM3.g:1447:1: rule__Reference__Group__5 : rule__Reference__Group__5__Impl rule__Reference__Group__6 ;
    public final void rule__Reference__Group__5() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1451:1: ( rule__Reference__Group__5__Impl rule__Reference__Group__6 )
            // InternalKM3.g:1452:2: rule__Reference__Group__5__Impl rule__Reference__Group__6
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
    // InternalKM3.g:1459:1: rule__Reference__Group__5__Impl : ( ':' ) ;
    public final void rule__Reference__Group__5__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1463:1: ( ( ':' ) )
            // InternalKM3.g:1464:1: ( ':' )
            {
            // InternalKM3.g:1464:1: ( ':' )
            // InternalKM3.g:1465:2: ':'
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
    // InternalKM3.g:1474:1: rule__Reference__Group__6 : rule__Reference__Group__6__Impl rule__Reference__Group__7 ;
    public final void rule__Reference__Group__6() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1478:1: ( rule__Reference__Group__6__Impl rule__Reference__Group__7 )
            // InternalKM3.g:1479:2: rule__Reference__Group__6__Impl rule__Reference__Group__7
            {
            pushFollow(FOLLOW_22);
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
    // InternalKM3.g:1486:1: rule__Reference__Group__6__Impl : ( ( rule__Reference__TypeAssignment_6 ) ) ;
    public final void rule__Reference__Group__6__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1490:1: ( ( ( rule__Reference__TypeAssignment_6 ) ) )
            // InternalKM3.g:1491:1: ( ( rule__Reference__TypeAssignment_6 ) )
            {
            // InternalKM3.g:1491:1: ( ( rule__Reference__TypeAssignment_6 ) )
            // InternalKM3.g:1492:2: ( rule__Reference__TypeAssignment_6 )
            {
             before(grammarAccess.getReferenceAccess().getTypeAssignment_6()); 
            // InternalKM3.g:1493:2: ( rule__Reference__TypeAssignment_6 )
            // InternalKM3.g:1493:3: rule__Reference__TypeAssignment_6
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
    // InternalKM3.g:1501:1: rule__Reference__Group__7 : rule__Reference__Group__7__Impl rule__Reference__Group__8 ;
    public final void rule__Reference__Group__7() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1505:1: ( rule__Reference__Group__7__Impl rule__Reference__Group__8 )
            // InternalKM3.g:1506:2: rule__Reference__Group__7__Impl rule__Reference__Group__8
            {
            pushFollow(FOLLOW_22);
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
    // InternalKM3.g:1513:1: rule__Reference__Group__7__Impl : ( ( rule__Reference__Group_7__0 )? ) ;
    public final void rule__Reference__Group__7__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1517:1: ( ( ( rule__Reference__Group_7__0 )? ) )
            // InternalKM3.g:1518:1: ( ( rule__Reference__Group_7__0 )? )
            {
            // InternalKM3.g:1518:1: ( ( rule__Reference__Group_7__0 )? )
            // InternalKM3.g:1519:2: ( rule__Reference__Group_7__0 )?
            {
             before(grammarAccess.getReferenceAccess().getGroup_7()); 
            // InternalKM3.g:1520:2: ( rule__Reference__Group_7__0 )?
            int alt17=2;
            int LA17_0 = input.LA(1);

            if ( (LA17_0==27) ) {
                alt17=1;
            }
            switch (alt17) {
                case 1 :
                    // InternalKM3.g:1520:3: rule__Reference__Group_7__0
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
    // InternalKM3.g:1528:1: rule__Reference__Group__8 : rule__Reference__Group__8__Impl ;
    public final void rule__Reference__Group__8() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1532:1: ( rule__Reference__Group__8__Impl )
            // InternalKM3.g:1533:2: rule__Reference__Group__8__Impl
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
    // InternalKM3.g:1539:1: rule__Reference__Group__8__Impl : ( ';' ) ;
    public final void rule__Reference__Group__8__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1543:1: ( ( ';' ) )
            // InternalKM3.g:1544:1: ( ';' )
            {
            // InternalKM3.g:1544:1: ( ';' )
            // InternalKM3.g:1545:2: ';'
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
    // InternalKM3.g:1555:1: rule__Reference__Group_2__0 : rule__Reference__Group_2__0__Impl rule__Reference__Group_2__1 ;
    public final void rule__Reference__Group_2__0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1559:1: ( rule__Reference__Group_2__0__Impl rule__Reference__Group_2__1 )
            // InternalKM3.g:1560:2: rule__Reference__Group_2__0__Impl rule__Reference__Group_2__1
            {
            pushFollow(FOLLOW_18);
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
    // InternalKM3.g:1567:1: rule__Reference__Group_2__0__Impl : ( '[' ) ;
    public final void rule__Reference__Group_2__0__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1571:1: ( ( '[' ) )
            // InternalKM3.g:1572:1: ( '[' )
            {
            // InternalKM3.g:1572:1: ( '[' )
            // InternalKM3.g:1573:2: '['
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
    // InternalKM3.g:1582:1: rule__Reference__Group_2__1 : rule__Reference__Group_2__1__Impl rule__Reference__Group_2__2 ;
    public final void rule__Reference__Group_2__1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1586:1: ( rule__Reference__Group_2__1__Impl rule__Reference__Group_2__2 )
            // InternalKM3.g:1587:2: rule__Reference__Group_2__1__Impl rule__Reference__Group_2__2
            {
            pushFollow(FOLLOW_18);
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
    // InternalKM3.g:1594:1: rule__Reference__Group_2__1__Impl : ( ( rule__Reference__Group_2_1__0 )? ) ;
    public final void rule__Reference__Group_2__1__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1598:1: ( ( ( rule__Reference__Group_2_1__0 )? ) )
            // InternalKM3.g:1599:1: ( ( rule__Reference__Group_2_1__0 )? )
            {
            // InternalKM3.g:1599:1: ( ( rule__Reference__Group_2_1__0 )? )
            // InternalKM3.g:1600:2: ( rule__Reference__Group_2_1__0 )?
            {
             before(grammarAccess.getReferenceAccess().getGroup_2_1()); 
            // InternalKM3.g:1601:2: ( rule__Reference__Group_2_1__0 )?
            int alt18=2;
            int LA18_0 = input.LA(1);

            if ( (LA18_0==12) ) {
                int LA18_1 = input.LA(2);

                if ( (LA18_1==25) ) {
                    alt18=1;
                }
            }
            else if ( (LA18_0==RULE_INT) ) {
                int LA18_2 = input.LA(2);

                if ( (LA18_2==25) ) {
                    alt18=1;
                }
            }
            switch (alt18) {
                case 1 :
                    // InternalKM3.g:1601:3: rule__Reference__Group_2_1__0
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
    // InternalKM3.g:1609:1: rule__Reference__Group_2__2 : rule__Reference__Group_2__2__Impl rule__Reference__Group_2__3 ;
    public final void rule__Reference__Group_2__2() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1613:1: ( rule__Reference__Group_2__2__Impl rule__Reference__Group_2__3 )
            // InternalKM3.g:1614:2: rule__Reference__Group_2__2__Impl rule__Reference__Group_2__3
            {
            pushFollow(FOLLOW_19);
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
    // InternalKM3.g:1621:1: rule__Reference__Group_2__2__Impl : ( ( rule__Reference__UpperAssignment_2_2 ) ) ;
    public final void rule__Reference__Group_2__2__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1625:1: ( ( ( rule__Reference__UpperAssignment_2_2 ) ) )
            // InternalKM3.g:1626:1: ( ( rule__Reference__UpperAssignment_2_2 ) )
            {
            // InternalKM3.g:1626:1: ( ( rule__Reference__UpperAssignment_2_2 ) )
            // InternalKM3.g:1627:2: ( rule__Reference__UpperAssignment_2_2 )
            {
             before(grammarAccess.getReferenceAccess().getUpperAssignment_2_2()); 
            // InternalKM3.g:1628:2: ( rule__Reference__UpperAssignment_2_2 )
            // InternalKM3.g:1628:3: rule__Reference__UpperAssignment_2_2
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
    // InternalKM3.g:1636:1: rule__Reference__Group_2__3 : rule__Reference__Group_2__3__Impl ;
    public final void rule__Reference__Group_2__3() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1640:1: ( rule__Reference__Group_2__3__Impl )
            // InternalKM3.g:1641:2: rule__Reference__Group_2__3__Impl
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
    // InternalKM3.g:1647:1: rule__Reference__Group_2__3__Impl : ( ']' ) ;
    public final void rule__Reference__Group_2__3__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1651:1: ( ( ']' ) )
            // InternalKM3.g:1652:1: ( ']' )
            {
            // InternalKM3.g:1652:1: ( ']' )
            // InternalKM3.g:1653:2: ']'
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
    // InternalKM3.g:1663:1: rule__Reference__Group_2_1__0 : rule__Reference__Group_2_1__0__Impl rule__Reference__Group_2_1__1 ;
    public final void rule__Reference__Group_2_1__0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1667:1: ( rule__Reference__Group_2_1__0__Impl rule__Reference__Group_2_1__1 )
            // InternalKM3.g:1668:2: rule__Reference__Group_2_1__0__Impl rule__Reference__Group_2_1__1
            {
            pushFollow(FOLLOW_20);
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
    // InternalKM3.g:1675:1: rule__Reference__Group_2_1__0__Impl : ( ( rule__Reference__LowerAssignment_2_1_0 ) ) ;
    public final void rule__Reference__Group_2_1__0__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1679:1: ( ( ( rule__Reference__LowerAssignment_2_1_0 ) ) )
            // InternalKM3.g:1680:1: ( ( rule__Reference__LowerAssignment_2_1_0 ) )
            {
            // InternalKM3.g:1680:1: ( ( rule__Reference__LowerAssignment_2_1_0 ) )
            // InternalKM3.g:1681:2: ( rule__Reference__LowerAssignment_2_1_0 )
            {
             before(grammarAccess.getReferenceAccess().getLowerAssignment_2_1_0()); 
            // InternalKM3.g:1682:2: ( rule__Reference__LowerAssignment_2_1_0 )
            // InternalKM3.g:1682:3: rule__Reference__LowerAssignment_2_1_0
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
    // InternalKM3.g:1690:1: rule__Reference__Group_2_1__1 : rule__Reference__Group_2_1__1__Impl ;
    public final void rule__Reference__Group_2_1__1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1694:1: ( rule__Reference__Group_2_1__1__Impl )
            // InternalKM3.g:1695:2: rule__Reference__Group_2_1__1__Impl
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
    // InternalKM3.g:1701:1: rule__Reference__Group_2_1__1__Impl : ( '-' ) ;
    public final void rule__Reference__Group_2_1__1__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1705:1: ( ( '-' ) )
            // InternalKM3.g:1706:1: ( '-' )
            {
            // InternalKM3.g:1706:1: ( '-' )
            // InternalKM3.g:1707:2: '-'
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
    // InternalKM3.g:1717:1: rule__Reference__Group_7__0 : rule__Reference__Group_7__0__Impl rule__Reference__Group_7__1 ;
    public final void rule__Reference__Group_7__0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1721:1: ( rule__Reference__Group_7__0__Impl rule__Reference__Group_7__1 )
            // InternalKM3.g:1722:2: rule__Reference__Group_7__0__Impl rule__Reference__Group_7__1
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
    // InternalKM3.g:1729:1: rule__Reference__Group_7__0__Impl : ( 'oppositeOf' ) ;
    public final void rule__Reference__Group_7__0__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1733:1: ( ( 'oppositeOf' ) )
            // InternalKM3.g:1734:1: ( 'oppositeOf' )
            {
            // InternalKM3.g:1734:1: ( 'oppositeOf' )
            // InternalKM3.g:1735:2: 'oppositeOf'
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
    // InternalKM3.g:1744:1: rule__Reference__Group_7__1 : rule__Reference__Group_7__1__Impl ;
    public final void rule__Reference__Group_7__1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1748:1: ( rule__Reference__Group_7__1__Impl )
            // InternalKM3.g:1749:2: rule__Reference__Group_7__1__Impl
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
    // InternalKM3.g:1755:1: rule__Reference__Group_7__1__Impl : ( ( rule__Reference__OppositeAssignment_7_1 ) ) ;
    public final void rule__Reference__Group_7__1__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1759:1: ( ( ( rule__Reference__OppositeAssignment_7_1 ) ) )
            // InternalKM3.g:1760:1: ( ( rule__Reference__OppositeAssignment_7_1 ) )
            {
            // InternalKM3.g:1760:1: ( ( rule__Reference__OppositeAssignment_7_1 ) )
            // InternalKM3.g:1761:2: ( rule__Reference__OppositeAssignment_7_1 )
            {
             before(grammarAccess.getReferenceAccess().getOppositeAssignment_7_1()); 
            // InternalKM3.g:1762:2: ( rule__Reference__OppositeAssignment_7_1 )
            // InternalKM3.g:1762:3: rule__Reference__OppositeAssignment_7_1
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
    // InternalKM3.g:1771:1: rule__Metamodel__ContentsAssignment_1 : ( rulePackage ) ;
    public final void rule__Metamodel__ContentsAssignment_1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1775:1: ( ( rulePackage ) )
            // InternalKM3.g:1776:2: ( rulePackage )
            {
            // InternalKM3.g:1776:2: ( rulePackage )
            // InternalKM3.g:1777:3: rulePackage
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
    // InternalKM3.g:1786:1: rule__Package__NameAssignment_1 : ( RULE_ID ) ;
    public final void rule__Package__NameAssignment_1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1790:1: ( ( RULE_ID ) )
            // InternalKM3.g:1791:2: ( RULE_ID )
            {
            // InternalKM3.g:1791:2: ( RULE_ID )
            // InternalKM3.g:1792:3: RULE_ID
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
    // InternalKM3.g:1801:1: rule__Package__ContentsAssignment_3 : ( ruleModelElement ) ;
    public final void rule__Package__ContentsAssignment_3() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1805:1: ( ( ruleModelElement ) )
            // InternalKM3.g:1806:2: ( ruleModelElement )
            {
            // InternalKM3.g:1806:2: ( ruleModelElement )
            // InternalKM3.g:1807:3: ruleModelElement
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
    // InternalKM3.g:1816:1: rule__DataType__NameAssignment_1 : ( RULE_ID ) ;
    public final void rule__DataType__NameAssignment_1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1820:1: ( ( RULE_ID ) )
            // InternalKM3.g:1821:2: ( RULE_ID )
            {
            // InternalKM3.g:1821:2: ( RULE_ID )
            // InternalKM3.g:1822:3: RULE_ID
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
    // InternalKM3.g:1831:1: rule__Class__IsAbstractAssignment_0 : ( ( 'abstract' ) ) ;
    public final void rule__Class__IsAbstractAssignment_0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1835:1: ( ( ( 'abstract' ) ) )
            // InternalKM3.g:1836:2: ( ( 'abstract' ) )
            {
            // InternalKM3.g:1836:2: ( ( 'abstract' ) )
            // InternalKM3.g:1837:3: ( 'abstract' )
            {
             before(grammarAccess.getClassAccess().getIsAbstractAbstractKeyword_0_0()); 
            // InternalKM3.g:1838:3: ( 'abstract' )
            // InternalKM3.g:1839:4: 'abstract'
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
    // InternalKM3.g:1850:1: rule__Class__NameAssignment_2 : ( RULE_ID ) ;
    public final void rule__Class__NameAssignment_2() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1854:1: ( ( RULE_ID ) )
            // InternalKM3.g:1855:2: ( RULE_ID )
            {
            // InternalKM3.g:1855:2: ( RULE_ID )
            // InternalKM3.g:1856:3: RULE_ID
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
    // InternalKM3.g:1865:1: rule__Class__SupertypesAssignment_3_1 : ( ( RULE_ID ) ) ;
    public final void rule__Class__SupertypesAssignment_3_1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1869:1: ( ( ( RULE_ID ) ) )
            // InternalKM3.g:1870:2: ( ( RULE_ID ) )
            {
            // InternalKM3.g:1870:2: ( ( RULE_ID ) )
            // InternalKM3.g:1871:3: ( RULE_ID )
            {
             before(grammarAccess.getClassAccess().getSupertypesClassCrossReference_3_1_0()); 
            // InternalKM3.g:1872:3: ( RULE_ID )
            // InternalKM3.g:1873:4: RULE_ID
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
    // InternalKM3.g:1884:1: rule__Class__SupertypesAssignment_3_2_1 : ( ( RULE_ID ) ) ;
    public final void rule__Class__SupertypesAssignment_3_2_1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1888:1: ( ( ( RULE_ID ) ) )
            // InternalKM3.g:1889:2: ( ( RULE_ID ) )
            {
            // InternalKM3.g:1889:2: ( ( RULE_ID ) )
            // InternalKM3.g:1890:3: ( RULE_ID )
            {
             before(grammarAccess.getClassAccess().getSupertypesClassCrossReference_3_2_1_0()); 
            // InternalKM3.g:1891:3: ( RULE_ID )
            // InternalKM3.g:1892:4: RULE_ID
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
    // InternalKM3.g:1903:1: rule__Class__StructuralFeaturesAssignment_5 : ( ruleStructuralFeature ) ;
    public final void rule__Class__StructuralFeaturesAssignment_5() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1907:1: ( ( ruleStructuralFeature ) )
            // InternalKM3.g:1908:2: ( ruleStructuralFeature )
            {
            // InternalKM3.g:1908:2: ( ruleStructuralFeature )
            // InternalKM3.g:1909:3: ruleStructuralFeature
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
    // InternalKM3.g:1918:1: rule__Attribute__IsUniqueAssignment_0 : ( ( 'unique' ) ) ;
    public final void rule__Attribute__IsUniqueAssignment_0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1922:1: ( ( ( 'unique' ) ) )
            // InternalKM3.g:1923:2: ( ( 'unique' ) )
            {
            // InternalKM3.g:1923:2: ( ( 'unique' ) )
            // InternalKM3.g:1924:3: ( 'unique' )
            {
             before(grammarAccess.getAttributeAccess().getIsUniqueUniqueKeyword_0_0()); 
            // InternalKM3.g:1925:3: ( 'unique' )
            // InternalKM3.g:1926:4: 'unique'
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
    // InternalKM3.g:1937:1: rule__Attribute__NameAssignment_2 : ( RULE_ID ) ;
    public final void rule__Attribute__NameAssignment_2() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1941:1: ( ( RULE_ID ) )
            // InternalKM3.g:1942:2: ( RULE_ID )
            {
            // InternalKM3.g:1942:2: ( RULE_ID )
            // InternalKM3.g:1943:3: RULE_ID
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
    // InternalKM3.g:1952:1: rule__Attribute__LowerAssignment_3_1_0 : ( ruleElementBound ) ;
    public final void rule__Attribute__LowerAssignment_3_1_0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1956:1: ( ( ruleElementBound ) )
            // InternalKM3.g:1957:2: ( ruleElementBound )
            {
            // InternalKM3.g:1957:2: ( ruleElementBound )
            // InternalKM3.g:1958:3: ruleElementBound
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
    // InternalKM3.g:1967:1: rule__Attribute__UpperAssignment_3_2 : ( ruleElementBound ) ;
    public final void rule__Attribute__UpperAssignment_3_2() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1971:1: ( ( ruleElementBound ) )
            // InternalKM3.g:1972:2: ( ruleElementBound )
            {
            // InternalKM3.g:1972:2: ( ruleElementBound )
            // InternalKM3.g:1973:3: ruleElementBound
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
    // InternalKM3.g:1982:1: rule__Attribute__IsOrderedAssignment_4 : ( ( 'ordered' ) ) ;
    public final void rule__Attribute__IsOrderedAssignment_4() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1986:1: ( ( ( 'ordered' ) ) )
            // InternalKM3.g:1987:2: ( ( 'ordered' ) )
            {
            // InternalKM3.g:1987:2: ( ( 'ordered' ) )
            // InternalKM3.g:1988:3: ( 'ordered' )
            {
             before(grammarAccess.getAttributeAccess().getIsOrderedOrderedKeyword_4_0()); 
            // InternalKM3.g:1989:3: ( 'ordered' )
            // InternalKM3.g:1990:4: 'ordered'
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
    // InternalKM3.g:2001:1: rule__Attribute__TypeAssignment_6 : ( ( RULE_ID ) ) ;
    public final void rule__Attribute__TypeAssignment_6() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:2005:1: ( ( ( RULE_ID ) ) )
            // InternalKM3.g:2006:2: ( ( RULE_ID ) )
            {
            // InternalKM3.g:2006:2: ( ( RULE_ID ) )
            // InternalKM3.g:2007:3: ( RULE_ID )
            {
             before(grammarAccess.getAttributeAccess().getTypeClassifierCrossReference_6_0()); 
            // InternalKM3.g:2008:3: ( RULE_ID )
            // InternalKM3.g:2009:4: RULE_ID
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
    // InternalKM3.g:2020:1: rule__Reference__NameAssignment_1 : ( RULE_ID ) ;
    public final void rule__Reference__NameAssignment_1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:2024:1: ( ( RULE_ID ) )
            // InternalKM3.g:2025:2: ( RULE_ID )
            {
            // InternalKM3.g:2025:2: ( RULE_ID )
            // InternalKM3.g:2026:3: RULE_ID
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
    // InternalKM3.g:2035:1: rule__Reference__LowerAssignment_2_1_0 : ( ruleElementBound ) ;
    public final void rule__Reference__LowerAssignment_2_1_0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:2039:1: ( ( ruleElementBound ) )
            // InternalKM3.g:2040:2: ( ruleElementBound )
            {
            // InternalKM3.g:2040:2: ( ruleElementBound )
            // InternalKM3.g:2041:3: ruleElementBound
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
    // InternalKM3.g:2050:1: rule__Reference__UpperAssignment_2_2 : ( ruleElementBound ) ;
    public final void rule__Reference__UpperAssignment_2_2() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:2054:1: ( ( ruleElementBound ) )
            // InternalKM3.g:2055:2: ( ruleElementBound )
            {
            // InternalKM3.g:2055:2: ( ruleElementBound )
            // InternalKM3.g:2056:3: ruleElementBound
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
    // InternalKM3.g:2065:1: rule__Reference__IsOrderedAssignment_3 : ( ( 'ordered' ) ) ;
    public final void rule__Reference__IsOrderedAssignment_3() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:2069:1: ( ( ( 'ordered' ) ) )
            // InternalKM3.g:2070:2: ( ( 'ordered' ) )
            {
            // InternalKM3.g:2070:2: ( ( 'ordered' ) )
            // InternalKM3.g:2071:3: ( 'ordered' )
            {
             before(grammarAccess.getReferenceAccess().getIsOrderedOrderedKeyword_3_0()); 
            // InternalKM3.g:2072:3: ( 'ordered' )
            // InternalKM3.g:2073:4: 'ordered'
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
    // InternalKM3.g:2084:1: rule__Reference__IsContainerAssignment_4 : ( ( 'container' ) ) ;
    public final void rule__Reference__IsContainerAssignment_4() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:2088:1: ( ( ( 'container' ) ) )
            // InternalKM3.g:2089:2: ( ( 'container' ) )
            {
            // InternalKM3.g:2089:2: ( ( 'container' ) )
            // InternalKM3.g:2090:3: ( 'container' )
            {
             before(grammarAccess.getReferenceAccess().getIsContainerContainerKeyword_4_0()); 
            // InternalKM3.g:2091:3: ( 'container' )
            // InternalKM3.g:2092:4: 'container'
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
    // InternalKM3.g:2103:1: rule__Reference__TypeAssignment_6 : ( ( RULE_ID ) ) ;
    public final void rule__Reference__TypeAssignment_6() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:2107:1: ( ( ( RULE_ID ) ) )
            // InternalKM3.g:2108:2: ( ( RULE_ID ) )
            {
            // InternalKM3.g:2108:2: ( ( RULE_ID ) )
            // InternalKM3.g:2109:3: ( RULE_ID )
            {
             before(grammarAccess.getReferenceAccess().getTypeClassifierCrossReference_6_0()); 
            // InternalKM3.g:2110:3: ( RULE_ID )
            // InternalKM3.g:2111:4: RULE_ID
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
    // InternalKM3.g:2122:1: rule__Reference__OppositeAssignment_7_1 : ( ( RULE_ID ) ) ;
    public final void rule__Reference__OppositeAssignment_7_1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:2126:1: ( ( ( RULE_ID ) ) )
            // InternalKM3.g:2127:2: ( ( RULE_ID ) )
            {
            // InternalKM3.g:2127:2: ( ( RULE_ID ) )
            // InternalKM3.g:2128:3: ( RULE_ID )
            {
             before(grammarAccess.getReferenceAccess().getOppositeReferenceCrossReference_7_1_0()); 
            // InternalKM3.g:2129:3: ( RULE_ID )
            // InternalKM3.g:2130:4: RULE_ID
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
    public static final BitSet FOLLOW_3 = new BitSet(new long[]{0x0000000000002000L});
    public static final BitSet FOLLOW_4 = new BitSet(new long[]{0x0000000000002002L});
    public static final BitSet FOLLOW_5 = new BitSet(new long[]{0x0000000000000020L});
    public static final BitSet FOLLOW_6 = new BitSet(new long[]{0x0000000000004000L});
    public static final BitSet FOLLOW_7 = new BitSet(new long[]{0x0000000010058000L});
    public static final BitSet FOLLOW_8 = new BitSet(new long[]{0x0000000010050002L});
    public static final BitSet FOLLOW_9 = new BitSet(new long[]{0x0000000000020000L});
    public static final BitSet FOLLOW_10 = new BitSet(new long[]{0x0000000010050000L});
    public static final BitSet FOLLOW_11 = new BitSet(new long[]{0x0000000000084000L});
    public static final BitSet FOLLOW_12 = new BitSet(new long[]{0x0000000024208000L});
    public static final BitSet FOLLOW_13 = new BitSet(new long[]{0x0000000024200002L});
    public static final BitSet FOLLOW_14 = new BitSet(new long[]{0x0000000000100000L});
    public static final BitSet FOLLOW_15 = new BitSet(new long[]{0x0000000000100002L});
    public static final BitSet FOLLOW_16 = new BitSet(new long[]{0x0000000020200000L});
    public static final BitSet FOLLOW_17 = new BitSet(new long[]{0x0000000040C00000L});
    public static final BitSet FOLLOW_18 = new BitSet(new long[]{0x0000000000001010L});
    public static final BitSet FOLLOW_19 = new BitSet(new long[]{0x0000000001000000L});
    public static final BitSet FOLLOW_20 = new BitSet(new long[]{0x0000000002000000L});
    public static final BitSet FOLLOW_21 = new BitSet(new long[]{0x00000000C0C00000L});
    public static final BitSet FOLLOW_22 = new BitSet(new long[]{0x0000000008020000L});

}