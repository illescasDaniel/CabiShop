//
//  ProductMapper.swift
//  CabiShop
//
//  Created by Daniel Illescas Romero on 25/5/23.
//

import Foundation

final class ProductMapper {

	private let promotionMapper: PromotionMapper

	init(promotionMapper: PromotionMapper) {
		self.promotionMapper = promotionMapper
	}

	func mapToProductsWithPromotion(
		products: [Product],
		xForYPromotions: [XforYPromotionForProductCode],
		bulkPurchaseDiscounts: [BulkPurchasePriceModifierForProductCode]
	) -> [ProductWithPromotion] {
		return products.map { product in
			let productPromotion: ProductPromotion?
			if let xForYPromotionWithProductCode = xForYPromotions.first(where: { $0.productCode == product.code }) {
				let xForYPromotion = self.promotionMapper.mapXForYPromotion(xForYPromotionWithProductCode)
				productPromotion = .xForYPromotion(xForYPromotion)
			} else if let bulkPurchaseDiscountWithProductCode = bulkPurchaseDiscounts.first(where: { $0.productCode == product.code }) {
				let bulkPurchaseDiscount = self.promotionMapper.mapBulkPurchase(bulkPurchaseDiscountWithProductCode)
				productPromotion = .bulkPurchaseDiscount(bulkPurchaseDiscount)
			} else {
				productPromotion = nil
			}
			return mapToProductWithPromotion(product: product, promotion: productPromotion)
		}
	}

	private func mapToProductWithPromotion(
		product: Product,
		promotion: ProductPromotion?
	) -> ProductWithPromotion {
		return ProductWithPromotion(
			name: product.name,
			productCode: product.code,
			basePricePerUnit: product.price,
			productPromotion: promotion
		)
	}
}
