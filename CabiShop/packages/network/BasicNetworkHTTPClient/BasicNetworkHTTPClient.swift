//
//  BasicNetworkHTTPClient.swift
//  CabiShop
//
//  Created by Daniel Illescas Romero on 28/5/23.
//

import Foundation

protocol BasicNetworkHTTPClient {
	func makeRequest(_ request: URLRequest) async throws -> NetworkResponse
}
