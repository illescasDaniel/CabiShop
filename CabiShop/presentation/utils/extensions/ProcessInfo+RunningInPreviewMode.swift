//
//  ProcessInfo+RunningInPreviewMode.swift
//  CabiShop
//
//  Created by Daniel Illescas Romero on 27/5/23.
//

#if DEBUG
import Foundation

extension ProcessInfo {
	var isRunningInPreviewMode: Bool {
		self.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
	}
}
#endif
