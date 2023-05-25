//
//  ProductsForCheckoutUseCaseImpl.swift
//  CabiShop
//
//  Created by Daniel Illescas Romero on 27/5/23.
//

import Foundation
import Combine

class ProductsForCheckoutUseCaseImpl: ProductsForCheckoutUseCase {

	private let productCodesForCheckoutUseCase: ProductCodesForCheckoutUseCase
	private let calculateTotalPriceForCheckout: CalculateTotalCheckoutPriceUseCase
	private let fetchProductsUseCase: FetchProductsUseCase

	init(
		productCodesForCheckoutUseCase: ProductCodesForCheckoutUseCase,
		calculateTotalPriceForCheckout: CalculateTotalCheckoutPriceUseCase,
		fetchProductsUseCase: FetchProductsUseCase
	) {
		self.productCodesForCheckoutUseCase = productCodesForCheckoutUseCase
		self.calculateTotalPriceForCheckout = calculateTotalPriceForCheckout
		self.fetchProductsUseCase = fetchProductsUseCase
	}

	func execute() async throws -> AnyPublisher<ProductsForCheckout, Never> {
		let allAvailableProducts = try await fetchProductsUseCase.execute()
		return productCodesForCheckoutUseCase
			.execute()
			.map { productCodes in
				let groupedProducts = allAvailableProducts.filter { productCodes.contains($0.productCode) }
				if groupedProducts.isEmpty {
					return ProductsForCheckout(products: [], totalPrice: 0)
				} else {
					let price = self.calculateTotalPriceForCheckout.execute(products: allAvailableProducts)
					return ProductsForCheckout(
						products: groupedProducts,
						totalPrice: price
					)
				}
			}
			.eraseToAnyPublisher()
	}
}
