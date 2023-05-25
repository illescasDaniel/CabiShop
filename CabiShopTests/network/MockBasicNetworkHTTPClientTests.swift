//
//  MockBasicNetworkHTTPClientTests.swift
//  CabiShopTests
//
//  Created by Daniel Illescas Romero on 28/5/23.
//

import Foundation
import XCTest
@testable import CabiShop

class MockBasicNetworkHTTPClientTests: XCTestCase {

	func testRequest() async throws {
		let mockClient = MockBasicNetworkHTTPClient(
			mockData: [
				.init(url: "https://www.example.com", httpMethod: "GET"): .init(body: String(), httpStatusCode: .okay(200)),
				.init(url: "https://www.example.com/2", httpMethod: "POST"): .init(body: #"{ "key": "value" }"#, httpStatusCode: .okay(201))
			]
		)

		let request1 = URLRequest(url: try XCTUnwrap(URL(string: "https://www.example.com")))
		let response1 = try await mockClient.makeRequest(request1)
		XCTAssertEqual(response1.bodyString, String())
		XCTAssertEqual(response1.body, Data(String().utf8))
		XCTAssertEqual(response1.urlRequest, request1)
		XCTAssertEqual(response1.httpStatusCode, .okay(200))

		var request2 = URLRequest(url: try XCTUnwrap(URL(string: "https://www.example.com/2")))
		request2.httpMethod = "POST"
		let response2 = try await mockClient.makeRequest(request2)
		XCTAssertEqual(response2.bodyString, #"{ "key": "value" }"#)
		XCTAssertEqual(response2.body, Data(#"{ "key": "value" }"#.utf8))
		XCTAssertEqual(response2.urlRequest, request2)
		XCTAssertEqual(response2.httpStatusCode, .okay(201))
	}
}
