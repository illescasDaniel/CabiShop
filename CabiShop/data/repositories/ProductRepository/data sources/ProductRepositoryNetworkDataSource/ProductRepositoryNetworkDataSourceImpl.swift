//
//  ProductRepositoryNetworkDataSourceImpl.swift
//  CabiShop
//
//  Created by Daniel Illescas Romero on 28/5/23.
//

import Foundation

final class ProductRepositoryNetworkDataSourceImpl: ProductRepositoryNetworkDataSource {

	private let networkHTTPClient: NetworkHTTPClient

	init(networkHTTPClient: NetworkHTTPClient) {
		self.networkHTTPClient = networkHTTPClient
	}

	func fetchProducts() async throws -> ProductList {
		let url: String = "https://gist.githubusercontent.com/palcalde/6c19259bd32dd6aafa327fa557859c2f/raw/ba51779474a150ee4367cda4f4ffacdcca479887/Products.json"
		return try await self.networkHTTPClient.makeRequest(
			decoding: ProductList.self,
			url: url,
			method: .get(queryItems: [])
		)
	}
}
