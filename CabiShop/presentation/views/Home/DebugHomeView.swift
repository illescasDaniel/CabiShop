//
//  DebugHomeView.swift
//  CabiShop
//
//  Created by Daniel Illescas Romero on 28/5/23.
//

#if DEBUG

import Foundation
import SwiftUI

struct DebugHomeView: View {
	
	private let environmentKey = "environment"

	@State
	private var appEnvironment: AppEnvironment

	@State
	private var homeID: String = UUID().uuidString

	@MainActor
	init() {
		let environment = UserDefaults.standard.string(forKey: environmentKey).flatMap(AppEnvironment.init) ?? .unknown
		if environment == .unknown {
			let isRunningInPreviewMode = ProcessInfo.processInfo.isRunningInPreviewMode
			if isRunningInPreviewMode {
				self._appEnvironment = State(initialValue: .mock)
			} else {
				self._appEnvironment = State(initialValue: .production)
			}
		} else {
			self._appEnvironment = State(initialValue: environment)
		}
		CabiShopApp.dependencyFactory = getCorrectDependencyFactory()
	}

	var body: some View {
		content
			.id(homeID)
			.onChange(of: appEnvironment) { newValue in
				UserDefaults.standard.set(newValue.rawValue, forKey: environmentKey)
				CabiShopApp.dependencyFactory = self.getCorrectDependencyFactory()
				self.homeID = UUID().uuidString
			}
	}

	@MainActor
	private func getCorrectDependencyFactory() -> DependencyFactory {
		switch appEnvironment {
		case .mock:
			return MockDependencyFactory()
		case .production:
			return DependencyFactoryImpl()
		case .unknown:
			let isRunningInPreviewMode = ProcessInfo.processInfo.isRunningInPreviewMode
			if isRunningInPreviewMode {
				return MockDependencyFactory()
			} else {
				return DependencyFactoryImpl()
			}
		}
	}

	private var content: some View {
		NavigationStack {
			ProductListView()
			.toolbar {
				ToolbarItem(placement: .leading) {
					Menu {
						Menu {
							Picker("Environment picker", selection: $appEnvironment) {
								Text("Production")
									.tag(AppEnvironment.production)
								Text("Mock")
									.tag(AppEnvironment.mock)
							}
						} label: {
							Text("Environment")
						}
						// other entries here
					} label: {
						Image(systemName: "ladybug")
					}
				}
				ToolbarItem(placement: .primaryAction) {
					ShoppingCartButton()
				}
			}
		}
	}
}

struct DebugHomeView_Previews: PreviewProvider {
	static var previews: some View {
		DebugHomeView()
	}
}
#endif
