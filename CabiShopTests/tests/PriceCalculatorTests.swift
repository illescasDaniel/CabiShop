//
//  PriceCalculatorTests.swift
//  CabiShopTests
//
//  Created by Daniel Illescas Romero on 29/5/23.
//

import Foundation
import XCTest
@testable import CabiShop

class PriceCalculatorTests: XCTestCase {

	private lazy var totalPriceCalculator = TotalPriceCalculator(priceCalculator: ProductPriceCalculator())

	func testProductPriceCalculator() {
		/*
		 Code         | Name                |  Price
		 -------------------------------------------------
		 VOUCHER      | Cabify Voucher      |   5.00€
		 TSHIRT       | Cabify T-Shirt      |  20.00€
		 MUG          | Cabify Coffee Mug   |   7.50€
		*/
		/*
		 * The marketing department believes in 2-for-1 promotions (buy two of the same product, get one free), and would like to have a 2-for-1 special on `VOUCHER` items.
		 * The CFO insists that the best way to increase sales is with discounts on bulk purchases (buying x or more of a product, the price of that product is reduced), and demands that if you buy 3 or more `TSHIRT` items, the price per unit should be 19.00€.
		 */
		let voucherProduct = ProductWithPromotion(
			name: "Cabify Voucher",
			productCode: "VOUCHER",
			basePricePerUnit: 5,
			productPromotion: .xForYPromotion(.init(howManyItemsTheUserNeedsToBuy: 2, howManyItemsTheUserWillPay: 1))
		)
		let tShirtProduct = ProductWithPromotion(
			name: "Cabify T-Shirt",
			productCode: "TSHIRT",
			basePricePerUnit: 20,
			productPromotion: .bulkPurchaseDiscount(.init(howManyItemsTheUserNeedsToBuyAtLeast: 3, priceModifierPerUnit: -1))
		)
		let mugProduct = ProductWithPromotion(
			name: "Cabify Coffee Mug",
			productCode: "MUG",
			basePricePerUnit: 7.5,
			productPromotion: .bulkPurchaseDiscount(.init(howManyItemsTheUserNeedsToBuyAtLeast: 3, priceModifierPerUnit: -1))
		)
		let allProducts = [ voucherProduct, tShirtProduct, mugProduct ]
		/*
		 Items: VOUCHER, TSHIRT, MUG
		 Total: 32.50€

		 Items: VOUCHER, TSHIRT, VOUCHER
		 Total: 25.00€

		 Items: TSHIRT, TSHIRT, TSHIRT, VOUCHER, TSHIRT
		 Total: 81.00€

		 Items: VOUCHER, TSHIRT, VOUCHER, VOUCHER, MUG, TSHIRT, TSHIRT
		 Total: 74.50€
		 */

		let totalPrice1 = totalPriceCalculator.totalPrice(
			allProducts: allProducts,
			selectedProductCodes: [
				voucherProduct, tShirtProduct, mugProduct
			].map(\.productCode)
		)
		XCTAssertEqual(totalPrice1, 32.5)

		let totalPrice2 = totalPriceCalculator.totalPrice(
			allProducts: allProducts,
			selectedProductCodes: [
				voucherProduct, tShirtProduct, voucherProduct
			].map(\.productCode)
		)
		XCTAssertEqual(totalPrice2, 25)

		let totalPrice3 = totalPriceCalculator.totalPrice(
			allProducts: allProducts,
			selectedProductCodes: [
				tShirtProduct, tShirtProduct, tShirtProduct, voucherProduct, tShirtProduct
			].map(\.productCode)
		)
		XCTAssertEqual(totalPrice3, 81)

		let totalPrice4 = totalPriceCalculator.totalPrice(
			allProducts: allProducts,
			selectedProductCodes: [
				voucherProduct, tShirtProduct, voucherProduct, voucherProduct, mugProduct, tShirtProduct, tShirtProduct
			].map(\.productCode)
		)
		XCTAssertEqual(totalPrice4, 74.5)
	}
}
