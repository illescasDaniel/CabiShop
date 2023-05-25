//
//  ProductPriceCalculator.swift
//  CabiShop
//
//  Created by Daniel Illescas Romero on 26/5/23.
//

import Foundation

final class ProductPriceCalculator {

	func calculatePrice(basePricePerUnit: Decimal, promotion: ProductPromotion?, units: UInt) -> Decimal {
		switch promotion {
		case .xForYPromotion(let xForYPromotion):
			return xForYPromotionPrice(xForYPromotion, basePricePerUnit: basePricePerUnit, units: units)
		case .bulkPurchaseDiscount(let bulkPurchaseDiscount):
			return bulkPurchaseDiscountPrice(bulkPurchaseDiscount, basePricePerUnit: basePricePerUnit, units: units)
		case nil:
			return normalPrice(basePricePerUnit: basePricePerUnit, units: units)
		}
	}

	func xForYPromotionPrice(_ xForYPromotion: XforYPromotion, basePricePerUnit: Decimal, units: UInt) -> Decimal {
		guard units >= xForYPromotion.howManyItemsTheUserNeedsToBuy else {
			return normalPrice(basePricePerUnit: basePricePerUnit, units: units)
		}
		let numberOfDiscounts = units / xForYPromotion.howManyItemsTheUserNeedsToBuy
		let restOfItemsOutOfDiscounts = units % xForYPromotion.howManyItemsTheUserNeedsToBuy
		return (Decimal(numberOfDiscounts) * Decimal(xForYPromotion.howManyItemsTheUserWillPay) * basePricePerUnit) + (Decimal(restOfItemsOutOfDiscounts) * normalPrice(basePricePerUnit: basePricePerUnit, units: restOfItemsOutOfDiscounts))
	}

	func bulkPurchaseDiscountPrice(_ bulkPurchaseDiscount: BulkPurchaseDiscount, basePricePerUnit: Decimal, units: UInt) -> Decimal {
		guard units >= bulkPurchaseDiscount.howManyItemsTheUserNeedsToBuyAtLeast else {
			return normalPrice(basePricePerUnit: basePricePerUnit, units: units)
		}
		return (basePricePerUnit + bulkPurchaseDiscount.priceModifierPerUnit) * Decimal(units)
	}

	func normalPrice(basePricePerUnit: Decimal, units: UInt) -> Decimal {
		if units < 1 {
			return basePricePerUnit
		}
		return basePricePerUnit * Decimal(units)
	}
}
