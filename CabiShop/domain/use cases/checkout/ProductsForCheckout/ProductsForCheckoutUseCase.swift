//
//  ProductsForCheckoutUseCase.swift
//  CabiShop
//
//  Created by Daniel Illescas Romero on 27/5/23.
//

import Foundation
import Combine

protocol ProductsForCheckoutUseCase {
	func execute() async throws -> AnyPublisher<ProductsForCheckout, Never>
}
