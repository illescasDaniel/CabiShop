//
//  ProductRepositoryNetworkDataSource.swift
//  CabiShop
//
//  Created by Daniel Illescas Romero on 25/5/23.
//

import Foundation

protocol ProductRepositoryNetworkDataSource {
	func fetchProducts() async throws -> ProductList
}
