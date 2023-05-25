//
//  ToolbarItemPlacement+iOSMacOS.swift
//  CabiShop
//
//  Created by Daniel Illescas Romero on 28/5/23.
//

import SwiftUI

extension ToolbarItemPlacement {
	static var leading: ToolbarItemPlacement {
		#if os(iOS)
		return .navigationBarLeading
		#else
		return .automatic
		#endif
	}
}
