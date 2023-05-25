//
//  ProductWithPromotion.swift
//  CabiShop
//
//  Created by Daniel Illescas Romero on 25/5/23.
//

import Foundation

struct ProductWithPromotion {
	let name: String
	let productCode: String
	let basePricePerUnit: Decimal
	let productPromotion: ProductPromotion?
}
