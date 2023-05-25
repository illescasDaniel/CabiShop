//
//  HTTPStatusCode.swift
//  CabiShop
//
//  Created by Daniel Illescas Romero on 25/5/23.
//

import Foundation

enum HTTPStatusCode: Equatable {

	case serverError(Int)
	case badRequest(Int)
	case redirect(Int)
	case okay(Int)
	case other(Int)

	init(statusCode: Int) {
		switch statusCode {
		case 500...599:
			self = .serverError(statusCode)
		case 400...499:
			self = .badRequest(statusCode)
		case 300...399:
			self = .redirect(statusCode)
		case 200...299:
			self = .okay(statusCode)
		default:
			self = .other(statusCode)
		}
	}

	static func ==(lhs: Self, rhs: Self) -> Bool {
		switch (lhs, rhs) {
		case (.serverError(let lhsCode), .serverError(let rhsCode)):
			return lhsCode == rhsCode
		case (.badRequest(let lhsCode), .badRequest(let rhsCode)):
			return lhsCode == rhsCode
		case (.redirect(let lhsCode), .redirect(let rhsCode)):
			return lhsCode == rhsCode
		case (.okay(let lhsCode), .okay(let rhsCode)):
			return lhsCode == rhsCode
		case (.other(let lhsCode), .other(let rhsCode)):
			return lhsCode == rhsCode
		default:
			return false
		}
	}

	var isOK: Bool {
		if case .okay = self {
			return true
		}
		return false
	}
}
