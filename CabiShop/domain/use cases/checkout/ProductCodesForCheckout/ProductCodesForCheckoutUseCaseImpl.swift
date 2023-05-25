//
//  ProductCodesForCheckoutUseCaseImpl.swift
//  CabiShop
//
//  Created by Daniel Illescas Romero on 26/5/23.
//

import Foundation
import Combine

final class ProductCodesForCheckoutUseCaseImpl: ProductCodesForCheckoutUseCase {

	private let productRepository: ProductRepository

	init(productRepository: ProductRepository) {
		self.productRepository = productRepository
	}

	func execute() -> [String] {
		self.productRepository.fetchProductCodesForCheckout()
	}

	func execute() -> AnyPublisher<[String], Never> {
		self.productRepository.productCodesForCheckout()
	}
}
