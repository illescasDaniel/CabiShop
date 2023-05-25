//
//  Color+Extension.swift
//  CabiShop
//
//  Created by Daniel Illescas Romero on 26/5/23.
//

import SwiftUI

extension Color {
	enum Custom {
		static var accentColor: Color {
			Color("AccentColor", bundle: .main)
		}
		static var specialPriceColor: Color {
			Color("SpecialPriceColor", bundle: .main)
		}
		static var labelColor: Color {
			Color("LabelColor", bundle: .main)
		}
	}
}
