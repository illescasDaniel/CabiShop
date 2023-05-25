//
//  NetworkRequestError.swift
//  CabiShop
//
//  Created by Daniel Illescas Romero on 25/5/23.
//

import Foundation

enum NetworkRequestError: Error, LocalizedError {
	case requestError(Error)
	case invalidResponse(NetworkResponse)
	case decodingError(Error)
	case urlError(String)

	var errorDescription: String? {
		var description = String()
		dump(self, to: &description)
		return description
	}
}
