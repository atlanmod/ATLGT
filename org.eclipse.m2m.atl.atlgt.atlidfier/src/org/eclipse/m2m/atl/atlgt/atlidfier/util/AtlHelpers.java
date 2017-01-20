package org.eclipse.m2m.atl.atlgt.atlidfier.util;

import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.resource.impl.ExtensibleURIConverterImpl;
import org.eclipse.m2m.atl.core.IExtractor;
import org.eclipse.m2m.atl.core.IModel;
import org.eclipse.m2m.atl.core.emf.EMFExtractor;
import org.eclipse.m2m.atl.engine.parser.AtlParser;

import java.io.InputStream;

public class AtlHelpers {

    public static void extractToEmf(String atlModel, String storePath) throws Exception {
        InputStream input = new ExtensibleURIConverterImpl().createInputStream(URI.createURI(atlModel));

        AtlParser atlParser = AtlParser.getDefault();
        IModel m = atlParser.parseToModel(input);

        // Save/Extract to a file
        IExtractor extractor = new EMFExtractor();
        extractor.extract(m, storePath);
    }

    public static void extractToAtl(String modelPath, String storePath) throws Exception {
//        InputStream input = new FileInputStream(modelPath);
//        AtlParser atlParser = AtlParser.getDefault();
//        IModel model = atlParser.parseToModel(input);
//
////        ModelFactory modelFactory = new EMFModelFactory();
////        IInjector injector = new EMFInjector();
////        IReferenceModel atlMeta = modelFactory.newReferenceModel();
////        injector.inject(atlMeta, ATL_METAMODEL);
//
//        if (EMFModel.class.isInstance(model)) {
//            EMFModel emfModel = (EMFModel) model;
//            Set<EObject> classifiers = emfModel.getElementsByType(ATLPackage.eINSTANCE.getEClassifier("Module"));
//
//            EObject firstElement = classifiers.iterator().next();
//            Module module = (Module) firstElement;
//            module.getCommentsBefore().set(0, "-- @atlcompiler emftvm");
//
//            AtlParser.getDefault().extract(emfModel, "./metrics/Ant2Maven/transformation/Ant2Maven2.atl");
//
//            // Save/Extract to a file
//            IExtractor extractor = new EMFExtractor();
//            extractor.extract(model, storePath);
//        }
    }
}
