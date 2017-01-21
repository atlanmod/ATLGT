package org.eclipse.m2m.km3.xtext.converter;

import org.eclipse.xtext.common.services.DefaultTerminalConverters;
import org.eclipse.xtext.conversion.IValueConverter;
import org.eclipse.xtext.conversion.ValueConverter;
import org.eclipse.xtext.conversion.ValueConverterException;
import org.eclipse.xtext.nodemodel.INode;
import org.eclipse.xtext.util.Strings;

public class MultiplicityValueConverter extends DefaultTerminalConverters {
	@ValueConverter(rule = "ElementBound")
	public IValueConverter<Integer> ElementBound() {
		return new IValueConverter<Integer>() {
			@Override
			public Integer toValue(String string, INode node) throws ValueConverterException {
				if (Strings.isEmpty(string))
					throw new ValueConverterException("Couldn't convert empty string to int", node, null);
				else if ("*".equals(string.trim()))
					return -1;
				try {
					return Integer.parseInt(string);
				} catch (NumberFormatException e) {
					throw new ValueConverterException("Couldn't convert '" + string + "' to int", node, e);
				}
			}

			public String toString(Integer value) {
				return ((value == -1) ? "*" : Integer.toString(value));
			}
		};
	}
}