//
//  ShoppingCartButtonViewModel.swift
//  CabiShop
//
//  Created by Daniel Illescas Romero on 28/5/23.
//

import Foundation
import Combine

@MainActor
class ShoppingCartButtonViewModel: ObservableObject {

	@Published
	private(set) var hasProductsForCheckout: Bool = false

	private var cancellables: [AnyCancellable] = []

	private let productCodesForCheckoutUseCase: ProductCodesForCheckoutUseCase

	init(productCodesForCheckoutUseCase: ProductCodesForCheckoutUseCase) {
		self.productCodesForCheckoutUseCase = productCodesForCheckoutUseCase
	}

	deinit {
		self.cancellables.forEach { $0.cancel() }
		self.cancellables.removeAll()
	}

	func listenForNewProductsForCheckout()  {
		cancellables.forEach { $0.cancel() }
		let productCodes: [String] = self.productCodesForCheckoutUseCase.execute()
		self.hasProductsForCheckout = !productCodes.isEmpty

		let productCodesForCheckout: AnyPublisher<[String], Never> = self.productCodesForCheckoutUseCase.execute()
		productCodesForCheckout
			.receive(on: DispatchQueue.main)
			.sink { [weak self] productCodes in
				guard let self else { return }
				self.hasProductsForCheckout = !productCodes.isEmpty
			}
			.store(in: &cancellables)
	}
}
