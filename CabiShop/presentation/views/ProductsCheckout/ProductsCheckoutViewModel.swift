//
//  ProductsCheckoutViewModel.swift
//  CabiShop
//
//  Created by Daniel Illescas Romero on 25/5/23.
//

import Foundation
import Combine

@MainActor
final class ProductsCheckoutViewModel: ObservableObject {

	@Published
	private(set) var loadingState: LoadingState = .idle

	@Published
	private(set) var products: [ProductForDisplay] = []

	@Published
	private(set) var formattedTotalPrice: String = String()

	private var cancellables: [AnyCancellable] = []

	private let productsForCheckoutUseCase: ProductsForCheckoutUseCase
	private let productWithPromotionMapper: ProductWithPromotionMapper
	private let numberFormatterUtils: NumberFormatterUtils

	init(
		productsForCheckoutUseCase: ProductsForCheckoutUseCase,
		productWithPromotionMapper: ProductWithPromotionMapper,
		numberFormatterUtils: NumberFormatterUtils
	) {
		self.productsForCheckoutUseCase = productsForCheckoutUseCase
		self.productWithPromotionMapper = productWithPromotionMapper
		self.numberFormatterUtils = numberFormatterUtils
	}

	deinit {
		self.cancellables.forEach { $0.cancel() }
		self.cancellables.removeAll()
	}

	func loadProducts() async {
		loadingState = .loading
		do {
			try await _loadProducts()
		} catch {
			loadingState = .error
		}
	}

	private func _loadProducts() async throws {
		let productsForCheckoutPublisher = try await productsForCheckoutUseCase.execute()
		productsForCheckoutPublisher
			.receive(on: DispatchQueue.main)
			.sink { [weak self] productsForCheckout in
				guard let self else { return }
				if productsForCheckout.products.isEmpty {
					self.loadingState = .hasNoData
				} else {
					let products = self.productWithPromotionMapper.mapProductsWithPromotion(productsForCheckout.products)
					self.products = products
					let formattedPrice = self.numberFormatterUtils.formatProductPriceInEuro(productsForCheckout.totalPrice)
					self.formattedTotalPrice = formattedPrice
					self.loadingState = .hasData
				}
			}
			.store(in: &cancellables)
	}
}
