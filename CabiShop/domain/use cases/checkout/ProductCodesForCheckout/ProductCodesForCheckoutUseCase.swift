//
//  ProductCodesForCheckoutUseCase.swift
//  CabiShop
//
//  Created by Daniel Illescas Romero on 26/5/23.
//

import Foundation
import Combine

protocol ProductCodesForCheckoutUseCase {
	func execute() -> [String]
	func execute() -> AnyPublisher<[String], Never>
}
