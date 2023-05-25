//
//  BasicNetworkHTTPClientURLSessionImpl.swift
//  CabiShop
//
//  Created by Daniel Illescas Romero on 28/5/23.
//

import Foundation

class BasicNetworkHTTPClientURLSessionImpl: BasicNetworkHTTPClient {

	private let urlSession: URLSession

	init(urlSession: URLSession) {
		self.urlSession = urlSession
	}

	func makeRequest(_ request: URLRequest) async throws -> NetworkResponse {
		let (data, response) = try await self.urlSession.data(for: request)
		let httpURLResponse = response as? HTTPURLResponse
		let statusCode = HTTPStatusCode(statusCode: httpURLResponse?.statusCode ?? -1)
		return NetworkResponse(
			urlRequest: request,
			body: data,
			httpStatusCode: statusCode
		)
	}
}
