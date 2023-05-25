//
//  ProductRepositoryLocalDataSourceImpl.swift
//  CabiShop
//
//  Created by Daniel Illescas Romero on 25/5/23.
//

import Foundation
import Combine

final class ProductRepositoryLocalDataSourceImpl: ProductRepositoryLocalDataSource {

	private let userDefaults: UserDefaults
	fileprivate static let productCodesForCheckoutKey: String = "productCodesForCheckoutKey"

	init(userDefaults: UserDefaults) {
		self.userDefaults = userDefaults
	}

	func fetchXforYPromotions() -> [XforYPromotionForProductCode] {
		return [
			XforYPromotionForProductCode.create2for1Promotion(productCode: "VOUCHER")
		]
	}

	func fetchBulkPurchaseDiscounts() -> [BulkPurchasePriceModifierForProductCode] {
		return [
			BulkPurchasePriceModifierForProductCode(
				howManyItemsTheUserNeedsToBuyAtLeast: 3,
				priceModifierPerUnit: -1,
				productCode: "TSHIRT"
			)
		]
	}

	func saveProductsForCheckout(productCodes: [String]) {
		self.userDefaults.set(productCodes, forKey: Self.productCodesForCheckoutKey)
	}

	func fetchProductCodesForCheckout() -> [String] {
		return self.userDefaults.stringArray(forKey: Self.productCodesForCheckoutKey) ?? []
	}

	func productCodesForCheckout() -> AnyPublisher<[String], Never> {
		return self.userDefaults
			.publisher(for: \.productCodesForCheckoutKey)
			.map { $0 ?? [] }
			.eraseToAnyPublisher()
	}
}

fileprivate extension UserDefaults {
	// Important: this property name must be exactly the same as the key value: "productCodesForCheckoutKey"
	@objc dynamic var productCodesForCheckoutKey: [String]? {
		return stringArray(forKey: ProductRepositoryLocalDataSourceImpl.productCodesForCheckoutKey)
	}
}
