//
//  CalculateTotalCheckoutPriceUseCaseImpl.swift
//  CabiShop
//
//  Created by Daniel Illescas Romero on 27/5/23.
//

import Foundation

final class CalculateTotalCheckoutPriceUseCaseImpl: CalculateTotalCheckoutPriceUseCase {

	private let fetchProductsUseCase: FetchProductsUseCase
	private let productCodesForCheckoutUseCase: ProductCodesForCheckoutUseCase
	private let totalPriceCalculator: TotalPriceCalculator

	init(
		fetchProductsUseCase: FetchProductsUseCase,
		productCodesForCheckoutUseCase: ProductCodesForCheckoutUseCase,
		totalPriceCalculator: TotalPriceCalculator
	) {
		self.fetchProductsUseCase = fetchProductsUseCase
		self.productCodesForCheckoutUseCase = productCodesForCheckoutUseCase
		self.totalPriceCalculator = totalPriceCalculator
	}

	func execute() async throws -> Decimal {
		let products = try await self.fetchProductsUseCase.execute()
		let productCodes: [String] = self.productCodesForCheckoutUseCase.execute()
		return totalPriceCalculator.totalPrice(allProducts: products, selectedProductCodes: productCodes)
	}

	func execute(products: [ProductWithPromotion]) -> Decimal {
		let productCodes: [String] = self.productCodesForCheckoutUseCase.execute()
		return totalPriceCalculator.totalPrice(allProducts: products, selectedProductCodes: productCodes)
	}
}
