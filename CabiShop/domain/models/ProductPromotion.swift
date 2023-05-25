//
//  ProductPromotion.swift
//  CabiShop
//
//  Created by Daniel Illescas Romero on 25/5/23.
//

import Foundation

enum ProductPromotion: Equatable, Hashable {
	case xForYPromotion(XforYPromotion)
	case bulkPurchaseDiscount(BulkPurchaseDiscount)

	static func ==(lhs: Self, rhs: Self) -> Bool {
		switch (lhs, rhs) {
		case (.xForYPromotion(let lhsXforYPromotion), .xForYPromotion(let rhsXforYPromotion)):
			return lhsXforYPromotion == rhsXforYPromotion
		case (.bulkPurchaseDiscount(let lhsBulkPurchaseDiscount), .bulkPurchaseDiscount(let rhsBulkPurchaseDiscount)):
			return lhsBulkPurchaseDiscount == rhsBulkPurchaseDiscount
		default:
			return false
		}
	}

	func hash(into hasher: inout Hasher) {
		switch self {
		case .xForYPromotion(let xForYPromotion):
			hasher.combine(xForYPromotion)
		case .bulkPurchaseDiscount(let bulkPurchaseDiscount):
			hasher.combine(bulkPurchaseDiscount)
		}
	}
}
