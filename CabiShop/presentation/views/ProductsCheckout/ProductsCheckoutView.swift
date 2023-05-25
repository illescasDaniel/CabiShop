//
//  ProductsCheckoutView.swift
//  CabiShop
//
//  Created by Daniel Illescas Romero on 25/5/23.
//

import Foundation
import SwiftUI

struct ProductsCheckoutView: View {

	@StateObject
	var viewModel: ProductsCheckoutViewModel = CabiShopApp.dependencyFactory.get()
	
	@State
	private var isNotImplementedAlertPresented = false

	var body: some View {
		contentView
			.navigationTitle(Text("Checkout"))
			.alert(isPresented: $isNotImplementedAlertPresented) {
				Alert(title: Text("Not Implemented!"), dismissButton: .default(Text("OK")))
			}
			.task {
				await viewModel.loadProducts()
			}
	}

	private var contentView: some View {
		VStack {
			switch viewModel.loadingState {
			case .idle, .loading:
				ProgressView()
					.progressViewStyle(.circular)
			case .error:
				Text("Sorry, come back later.")
			case .hasNoData:
				Text("Your cart is empty.")
			case .hasData:
				productListView
			}
		}
	}

	private var productListView: some View {
		VStack {
			List(viewModel.products) { product in
				ProductListItemView(productForDisplay: product)
			}
			.listStyle(.plain)
			Divider()
				.padding(.vertical, 8)
			VStack(alignment: .trailing) {
				HStack(alignment: .bottom) {
					Text("Total")
						.font(.title)
						.bold()
					Spacer()
					Text(viewModel.formattedTotalPrice)
						.font(.title3)
						.fontDesign(.monospaced)
						.bold()
				}
				Button {
					isNotImplementedAlertPresented = true
				} label: {
					Text("Buy")
						.font(.title3)
						.bold()
						.frame(minWidth: 100, minHeight: 32)
				}
				.buttonStyle(.borderedProminent)
			}
			.padding(EdgeInsets(top: 0, leading: 16, bottom: 24, trailing: 16))
		}
	}
}

#if DEBUG
struct ProductsCheckoutView_Previews: PreviewProvider {

	static var previews: some View {
		ProductsCheckoutViewPreview()
	}

	struct ProductsCheckoutViewPreview: View {

		@MainActor
		init() {
			guard let mockDependencyFactory = CabiShopApp.dependencyFactory as? MockDependencyFactory else { return }
			mockDependencyFactory._mockProductRepositoryLocalDataSource.xForYPromotions = [
				.create2for1Promotion(productCode: "VOUCHER")
			]
			mockDependencyFactory._mockProductRepositoryLocalDataSource.bulkPurchaseDiscounts = [
				BulkPurchasePriceModifierForProductCode(howManyItemsTheUserNeedsToBuyAtLeast: 3, priceModifierPerUnit: -0.1, productCode: "TSHIRT")
			]
			mockDependencyFactory._mockProductRepositoryLocalDataSource.productsForCheckout  = [
				"VOUCHER", "VOUCHER", "MUG", "TSHIRT"
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
					{ "code": "OTHER", "name": "Other item", "price": 200 },
					{ "code": "MUG", "name": "Cabify Coffee Mug", "price": 7.5 }
				]}
				""",
				httpStatusCode: .okay(200)
			)
		}

		var body: some View {
			ProductsCheckoutView()
		}
	}
}
#endif
