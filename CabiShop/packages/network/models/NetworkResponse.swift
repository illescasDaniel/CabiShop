//
//  NetworkResponse.swift
//  CabiShop
//
//  Created by Daniel Illescas Romero on 25/5/23.
//

import Foundation

struct NetworkResponse {
	let urlRequest: URLRequest
	let body: Data
	let httpStatusCode: HTTPStatusCode
	var bodyString: String {
		String(decoding: body, as: UTF8.self)
	}
}
