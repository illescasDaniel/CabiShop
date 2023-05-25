//
//  ProductListView.swift
//  CabiShop
//
//  Created by Daniel Illescas Romero on 25/5/23.
//

import Foundation
import SwiftUI

struct ProductListView: View {

	@StateObject
	var viewModel: ProductListViewModel = CabiShopApp.dependencyFactory.get()

	var body: some View {
		List(viewModel.productsResult.data ?? []) { product in
			ProductListItemView(productForDisplay: product)
		}
		.navigationTitle(Text("CabiShop"))
		.refreshable {
			await viewModel.fetchProducts()
		}
		.task {
			await viewModel.fetchProducts()
		}
		.overlay(
			VStack {
				switch viewModel.productsResult {
				case .idle, .loading:
					ProgressView()
						.progressViewStyle(.circular)
				case .empty:
					Text("No items")
				case .error:
					Text("Sorry, come back later.")
				case .nonEmpty:
					EmptyView()
				}
			}.allowsHitTesting(false)
		)
	}
}

#if DEBUG
struct ProductListView_Previews: PreviewProvider {

	static var previews: some View {
		ProductListView_PreviewView()
	}

	struct ProductListView_PreviewView: View {

		@MainActor
		init() {
			guard let mockDependencyFactory = CabiShopApp.dependencyFactory as? MockDependencyFactory else { return }
			mockDependencyFactory._mockProductRepositoryLocalDataSource.xForYPromotions = [
				.create2for1Promotion(productCode: "VOUCHER")
			]
			mockDependencyFactory._mockProductRepositoryLocalDataSource.bulkPurchaseDiscounts = [
				BulkPurchasePriceModifierForProductCode(howManyItemsTheUserNeedsToBuyAtLeast: 3, priceModifierPerUnit: -0.1, productCode: "TSHIRT")
			]
			mockDependencyFactory._mockProductRepositoryLocalDataSource.productsForCheckout = [
				"VOUCHER", "VOUCHER"
			]
			mockDependencyFactory._mockBasicNetworkHTTPClient.mockData[
				MockURLRequest(
					url: "https://gist.githubusercontent.com/palcalde/6c19259bd32dd6aafa327fa557859c2f/raw/ba51779474a150ee4367cda4f4ffacdcca479887/Products.json",
					httpMethod: "GET"
				)
			] = MockNetworkResponse(
				body: """
				{ "products": [
					{ "code": "VOUCHER", "name": "Cabify Voucher", "price": 5 },
					{ "code": "TSHIRT", "name": "Cabify T-Shirt", "price": 20 },
					{ "code": "OTHER", "name": "Other item", "price": 21 },
					{ "code": "MUG", "name": "Cabify Coffee Mug", "price": 7.5 }
				]}
				""",
				httpStatusCode: .okay(200)
			)
		}

		var body: some View {
			NavigationStack {
				ProductListView()
			}
		}
	}
}
#endif
