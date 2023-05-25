//
//  ProductListItemView.swift
//  CabiShop
//
//  Created by Daniel Illescas Romero on 25/5/23.
//

import Foundation
import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

struct ProductListItemView: View {

	@StateObject
	var viewModel: ProductListItemViewModel = CabiShopApp.dependencyFactory.get()
	
	let productForDisplay: ProductForDisplay

	#if canImport(UIKit)
	let lightHapticFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
	#endif

	var body: some View {
		HStack {
			itemDescription
			Spacer()
			priceDetails
		}
		.swipeActions {
			if viewModel.addedItemsCount >= 1 {
				Button {
					viewModel.removeAllProducts(withCode: productForDisplay.productCode)
				} label: {
					Label {
						Text("Remove")
					} icon: {
						Image(systemName: "xmark.bin.fill")
					}
				}.tint(.red)
			}
		}
		.task {
			viewModel.listenForProductChangesForCheckout(for: productForDisplay)
		}
		#if canImport(UIKit)
		.onAppear {
			lightHapticFeedbackGenerator.prepare()
		}
		#endif
	}

	private var itemDescription: some View {
		VStack(alignment: .leading) {
			Text(productForDisplay.name)
				.font(.headline)
			if let promotion = productForDisplay.promotionWithDescription {
				Text(promotion.description)
					.font(.callout)
					.foregroundColor(.white)
					.padding(4)
					.background(Color.Custom.accentColor.cornerRadius(4))
			}
		}
	}

	private var priceDetails: some View {
		VStack(alignment: .trailing) {
			priceDetails(formattedPrice: viewModel.productPrice(for: productForDisplay), hasPromotionApplied: viewModel.hasPromotionApplied(for: productForDisplay))
			itemCounter
		}
	}
	private func priceDetails(formattedPrice: String, hasPromotionApplied: Bool) -> some View {
		VStack {
			Text(formattedPrice)
				.font(.body)
				.fontDesign(.monospaced)
				.foregroundColor(hasPromotionApplied ? Color.Custom.specialPriceColor : Color.Custom.labelColor)
			if productForDisplay.promotionWithDescription != nil {
				Text(viewModel.priceWithoutDiscounts(for: productForDisplay))
					.strikethrough()
					.font(.subheadline)
					.fontDesign(.monospaced)
					.foregroundColor(.gray)
					.opacity(hasPromotionApplied ? 1 : 0)
			}
		}
	}

	@ViewBuilder
	private var itemCounter: some View {
		if viewModel.addedItemsCount > 0 {
			biggerThanZeroItemCounter
		} else {
			zeroItemCounter
		}
	}

	private var zeroItemCounter: some View {
		Button {
			viewModel.addProduct(productForDisplay)
			hapticFeedbackIfPossible()
		} label: {
			Image(systemName: "plus.square.fill")
				.symbolRenderingMode(.multicolor)
				.foregroundColor(.green)
				.font(.system(size: 28))
		}.buttonStyle(.plain)
	}

	private var biggerThanZeroItemCounter: some View {
		HStack {
			Button {
				viewModel.removeProduct(productForDisplay)
				hapticFeedbackIfPossible()
			} label: {
				Image(systemName: "minus.square.fill")
					.symbolRenderingMode(.multicolor)
					.foregroundColor(.red)
					.font(.system(size: 28))
			}.buttonStyle(.plain)
			Text("x\(viewModel.addedItemsCount)")
				.fontDesign(.monospaced)
			Button {
				viewModel.addProduct(productForDisplay)
				hapticFeedbackIfPossible()
			} label: {
				Image(systemName: "plus.square.fill")
					.symbolRenderingMode(.multicolor)
					.foregroundColor(.green)
					.font(.system(size: 28))
			}.buttonStyle(.plain)
		}
	}

	private func hapticFeedbackIfPossible() {
		#if canImport(UIKit)
		lightHapticFeedbackGenerator.impactOccurred()
		#endif
	}
}

#if DEBUG
// MARK: Preview
struct ProductListItemView_Previews: PreviewProvider {

	static var previews: some View {
		ProductListItemViewPreview()
	}

	struct ProductListItemViewPreview: View {

		@MainActor
		init() {
			guard let mockDependencyFactory = CabiShopApp.dependencyFactory as? MockDependencyFactory else { return }
			mockDependencyFactory._mockProductRepositoryLocalDataSource.productsForCheckout = [
				"SOMETHING0", "SOMETHING02", "SOMETHING02"
			]
		}
		var body: some View {
			List {
				ProductListItemView(
					productForDisplay: ProductForDisplay(
						name: "Big T-Shirt 1 added",
						productCode: "SOMETHING0",
						promotionWithDescription: nil,
						basePricePerUnit: 10.9,
						formattedBasePrice: "10.9 €"
					)
				)
				ProductListItemView(
					productForDisplay: ProductForDisplay(
						name: "Big T-Shirt 2 added",
						productCode: "SOMETHING02",
						promotionWithDescription: nil,
						basePricePerUnit: 0.5,
						formattedBasePrice: "0.5 €"
					)
				)
				ProductListItemView(
					productForDisplay: ProductForDisplay(
						name: "Big T-Shirt no prom",
						productCode: "SOMETHING1",
						promotionWithDescription: nil,
						basePricePerUnit: 20,
						formattedBasePrice: "20 €"
					)
				)
				ProductListItemView(
					productForDisplay: ProductForDisplay(
						name: "Big T-Shirt 2-for-1 prom",
						productCode: "SOMETHING2",
						promotionWithDescription: ProductPromotionWithDescription(description: "2-for-1 promotion", promotion: .xForYPromotion(.init(howManyItemsTheUserNeedsToBuy: 2, howManyItemsTheUserWillPay: 1))),
						basePricePerUnit: 10.5,
						formattedBasePrice: "10.5 €"
					)
				)
				ProductListItemView(
					productForDisplay: ProductForDisplay(
						name: "Big T-Shirt 2-for-1 prom",
						productCode: "SOMETHING3",
						promotionWithDescription: ProductPromotionWithDescription(description: "bulk promotion", promotion: .bulkPurchaseDiscount(.init(howManyItemsTheUserNeedsToBuyAtLeast: 3, priceModifierPerUnit: -0.1))),
						basePricePerUnit: 10.5,
						formattedBasePrice: "10.5 €"
					)
				)
			}
		}
	}
}
#endif
