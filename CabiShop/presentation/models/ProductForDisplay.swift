//
//  ProductForDisplay.swift
//  CabiShop
//
//  Created by Daniel Illescas Romero on 25/5/23.
//

import Foundation

struct ProductForDisplay: Equatable, Hashable, Identifiable {
	// Should a product name be translated? We should probably receive the translation dynamically, to support new products without updating the app.
	let name: String
	let productCode: String
	let promotionWithDescription: ProductPromotionWithDescription?
	let basePricePerUnit: Decimal
	let formattedBasePrice: String

	var id: String {
		productCode
	}
}
