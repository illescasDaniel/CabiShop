//
//  MockBasicNetworkHTTPClient.swift
//  CabiShop
//
//  Created by Daniel Illescas Romero on 28/5/23.
//

#if DEBUG
import Foundation

struct MockURLRequest: Hashable {
	let url: String
	let httpMethod: String
}

struct MockNetworkResponse {
	let body: String
	let httpStatusCode: HTTPStatusCode
}

final class MockBasicNetworkHTTPClient: BasicNetworkHTTPClient {

	var mockData: [MockURLRequest: MockNetworkResponse]

	init(mockData: [MockURLRequest: MockNetworkResponse]) {
		self.mockData = mockData
	}

	func makeRequest(_ request: URLRequest) async throws -> NetworkResponse {
		let mockURLRequest = MockURLRequest(url: request.url?.absoluteString ?? String(), httpMethod: request.httpMethod ?? String())
		if let response = mockData[mockURLRequest] {
			return NetworkResponse(
				urlRequest: request,
				body: Data(response.body.utf8),
				httpStatusCode: response.httpStatusCode
			)
		}
		return NetworkResponse(
			urlRequest: request,
			body: Data("Missing associated NetworkResponse in mockData!".utf8),
			httpStatusCode: .other(-1)
		)
	}
}
#endif
