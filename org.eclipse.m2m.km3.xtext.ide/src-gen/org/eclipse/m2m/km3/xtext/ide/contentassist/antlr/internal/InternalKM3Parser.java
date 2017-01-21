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
        "<invalid>", "<EOR>", "<DOWN>", "<UP>", "RULE_ID", "RULE_COMMENT", "RULE_INT", "RULE_STRING", "RULE_ML_COMMENT", "RULE_SL_COMMENT", "RULE_WS", "RULE_ANY_OTHER", "'package'", "'{'", "'}'", "'datatype'", "';'", "'class'", "'extends'", "','", "'attribute'", "':'", "'reference'", "'oppositeOf'", "'abstract'", "'unique'", "'ordered'", "'container'"
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
    public static final int RULE_INT=6;
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


    // $ANTLR start "rule__ModelElement__Alternatives"
    // InternalKM3.g:227:1: rule__ModelElement__Alternatives : ( ( ruleDataType ) | ( ruleClass ) );
    public final void rule__ModelElement__Alternatives() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:231:1: ( ( ruleDataType ) | ( ruleClass ) )
            int alt1=2;
            int LA1_0 = input.LA(1);

            if ( (LA1_0==15) ) {
                alt1=1;
            }
            else if ( (LA1_0==17||LA1_0==24) ) {
                alt1=2;
            }
            else {
                NoViableAltException nvae =
                    new NoViableAltException("", 1, 0, input);

                throw nvae;
            }
            switch (alt1) {
                case 1 :
                    // InternalKM3.g:232:2: ( ruleDataType )
                    {
                    // InternalKM3.g:232:2: ( ruleDataType )
                    // InternalKM3.g:233:3: ruleDataType
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
                    // InternalKM3.g:238:2: ( ruleClass )
                    {
                    // InternalKM3.g:238:2: ( ruleClass )
                    // InternalKM3.g:239:3: ruleClass
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
    // InternalKM3.g:248:1: rule__StructuralFeature__Alternatives : ( ( ruleAttribute ) | ( ruleReference ) );
    public final void rule__StructuralFeature__Alternatives() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:252:1: ( ( ruleAttribute ) | ( ruleReference ) )
            int alt2=2;
            int LA2_0 = input.LA(1);

            if ( (LA2_0==20||LA2_0==25) ) {
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
                    // InternalKM3.g:253:2: ( ruleAttribute )
                    {
                    // InternalKM3.g:253:2: ( ruleAttribute )
                    // InternalKM3.g:254:3: ruleAttribute
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
                    // InternalKM3.g:259:2: ( ruleReference )
                    {
                    // InternalKM3.g:259:2: ( ruleReference )
                    // InternalKM3.g:260:3: ruleReference
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


    // $ANTLR start "rule__Package__Group__0"
    // InternalKM3.g:269:1: rule__Package__Group__0 : rule__Package__Group__0__Impl rule__Package__Group__1 ;
    public final void rule__Package__Group__0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:273:1: ( rule__Package__Group__0__Impl rule__Package__Group__1 )
            // InternalKM3.g:274:2: rule__Package__Group__0__Impl rule__Package__Group__1
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
    // InternalKM3.g:281:1: rule__Package__Group__0__Impl : ( 'package' ) ;
    public final void rule__Package__Group__0__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:285:1: ( ( 'package' ) )
            // InternalKM3.g:286:1: ( 'package' )
            {
            // InternalKM3.g:286:1: ( 'package' )
            // InternalKM3.g:287:2: 'package'
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
    // InternalKM3.g:296:1: rule__Package__Group__1 : rule__Package__Group__1__Impl rule__Package__Group__2 ;
    public final void rule__Package__Group__1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:300:1: ( rule__Package__Group__1__Impl rule__Package__Group__2 )
            // InternalKM3.g:301:2: rule__Package__Group__1__Impl rule__Package__Group__2
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
    // InternalKM3.g:308:1: rule__Package__Group__1__Impl : ( ( rule__Package__NameAssignment_1 ) ) ;
    public final void rule__Package__Group__1__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:312:1: ( ( ( rule__Package__NameAssignment_1 ) ) )
            // InternalKM3.g:313:1: ( ( rule__Package__NameAssignment_1 ) )
            {
            // InternalKM3.g:313:1: ( ( rule__Package__NameAssignment_1 ) )
            // InternalKM3.g:314:2: ( rule__Package__NameAssignment_1 )
            {
             before(grammarAccess.getPackageAccess().getNameAssignment_1()); 
            // InternalKM3.g:315:2: ( rule__Package__NameAssignment_1 )
            // InternalKM3.g:315:3: rule__Package__NameAssignment_1
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
    // InternalKM3.g:323:1: rule__Package__Group__2 : rule__Package__Group__2__Impl rule__Package__Group__3 ;
    public final void rule__Package__Group__2() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:327:1: ( rule__Package__Group__2__Impl rule__Package__Group__3 )
            // InternalKM3.g:328:2: rule__Package__Group__2__Impl rule__Package__Group__3
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
    // InternalKM3.g:335:1: rule__Package__Group__2__Impl : ( '{' ) ;
    public final void rule__Package__Group__2__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:339:1: ( ( '{' ) )
            // InternalKM3.g:340:1: ( '{' )
            {
            // InternalKM3.g:340:1: ( '{' )
            // InternalKM3.g:341:2: '{'
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
    // InternalKM3.g:350:1: rule__Package__Group__3 : rule__Package__Group__3__Impl rule__Package__Group__4 ;
    public final void rule__Package__Group__3() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:354:1: ( rule__Package__Group__3__Impl rule__Package__Group__4 )
            // InternalKM3.g:355:2: rule__Package__Group__3__Impl rule__Package__Group__4
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
    // InternalKM3.g:362:1: rule__Package__Group__3__Impl : ( ( rule__Package__ContentsAssignment_3 )* ) ;
    public final void rule__Package__Group__3__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:366:1: ( ( ( rule__Package__ContentsAssignment_3 )* ) )
            // InternalKM3.g:367:1: ( ( rule__Package__ContentsAssignment_3 )* )
            {
            // InternalKM3.g:367:1: ( ( rule__Package__ContentsAssignment_3 )* )
            // InternalKM3.g:368:2: ( rule__Package__ContentsAssignment_3 )*
            {
             before(grammarAccess.getPackageAccess().getContentsAssignment_3()); 
            // InternalKM3.g:369:2: ( rule__Package__ContentsAssignment_3 )*
            loop3:
            do {
                int alt3=2;
                int LA3_0 = input.LA(1);

                if ( (LA3_0==15||LA3_0==17||LA3_0==24) ) {
                    alt3=1;
                }


                switch (alt3) {
            	case 1 :
            	    // InternalKM3.g:369:3: rule__Package__ContentsAssignment_3
            	    {
            	    pushFollow(FOLLOW_6);
            	    rule__Package__ContentsAssignment_3();

            	    state._fsp--;


            	    }
            	    break;

            	default :
            	    break loop3;
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
    // InternalKM3.g:377:1: rule__Package__Group__4 : rule__Package__Group__4__Impl ;
    public final void rule__Package__Group__4() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:381:1: ( rule__Package__Group__4__Impl )
            // InternalKM3.g:382:2: rule__Package__Group__4__Impl
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
    // InternalKM3.g:388:1: rule__Package__Group__4__Impl : ( '}' ) ;
    public final void rule__Package__Group__4__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:392:1: ( ( '}' ) )
            // InternalKM3.g:393:1: ( '}' )
            {
            // InternalKM3.g:393:1: ( '}' )
            // InternalKM3.g:394:2: '}'
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
    // InternalKM3.g:404:1: rule__DataType__Group__0 : rule__DataType__Group__0__Impl rule__DataType__Group__1 ;
    public final void rule__DataType__Group__0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:408:1: ( rule__DataType__Group__0__Impl rule__DataType__Group__1 )
            // InternalKM3.g:409:2: rule__DataType__Group__0__Impl rule__DataType__Group__1
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
    // InternalKM3.g:416:1: rule__DataType__Group__0__Impl : ( 'datatype' ) ;
    public final void rule__DataType__Group__0__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:420:1: ( ( 'datatype' ) )
            // InternalKM3.g:421:1: ( 'datatype' )
            {
            // InternalKM3.g:421:1: ( 'datatype' )
            // InternalKM3.g:422:2: 'datatype'
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
    // InternalKM3.g:431:1: rule__DataType__Group__1 : rule__DataType__Group__1__Impl rule__DataType__Group__2 ;
    public final void rule__DataType__Group__1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:435:1: ( rule__DataType__Group__1__Impl rule__DataType__Group__2 )
            // InternalKM3.g:436:2: rule__DataType__Group__1__Impl rule__DataType__Group__2
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
    // InternalKM3.g:443:1: rule__DataType__Group__1__Impl : ( ( rule__DataType__NameAssignment_1 ) ) ;
    public final void rule__DataType__Group__1__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:447:1: ( ( ( rule__DataType__NameAssignment_1 ) ) )
            // InternalKM3.g:448:1: ( ( rule__DataType__NameAssignment_1 ) )
            {
            // InternalKM3.g:448:1: ( ( rule__DataType__NameAssignment_1 ) )
            // InternalKM3.g:449:2: ( rule__DataType__NameAssignment_1 )
            {
             before(grammarAccess.getDataTypeAccess().getNameAssignment_1()); 
            // InternalKM3.g:450:2: ( rule__DataType__NameAssignment_1 )
            // InternalKM3.g:450:3: rule__DataType__NameAssignment_1
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
    // InternalKM3.g:458:1: rule__DataType__Group__2 : rule__DataType__Group__2__Impl ;
    public final void rule__DataType__Group__2() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:462:1: ( rule__DataType__Group__2__Impl )
            // InternalKM3.g:463:2: rule__DataType__Group__2__Impl
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
    // InternalKM3.g:469:1: rule__DataType__Group__2__Impl : ( ';' ) ;
    public final void rule__DataType__Group__2__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:473:1: ( ( ';' ) )
            // InternalKM3.g:474:1: ( ';' )
            {
            // InternalKM3.g:474:1: ( ';' )
            // InternalKM3.g:475:2: ';'
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
    // InternalKM3.g:485:1: rule__Class__Group__0 : rule__Class__Group__0__Impl rule__Class__Group__1 ;
    public final void rule__Class__Group__0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:489:1: ( rule__Class__Group__0__Impl rule__Class__Group__1 )
            // InternalKM3.g:490:2: rule__Class__Group__0__Impl rule__Class__Group__1
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
    // InternalKM3.g:497:1: rule__Class__Group__0__Impl : ( ( rule__Class__IsAbstractAssignment_0 )? ) ;
    public final void rule__Class__Group__0__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:501:1: ( ( ( rule__Class__IsAbstractAssignment_0 )? ) )
            // InternalKM3.g:502:1: ( ( rule__Class__IsAbstractAssignment_0 )? )
            {
            // InternalKM3.g:502:1: ( ( rule__Class__IsAbstractAssignment_0 )? )
            // InternalKM3.g:503:2: ( rule__Class__IsAbstractAssignment_0 )?
            {
             before(grammarAccess.getClassAccess().getIsAbstractAssignment_0()); 
            // InternalKM3.g:504:2: ( rule__Class__IsAbstractAssignment_0 )?
            int alt4=2;
            int LA4_0 = input.LA(1);

            if ( (LA4_0==24) ) {
                alt4=1;
            }
            switch (alt4) {
                case 1 :
                    // InternalKM3.g:504:3: rule__Class__IsAbstractAssignment_0
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
    // InternalKM3.g:512:1: rule__Class__Group__1 : rule__Class__Group__1__Impl rule__Class__Group__2 ;
    public final void rule__Class__Group__1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:516:1: ( rule__Class__Group__1__Impl rule__Class__Group__2 )
            // InternalKM3.g:517:2: rule__Class__Group__1__Impl rule__Class__Group__2
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
    // InternalKM3.g:524:1: rule__Class__Group__1__Impl : ( 'class' ) ;
    public final void rule__Class__Group__1__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:528:1: ( ( 'class' ) )
            // InternalKM3.g:529:1: ( 'class' )
            {
            // InternalKM3.g:529:1: ( 'class' )
            // InternalKM3.g:530:2: 'class'
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
    // InternalKM3.g:539:1: rule__Class__Group__2 : rule__Class__Group__2__Impl rule__Class__Group__3 ;
    public final void rule__Class__Group__2() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:543:1: ( rule__Class__Group__2__Impl rule__Class__Group__3 )
            // InternalKM3.g:544:2: rule__Class__Group__2__Impl rule__Class__Group__3
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
    // InternalKM3.g:551:1: rule__Class__Group__2__Impl : ( ( rule__Class__NameAssignment_2 ) ) ;
    public final void rule__Class__Group__2__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:555:1: ( ( ( rule__Class__NameAssignment_2 ) ) )
            // InternalKM3.g:556:1: ( ( rule__Class__NameAssignment_2 ) )
            {
            // InternalKM3.g:556:1: ( ( rule__Class__NameAssignment_2 ) )
            // InternalKM3.g:557:2: ( rule__Class__NameAssignment_2 )
            {
             before(grammarAccess.getClassAccess().getNameAssignment_2()); 
            // InternalKM3.g:558:2: ( rule__Class__NameAssignment_2 )
            // InternalKM3.g:558:3: rule__Class__NameAssignment_2
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
    // InternalKM3.g:566:1: rule__Class__Group__3 : rule__Class__Group__3__Impl rule__Class__Group__4 ;
    public final void rule__Class__Group__3() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:570:1: ( rule__Class__Group__3__Impl rule__Class__Group__4 )
            // InternalKM3.g:571:2: rule__Class__Group__3__Impl rule__Class__Group__4
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
    // InternalKM3.g:578:1: rule__Class__Group__3__Impl : ( ( rule__Class__Group_3__0 )? ) ;
    public final void rule__Class__Group__3__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:582:1: ( ( ( rule__Class__Group_3__0 )? ) )
            // InternalKM3.g:583:1: ( ( rule__Class__Group_3__0 )? )
            {
            // InternalKM3.g:583:1: ( ( rule__Class__Group_3__0 )? )
            // InternalKM3.g:584:2: ( rule__Class__Group_3__0 )?
            {
             before(grammarAccess.getClassAccess().getGroup_3()); 
            // InternalKM3.g:585:2: ( rule__Class__Group_3__0 )?
            int alt5=2;
            int LA5_0 = input.LA(1);

            if ( (LA5_0==18) ) {
                alt5=1;
            }
            switch (alt5) {
                case 1 :
                    // InternalKM3.g:585:3: rule__Class__Group_3__0
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
    // InternalKM3.g:593:1: rule__Class__Group__4 : rule__Class__Group__4__Impl rule__Class__Group__5 ;
    public final void rule__Class__Group__4() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:597:1: ( rule__Class__Group__4__Impl rule__Class__Group__5 )
            // InternalKM3.g:598:2: rule__Class__Group__4__Impl rule__Class__Group__5
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
    // InternalKM3.g:605:1: rule__Class__Group__4__Impl : ( '{' ) ;
    public final void rule__Class__Group__4__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:609:1: ( ( '{' ) )
            // InternalKM3.g:610:1: ( '{' )
            {
            // InternalKM3.g:610:1: ( '{' )
            // InternalKM3.g:611:2: '{'
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
    // InternalKM3.g:620:1: rule__Class__Group__5 : rule__Class__Group__5__Impl rule__Class__Group__6 ;
    public final void rule__Class__Group__5() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:624:1: ( rule__Class__Group__5__Impl rule__Class__Group__6 )
            // InternalKM3.g:625:2: rule__Class__Group__5__Impl rule__Class__Group__6
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
    // InternalKM3.g:632:1: rule__Class__Group__5__Impl : ( ( rule__Class__StructuralFeaturesAssignment_5 )* ) ;
    public final void rule__Class__Group__5__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:636:1: ( ( ( rule__Class__StructuralFeaturesAssignment_5 )* ) )
            // InternalKM3.g:637:1: ( ( rule__Class__StructuralFeaturesAssignment_5 )* )
            {
            // InternalKM3.g:637:1: ( ( rule__Class__StructuralFeaturesAssignment_5 )* )
            // InternalKM3.g:638:2: ( rule__Class__StructuralFeaturesAssignment_5 )*
            {
             before(grammarAccess.getClassAccess().getStructuralFeaturesAssignment_5()); 
            // InternalKM3.g:639:2: ( rule__Class__StructuralFeaturesAssignment_5 )*
            loop6:
            do {
                int alt6=2;
                int LA6_0 = input.LA(1);

                if ( (LA6_0==20||LA6_0==22||LA6_0==25) ) {
                    alt6=1;
                }


                switch (alt6) {
            	case 1 :
            	    // InternalKM3.g:639:3: rule__Class__StructuralFeaturesAssignment_5
            	    {
            	    pushFollow(FOLLOW_11);
            	    rule__Class__StructuralFeaturesAssignment_5();

            	    state._fsp--;


            	    }
            	    break;

            	default :
            	    break loop6;
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
    // InternalKM3.g:647:1: rule__Class__Group__6 : rule__Class__Group__6__Impl ;
    public final void rule__Class__Group__6() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:651:1: ( rule__Class__Group__6__Impl )
            // InternalKM3.g:652:2: rule__Class__Group__6__Impl
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
    // InternalKM3.g:658:1: rule__Class__Group__6__Impl : ( '}' ) ;
    public final void rule__Class__Group__6__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:662:1: ( ( '}' ) )
            // InternalKM3.g:663:1: ( '}' )
            {
            // InternalKM3.g:663:1: ( '}' )
            // InternalKM3.g:664:2: '}'
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
    // InternalKM3.g:674:1: rule__Class__Group_3__0 : rule__Class__Group_3__0__Impl rule__Class__Group_3__1 ;
    public final void rule__Class__Group_3__0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:678:1: ( rule__Class__Group_3__0__Impl rule__Class__Group_3__1 )
            // InternalKM3.g:679:2: rule__Class__Group_3__0__Impl rule__Class__Group_3__1
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
    // InternalKM3.g:686:1: rule__Class__Group_3__0__Impl : ( 'extends' ) ;
    public final void rule__Class__Group_3__0__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:690:1: ( ( 'extends' ) )
            // InternalKM3.g:691:1: ( 'extends' )
            {
            // InternalKM3.g:691:1: ( 'extends' )
            // InternalKM3.g:692:2: 'extends'
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
    // InternalKM3.g:701:1: rule__Class__Group_3__1 : rule__Class__Group_3__1__Impl rule__Class__Group_3__2 ;
    public final void rule__Class__Group_3__1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:705:1: ( rule__Class__Group_3__1__Impl rule__Class__Group_3__2 )
            // InternalKM3.g:706:2: rule__Class__Group_3__1__Impl rule__Class__Group_3__2
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
    // InternalKM3.g:713:1: rule__Class__Group_3__1__Impl : ( ( rule__Class__SupertypesAssignment_3_1 ) ) ;
    public final void rule__Class__Group_3__1__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:717:1: ( ( ( rule__Class__SupertypesAssignment_3_1 ) ) )
            // InternalKM3.g:718:1: ( ( rule__Class__SupertypesAssignment_3_1 ) )
            {
            // InternalKM3.g:718:1: ( ( rule__Class__SupertypesAssignment_3_1 ) )
            // InternalKM3.g:719:2: ( rule__Class__SupertypesAssignment_3_1 )
            {
             before(grammarAccess.getClassAccess().getSupertypesAssignment_3_1()); 
            // InternalKM3.g:720:2: ( rule__Class__SupertypesAssignment_3_1 )
            // InternalKM3.g:720:3: rule__Class__SupertypesAssignment_3_1
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
    // InternalKM3.g:728:1: rule__Class__Group_3__2 : rule__Class__Group_3__2__Impl ;
    public final void rule__Class__Group_3__2() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:732:1: ( rule__Class__Group_3__2__Impl )
            // InternalKM3.g:733:2: rule__Class__Group_3__2__Impl
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
    // InternalKM3.g:739:1: rule__Class__Group_3__2__Impl : ( ( rule__Class__Group_3_2__0 )* ) ;
    public final void rule__Class__Group_3__2__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:743:1: ( ( ( rule__Class__Group_3_2__0 )* ) )
            // InternalKM3.g:744:1: ( ( rule__Class__Group_3_2__0 )* )
            {
            // InternalKM3.g:744:1: ( ( rule__Class__Group_3_2__0 )* )
            // InternalKM3.g:745:2: ( rule__Class__Group_3_2__0 )*
            {
             before(grammarAccess.getClassAccess().getGroup_3_2()); 
            // InternalKM3.g:746:2: ( rule__Class__Group_3_2__0 )*
            loop7:
            do {
                int alt7=2;
                int LA7_0 = input.LA(1);

                if ( (LA7_0==19) ) {
                    alt7=1;
                }


                switch (alt7) {
            	case 1 :
            	    // InternalKM3.g:746:3: rule__Class__Group_3_2__0
            	    {
            	    pushFollow(FOLLOW_13);
            	    rule__Class__Group_3_2__0();

            	    state._fsp--;


            	    }
            	    break;

            	default :
            	    break loop7;
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
    // InternalKM3.g:755:1: rule__Class__Group_3_2__0 : rule__Class__Group_3_2__0__Impl rule__Class__Group_3_2__1 ;
    public final void rule__Class__Group_3_2__0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:759:1: ( rule__Class__Group_3_2__0__Impl rule__Class__Group_3_2__1 )
            // InternalKM3.g:760:2: rule__Class__Group_3_2__0__Impl rule__Class__Group_3_2__1
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
    // InternalKM3.g:767:1: rule__Class__Group_3_2__0__Impl : ( ',' ) ;
    public final void rule__Class__Group_3_2__0__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:771:1: ( ( ',' ) )
            // InternalKM3.g:772:1: ( ',' )
            {
            // InternalKM3.g:772:1: ( ',' )
            // InternalKM3.g:773:2: ','
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
    // InternalKM3.g:782:1: rule__Class__Group_3_2__1 : rule__Class__Group_3_2__1__Impl ;
    public final void rule__Class__Group_3_2__1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:786:1: ( rule__Class__Group_3_2__1__Impl )
            // InternalKM3.g:787:2: rule__Class__Group_3_2__1__Impl
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
    // InternalKM3.g:793:1: rule__Class__Group_3_2__1__Impl : ( ( rule__Class__SupertypesAssignment_3_2_1 ) ) ;
    public final void rule__Class__Group_3_2__1__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:797:1: ( ( ( rule__Class__SupertypesAssignment_3_2_1 ) ) )
            // InternalKM3.g:798:1: ( ( rule__Class__SupertypesAssignment_3_2_1 ) )
            {
            // InternalKM3.g:798:1: ( ( rule__Class__SupertypesAssignment_3_2_1 ) )
            // InternalKM3.g:799:2: ( rule__Class__SupertypesAssignment_3_2_1 )
            {
             before(grammarAccess.getClassAccess().getSupertypesAssignment_3_2_1()); 
            // InternalKM3.g:800:2: ( rule__Class__SupertypesAssignment_3_2_1 )
            // InternalKM3.g:800:3: rule__Class__SupertypesAssignment_3_2_1
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
    // InternalKM3.g:809:1: rule__Attribute__Group__0 : rule__Attribute__Group__0__Impl rule__Attribute__Group__1 ;
    public final void rule__Attribute__Group__0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:813:1: ( rule__Attribute__Group__0__Impl rule__Attribute__Group__1 )
            // InternalKM3.g:814:2: rule__Attribute__Group__0__Impl rule__Attribute__Group__1
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
    // InternalKM3.g:821:1: rule__Attribute__Group__0__Impl : ( ( rule__Attribute__IsUniqueAssignment_0 )? ) ;
    public final void rule__Attribute__Group__0__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:825:1: ( ( ( rule__Attribute__IsUniqueAssignment_0 )? ) )
            // InternalKM3.g:826:1: ( ( rule__Attribute__IsUniqueAssignment_0 )? )
            {
            // InternalKM3.g:826:1: ( ( rule__Attribute__IsUniqueAssignment_0 )? )
            // InternalKM3.g:827:2: ( rule__Attribute__IsUniqueAssignment_0 )?
            {
             before(grammarAccess.getAttributeAccess().getIsUniqueAssignment_0()); 
            // InternalKM3.g:828:2: ( rule__Attribute__IsUniqueAssignment_0 )?
            int alt8=2;
            int LA8_0 = input.LA(1);

            if ( (LA8_0==25) ) {
                alt8=1;
            }
            switch (alt8) {
                case 1 :
                    // InternalKM3.g:828:3: rule__Attribute__IsUniqueAssignment_0
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
    // InternalKM3.g:836:1: rule__Attribute__Group__1 : rule__Attribute__Group__1__Impl rule__Attribute__Group__2 ;
    public final void rule__Attribute__Group__1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:840:1: ( rule__Attribute__Group__1__Impl rule__Attribute__Group__2 )
            // InternalKM3.g:841:2: rule__Attribute__Group__1__Impl rule__Attribute__Group__2
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
    // InternalKM3.g:848:1: rule__Attribute__Group__1__Impl : ( 'attribute' ) ;
    public final void rule__Attribute__Group__1__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:852:1: ( ( 'attribute' ) )
            // InternalKM3.g:853:1: ( 'attribute' )
            {
            // InternalKM3.g:853:1: ( 'attribute' )
            // InternalKM3.g:854:2: 'attribute'
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
    // InternalKM3.g:863:1: rule__Attribute__Group__2 : rule__Attribute__Group__2__Impl rule__Attribute__Group__3 ;
    public final void rule__Attribute__Group__2() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:867:1: ( rule__Attribute__Group__2__Impl rule__Attribute__Group__3 )
            // InternalKM3.g:868:2: rule__Attribute__Group__2__Impl rule__Attribute__Group__3
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
    // InternalKM3.g:875:1: rule__Attribute__Group__2__Impl : ( ( rule__Attribute__NameAssignment_2 ) ) ;
    public final void rule__Attribute__Group__2__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:879:1: ( ( ( rule__Attribute__NameAssignment_2 ) ) )
            // InternalKM3.g:880:1: ( ( rule__Attribute__NameAssignment_2 ) )
            {
            // InternalKM3.g:880:1: ( ( rule__Attribute__NameAssignment_2 ) )
            // InternalKM3.g:881:2: ( rule__Attribute__NameAssignment_2 )
            {
             before(grammarAccess.getAttributeAccess().getNameAssignment_2()); 
            // InternalKM3.g:882:2: ( rule__Attribute__NameAssignment_2 )
            // InternalKM3.g:882:3: rule__Attribute__NameAssignment_2
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
    // InternalKM3.g:890:1: rule__Attribute__Group__3 : rule__Attribute__Group__3__Impl rule__Attribute__Group__4 ;
    public final void rule__Attribute__Group__3() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:894:1: ( rule__Attribute__Group__3__Impl rule__Attribute__Group__4 )
            // InternalKM3.g:895:2: rule__Attribute__Group__3__Impl rule__Attribute__Group__4
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
    // InternalKM3.g:902:1: rule__Attribute__Group__3__Impl : ( ( rule__Attribute__IsOrderedAssignment_3 )? ) ;
    public final void rule__Attribute__Group__3__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:906:1: ( ( ( rule__Attribute__IsOrderedAssignment_3 )? ) )
            // InternalKM3.g:907:1: ( ( rule__Attribute__IsOrderedAssignment_3 )? )
            {
            // InternalKM3.g:907:1: ( ( rule__Attribute__IsOrderedAssignment_3 )? )
            // InternalKM3.g:908:2: ( rule__Attribute__IsOrderedAssignment_3 )?
            {
             before(grammarAccess.getAttributeAccess().getIsOrderedAssignment_3()); 
            // InternalKM3.g:909:2: ( rule__Attribute__IsOrderedAssignment_3 )?
            int alt9=2;
            int LA9_0 = input.LA(1);

            if ( (LA9_0==26) ) {
                alt9=1;
            }
            switch (alt9) {
                case 1 :
                    // InternalKM3.g:909:3: rule__Attribute__IsOrderedAssignment_3
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
    // InternalKM3.g:917:1: rule__Attribute__Group__4 : rule__Attribute__Group__4__Impl rule__Attribute__Group__5 ;
    public final void rule__Attribute__Group__4() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:921:1: ( rule__Attribute__Group__4__Impl rule__Attribute__Group__5 )
            // InternalKM3.g:922:2: rule__Attribute__Group__4__Impl rule__Attribute__Group__5
            {
            pushFollow(FOLLOW_3);
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
    // InternalKM3.g:929:1: rule__Attribute__Group__4__Impl : ( ':' ) ;
    public final void rule__Attribute__Group__4__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:933:1: ( ( ':' ) )
            // InternalKM3.g:934:1: ( ':' )
            {
            // InternalKM3.g:934:1: ( ':' )
            // InternalKM3.g:935:2: ':'
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
    // InternalKM3.g:944:1: rule__Attribute__Group__5 : rule__Attribute__Group__5__Impl rule__Attribute__Group__6 ;
    public final void rule__Attribute__Group__5() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:948:1: ( rule__Attribute__Group__5__Impl rule__Attribute__Group__6 )
            // InternalKM3.g:949:2: rule__Attribute__Group__5__Impl rule__Attribute__Group__6
            {
            pushFollow(FOLLOW_7);
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
    // InternalKM3.g:956:1: rule__Attribute__Group__5__Impl : ( ( rule__Attribute__TypeAssignment_5 ) ) ;
    public final void rule__Attribute__Group__5__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:960:1: ( ( ( rule__Attribute__TypeAssignment_5 ) ) )
            // InternalKM3.g:961:1: ( ( rule__Attribute__TypeAssignment_5 ) )
            {
            // InternalKM3.g:961:1: ( ( rule__Attribute__TypeAssignment_5 ) )
            // InternalKM3.g:962:2: ( rule__Attribute__TypeAssignment_5 )
            {
             before(grammarAccess.getAttributeAccess().getTypeAssignment_5()); 
            // InternalKM3.g:963:2: ( rule__Attribute__TypeAssignment_5 )
            // InternalKM3.g:963:3: rule__Attribute__TypeAssignment_5
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
    // InternalKM3.g:971:1: rule__Attribute__Group__6 : rule__Attribute__Group__6__Impl ;
    public final void rule__Attribute__Group__6() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:975:1: ( rule__Attribute__Group__6__Impl )
            // InternalKM3.g:976:2: rule__Attribute__Group__6__Impl
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
    // InternalKM3.g:982:1: rule__Attribute__Group__6__Impl : ( ';' ) ;
    public final void rule__Attribute__Group__6__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:986:1: ( ( ';' ) )
            // InternalKM3.g:987:1: ( ';' )
            {
            // InternalKM3.g:987:1: ( ';' )
            // InternalKM3.g:988:2: ';'
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
    // InternalKM3.g:998:1: rule__Reference__Group__0 : rule__Reference__Group__0__Impl rule__Reference__Group__1 ;
    public final void rule__Reference__Group__0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1002:1: ( rule__Reference__Group__0__Impl rule__Reference__Group__1 )
            // InternalKM3.g:1003:2: rule__Reference__Group__0__Impl rule__Reference__Group__1
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
    // InternalKM3.g:1010:1: rule__Reference__Group__0__Impl : ( 'reference' ) ;
    public final void rule__Reference__Group__0__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1014:1: ( ( 'reference' ) )
            // InternalKM3.g:1015:1: ( 'reference' )
            {
            // InternalKM3.g:1015:1: ( 'reference' )
            // InternalKM3.g:1016:2: 'reference'
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
    // InternalKM3.g:1025:1: rule__Reference__Group__1 : rule__Reference__Group__1__Impl rule__Reference__Group__2 ;
    public final void rule__Reference__Group__1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1029:1: ( rule__Reference__Group__1__Impl rule__Reference__Group__2 )
            // InternalKM3.g:1030:2: rule__Reference__Group__1__Impl rule__Reference__Group__2
            {
            pushFollow(FOLLOW_16);
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
    // InternalKM3.g:1037:1: rule__Reference__Group__1__Impl : ( ( rule__Reference__NameAssignment_1 ) ) ;
    public final void rule__Reference__Group__1__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1041:1: ( ( ( rule__Reference__NameAssignment_1 ) ) )
            // InternalKM3.g:1042:1: ( ( rule__Reference__NameAssignment_1 ) )
            {
            // InternalKM3.g:1042:1: ( ( rule__Reference__NameAssignment_1 ) )
            // InternalKM3.g:1043:2: ( rule__Reference__NameAssignment_1 )
            {
             before(grammarAccess.getReferenceAccess().getNameAssignment_1()); 
            // InternalKM3.g:1044:2: ( rule__Reference__NameAssignment_1 )
            // InternalKM3.g:1044:3: rule__Reference__NameAssignment_1
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
    // InternalKM3.g:1052:1: rule__Reference__Group__2 : rule__Reference__Group__2__Impl rule__Reference__Group__3 ;
    public final void rule__Reference__Group__2() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1056:1: ( rule__Reference__Group__2__Impl rule__Reference__Group__3 )
            // InternalKM3.g:1057:2: rule__Reference__Group__2__Impl rule__Reference__Group__3
            {
            pushFollow(FOLLOW_16);
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
    // InternalKM3.g:1064:1: rule__Reference__Group__2__Impl : ( ( rule__Reference__IsOrderedAssignment_2 )? ) ;
    public final void rule__Reference__Group__2__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1068:1: ( ( ( rule__Reference__IsOrderedAssignment_2 )? ) )
            // InternalKM3.g:1069:1: ( ( rule__Reference__IsOrderedAssignment_2 )? )
            {
            // InternalKM3.g:1069:1: ( ( rule__Reference__IsOrderedAssignment_2 )? )
            // InternalKM3.g:1070:2: ( rule__Reference__IsOrderedAssignment_2 )?
            {
             before(grammarAccess.getReferenceAccess().getIsOrderedAssignment_2()); 
            // InternalKM3.g:1071:2: ( rule__Reference__IsOrderedAssignment_2 )?
            int alt10=2;
            int LA10_0 = input.LA(1);

            if ( (LA10_0==26) ) {
                alt10=1;
            }
            switch (alt10) {
                case 1 :
                    // InternalKM3.g:1071:3: rule__Reference__IsOrderedAssignment_2
                    {
                    pushFollow(FOLLOW_2);
                    rule__Reference__IsOrderedAssignment_2();

                    state._fsp--;


                    }
                    break;

            }

             after(grammarAccess.getReferenceAccess().getIsOrderedAssignment_2()); 

            }


            }

        }
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
    // InternalKM3.g:1079:1: rule__Reference__Group__3 : rule__Reference__Group__3__Impl rule__Reference__Group__4 ;
    public final void rule__Reference__Group__3() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1083:1: ( rule__Reference__Group__3__Impl rule__Reference__Group__4 )
            // InternalKM3.g:1084:2: rule__Reference__Group__3__Impl rule__Reference__Group__4
            {
            pushFollow(FOLLOW_16);
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
    // InternalKM3.g:1091:1: rule__Reference__Group__3__Impl : ( ( rule__Reference__IsContainerAssignment_3 )? ) ;
    public final void rule__Reference__Group__3__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1095:1: ( ( ( rule__Reference__IsContainerAssignment_3 )? ) )
            // InternalKM3.g:1096:1: ( ( rule__Reference__IsContainerAssignment_3 )? )
            {
            // InternalKM3.g:1096:1: ( ( rule__Reference__IsContainerAssignment_3 )? )
            // InternalKM3.g:1097:2: ( rule__Reference__IsContainerAssignment_3 )?
            {
             before(grammarAccess.getReferenceAccess().getIsContainerAssignment_3()); 
            // InternalKM3.g:1098:2: ( rule__Reference__IsContainerAssignment_3 )?
            int alt11=2;
            int LA11_0 = input.LA(1);

            if ( (LA11_0==27) ) {
                alt11=1;
            }
            switch (alt11) {
                case 1 :
                    // InternalKM3.g:1098:3: rule__Reference__IsContainerAssignment_3
                    {
                    pushFollow(FOLLOW_2);
                    rule__Reference__IsContainerAssignment_3();

                    state._fsp--;


                    }
                    break;

            }

             after(grammarAccess.getReferenceAccess().getIsContainerAssignment_3()); 

            }


            }

        }
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
    // InternalKM3.g:1106:1: rule__Reference__Group__4 : rule__Reference__Group__4__Impl rule__Reference__Group__5 ;
    public final void rule__Reference__Group__4() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1110:1: ( rule__Reference__Group__4__Impl rule__Reference__Group__5 )
            // InternalKM3.g:1111:2: rule__Reference__Group__4__Impl rule__Reference__Group__5
            {
            pushFollow(FOLLOW_3);
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
    // InternalKM3.g:1118:1: rule__Reference__Group__4__Impl : ( ':' ) ;
    public final void rule__Reference__Group__4__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1122:1: ( ( ':' ) )
            // InternalKM3.g:1123:1: ( ':' )
            {
            // InternalKM3.g:1123:1: ( ':' )
            // InternalKM3.g:1124:2: ':'
            {
             before(grammarAccess.getReferenceAccess().getColonKeyword_4()); 
            match(input,21,FOLLOW_2); 
             after(grammarAccess.getReferenceAccess().getColonKeyword_4()); 

            }


            }

        }
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
    // InternalKM3.g:1133:1: rule__Reference__Group__5 : rule__Reference__Group__5__Impl rule__Reference__Group__6 ;
    public final void rule__Reference__Group__5() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1137:1: ( rule__Reference__Group__5__Impl rule__Reference__Group__6 )
            // InternalKM3.g:1138:2: rule__Reference__Group__5__Impl rule__Reference__Group__6
            {
            pushFollow(FOLLOW_17);
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
    // InternalKM3.g:1145:1: rule__Reference__Group__5__Impl : ( ( rule__Reference__TypeAssignment_5 ) ) ;
    public final void rule__Reference__Group__5__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1149:1: ( ( ( rule__Reference__TypeAssignment_5 ) ) )
            // InternalKM3.g:1150:1: ( ( rule__Reference__TypeAssignment_5 ) )
            {
            // InternalKM3.g:1150:1: ( ( rule__Reference__TypeAssignment_5 ) )
            // InternalKM3.g:1151:2: ( rule__Reference__TypeAssignment_5 )
            {
             before(grammarAccess.getReferenceAccess().getTypeAssignment_5()); 
            // InternalKM3.g:1152:2: ( rule__Reference__TypeAssignment_5 )
            // InternalKM3.g:1152:3: rule__Reference__TypeAssignment_5
            {
            pushFollow(FOLLOW_2);
            rule__Reference__TypeAssignment_5();

            state._fsp--;


            }

             after(grammarAccess.getReferenceAccess().getTypeAssignment_5()); 

            }


            }

        }
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
    // InternalKM3.g:1160:1: rule__Reference__Group__6 : rule__Reference__Group__6__Impl rule__Reference__Group__7 ;
    public final void rule__Reference__Group__6() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1164:1: ( rule__Reference__Group__6__Impl rule__Reference__Group__7 )
            // InternalKM3.g:1165:2: rule__Reference__Group__6__Impl rule__Reference__Group__7
            {
            pushFollow(FOLLOW_17);
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
    // InternalKM3.g:1172:1: rule__Reference__Group__6__Impl : ( ( rule__Reference__Group_6__0 )? ) ;
    public final void rule__Reference__Group__6__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1176:1: ( ( ( rule__Reference__Group_6__0 )? ) )
            // InternalKM3.g:1177:1: ( ( rule__Reference__Group_6__0 )? )
            {
            // InternalKM3.g:1177:1: ( ( rule__Reference__Group_6__0 )? )
            // InternalKM3.g:1178:2: ( rule__Reference__Group_6__0 )?
            {
             before(grammarAccess.getReferenceAccess().getGroup_6()); 
            // InternalKM3.g:1179:2: ( rule__Reference__Group_6__0 )?
            int alt12=2;
            int LA12_0 = input.LA(1);

            if ( (LA12_0==23) ) {
                alt12=1;
            }
            switch (alt12) {
                case 1 :
                    // InternalKM3.g:1179:3: rule__Reference__Group_6__0
                    {
                    pushFollow(FOLLOW_2);
                    rule__Reference__Group_6__0();

                    state._fsp--;


                    }
                    break;

            }

             after(grammarAccess.getReferenceAccess().getGroup_6()); 

            }


            }

        }
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
    // InternalKM3.g:1187:1: rule__Reference__Group__7 : rule__Reference__Group__7__Impl ;
    public final void rule__Reference__Group__7() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1191:1: ( rule__Reference__Group__7__Impl )
            // InternalKM3.g:1192:2: rule__Reference__Group__7__Impl
            {
            pushFollow(FOLLOW_2);
            rule__Reference__Group__7__Impl();

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
    // InternalKM3.g:1198:1: rule__Reference__Group__7__Impl : ( ';' ) ;
    public final void rule__Reference__Group__7__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1202:1: ( ( ';' ) )
            // InternalKM3.g:1203:1: ( ';' )
            {
            // InternalKM3.g:1203:1: ( ';' )
            // InternalKM3.g:1204:2: ';'
            {
             before(grammarAccess.getReferenceAccess().getSemicolonKeyword_7()); 
            match(input,16,FOLLOW_2); 
             after(grammarAccess.getReferenceAccess().getSemicolonKeyword_7()); 

            }


            }

        }
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


    // $ANTLR start "rule__Reference__Group_6__0"
    // InternalKM3.g:1214:1: rule__Reference__Group_6__0 : rule__Reference__Group_6__0__Impl rule__Reference__Group_6__1 ;
    public final void rule__Reference__Group_6__0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1218:1: ( rule__Reference__Group_6__0__Impl rule__Reference__Group_6__1 )
            // InternalKM3.g:1219:2: rule__Reference__Group_6__0__Impl rule__Reference__Group_6__1
            {
            pushFollow(FOLLOW_3);
            rule__Reference__Group_6__0__Impl();

            state._fsp--;

            pushFollow(FOLLOW_2);
            rule__Reference__Group_6__1();

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
    // $ANTLR end "rule__Reference__Group_6__0"


    // $ANTLR start "rule__Reference__Group_6__0__Impl"
    // InternalKM3.g:1226:1: rule__Reference__Group_6__0__Impl : ( 'oppositeOf' ) ;
    public final void rule__Reference__Group_6__0__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1230:1: ( ( 'oppositeOf' ) )
            // InternalKM3.g:1231:1: ( 'oppositeOf' )
            {
            // InternalKM3.g:1231:1: ( 'oppositeOf' )
            // InternalKM3.g:1232:2: 'oppositeOf'
            {
             before(grammarAccess.getReferenceAccess().getOppositeOfKeyword_6_0()); 
            match(input,23,FOLLOW_2); 
             after(grammarAccess.getReferenceAccess().getOppositeOfKeyword_6_0()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__Reference__Group_6__0__Impl"


    // $ANTLR start "rule__Reference__Group_6__1"
    // InternalKM3.g:1241:1: rule__Reference__Group_6__1 : rule__Reference__Group_6__1__Impl ;
    public final void rule__Reference__Group_6__1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1245:1: ( rule__Reference__Group_6__1__Impl )
            // InternalKM3.g:1246:2: rule__Reference__Group_6__1__Impl
            {
            pushFollow(FOLLOW_2);
            rule__Reference__Group_6__1__Impl();

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
    // $ANTLR end "rule__Reference__Group_6__1"


    // $ANTLR start "rule__Reference__Group_6__1__Impl"
    // InternalKM3.g:1252:1: rule__Reference__Group_6__1__Impl : ( ( rule__Reference__OppositeAssignment_6_1 ) ) ;
    public final void rule__Reference__Group_6__1__Impl() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1256:1: ( ( ( rule__Reference__OppositeAssignment_6_1 ) ) )
            // InternalKM3.g:1257:1: ( ( rule__Reference__OppositeAssignment_6_1 ) )
            {
            // InternalKM3.g:1257:1: ( ( rule__Reference__OppositeAssignment_6_1 ) )
            // InternalKM3.g:1258:2: ( rule__Reference__OppositeAssignment_6_1 )
            {
             before(grammarAccess.getReferenceAccess().getOppositeAssignment_6_1()); 
            // InternalKM3.g:1259:2: ( rule__Reference__OppositeAssignment_6_1 )
            // InternalKM3.g:1259:3: rule__Reference__OppositeAssignment_6_1
            {
            pushFollow(FOLLOW_2);
            rule__Reference__OppositeAssignment_6_1();

            state._fsp--;


            }

             after(grammarAccess.getReferenceAccess().getOppositeAssignment_6_1()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__Reference__Group_6__1__Impl"


    // $ANTLR start "rule__Package__NameAssignment_1"
    // InternalKM3.g:1268:1: rule__Package__NameAssignment_1 : ( RULE_ID ) ;
    public final void rule__Package__NameAssignment_1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1272:1: ( ( RULE_ID ) )
            // InternalKM3.g:1273:2: ( RULE_ID )
            {
            // InternalKM3.g:1273:2: ( RULE_ID )
            // InternalKM3.g:1274:3: RULE_ID
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
    // InternalKM3.g:1283:1: rule__Package__ContentsAssignment_3 : ( ruleModelElement ) ;
    public final void rule__Package__ContentsAssignment_3() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1287:1: ( ( ruleModelElement ) )
            // InternalKM3.g:1288:2: ( ruleModelElement )
            {
            // InternalKM3.g:1288:2: ( ruleModelElement )
            // InternalKM3.g:1289:3: ruleModelElement
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
    // InternalKM3.g:1298:1: rule__DataType__NameAssignment_1 : ( RULE_ID ) ;
    public final void rule__DataType__NameAssignment_1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1302:1: ( ( RULE_ID ) )
            // InternalKM3.g:1303:2: ( RULE_ID )
            {
            // InternalKM3.g:1303:2: ( RULE_ID )
            // InternalKM3.g:1304:3: RULE_ID
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
    // InternalKM3.g:1313:1: rule__Class__IsAbstractAssignment_0 : ( ( 'abstract' ) ) ;
    public final void rule__Class__IsAbstractAssignment_0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1317:1: ( ( ( 'abstract' ) ) )
            // InternalKM3.g:1318:2: ( ( 'abstract' ) )
            {
            // InternalKM3.g:1318:2: ( ( 'abstract' ) )
            // InternalKM3.g:1319:3: ( 'abstract' )
            {
             before(grammarAccess.getClassAccess().getIsAbstractAbstractKeyword_0_0()); 
            // InternalKM3.g:1320:3: ( 'abstract' )
            // InternalKM3.g:1321:4: 'abstract'
            {
             before(grammarAccess.getClassAccess().getIsAbstractAbstractKeyword_0_0()); 
            match(input,24,FOLLOW_2); 
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
    // InternalKM3.g:1332:1: rule__Class__NameAssignment_2 : ( RULE_ID ) ;
    public final void rule__Class__NameAssignment_2() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1336:1: ( ( RULE_ID ) )
            // InternalKM3.g:1337:2: ( RULE_ID )
            {
            // InternalKM3.g:1337:2: ( RULE_ID )
            // InternalKM3.g:1338:3: RULE_ID
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
    // InternalKM3.g:1347:1: rule__Class__SupertypesAssignment_3_1 : ( ( RULE_ID ) ) ;
    public final void rule__Class__SupertypesAssignment_3_1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1351:1: ( ( ( RULE_ID ) ) )
            // InternalKM3.g:1352:2: ( ( RULE_ID ) )
            {
            // InternalKM3.g:1352:2: ( ( RULE_ID ) )
            // InternalKM3.g:1353:3: ( RULE_ID )
            {
             before(grammarAccess.getClassAccess().getSupertypesClassCrossReference_3_1_0()); 
            // InternalKM3.g:1354:3: ( RULE_ID )
            // InternalKM3.g:1355:4: RULE_ID
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
    // InternalKM3.g:1366:1: rule__Class__SupertypesAssignment_3_2_1 : ( ( RULE_ID ) ) ;
    public final void rule__Class__SupertypesAssignment_3_2_1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1370:1: ( ( ( RULE_ID ) ) )
            // InternalKM3.g:1371:2: ( ( RULE_ID ) )
            {
            // InternalKM3.g:1371:2: ( ( RULE_ID ) )
            // InternalKM3.g:1372:3: ( RULE_ID )
            {
             before(grammarAccess.getClassAccess().getSupertypesClassCrossReference_3_2_1_0()); 
            // InternalKM3.g:1373:3: ( RULE_ID )
            // InternalKM3.g:1374:4: RULE_ID
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
    // InternalKM3.g:1385:1: rule__Class__StructuralFeaturesAssignment_5 : ( ruleStructuralFeature ) ;
    public final void rule__Class__StructuralFeaturesAssignment_5() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1389:1: ( ( ruleStructuralFeature ) )
            // InternalKM3.g:1390:2: ( ruleStructuralFeature )
            {
            // InternalKM3.g:1390:2: ( ruleStructuralFeature )
            // InternalKM3.g:1391:3: ruleStructuralFeature
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
    // InternalKM3.g:1400:1: rule__Attribute__IsUniqueAssignment_0 : ( ( 'unique' ) ) ;
    public final void rule__Attribute__IsUniqueAssignment_0() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1404:1: ( ( ( 'unique' ) ) )
            // InternalKM3.g:1405:2: ( ( 'unique' ) )
            {
            // InternalKM3.g:1405:2: ( ( 'unique' ) )
            // InternalKM3.g:1406:3: ( 'unique' )
            {
             before(grammarAccess.getAttributeAccess().getIsUniqueUniqueKeyword_0_0()); 
            // InternalKM3.g:1407:3: ( 'unique' )
            // InternalKM3.g:1408:4: 'unique'
            {
             before(grammarAccess.getAttributeAccess().getIsUniqueUniqueKeyword_0_0()); 
            match(input,25,FOLLOW_2); 
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
    // InternalKM3.g:1419:1: rule__Attribute__NameAssignment_2 : ( RULE_ID ) ;
    public final void rule__Attribute__NameAssignment_2() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1423:1: ( ( RULE_ID ) )
            // InternalKM3.g:1424:2: ( RULE_ID )
            {
            // InternalKM3.g:1424:2: ( RULE_ID )
            // InternalKM3.g:1425:3: RULE_ID
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
    // InternalKM3.g:1434:1: rule__Attribute__IsOrderedAssignment_3 : ( ( 'ordered' ) ) ;
    public final void rule__Attribute__IsOrderedAssignment_3() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1438:1: ( ( ( 'ordered' ) ) )
            // InternalKM3.g:1439:2: ( ( 'ordered' ) )
            {
            // InternalKM3.g:1439:2: ( ( 'ordered' ) )
            // InternalKM3.g:1440:3: ( 'ordered' )
            {
             before(grammarAccess.getAttributeAccess().getIsOrderedOrderedKeyword_3_0()); 
            // InternalKM3.g:1441:3: ( 'ordered' )
            // InternalKM3.g:1442:4: 'ordered'
            {
             before(grammarAccess.getAttributeAccess().getIsOrderedOrderedKeyword_3_0()); 
            match(input,26,FOLLOW_2); 
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
    // InternalKM3.g:1453:1: rule__Attribute__TypeAssignment_5 : ( ( RULE_ID ) ) ;
    public final void rule__Attribute__TypeAssignment_5() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1457:1: ( ( ( RULE_ID ) ) )
            // InternalKM3.g:1458:2: ( ( RULE_ID ) )
            {
            // InternalKM3.g:1458:2: ( ( RULE_ID ) )
            // InternalKM3.g:1459:3: ( RULE_ID )
            {
             before(grammarAccess.getAttributeAccess().getTypeClassifierCrossReference_5_0()); 
            // InternalKM3.g:1460:3: ( RULE_ID )
            // InternalKM3.g:1461:4: RULE_ID
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
    // InternalKM3.g:1472:1: rule__Reference__NameAssignment_1 : ( RULE_ID ) ;
    public final void rule__Reference__NameAssignment_1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1476:1: ( ( RULE_ID ) )
            // InternalKM3.g:1477:2: ( RULE_ID )
            {
            // InternalKM3.g:1477:2: ( RULE_ID )
            // InternalKM3.g:1478:3: RULE_ID
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


    // $ANTLR start "rule__Reference__IsOrderedAssignment_2"
    // InternalKM3.g:1487:1: rule__Reference__IsOrderedAssignment_2 : ( ( 'ordered' ) ) ;
    public final void rule__Reference__IsOrderedAssignment_2() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1491:1: ( ( ( 'ordered' ) ) )
            // InternalKM3.g:1492:2: ( ( 'ordered' ) )
            {
            // InternalKM3.g:1492:2: ( ( 'ordered' ) )
            // InternalKM3.g:1493:3: ( 'ordered' )
            {
             before(grammarAccess.getReferenceAccess().getIsOrderedOrderedKeyword_2_0()); 
            // InternalKM3.g:1494:3: ( 'ordered' )
            // InternalKM3.g:1495:4: 'ordered'
            {
             before(grammarAccess.getReferenceAccess().getIsOrderedOrderedKeyword_2_0()); 
            match(input,26,FOLLOW_2); 
             after(grammarAccess.getReferenceAccess().getIsOrderedOrderedKeyword_2_0()); 

            }

             after(grammarAccess.getReferenceAccess().getIsOrderedOrderedKeyword_2_0()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__Reference__IsOrderedAssignment_2"


    // $ANTLR start "rule__Reference__IsContainerAssignment_3"
    // InternalKM3.g:1506:1: rule__Reference__IsContainerAssignment_3 : ( ( 'container' ) ) ;
    public final void rule__Reference__IsContainerAssignment_3() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1510:1: ( ( ( 'container' ) ) )
            // InternalKM3.g:1511:2: ( ( 'container' ) )
            {
            // InternalKM3.g:1511:2: ( ( 'container' ) )
            // InternalKM3.g:1512:3: ( 'container' )
            {
             before(grammarAccess.getReferenceAccess().getIsContainerContainerKeyword_3_0()); 
            // InternalKM3.g:1513:3: ( 'container' )
            // InternalKM3.g:1514:4: 'container'
            {
             before(grammarAccess.getReferenceAccess().getIsContainerContainerKeyword_3_0()); 
            match(input,27,FOLLOW_2); 
             after(grammarAccess.getReferenceAccess().getIsContainerContainerKeyword_3_0()); 

            }

             after(grammarAccess.getReferenceAccess().getIsContainerContainerKeyword_3_0()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__Reference__IsContainerAssignment_3"


    // $ANTLR start "rule__Reference__TypeAssignment_5"
    // InternalKM3.g:1525:1: rule__Reference__TypeAssignment_5 : ( ( RULE_ID ) ) ;
    public final void rule__Reference__TypeAssignment_5() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1529:1: ( ( ( RULE_ID ) ) )
            // InternalKM3.g:1530:2: ( ( RULE_ID ) )
            {
            // InternalKM3.g:1530:2: ( ( RULE_ID ) )
            // InternalKM3.g:1531:3: ( RULE_ID )
            {
             before(grammarAccess.getReferenceAccess().getTypeClassifierCrossReference_5_0()); 
            // InternalKM3.g:1532:3: ( RULE_ID )
            // InternalKM3.g:1533:4: RULE_ID
            {
             before(grammarAccess.getReferenceAccess().getTypeClassifierIDTerminalRuleCall_5_0_1()); 
            match(input,RULE_ID,FOLLOW_2); 
             after(grammarAccess.getReferenceAccess().getTypeClassifierIDTerminalRuleCall_5_0_1()); 

            }

             after(grammarAccess.getReferenceAccess().getTypeClassifierCrossReference_5_0()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__Reference__TypeAssignment_5"


    // $ANTLR start "rule__Reference__OppositeAssignment_6_1"
    // InternalKM3.g:1544:1: rule__Reference__OppositeAssignment_6_1 : ( ( RULE_ID ) ) ;
    public final void rule__Reference__OppositeAssignment_6_1() throws RecognitionException {

        		int stackSize = keepStackSize();
        	
        try {
            // InternalKM3.g:1548:1: ( ( ( RULE_ID ) ) )
            // InternalKM3.g:1549:2: ( ( RULE_ID ) )
            {
            // InternalKM3.g:1549:2: ( ( RULE_ID ) )
            // InternalKM3.g:1550:3: ( RULE_ID )
            {
             before(grammarAccess.getReferenceAccess().getOppositeReferenceCrossReference_6_1_0()); 
            // InternalKM3.g:1551:3: ( RULE_ID )
            // InternalKM3.g:1552:4: RULE_ID
            {
             before(grammarAccess.getReferenceAccess().getOppositeReferenceIDTerminalRuleCall_6_1_0_1()); 
            match(input,RULE_ID,FOLLOW_2); 
             after(grammarAccess.getReferenceAccess().getOppositeReferenceIDTerminalRuleCall_6_1_0_1()); 

            }

             after(grammarAccess.getReferenceAccess().getOppositeReferenceCrossReference_6_1_0()); 

            }


            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {

            	restoreStackSize(stackSize);

        }
        return ;
    }
    // $ANTLR end "rule__Reference__OppositeAssignment_6_1"

    // Delegated rules


 

    public static final BitSet FOLLOW_1 = new BitSet(new long[]{0x0000000000000000L});
    public static final BitSet FOLLOW_2 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_3 = new BitSet(new long[]{0x0000000000000010L});
    public static final BitSet FOLLOW_4 = new BitSet(new long[]{0x0000000000002000L});
    public static final BitSet FOLLOW_5 = new BitSet(new long[]{0x000000000102C000L});
    public static final BitSet FOLLOW_6 = new BitSet(new long[]{0x0000000001028002L});
    public static final BitSet FOLLOW_7 = new BitSet(new long[]{0x0000000000010000L});
    public static final BitSet FOLLOW_8 = new BitSet(new long[]{0x0000000001028000L});
    public static final BitSet FOLLOW_9 = new BitSet(new long[]{0x0000000000042000L});
    public static final BitSet FOLLOW_10 = new BitSet(new long[]{0x0000000002504000L});
    public static final BitSet FOLLOW_11 = new BitSet(new long[]{0x0000000002500002L});
    public static final BitSet FOLLOW_12 = new BitSet(new long[]{0x0000000000080000L});
    public static final BitSet FOLLOW_13 = new BitSet(new long[]{0x0000000000080002L});
    public static final BitSet FOLLOW_14 = new BitSet(new long[]{0x0000000002100000L});
    public static final BitSet FOLLOW_15 = new BitSet(new long[]{0x0000000004200000L});
    public static final BitSet FOLLOW_16 = new BitSet(new long[]{0x000000000C200000L});
    public static final BitSet FOLLOW_17 = new BitSet(new long[]{0x0000000000810000L});

}