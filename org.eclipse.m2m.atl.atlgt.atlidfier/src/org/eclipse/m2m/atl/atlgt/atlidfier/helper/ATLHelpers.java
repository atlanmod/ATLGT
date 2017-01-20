package org.eclipse.m2m.atl.atlgt.atlidfier.helper;

import java.io.FileInputStream;
import java.io.InputStream;

import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.resource.URIConverter;
import org.eclipse.emf.ecore.resource.impl.ExtensibleURIConverterImpl;
import org.eclipse.m2m.atl.core.IExtractor;
import org.eclipse.m2m.atl.core.IModel;
import org.eclipse.m2m.atl.core.emf.EMFExtractor;
import org.eclipse.m2m.atl.engine.parser.AtlParser;

public class ATLHelpers {

	public static void extract2emf(String ATLPath, String storePath) throws Exception {
		URIConverter uriConverter = new ExtensibleURIConverterImpl();	
    	InputStream input = uriConverter.createInputStream(URI.createURI(ATLPath));
		AtlParser atlParser = AtlParser.getDefault();
		IModel m = atlParser.parseToModel(input);

		// save/extract to a file
		IExtractor extractor = new EMFExtractor();
		extractor.extract(m, storePath);
	}
	
	public static void extract2atl(String modelPath, String storePath) throws Exception {
//		InputStream input = new FileInputStream(ATLPath);
//		AtlParser atlParser = AtlParser.getDefault();
//		IModel m = atlParser.parseToModel(input);
//		
//		
//		
//		//ModelFactory modelFactory = new EMFModelFactory();
//		//IInjector injector = new EMFInjector();
//		//IReferenceModel atlMeta = modelFactory.newReferenceModel();
//		//injector.inject(atlMeta, ATL_METAMODEL);
//		
//		
//	
//		if(m instanceof EMFModel){
//			EMFModel emf = (EMFModel) m;
//			Set<EObject> c = emf.getElementsByType(ATLPackage.eINSTANCE.getEClassifier("Module"));
//			
//			for(EObject o : c){
//				Module obj = (Module) o;
//				obj.getCommentsBefore().set(0, "-- @atlcompiler emftvm");
//				
//				AtlParser.getDefault().extract(emf, "./metrics/Ant2Maven/transformation/Ant2Maven2.atl");
//				
//				break; // only interest in the first module
//			}
//			
//			
//			//save/extract to a file
//			IExtractor extractor = new EMFExtractor();
//			extractor.extract(m, storePath);
//			
//		}
	}
}
