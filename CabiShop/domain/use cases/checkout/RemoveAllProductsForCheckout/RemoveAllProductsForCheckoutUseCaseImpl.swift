//
//  RemoveAllProductsForCheckoutUseCaseImpl.swift
//  CabiShop
//
//  Created by Daniel Illescas Romero on 27/5/23.
//

import Foundation

final class RemoveAllProductsForCheckoutUseCaseImpl: RemoveAllProductsForCheckoutUseCase {

	private let productRepository: ProductRepository

	init(productRepository: ProductRepository) {
		self.productRepository = productRepository
	}

	func execute() {
		self.productRepository.removeAllProductsForCheckout()
	}
}
