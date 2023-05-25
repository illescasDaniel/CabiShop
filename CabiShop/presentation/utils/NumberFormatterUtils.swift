//
//  NumberFormatterUtils.swift
//  CabiShop
//
//  Created by Daniel Illescas Romero on 25/5/23.
//

import Foundation

final class NumberFormatterUtils {

	func formatProductPriceInEuro(_ value: Decimal, locale: Locale = .current) -> String {
		let formatter = NumberFormatter()
		formatter.locale = locale
		formatter.numberStyle = .currency
		formatter.currencySymbol = "€"
		formatter.minimum = NSNumber(value: 0)
		let decimalNumber: NSDecimalNumber = value as NSDecimalNumber
		let formattedPrice = formatter.string(from: decimalNumber)
		return formattedPrice ?? String((value as NSDecimalNumber).stringValue)+"€"
	}
}
