//
//  ShoppingCartImage.swift
//  CabiShop
//
//  Created by Daniel Illescas Romero on 28/5/23.
//

import Foundation
import SwiftUI

struct ShoppingCartImage: View {

	var isFilled: Bool

	@ViewBuilder
	var body: some View {
		if isFilled {
			Image(systemName: "cart.fill")
		} else {
			Image(systemName: "cart")
		}
	}
}

#if DEBUG
struct ShoppingCartImage_Previews: PreviewProvider {
	static var previews: some View {
		VStack {
			ShoppingCartImage(isFilled: true)
			ShoppingCartImage(isFilled: false)
		}
	}
}
#endif
