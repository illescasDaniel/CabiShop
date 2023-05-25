//
//  CabiShopApp.swift
//  CabiShop
//
//  Created by Daniel Illescas Romero on 25/5/23.
//

import SwiftUI

#if DEBUG
#else
@main
struct CabiShopApp: App {
	
	@MainActor
	static let dependencyFactory: DependencyFactory = DependencyFactoryImpl()

	var body: some Scene {
		WindowGroup {
			HomeView()
		}
	}
}
#endif
