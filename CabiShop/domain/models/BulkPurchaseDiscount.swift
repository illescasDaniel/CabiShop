//
//  BulkPurchaseDiscount.swift
//  CabiShop
//
//  Created by Daniel Illescas Romero on 25/5/23.
//

import Foundation

struct BulkPurchaseDiscount: Equatable, Hashable {
	let howManyItemsTheUserNeedsToBuyAtLeast: UInt
	let priceModifierPerUnit: Decimal
}
