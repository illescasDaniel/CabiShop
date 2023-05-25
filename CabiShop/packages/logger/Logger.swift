//
//  Logger.swift
//  CabiShop
//
//  Created by Daniel Illescas Romero on 28/5/23.
//

import Foundation

protocol Logger {
	func log(
		severity: LoggerSeverity,
		category: String,
		message: String,
		file: String,
		function: String,
		line: Int,
		column: Int
	)
}
extension Logger {
	func log(
		severity: LoggerSeverity,
		category: String,
		message: String,
		_file file: String = #file,
		_function function: String = #function,
		_line line: Int = #line,
		_column column: Int = #column
	) {
		self.log(
			severity: severity,
			category: category,
			message: message,
			file: file,
			function: function,
			line: line,
			column: column
		)
	}
}
