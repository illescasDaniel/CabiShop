//
//  PrintLogger.swift
//  CabiShop
//
//  Created by Daniel Illescas Romero on 28/5/23.
//

import Foundation

class PrintLogger: Logger {
	func log(
		severity: LoggerSeverity,
		category: String,
		message: String,
		file: String,
		function: String,
		line: Int,
		column: Int
	) {
		let fileName = URL(string: file)?.deletingPathExtension().lastPathComponent ?? file
		let severityDescription = String(describing: severity).uppercased()
		print("[\(severityDescription)][\(category)][\(fileName).\(function)-\(line):\(column)]\n\(message)\n")
	}
}
