//
//  ProductListViewModel.swift
//  CabiShop
//
//  Created by Daniel Illescas Romero on 25/5/23.
//

import Foundation
import Combine

@MainActor
final class ProductListViewModel: ObservableObject {

	@Published
	private(set) var productsResult: ResultState<[ProductForDisplay]> = .idle

	private let fetchProductsUseCase: FetchProductsUseCase
	private let produtWithPromotionMapper: ProductWithPromotionMapper
	private let logger: Logger

	init(
		fetchProductsUseCase: FetchProductsUseCase,
		produtWithPromotionMapper: ProductWithPromotionMapper,
		logger: Logger
	) {
		self.fetchProductsUseCase = fetchProductsUseCase
		self.produtWithPromotionMapper = produtWithPromotionMapper
		self.logger = logger
	}

	func fetchProducts() async {
		productsResult = .loading
		do {
			let products = try await _fetchProducts()
			if products.isEmpty {
				self.productsResult = .empty
			} else {
				self.productsResult = .nonEmpty(products)
			}
		} catch {
			self.logger.log(severity: .error, category: "ViewModel", message: error.localizedDescription)
			self.productsResult = .error
		}
	}

	func refreshProducts() async {
		do {
			let products = try await _fetchProducts()
			if products.isEmpty {
				self.productsResult = .empty
			} else {
				self.productsResult = .nonEmpty(products)
			}
		} catch {
			self.logger.log(severity: .error, category: "ViewModel", message: error.localizedDescription)
			self.productsResult = .error
		}
	}

	private func _fetchProducts() async throws -> [ProductForDisplay] {
		let products = try await self.fetchProductsUseCase.execute()
		let mappedProducts = produtWithPromotionMapper.mapProductsWithPromotion(products)
		return mappedProducts
	}
}
