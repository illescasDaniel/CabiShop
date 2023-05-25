//
//  DependencyFactoryImpl.swift
//  CabiShop
//
//  Created by Daniel Illescas Romero on 25/5/23.
//

import Foundation

class DependencyFactoryImpl: DependencyFactory {

	func get() -> ShoppingCartButtonViewModel {
		ShoppingCartButtonViewModel(productCodesForCheckoutUseCase: get())
	}

	func get() -> ProductListViewModel {
		ProductListViewModel(
			fetchProductsUseCase: get(),
			produtWithPromotionMapper: get(),
			logger: get()
		)
	}

	func get() -> ProductListItemViewModel {
		ProductListItemViewModel(
			numberFormatterUtils: get(),
			productPriceCalculator: get(),
			productCodesForCheckoutUseCase: get(),
			addProductForCheckoutUseCase: get(),
			removeProductForCheckoutUseCase: get()
		)
	}

	func get() -> ProductsCheckoutViewModel {
		ProductsCheckoutViewModel(
			productsForCheckoutUseCase: get(),
			productWithPromotionMapper: get(),
			numberFormatterUtils: get()
		)
	}

	//

	func get() -> FetchProductsUseCase {
		FetchProductsUseCaseImpl(productRepository: get(), productMapper: get())
	}

	func get() -> ProductCodesForCheckoutUseCase {
		ProductCodesForCheckoutUseCaseImpl(productRepository: get())
	}

	func get() -> AddProductForCheckoutUseCase {
		AddProductForCheckoutUseCaseImpl(productRepository: get())
	}

	func get() -> RemoveProductForCheckoutUseCase {
		RemoveProductForCheckoutUseCaseImpl(productRepository: get())
	}

	func get() -> RemoveAllProductsForCheckoutUseCase {
		RemoveAllProductsForCheckoutUseCaseImpl(productRepository: get())
	}

	func get() -> CalculateTotalCheckoutPriceUseCase {
		CalculateTotalCheckoutPriceUseCaseImpl(
			fetchProductsUseCase: get(),
			productCodesForCheckoutUseCase: get(),
			totalPriceCalculator: get()
		)
	}

	func get() -> ProductsForCheckoutUseCase {
		ProductsForCheckoutUseCaseImpl(
			productCodesForCheckoutUseCase: get(),
			calculateTotalPriceForCheckout: get(),
			fetchProductsUseCase: get()
		)
	}

	//

	func get() -> ProductRepository {
		ProductRepositoryImpl(
			networkDataSource: get(),
			localDataSource: get()
		)
	}

	func get() -> ProductRepositoryNetworkDataSource {
		ProductRepositoryNetworkDataSourceImpl(networkHTTPClient: get())
	}

	func get() -> ProductRepositoryLocalDataSource {
		ProductRepositoryLocalDataSourceImpl(userDefaults: get())
	}

	//

	func get() -> ProductMapper {
		ProductMapper(promotionMapper: get())
	}

	func get() -> PromotionMapper {
		PromotionMapper()
	}

	func get() -> ProductWithPromotionMapper {
		ProductWithPromotionMapper(numberFormatterUtils: get())
	}

	func get() -> NumberFormatterUtils {
		NumberFormatterUtils()
	}

	func get() -> ProductPriceCalculator {
		ProductPriceCalculator()
	}

	func get() -> TotalPriceCalculator {
		TotalPriceCalculator(priceCalculator: get())
	}

	//

	func get() -> NetworkHTTPClient {
		NetworkHTTPClientImpl(basicNetworkHTTPClient: get())
	}

	func get() -> BasicNetworkHTTPClient {
		BasicNetworkHTTPClientURLSessionImpl(urlSession: get())
	}

	func get() -> URLSession {
		let urlSessionConfiguration = URLSessionConfiguration.default
		let session = URLSession(configuration: urlSessionConfiguration)
		return session
	}

	func get() -> UserDefaults {
		return .standard
	}

	func get() -> Logger {
		#if DEBUG
		PrintLogger()
		#else
		FakeLogger()
		#endif
	}
}
