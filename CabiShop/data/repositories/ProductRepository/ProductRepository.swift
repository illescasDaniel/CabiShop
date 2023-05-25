//
//  ProductRepository.swift
//  CabiShop
//
//  Created by Daniel Illescas Romero on 25/5/23.
//

import Foundation
import Combine

protocol ProductRepository {
	func fetchProducts() async throws -> ProductList
	func fetchXforYPromotions() async throws -> [XforYPromotionForProductCode]
	func fetchBulkPurchaseDiscounts() async throws -> [BulkPurchasePriceModifierForProductCode]
	func addProductForCheckout(productCode: String)
	func removeProductForCheckout(productCode: String)
	func removeLastProductForCheckout(productCode: String)
	func removeAllProductsForCheckout()
	func fetchProductCodesForCheckout() -> [String]
	func productCodesForCheckout() -> AnyPublisher<[String], Never>
}
