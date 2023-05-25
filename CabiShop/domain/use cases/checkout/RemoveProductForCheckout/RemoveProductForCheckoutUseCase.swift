//
//  RemoveProductForCheckoutUseCase.swift
//  CabiShop
//
//  Created by Daniel Illescas Romero on 26/5/23.
//

import Foundation

protocol RemoveProductForCheckoutUseCase {
	func execute(forLastProductWithProductCode productCode: String)
	func execute(forAllProductsWithProductCode productCode: String)
}
