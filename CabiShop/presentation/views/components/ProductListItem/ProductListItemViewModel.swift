//
//  ProductListItemViewModel.swift
//  CabiShop
//
//  Created by Daniel Illescas Romero on 25/5/23.
//

import Foundation
import Combine

@MainActor
final class ProductListItemViewModel: ObservableObject {

	@Published
	private(set) var formattedFinalPrice: String?

	@Published
	private(set) var addedItemsCount: UInt = 0

	private var cancellables: [AnyCancellable] = []

	private let numberFormatterUtils: NumberFormatterUtils
	private let productPriceCalculator: ProductPriceCalculator
	private let productCodesForCheckoutUseCase: ProductCodesForCheckoutUseCase
	private let addProductForCheckoutUseCase: AddProductForCheckoutUseCase
	private let removeProductForCheckoutUseCase: RemoveProductForCheckoutUseCase

	init(
		numberFormatterUtils: NumberFormatterUtils,
		productPriceCalculator: ProductPriceCalculator,
		productCodesForCheckoutUseCase: ProductCodesForCheckoutUseCase,
		addProductForCheckoutUseCase: AddProductForCheckoutUseCase,
		removeProductForCheckoutUseCase: RemoveProductForCheckoutUseCase
	) {
		self.numberFormatterUtils = numberFormatterUtils
		self.productPriceCalculator = productPriceCalculator
		self.productCodesForCheckoutUseCase = productCodesForCheckoutUseCase
		self.addProductForCheckoutUseCase = addProductForCheckoutUseCase
		self.removeProductForCheckoutUseCase = removeProductForCheckoutUseCase
	}

	deinit {
		cancellables.forEach {
			$0.cancel()
		}
	}

	func listenForProductChangesForCheckout(for product: ProductForDisplay)  {
		let productCodesForCheckout: AnyPublisher<[String], Never> = self.productCodesForCheckoutUseCase.execute()
		productCodesForCheckout
			.receive(on: DispatchQueue.main)
			.map { productCodes in
				productCodes.filter { $0 == product.productCode }.count
			}
			.sink { [weak self] productCodeCount in
				guard let self else { return }
				if self.addedItemsCount != productCodeCount {
					self.addedItemsCount = UInt(productCodeCount)
					self.updatePrice(product)
				}
			}
			.store(in: &cancellables)
	}

	func addProduct(_ product: ProductForDisplay) {
		self.addProductForCheckoutUseCase.execute(product.productCode)
		updatePrice(product)
	}

	func removeProduct(_ product: ProductForDisplay) {
		guard addedItemsCount > 0 else { return }
		self.removeProductForCheckoutUseCase.execute(forLastProductWithProductCode: product.productCode)
		updatePrice(product)
	}

	func removeAllProducts(withCode productCode: String) {
		addedItemsCount = 0
		self.removeProductForCheckoutUseCase.execute(forAllProductsWithProductCode: productCode)
		formattedFinalPrice = nil
	}

	func hasPromotionApplied(for product: ProductForDisplay) -> Bool {
		switch product.promotionWithDescription?.promotion {
		case .xForYPromotion(let xForYPromotion):
			return addedItemsCount >= xForYPromotion.howManyItemsTheUserNeedsToBuy
		case .bulkPurchaseDiscount(let bulkPurchaseDiscount):
			return addedItemsCount >= bulkPurchaseDiscount.howManyItemsTheUserNeedsToBuyAtLeast
		case .none:
			return false
		}
	}

	func productPrice(for product: ProductForDisplay) -> String {
		let price = self.productPriceCalculator.calculatePrice(basePricePerUnit: product.basePricePerUnit, promotion: product.promotionWithDescription?.promotion, units: addedItemsCount)
		let formattedPrice = self.numberFormatterUtils.formatProductPriceInEuro(price)
		return formattedPrice
	}

	func priceWithoutDiscounts(for product: ProductForDisplay) -> String {
		let units = max(addedItemsCount, 1)
		let price = self.productPriceCalculator.normalPrice(basePricePerUnit: product.basePricePerUnit, units: units)
		let formattedPrice = self.numberFormatterUtils.formatProductPriceInEuro(price)
		return formattedPrice
	}

	// MARK: private

	private func updatePrice(_ product: ProductForDisplay) {
		formattedFinalPrice = productPrice(for: product)
	}
}
