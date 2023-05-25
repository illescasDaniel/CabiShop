//
//  FetchProductsUseCase.swift
//  CabiShop
//
//  Created by Daniel Illescas Romero on 25/5/23.
//

import Foundation

protocol FetchProductsUseCase {
	func execute() async throws -> [ProductWithPromotion] 
}
