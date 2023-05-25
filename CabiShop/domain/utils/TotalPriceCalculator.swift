//
//  TotalPriceCalculator.swift
//  CabiShop
//
//  Created by Daniel Illescas Romero on 29/5/23.
//

import Foundation

class TotalPriceCalculator {

	private let priceCalculator: ProductPriceCalculator

	init(priceCalculator: ProductPriceCalculator) {
		self.priceCalculator = priceCalculator
	}

	func totalPrice(allProducts products: [ProductWithPromotion], selectedProductCodes productCodes: [String]) -> Decimal {
		let groupedProductCodes = Dictionary(grouping: productCodes, by: { $0 }).mapValues { $0.count }

		let totalPrice = groupedProductCodes.reduce(into: Decimal(0)) { partialResult, groupedProductCodeKeyValue in
			let (productCode, units) = groupedProductCodeKeyValue
			if let product = products.first(where: { $0.productCode == productCode }) {
				let price = priceCalculator.calculatePrice(
					basePricePerUnit: product.basePricePerUnit,
					promotion: product.productPromotion,
					units: UInt(units)
				)
				partialResult += price
			}
		}
		return totalPrice
	}
}
