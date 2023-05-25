//
//  FakeLogger.swift
//  CabiShop
//
//  Created by Daniel Illescas Romero on 28/5/23.
//

import Foundation

class FakeLogger: Logger {
	func log(
		severity: LoggerSeverity,
		category: String,
		message: String,
		file: String,
		function: String,
		line: Int,
		column: Int
	) {}
}
