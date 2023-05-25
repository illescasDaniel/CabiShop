//
//  ResultState.swift
//  CabiShop
//
//  Created by Daniel Illescas Romero on 26/5/23.
//

import Foundation

enum ResultState<T> {
	case idle
	case loading
	case nonEmpty(T)
	case empty
	case error

	var data: T? {
		if case .nonEmpty(let value) = self {
			return value
		}
		return nil
	}
}
