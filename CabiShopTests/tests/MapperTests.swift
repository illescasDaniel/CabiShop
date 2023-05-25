//
//  MapperTests.swift
//  CabiShopTests
//
//  Created by Daniel Illescas Romero on 29/5/23.
//

import Foundation
import XCTest
@testable import CabiShop

class MapperTests: XCTestCase {

	private lazy var promotionMapper = PromotionMapper()
	private lazy var productMapper = ProductMapper(promotionMapper: promotionMapper)
	private lazy var productWithPromotionMapper = ProductWithPromotionMapper(numberFormatterUtils: NumberFormatterUtils())

	func testPromotionMapperBulkPurchasePriceModifierForProductCode() {
		let bulkPurchasePriceModifierForProductCode = BulkPurchasePriceModifierForProductCode(
			howManyItemsTheUserNeedsToBuyAtLeast: 3,
			priceModifierPerUnit: -1,
			productCode: "A"
		)
		let mappedBulkPurchaseDiscount = promotionMapper.mapBulkPurchase(bulkPurchasePriceModifierForProductCode)
		XCTAssertEqual(bulkPurchasePriceModifierForProductCode.howManyItemsTheUserNeedsToBuyAtLeast, mappedBulkPurchaseDiscount.howManyItemsTheUserNeedsToBuyAtLeast)
		XCTAssertEqual(bulkPurchasePriceModifierForProductCode.priceModifierPerUnit, mappedBulkPurchaseDiscount.priceModifierPerUnit)
	}

	func testPromotionMapperXforYPromotionForProductCode() {
		let xForYPromotionForProductCode = XforYPromotionForProductCode(
			howManyItemsTheUserNeedsToBuy: 2,
			howManyItemsTheUserWillPay: 1,
			productCode: "B"
		)
		let mappedXforYPromotion = promotionMapper.mapXForYPromotion(xForYPromotionForProductCode)
		XCTAssertEqual(xForYPromotionForProductCode.howManyItemsTheUserNeedsToBuy, mappedXforYPromotion.howManyItemsTheUserNeedsToBuy)
		XCTAssertEqual(xForYPromotionForProductCode.howManyItemsTheUserWillPay, mappedXforYPromotion.howManyItemsTheUserWillPay)
	}

	func testProductMapper() {
		let products = [
			Product(code: "a", name: "aa", price: 3.5),
			Product(code: "b", name: "bb", price: 3.5),
			Product(code: "c", name: "cc", price: 3.5),
		]
		let mappedProducts = productMapper.mapToProductsWithPromotion(
			products: products,
			xForYPromotions: [.create2for1Promotion(productCode: "a")],
			bulkPurchaseDiscounts: [.init(howManyItemsTheUserNeedsToBuyAtLeast: 3, priceModifierPerUnit: 1, productCode: "b")]
		)
		XCTAssertEqual(mappedProducts[0].productCode, products[0].code)
		XCTAssertEqual(mappedProducts[0].basePricePerUnit, products[0].price)
		XCTAssertEqual(mappedProducts[0].name, products[0].name)
		XCTAssertEqual(mappedProducts[0].productPromotion, ProductPromotion.xForYPromotion(XforYPromotion(howManyItemsTheUserNeedsToBuy: 2, howManyItemsTheUserWillPay: 1)))

		XCTAssertEqual(mappedProducts[1].productCode, products[1].code)
		XCTAssertEqual(mappedProducts[1].basePricePerUnit, products[1].price)
		XCTAssertEqual(mappedProducts[1].name, products[1].name)
		XCTAssertEqual(mappedProducts[1].productPromotion, ProductPromotion.bulkPurchaseDiscount(.init(howManyItemsTheUserNeedsToBuyAtLeast: 3, priceModifierPerUnit: 1)))

		XCTAssertEqual(mappedProducts[2].productCode, products[2].code)
		XCTAssertEqual(mappedProducts[2].basePricePerUnit, products[2].price)
		XCTAssertEqual(mappedProducts[2].name, products[2].name)
	}

	func testProductWithPromotionMapper() {
		let productsWithPromotion = [
			ProductWithPromotion(name: "a", productCode: "aa", basePricePerUnit: 3.1, productPromotion: .xForYPromotion(.init(howManyItemsTheUserNeedsToBuy: 2, howManyItemsTheUserWillPay: 1))),
			ProductWithPromotion(name: "b", productCode: "bb", basePricePerUnit: 3.1, productPromotion: .xForYPromotion(.init(howManyItemsTheUserNeedsToBuy: 2, howManyItemsTheUserWillPay: 1))),
			ProductWithPromotion(name: "c", productCode: "cc", basePricePerUnit: 3.1, productPromotion: nil),
		]
		let productsForDisplay = productWithPromotionMapper.mapProductsWithPromotion(productsWithPromotion)
		XCTAssertEqual(productsForDisplay[0].productCode, productsWithPromotion[0].productCode)
		XCTAssertEqual(productsForDisplay[0].basePricePerUnit, productsWithPromotion[0].basePricePerUnit)
		XCTAssertEqual(productsForDisplay[0].name, productsWithPromotion[0].name)
		XCTAssertEqual(productsForDisplay[0].promotionWithDescription?.promotion, productsWithPromotion[0].productPromotion)

		XCTAssertEqual(productsForDisplay[1].productCode, productsWithPromotion[1].productCode)
		XCTAssertEqual(productsForDisplay[1].basePricePerUnit, productsWithPromotion[1].basePricePerUnit)
		XCTAssertEqual(productsForDisplay[1].name, productsWithPromotion[1].name)
		XCTAssertEqual(productsForDisplay[1].promotionWithDescription?.promotion, productsWithPromotion[1].productPromotion)

		XCTAssertEqual(productsForDisplay[2].productCode, productsWithPromotion[2].productCode)
		XCTAssertEqual(productsForDisplay[2].basePricePerUnit, productsWithPromotion[2].basePricePerUnit)
		XCTAssertEqual(productsForDisplay[2].name, productsWithPromotion[2].name)
		XCTAssertEqual(productsForDisplay[2].promotionWithDescription?.promotion, productsWithPromotion[2].productPromotion)
	}
}
