package org.eclipse.m2m.km3.xtext.converter;

import org.eclipse.m2m.km3.xtext.converter.MultiplicityValueConverter;
import org.eclipse.xtext.conversion.IValueConverter;
import org.eclipse.xtext.conversion.ValueConverter;
import org.eclipse.xtext.conversion.impl.AbstractDeclarativeValueConverterService;

@SuppressWarnings("all")
public class MultiplicityValueConverterService extends AbstractDeclarativeValueConverterService {
  @ValueConverter(rule = "ElementBound")
  public IValueConverter<Integer> getMyRuleNameConverter() {
    MultiplicityValueConverter _multiplicityValueConverter = new MultiplicityValueConverter();
    return _multiplicityValueConverter.ElementBound();
  }
}
