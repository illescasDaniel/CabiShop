//
//  ProductRepositoryImpl.swift
//  CabiShop
//
//  Created by Daniel Illescas Romero on 25/5/23.
//

import Foundation
import Combine

final class ProductRepositoryImpl: ProductRepository {

	private let networkDataSource: ProductRepositoryNetworkDataSource
	private let localDataSource: ProductRepositoryLocalDataSource

	init(
		networkDataSource: ProductRepositoryNetworkDataSource,
		localDataSource: ProductRepositoryLocalDataSource
	) {
		self.networkDataSource = networkDataSource
		self.localDataSource = localDataSource
	}

	func fetchProducts() async throws -> ProductList {
		try await self.networkDataSource.fetchProducts()
	}

	func fetchXforYPromotions() async throws -> [XforYPromotionForProductCode] {
		self.localDataSource.fetchXforYPromotions()
	}

	func fetchBulkPurchaseDiscounts() async throws -> [BulkPurchasePriceModifierForProductCode] {
		self.localDataSource.fetchBulkPurchaseDiscounts()
	}

	func addProductForCheckout(productCode: String) {
		self.localDataSource.saveProductsForCheckout(productCodes: fetchProductCodesForCheckout() + [productCode])
	}

	func removeProductForCheckout(productCode: String) {
		let savedProductCodes = fetchProductCodesForCheckout()
		let filteredProductCodes = savedProductCodes.filter { $0 != productCode }
		self.localDataSource.saveProductsForCheckout(productCodes: filteredProductCodes)
	}

	func removeLastProductForCheckout(productCode: String) {
		var savedProductCodes = fetchProductCodesForCheckout()
		if let savedProductCodeIndex = savedProductCodes.lastIndex(where: { $0 == productCode}) {
			savedProductCodes.remove(at: savedProductCodeIndex)
			self.localDataSource.saveProductsForCheckout(productCodes: savedProductCodes)
		}
	}

	func removeAllProductsForCheckout() {
		self.localDataSource.saveProductsForCheckout(productCodes: [])
	}

	func fetchProductCodesForCheckout() -> [String] {
		return self.localDataSource.fetchProductCodesForCheckout()
	}

	func productCodesForCheckout() -> AnyPublisher<[String], Never> {
		return self.localDataSource.productCodesForCheckout()
	}
}
