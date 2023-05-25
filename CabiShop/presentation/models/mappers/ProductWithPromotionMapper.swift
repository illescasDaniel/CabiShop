//
//  ProductWithPromotionMapper.swift
//  CabiShop
//
//  Created by Daniel Illescas Romero on 25/5/23.
//

import Foundation

final class ProductWithPromotionMapper {

	private let numberFormatterUtils: NumberFormatterUtils

	init(numberFormatterUtils: NumberFormatterUtils) {
		self.numberFormatterUtils = numberFormatterUtils
	}

	func mapProductsWithPromotion(_ values: [ProductWithPromotion]) -> [ProductForDisplay] {
		values.map(mapProductWithPromotion(_:))
	}

	func mapProductWithPromotion(_ value: ProductWithPromotion) -> ProductForDisplay {
		let trimmedName = value.name.trimmingCharacters(in: .whitespacesAndNewlines)
		let promotion: ProductPromotionWithDescription?
		switch value.productPromotion {
		case .xForYPromotion(let xForYPromotion):
			promotion = ProductPromotionWithDescription(
				description: String(format: NSLocalizedString("%u-for-%u promotion!", comment: "x-for-y promotions, like 2-for-1"), xForYPromotion.howManyItemsTheUserNeedsToBuy, xForYPromotion.howManyItemsTheUserWillPay),
				promotion: .xForYPromotion(xForYPromotion)
			)
		case .bulkPurchaseDiscount(let bulkPurchaseDiscount):
			promotion = ProductPromotionWithDescription(
				description: String(format: NSLocalizedString("%u or more for discounts!", comment: "Bulk promotions buying more X items or more."), bulkPurchaseDiscount.howManyItemsTheUserNeedsToBuyAtLeast),
				promotion: .bulkPurchaseDiscount(bulkPurchaseDiscount)
			)
		case nil:
			promotion = nil
		}
		let basePricePerUnit = value.basePricePerUnit
		let formattedBasePrice = self.numberFormatterUtils.formatProductPriceInEuro(basePricePerUnit)
		return ProductForDisplay(
			name: trimmedName.isEmpty ? "-" : trimmedName,
			productCode: value.productCode,
			promotionWithDescription: promotion,
			basePricePerUnit: value.basePricePerUnit,
			formattedBasePrice: formattedBasePrice
		)
	}
}
