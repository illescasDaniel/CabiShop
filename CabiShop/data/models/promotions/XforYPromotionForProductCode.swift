//
//  XforYPromotionForProductCode.swift
//  CabiShop
//
//  Created by Daniel Illescas Romero on 25/5/23.
//

import Foundation

// This structure might represent the data as if it was stored
// in a row of a table in a database.
// The original specification only accounted for 2-for-1 discounts
// but to avoid conflicts with the product team if they ever decide
// to apply other similar discounts (like 4-for-1 or 3-for-2, etc)
// the structure is able to handle other discounts without any problem.
struct XforYPromotionForProductCode: Equatable {
	
	let howManyItemsTheUserNeedsToBuy: UInt
	let howManyItemsTheUserWillPay: UInt
	let productCode: String

	static func create2for1Promotion(productCode: String) -> XforYPromotionForProductCode {
		XforYPromotionForProductCode(howManyItemsTheUserNeedsToBuy: 2, howManyItemsTheUserWillPay: 1, productCode: productCode)
	}
}
