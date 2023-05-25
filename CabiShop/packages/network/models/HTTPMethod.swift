//
//  HTTPMethod.swift
//  CabiShop
//
//  Created by Daniel Illescas Romero on 25/5/23.
//

import Foundation

enum HTTPMethod {
	case get(queryItems: [URLQueryItem])
	case post(body: Data?)
	case put(body: Data?)
	case patch(body: Data?)
	case delete

	var methodName: String {
		switch self {
		case .get: return "GET"
		case .post: return "POST"
		case .put: return "PUT"
		case .patch: return "PATCH"
		case .delete: return "DELETE"
		}
	}
}
