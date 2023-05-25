//
//  NetworkHTTPClient.swift
//  CabiShop
//
//  Created by Daniel Illescas Romero on 26/5/23.
//

import Foundation

protocol NetworkHTTPClient {

	func makeRequest<T: Decodable>(
		decoding type: T.Type,
		url requestURLString: String,
		method: HTTPMethod
	) async throws -> T

	func makeRequest<T: Decodable>(
		decoding type: T.Type,
		url requestURLString: String,
		method: HTTPMethod
	) async -> Result<T, NetworkRequestError>

	func makeRequest(
		url requestURLString: String,
		method: HTTPMethod
	) async -> Result<NetworkResponse, NetworkRequestError>

	func makeRequest(_ request: URLRequest) async throws -> NetworkResponse
}
