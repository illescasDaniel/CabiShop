//
//  NumberFormatterUtilsTests.swift
//  CabiShopTests
//
//  Created by Daniel Illescas Romero on 29/5/23.
//

import Foundation
import XCTest
@testable import CabiShop

class NumberFormatterUtilsTests: XCTestCase {

	private lazy var numberFormatterUtils = NumberFormatterUtils()

	func testNumberFormatter() {
		let formattedPriceSpain = self.numberFormatterUtils.formatProductPriceInEuro(1.5, locale: Locale(identifier: "es_ES"))
		XCTAssertEqual(formattedPriceSpain, "1,50\u{00A0}€")

		let formattedPriceUS = self.numberFormatterUtils.formatProductPriceInEuro(1.5, locale: Locale(identifier: "en_US"))
		XCTAssertEqual(formattedPriceUS, "€1.50")
	}
}
