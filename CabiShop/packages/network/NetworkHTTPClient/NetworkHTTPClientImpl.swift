//
//  NetworkHTTPClientImpl.swift
//  CabiShop
//
//  Created by Daniel Illescas Romero on 25/5/23.
//

import Foundation

final class NetworkHTTPClientImpl: NetworkHTTPClient {

	private let basicNetworkHTTPClient: BasicNetworkHTTPClient

	init(basicNetworkHTTPClient: BasicNetworkHTTPClient) {
		self.basicNetworkHTTPClient = basicNetworkHTTPClient
	}

	func makeRequest<T: Decodable>(
		decoding type: T.Type,
		url requestURLString: String,
		method: HTTPMethod
	) async throws -> T {
		try await makeRequest(decoding: type, url: requestURLString, method: method).get()
	}

	func makeRequest<T: Decodable>(
		decoding type: T.Type,
		url requestURLString: String,
		method: HTTPMethod
	) async -> Result<T, NetworkRequestError> {
		let responseResult = await makeRequest(url: requestURLString, method: method)
		switch responseResult {
		case .failure(let error):
			return .failure(error)
		case .success(let response):
			guard response.httpStatusCode.isOK else {
				return .failure(NetworkRequestError.invalidResponse(response))
			}
			do {
				let decoder = JSONDecoder()
				let decodedValue = try decoder.decode(T.self, from: response.body)
				return .success(decodedValue)
			} catch {
				return .failure(NetworkRequestError.decodingError(error))
			}
		}
	}

	func makeRequest(
		url requestURLString: String,
		method: HTTPMethod
	) async -> Result<NetworkResponse, NetworkRequestError> {
		guard let requestURL = URL(string: requestURLString) else {
			return .failure(NetworkRequestError.urlError(requestURLString))
		}
		var urlRequest = URLRequest(url: requestURL)
		urlRequest.httpMethod = method.methodName
		switch method {
		case .get(queryItems: let queryItems):
			if !queryItems.isEmpty {
				guard var urlComponents = URLComponents(string: requestURLString) else {
					return .failure(NetworkRequestError.urlError(requestURLString))
				}
				urlComponents.queryItems = (urlComponents.queryItems ?? []) + queryItems
				guard let validComponentsURL = urlComponents.url else {
					return .failure(NetworkRequestError.urlError(requestURLString))
				}
				urlRequest.url = validComponentsURL
			}
		case .post(body: let bodyData), .put(body: let bodyData), .patch(body: let bodyData):
			urlRequest.httpBody = bodyData
		case .delete: break
		}
		do {
			let response = try await self.makeRequest(urlRequest)
			return .success(response)
		} catch {
			return .failure(NetworkRequestError.requestError(error))
		}
	}

	func makeRequest(_ request: URLRequest) async throws -> NetworkResponse {
		try await self.basicNetworkHTTPClient.makeRequest(request)
	}
}
