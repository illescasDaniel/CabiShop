//
//  ProductsDataTests.swift
//  CabiShopTests
//
//  Created by Daniel Illescas Romero on 29/5/23.
//

import Foundation
import XCTest
import Combine
@testable import CabiShop

class ProductsDataTests: XCTestCase {

	// MARK: - Mock data

	private lazy var mockBasicNetworkHTTPClient = MockBasicNetworkHTTPClient(mockData: [
		MockURLRequest(
			url: "https://gist.githubusercontent.com/palcalde/6c19259bd32dd6aafa327fa557859c2f/raw/ba51779474a150ee4367cda4f4ffacdcca479887/Products.json",
			httpMethod: "GET"
		) :
		MockNetworkResponse(
			body: """
			{ "products": [
				{ "code": "PC1", "name": "Cabify Voucher", "price": 5 },
				{ "code": "PC2", "name": "Cabify T-Shirt", "price": 20 },
				{ "code": "PC3", "name": "Other item", "price": 21 },
				{ "code": "PC4", "name": "Cabify Coffee Mug", "price": 7.5 },
				{ "code": "PC5", "name": "Cabify Coffee Mug 2", "price": 7.54 }
			]}
			""",
			httpStatusCode: .okay(200)
		)
	])
	private lazy var productRepositoryNetworkDataSource: ProductRepositoryNetworkDataSource = ProductRepositoryNetworkDataSourceImpl(
		networkHTTPClient: NetworkHTTPClientImpl(
			basicNetworkHTTPClient: mockBasicNetworkHTTPClient
		)
	)
	private lazy var xForYPromotions: [XforYPromotionForProductCode] = [
		.create2for1Promotion(productCode: "PC1"),
		.init(howManyItemsTheUserNeedsToBuy: 4, howManyItemsTheUserWillPay: 1, productCode: "PC2")
	]
	private lazy var bulkPurchaseDiscounts: [BulkPurchasePriceModifierForProductCode] = [
		.init(howManyItemsTheUserNeedsToBuyAtLeast: 3, priceModifierPerUnit: -0.1, productCode: "PC3"),
		.init(howManyItemsTheUserNeedsToBuyAtLeast: 2, priceModifierPerUnit: 2, productCode: "PC4")
	]
	private lazy var productCodes = ["PC1", "PC2", "PC2", "PC3"]
	private lazy var productRepositoryLocalDataSource: ProductRepositoryLocalDataSource = MockProductRepositoryLocalDataSource(
		xForYPromotions: xForYPromotions,
		bulkPurchaseDiscounts: bulkPurchaseDiscounts,
		productsForCheckout: productCodes
	)
	private lazy var productRepository: ProductRepository = ProductRepositoryImpl(
		networkDataSource: productRepositoryNetworkDataSource,
		localDataSource: productRepositoryLocalDataSource
	)
	private lazy var fetchProductsUseCase: FetchProductsUseCase = FetchProductsUseCaseImpl(
		productRepository: productRepository,
		productMapper: ProductMapper(promotionMapper: PromotionMapper())
	)
	private lazy var productCodesForCheckoutUseCase: ProductCodesForCheckoutUseCase = ProductCodesForCheckoutUseCaseImpl(productRepository: productRepository)
	private lazy var addProductForCheckoutUseCase: AddProductForCheckoutUseCase = AddProductForCheckoutUseCaseImpl(productRepository: productRepository)
	private lazy var removeProductForCheckoutUseCase: RemoveProductForCheckoutUseCase = RemoveProductForCheckoutUseCaseImpl(productRepository: productRepository)
	private lazy var removeAllProductsForCheckoutUseCase: RemoveAllProductsForCheckoutUseCase = RemoveAllProductsForCheckoutUseCaseImpl(productRepository: productRepository)

	// MARK: - Tests

	// MARK: ProductRepository data sources

	func testProductRepositoryNetworkDataSource() async throws {
		let productList = try await self.productRepositoryNetworkDataSource.fetchProducts()
		XCTAssertEqual(productList.products.count, 5)
		XCTAssertEqual(productList.products[0].code, "PC1")
		XCTAssertEqual(productList.products[0].name, "Cabify Voucher")
		XCTAssertEqual(productList.products[0].price, 5)
		XCTAssertEqual(productList.products[1].code, "PC2")
		XCTAssertEqual(productList.products[1].name, "Cabify T-Shirt")
		XCTAssertEqual(productList.products[1].price, 20)
		XCTAssertEqual(productList.products[2].code, "PC3")
		XCTAssertEqual(productList.products[2].name, "Other item")
		XCTAssertEqual(productList.products[2].price, 21)
		XCTAssertEqual(productList.products[3].code, "PC4")
		XCTAssertEqual(productList.products[3].name, "Cabify Coffee Mug")
		// NOTE: we can compare decimals directly because we are using Decimal
		// if we were using Float/Double we could do something like:
		// XCTAssertEqual(1.34, 1.34001, accuracy: 0.01)
		XCTAssertEqual(productList.products[3].price, 7.5)
		XCTAssertEqual(productList.products[4].code, "PC5")
		XCTAssertEqual(productList.products[4].name, "Cabify Coffee Mug 2")
		XCTAssertEqual(productList.products[4].price, 7.54)
	}

	func testProductRepositoryLocalDataSource() async throws {
		XCTAssertEqual(self.productRepositoryLocalDataSource.fetchXforYPromotions(), self.xForYPromotions)
		XCTAssertEqual(self.productRepositoryLocalDataSource.fetchBulkPurchaseDiscounts(), self.bulkPurchaseDiscounts)
		XCTAssertEqual(self.productRepositoryLocalDataSource.fetchProductCodesForCheckout(), self.productCodes)
	}

	// MARK: ProductRepository

	func testProductRepositoryFetchProducts() async throws {
		let productList = try await self.productRepository.fetchProducts()
		XCTAssertEqual(productList.products.count, 5)
		XCTAssertEqual(productList.products[0].code, "PC1")
		XCTAssertEqual(productList.products[0].name, "Cabify Voucher")
		XCTAssertEqual(productList.products[0].price, 5)
		XCTAssertEqual(productList.products[1].code, "PC2")
		XCTAssertEqual(productList.products[1].name, "Cabify T-Shirt")
		XCTAssertEqual(productList.products[1].price, 20)
		XCTAssertEqual(productList.products[2].code, "PC3")
		XCTAssertEqual(productList.products[2].name, "Other item")
		XCTAssertEqual(productList.products[2].price, 21)
		XCTAssertEqual(productList.products[3].code, "PC4")
		XCTAssertEqual(productList.products[3].name, "Cabify Coffee Mug")
		XCTAssertEqual(productList.products[3].price, 7.5)
		XCTAssertEqual(productList.products[4].code, "PC5")
		XCTAssertEqual(productList.products[4].name, "Cabify Coffee Mug 2")
		XCTAssertEqual(productList.products[4].price, 7.54)
	}

	func testProductRepositoryFetchXforYPromotions() async throws {
		let promotions = try await self.productRepository.fetchXforYPromotions()
		XCTAssertEqual(promotions, self.xForYPromotions)
	}

	func testProductRepositoryFetchBulkPurchaseDiscounts() async throws {
		let discounts = try await self.productRepository.fetchBulkPurchaseDiscounts()
		XCTAssertEqual(discounts, self.bulkPurchaseDiscounts)
	}

	func testProductRepositoryFetchProductCodesForCheckout() {
		let productCodes = self.productRepository.fetchProductCodesForCheckout()
		XCTAssertEqual(productCodes, self.productCodes)
	}

	func testProductRepositoryAddProductForCheckout() {
		self.productRepository.addProductForCheckout(productCode: "new1")
		let productCodes = self.productRepository.fetchProductCodesForCheckout()
		XCTAssertNotEqual(productCodes, self.productCodes)
		XCTAssertTrue(productCodes.contains("new1"))
		XCTAssertEqual(productCodes.last, "new1")

		self.productRepository.removeAllProductsForCheckout()
		let productCodesAfterRemovingThem = self.productRepository.fetchProductCodesForCheckout()
		XCTAssertTrue(productCodesAfterRemovingThem.isEmpty)
		self.productCodes.forEach {
			self.productRepository.addProductForCheckout(productCode: $0)
		}
		let productCodesAfterAddedThemAgain = self.productRepository.fetchProductCodesForCheckout()
		XCTAssertEqual(productCodesAfterAddedThemAgain, self.productCodes)
	}

	func testProductRepositoryRemoveProductForCheckout() {
		self.productRepository.removeProductForCheckout(productCode: self.productCodes[1])
		let productCodes = self.productRepository.fetchProductCodesForCheckout()
		XCTAssertNotEqual(productCodes, self.productCodes)
		XCTAssertFalse(productCodes.contains(self.productCodes[1]))

		self.productRepository.removeProductForCheckout(productCode: self.productCodes[0])
		let productCodes2 = self.productRepository.fetchProductCodesForCheckout()
		XCTAssertNotEqual(productCodes2, self.productCodes)
		XCTAssertFalse(productCodes2.contains(self.productCodes[0]))
		XCTAssertNotEqual(productCodes2.first, self.productCodes[0])

		self.productRepository.removeAllProductsForCheckout()
		let productCodesAfterRemovingThem = self.productRepository.fetchProductCodesForCheckout()
		XCTAssertTrue(productCodesAfterRemovingThem.isEmpty)
		self.productCodes.forEach {
			self.productRepository.addProductForCheckout(productCode: $0)
		}
		let productCodesAfterAddedThemAgain = self.productRepository.fetchProductCodesForCheckout()
		XCTAssertEqual(productCodesAfterAddedThemAgain, self.productCodes)
	}

	func testProductRepositoryRemoveLastProductForCheckout() {
		self.productRepository.removeLastProductForCheckout(productCode: self.productCodes[1])
		let productCodes = self.productRepository.fetchProductCodesForCheckout()
		XCTAssertNotEqual(productCodes, self.productCodes)
		XCTAssertTrue(productCodes.contains(self.productCodes[1])) // we have the product code repeated, so if we just delete one it will still be one left

		self.productRepository.removeProductForCheckout(productCode: self.productCodes[0])
		let productCodes2 = self.productRepository.fetchProductCodesForCheckout()
		XCTAssertNotEqual(productCodes2, self.productCodes)
		XCTAssertFalse(productCodes2.contains(self.productCodes[0]))
		XCTAssertNotEqual(productCodes2.first, self.productCodes[0])

		self.productRepository.removeAllProductsForCheckout()
		let productCodesAfterRemovingThem = self.productRepository.fetchProductCodesForCheckout()
		XCTAssertTrue(productCodesAfterRemovingThem.isEmpty)
		self.productCodes.forEach {
			self.productRepository.addProductForCheckout(productCode: $0)
		}
		let productCodesAfterAddedThemAgain = self.productRepository.fetchProductCodesForCheckout()
		XCTAssertEqual(productCodesAfterAddedThemAgain, self.productCodes)
	}

	func testProductRepositoryRemoveAllProductsForCheckout() {
		self.productRepository.removeAllProductsForCheckout()
		let productCodesAfterRemovingThem = self.productRepository.fetchProductCodesForCheckout()
		XCTAssertTrue(productCodesAfterRemovingThem.isEmpty)
		self.productCodes.forEach {
			self.productRepository.addProductForCheckout(productCode: $0)
		}
		let productCodesAfterAddedThemAgain = self.productRepository.fetchProductCodesForCheckout()
		XCTAssertEqual(productCodesAfterAddedThemAgain, self.productCodes)
	}

	// MARK: - Use cases

	func testFetchProductsUseCaseUseCase() async throws {
		let products = try await self.fetchProductsUseCase.execute()
		XCTAssertEqual(products.count, 5)
		XCTAssertEqual(products[0].productCode, "PC1")
		XCTAssertEqual(products[0].name, "Cabify Voucher")
		XCTAssertEqual(products[0].basePricePerUnit, 5)
		XCTAssertEqual(products[0].productPromotion, ProductPromotion.xForYPromotion(.init(howManyItemsTheUserNeedsToBuy: 2, howManyItemsTheUserWillPay: 1)))
		XCTAssertEqual(products[1].productCode, "PC2")
		XCTAssertEqual(products[1].name, "Cabify T-Shirt")
		XCTAssertEqual(products[1].basePricePerUnit, 20)
		XCTAssertEqual(products[1].productPromotion, ProductPromotion.xForYPromotion(.init(howManyItemsTheUserNeedsToBuy: 4, howManyItemsTheUserWillPay: 1)))
		XCTAssertEqual(products[2].productCode, "PC3")
		XCTAssertEqual(products[2].name, "Other item")
		XCTAssertEqual(products[2].basePricePerUnit, 21)
		XCTAssertEqual(products[2].productPromotion, ProductPromotion.bulkPurchaseDiscount(.init(howManyItemsTheUserNeedsToBuyAtLeast: 3, priceModifierPerUnit: -0.1)))
		XCTAssertEqual(products[3].productCode, "PC4")
		XCTAssertEqual(products[3].name, "Cabify Coffee Mug")
		XCTAssertEqual(products[3].basePricePerUnit, 7.5)
		XCTAssertEqual(products[3].productPromotion, ProductPromotion.bulkPurchaseDiscount(.init(howManyItemsTheUserNeedsToBuyAtLeast: 2, priceModifierPerUnit: 2)))
		XCTAssertEqual(products[4].productCode, "PC5")
		XCTAssertEqual(products[4].name, "Cabify Coffee Mug 2")
		XCTAssertEqual(products[4].basePricePerUnit, 7.54)
	}

	// MARK: checkout use cases

	func testProductCodesForCheckout() {
		XCTAssertEqual(self.productCodesForCheckoutUseCase.execute(), self.productCodes)
	}

	func testAddProductForCheckout() {
		self.addProductForCheckoutUseCase.execute("new1")
		let productCodes: [String] = self.productCodesForCheckoutUseCase.execute()
		XCTAssertNotEqual(productCodes, self.productCodes)
		XCTAssertTrue(productCodes.contains("new1"))
		XCTAssertEqual(productCodes.last, "new1")

		self.removeAllProductsForCheckoutUseCase.execute()
		let productCodesAfterRemovingThem: [String] = self.productCodesForCheckoutUseCase.execute()
		XCTAssertTrue(productCodesAfterRemovingThem.isEmpty)
		self.productCodes.forEach {
			self.addProductForCheckoutUseCase.execute($0)
		}
		let productCodesAfterAddedThemAgain: [String] = self.productCodesForCheckoutUseCase.execute()
		XCTAssertEqual(productCodesAfterAddedThemAgain, self.productCodes)
	}

	func testRemoveProductForCheckoutRemovingAllProductsWithSameCode() {
		self.removeProductForCheckoutUseCase.execute(forAllProductsWithProductCode: "PC2")
		let productCodes: [String] = self.productCodesForCheckoutUseCase.execute()
		XCTAssertNotEqual(productCodes, self.productCodes)
		XCTAssertFalse(productCodes.contains("PC2"))

		self.removeAllProductsForCheckoutUseCase.execute()
		let productCodesAfterRemovingThem: [String] = self.productCodesForCheckoutUseCase.execute()
		XCTAssertTrue(productCodesAfterRemovingThem.isEmpty)
		self.productCodes.forEach {
			self.addProductForCheckoutUseCase.execute($0)
		}
		let productCodesAfterAddedThemAgain: [String] = self.productCodesForCheckoutUseCase.execute()
		XCTAssertEqual(productCodesAfterAddedThemAgain, self.productCodes)
	}

	func testRemoveProductForCheckoutRemovingLastProduct() {
		self.removeProductForCheckoutUseCase.execute(forLastProductWithProductCode: "PC2")
		let productCodes: [String] = self.productCodesForCheckoutUseCase.execute()
		XCTAssertNotEqual(productCodes, self.productCodes)
		XCTAssertTrue(productCodes.contains("PC2"))

		self.removeAllProductsForCheckoutUseCase.execute()
		let productCodesAfterRemovingThem: [String] = self.productCodesForCheckoutUseCase.execute()
		XCTAssertTrue(productCodesAfterRemovingThem.isEmpty)
		self.productCodes.forEach {
			self.addProductForCheckoutUseCase.execute($0)
		}
		let productCodesAfterAddedThemAgain: [String] = self.productCodesForCheckoutUseCase.execute()
		XCTAssertEqual(productCodesAfterAddedThemAgain, self.productCodes)
	}

	func testRemoveAllProductsForCheckout() {
		self.removeAllProductsForCheckoutUseCase.execute()
		let productCodesAfterRemovingThem: [String] = self.productCodesForCheckoutUseCase.execute()
		XCTAssertTrue(productCodesAfterRemovingThem.isEmpty)
		self.productCodes.forEach {
			self.addProductForCheckoutUseCase.execute($0)
		}
		let productCodesAfterAddedThemAgain: [String] = self.productCodesForCheckoutUseCase.execute()
		XCTAssertEqual(productCodesAfterAddedThemAgain, self.productCodes)
	}
}
