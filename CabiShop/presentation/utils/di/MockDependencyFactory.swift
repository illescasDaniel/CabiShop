//
//  MockDependencyFactory.swift
//  CabiShop
//
//  Created by Daniel Illescas Romero on 27/5/23.
//

#if DEBUG
import Foundation

final class MockDependencyFactory: DependencyFactory {

	var _mockProductRepositoryLocalDataSource: MockProductRepositoryLocalDataSource
	var _mockBasicNetworkHTTPClient: MockBasicNetworkHTTPClient
	init() {
		_mockProductRepositoryLocalDataSource = MockProductRepositoryLocalDataSource(
			xForYPromotions: [.create2for1Promotion(productCode: "VOUCHER")],
			bulkPurchaseDiscounts: [
				BulkPurchasePriceModifierForProductCode(howManyItemsTheUserNeedsToBuyAtLeast: 3, priceModifierPerUnit: -0.1, productCode: "TSHIRT")
			],
			productsForCheckout: ["VOUCHER", "VOUCHER"]
		)

		_mockBasicNetworkHTTPClient = MockBasicNetworkHTTPClient(mockData: [
			MockURLRequest(
				url: "https://gist.githubusercontent.com/palcalde/6c19259bd32dd6aafa327fa557859c2f/raw/ba51779474a150ee4367cda4f4ffacdcca479887/Products.json",
				httpMethod: "GET"
			): MockNetworkResponse(
				body: """
				{ "products": [
					{ "code": "VOUCHER", "name": "Cabify Voucher", "price": 5 },
					{ "code": "TSHIRT", "name": "Cabify T-Shirt", "price": 20 },
					{ "code": "OTHER", "name": "Other item", "price": 200 },
					{ "code": "MUG", "name": "Cabify Coffee Mug", "price": 7.5 }
				]}
				""",
				httpStatusCode: .okay(200)
			)
		])
	}

	//

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
		_mockProductRepositoryLocalDataSource
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
		_mockBasicNetworkHTTPClient
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
		PrintLogger()
	}
}
#endif
