//
//  CalculateTotalCheckoutPriceUseCase.swift
//  CabiShop
//
//  Created by Daniel Illescas Romero on 27/5/23.
//

import Foundation

protocol CalculateTotalCheckoutPriceUseCase {
	func execute() async throws -> Decimal
	func execute(products: [ProductWithPromotion]) -> Decimal
}
