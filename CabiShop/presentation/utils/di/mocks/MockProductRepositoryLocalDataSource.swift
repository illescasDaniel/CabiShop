//
//  MockProductRepositoryLocalDataSource.swift
//  CabiShop
//
//  Created by Daniel Illescas Romero on 27/5/23.
//

#if DEBUG
import Foundation
import Combine

final class MockProductRepositoryLocalDataSource: ProductRepositoryLocalDataSource {

	fileprivate static let productCodesForCheckoutKey: String = "mockProductCodesForCheckoutKey"
	var xForYPromotions: [XforYPromotionForProductCode]
	var bulkPurchaseDiscounts: [BulkPurchasePriceModifierForProductCode]
	var productsForCheckout: [String] {
		didSet {
			self.publisher.send(productsForCheckout)
		}
	}
	private let publisher: CurrentValueSubject<[String], Never>

	init(
		xForYPromotions: [XforYPromotionForProductCode],
		bulkPurchaseDiscounts: [BulkPurchasePriceModifierForProductCode],
		productsForCheckout: [String]
	) {
		self.xForYPromotions = xForYPromotions
		self.bulkPurchaseDiscounts = bulkPurchaseDiscounts
		self.productsForCheckout = productsForCheckout
		self.publisher = CurrentValueSubject<[String], Never>(productsForCheckout)
	}

	func fetchXforYPromotions() -> [XforYPromotionForProductCode] {
		self.xForYPromotions
	}

	func fetchBulkPurchaseDiscounts() -> [BulkPurchasePriceModifierForProductCode] {
		self.bulkPurchaseDiscounts
	}

	func saveProductsForCheckout(productCodes: [String]) {
		self.productsForCheckout = productCodes
		self.publisher.send(productCodes)
	}

	func fetchProductCodesForCheckout() -> [String] {
		self.productsForCheckout
	}

	func productCodesForCheckout() -> AnyPublisher<[String], Never> {
		self.publisher.send(fetchProductCodesForCheckout())
		return self.publisher.eraseToAnyPublisher()
	}
}
#endif
