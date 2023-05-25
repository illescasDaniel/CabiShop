//
//  Product.swift
//  CabiShop
//
//  Created by Daniel Illescas Romero on 25/5/23.
//

import Foundation

struct Product: Decodable {
	let code: String
	let name: String
	let price: Decimal
}
