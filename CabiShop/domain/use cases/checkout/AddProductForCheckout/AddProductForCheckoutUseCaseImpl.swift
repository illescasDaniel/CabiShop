//
//  AddProductForCheckoutUseCaseImpl.swift
//  CabiShop
//
//  Created by Daniel Illescas Romero on 26/5/23.
//

import Foundation

final class AddProductForCheckoutUseCaseImpl: AddProductForCheckoutUseCase {

	private let productRepository: ProductRepository

	init(productRepository: ProductRepository) {
		self.productRepository = productRepository
	}

	func execute(_ productCode: String) {
		self.productRepository.addProductForCheckout(productCode: productCode)
	}
}
