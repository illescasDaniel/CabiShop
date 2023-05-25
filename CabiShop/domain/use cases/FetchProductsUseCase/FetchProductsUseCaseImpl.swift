//
//  FetchProductsUseCaseImpl.swift
//  CabiShop
//
//  Created by Daniel Illescas Romero on 25/5/23.
//

import Foundation

final class FetchProductsUseCaseImpl: FetchProductsUseCase {

	private let productRepository: ProductRepository
	private let productMapper: ProductMapper

	init(productRepository: ProductRepository, productMapper: ProductMapper) {
		self.productRepository = productRepository
		self.productMapper = productMapper
	}

	func execute() async throws -> [ProductWithPromotion] {

		async let productList = self.productRepository.fetchProducts()
		async let xForYPromotions = self.productRepository.fetchXforYPromotions()
		async let bulkPurchaseDiscounts = self.productRepository.fetchBulkPurchaseDiscounts()

		return self.productMapper.mapToProductsWithPromotion(
			products: try await productList.products,
			xForYPromotions: try await xForYPromotions,
			bulkPurchaseDiscounts: try await bulkPurchaseDiscounts
		)
	}
}
