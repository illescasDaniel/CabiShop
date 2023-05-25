//
//  BulkPurchasePriceModifierForProductCode.swift
//  CabiShop
//
//  Created by Daniel Illescas Romero on 25/5/23.
//

import Foundation

// This structure might represent the data as if it was stored
// in a row of a table in a database.
// `priceModifierPerUnit` can be negative to apply a discount
// but it can also be positive to apply a penalty for buying lots of items.
// The motivation behind this is to avoid "scalpers" buying all your stock
// and reselling it for a higher price outside the shop, as it happened
// with new game consoles; by applying a higher price if they buy in bulk,
// we could easily avoid people buying more than X items.
// As this is just theoretical and the code challenge doesn't account for this
// case, we'll just use a different structure name here but in the rest of the app
// layers we will imagine that `priceModifierPerUnit` will always be a negative number,
// for now.
struct BulkPurchasePriceModifierForProductCode: Equatable {
	let howManyItemsTheUserNeedsToBuyAtLeast: UInt
	let priceModifierPerUnit: Decimal
	let productCode: String
}
