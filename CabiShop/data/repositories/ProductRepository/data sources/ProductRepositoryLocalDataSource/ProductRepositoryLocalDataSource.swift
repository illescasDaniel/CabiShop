//
//  ProductRepositoryLocalDataSource.swift
//  CabiShop
//
//  Created by Daniel Illescas Romero on 27/5/23.
//

import Foundation
import Combine

protocol ProductRepositoryLocalDataSource {
	func fetchXforYPromotions() -> [XforYPromotionForProductCode]
	func fetchBulkPurchaseDiscounts() -> [BulkPurchasePriceModifierForProductCode]
	func saveProductsForCheckout(productCodes: [String])
	func fetchProductCodesForCheckout() -> [String]
	func productCodesForCheckout() -> AnyPublisher<[String], Never>
}
