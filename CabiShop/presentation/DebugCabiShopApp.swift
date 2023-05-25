//
//  DebugCabiShopApp.swift
//  CabiShop
//
//  Created by Daniel Illescas Romero on 25/5/23.
//

import SwiftUI

#if DEBUG
enum AppEnvironment: String {
	case production
	case mock
	case unknown
}

@main
struct CabiShopApp: App {

	@MainActor
	static var dependencyFactory: DependencyFactory = DependencyFactoryImpl()

	var body: some Scene {
		WindowGroup {
			DebugHomeView()
		}
	}
}
#endif
