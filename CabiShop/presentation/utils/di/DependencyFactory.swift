//
//  DependencyFactory.swift
//  CabiShop
//
//  Created by Daniel Illescas Romero on 25/5/23.
//

import Foundation

@MainActor
protocol DependencyFactory {
	func get() -> ProductListViewModel
	func get() -> ProductListItemViewModel
	func get() -> ProductsCheckoutViewModel
	func get() -> ShoppingCartButtonViewModel

	func get() -> Logger
}
