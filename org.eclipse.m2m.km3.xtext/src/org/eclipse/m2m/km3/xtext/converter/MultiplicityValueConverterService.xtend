package org.eclipse.m2m.km3.xtext.converter

import org.eclipse.xtext.conversion.impl.AbstractDeclarativeValueConverterService
import org.eclipse.xtext.conversion.ValueConverter
import org.eclipse.xtext.conversion.IValueConverter

class MultiplicityValueConverterService extends AbstractDeclarativeValueConverterService {
	@ValueConverter(rule = "ElementBound")
	def IValueConverter<Integer> getMyRuleNameConverter() {
    	return new MultiplicityValueConverter().ElementBound
	}
}