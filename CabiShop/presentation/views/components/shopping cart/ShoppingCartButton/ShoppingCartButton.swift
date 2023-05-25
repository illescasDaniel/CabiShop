//
//  ShoppingCartButton.swift
//  CabiShop
//
//  Created by Daniel Illescas Romero on 28/5/23.
//

import Foundation
import SwiftUI

struct ShoppingCartButton: View {

	@StateObject
	var viewModel: ShoppingCartButtonViewModel = CabiShopApp.dependencyFactory.get()

	var body: some View {
		NavigationLink(destination: ProductsCheckoutView()) {
			ShoppingCartImage(isFilled: viewModel.hasProductsForCheckout)
		}
		.task {
			viewModel.listenForNewProductsForCheckout()
		}
	}
}

#if DEBUG
struct ShoppingCartButton_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			ShoppingCartButtonEmptyPreview()
			ShoppingCartButtonFilledPreview()
		}
	}

	struct ShoppingCartButtonEmptyPreview: View {
		var body: some View {
			ShoppingCartButton()
				.onAppear {
					guard let mockDependencyFactory = CabiShopApp.dependencyFactory as? MockDependencyFactory else { return }
					mockDependencyFactory._mockProductRepositoryLocalDataSource.productsForCheckout = []
				}
		}
	}

	struct ShoppingCartButtonFilledPreview: View {
		var body: some View {
			ShoppingCartButton()
				.onAppear {
					guard let mockDependencyFactory = CabiShopApp.dependencyFactory as? MockDependencyFactory else { return }
					mockDependencyFactory._mockProductRepositoryLocalDataSource.productsForCheckout = ["SOMETHING"]
				}
		}
	}
}
#endif
