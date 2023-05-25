//
//  RemoveProductForCheckoutUseCaseImpl.swift
//  CabiShop
//
//  Created by Daniel Illescas Romero on 26/5/23.
//

import Foundation

final class RemoveProductForCheckoutUseCaseImpl: RemoveProductForCheckoutUseCase {

	private let productRepository: ProductRepository

	init(productRepository: ProductRepository) {
		self.productRepository = productRepository
	}

	func execute(forLastProductWithProductCode productCode: String) {
		self.productRepository.removeLastProductForCheckout(productCode: productCode)
	}

	func execute(forAllProductsWithProductCode productCode: String) {
		self.productRepository.removeProductForCheckout(productCode: productCode)
	}
}
