//
//  PromotionMapper.swift
//  CabiShop
//
//  Created by Daniel Illescas Romero on 25/5/23.
//

import Foundation

final class PromotionMapper {
	func mapXForYPromotion(_ value: XforYPromotionForProductCode) -> XforYPromotion {
		XforYPromotion(howManyItemsTheUserNeedsToBuy: value.howManyItemsTheUserNeedsToBuy, howManyItemsTheUserWillPay: value.howManyItemsTheUserWillPay)
	}
	func mapBulkPurchase(_ value: BulkPurchasePriceModifierForProductCode) -> BulkPurchaseDiscount {
		BulkPurchaseDiscount(howManyItemsTheUserNeedsToBuyAtLeast: value.howManyItemsTheUserNeedsToBuyAtLeast, priceModifierPerUnit: value.priceModifierPerUnit)
	}
}
