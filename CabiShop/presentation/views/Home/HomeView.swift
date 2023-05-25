//
//  HomeView.swift
//  CabiShop
//
//  Created by Daniel Illescas Romero on 28/5/23.
//

import Foundation
import SwiftUI

struct HomeView: View {
	var body: some View {
		NavigationStack {
			ProductListView()
				.toolbar {
					ToolbarItem(placement: .primaryAction) {
						ShoppingCartButton()
					}
				}
		}
	}
}

#if DEBUG // (we don't really need to use this precondition for previews, we'll use it just in case we use some DEBUG-only item)
struct HomeView_Previews: PreviewProvider {

	static var previews: some View {
		HomeViewPreview()
	}

	struct HomeViewPreview: View {

		@MainActor
		init() {
			CabiShopApp.dependencyFactory = DependencyFactoryImpl()
		}
		var body: some View {
			HomeView()
		}
	}
}
#endif
