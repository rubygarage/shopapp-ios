//
//  APIMock.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/28/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

@testable import ShopApp

class APIMock: API {
    var isNeedToReturnError = false
    var isSetupProviderStarted = false
    var isGetShopInfoStarted = false
    var isGetProductListStarted = false
    var isGetProductStarted = false
    var isSearchProductsStarted = false
    var isGetProductVariantListStarted = false
    var isGetCategoryListStarted = false
    var isGetCategoryStarted = false
    var isGetArticleListStarted = false
    var isGetArticleStarted = false
    var isSignUpStarter = false
    var isLoginStarted = false
    var isLogoutStarted = false
    var isResetPasswordStarted = false
    var isGetCustomerStarted = false
    var isUpdateCustomerInfoStarted = false
    var isUpdateCustomerPromoStarted = false
    var isUpdateCustomerPasswordStarted = false
    var isAddCustomerAddressStarted = false
    var isUpdateCustomerAddressStarted = false
    var isUpdateCustomerDefaultAddressStarted = false
    var isDeleteCustomerAddressStarted = false
    var isCreateCheckoutStarted = false
    var isGetCheckoutStarted = false
    var isUpdateShippingAddressStarted = false
    var isGetShippingRatesStarted = false
    var isUpdateCheckoutStarted = false
    var isPayStarted = false
    var isSetupApplePayStarted = false
    var isGetCountriesStarted = false
    var isGetOrderListStarted = false
    var isGetOrderStarted = false
    var isAddCartProductStarted = false
    var isDeleteProductFromCartStarted = false
    var isDeleteProductsFromCartStarted = false
    var isDeleteAllProductsFromCartStarted = false
    var isChangeCartProductQuantityStarted = false
    var perPage: Int?
    var paginationValue: String?
    var sortBy: SortType?
    var reverse: Bool?
    var id: String?
    var keyword: String?
    var excludeKeyword: String?
    var query: String?
    var email: String?
    var firstName: String?
    var lastName: String?
    var password: String?
    var phone: String?
    var isAcceptMarketing: Bool?
    var address: Address?
    var addressId: String?
    var cartProducts: [CartProduct]?
    var checkoutId: String?
    var shippingRate: ShippingRate?
    var card: Card?
    var checkout: Checkout?
    var billingAddress: Address?
    var ids: [String]?
    var cartProduct: CartProduct?
    var cartItemId: String?
    var cartItemIds: [String?]?
    var quantity: Int?
    
    // MARK: - Setup
    
    func setupProvider(callback: @escaping ApiCallback<Void>) {
        isSetupProviderStarted = true
        
        isNeedToReturnError ? callback(nil, ShopAppError.content(isNetworkError: false)) : callback(nil, nil)
    }

    // MARK: - Shop
    
    func getShop(callback: @escaping ApiCallback<Shop>) {
        isGetShopInfoStarted = true
        
        isNeedToReturnError ? callback(nil, ShopAppError.content(isNetworkError: false)) : callback(TestHelper.shop, nil)
    }
    
    func getConfig() -> Config {
        return Config(isPopularEnabled: false, isBlogEnabled: false, isOrdersEnabled: false)
    }
    
    // MARK: - Products
    
    func getProducts(perPage: Int, paginationValue: Any?, sortBy: SortType?, keyword: String?, excludeKeyword: String?, callback: @escaping ApiCallback<[Product]>) {
        isGetProductListStarted = true
        
        self.perPage = perPage
        self.paginationValue = paginationValue as? String
        self.sortBy = sortBy
        self.keyword = keyword
        self.excludeKeyword = excludeKeyword
        
        isNeedToReturnError ? callback(nil, ShopAppError.content(isNetworkError: false)) : callback([], nil)
    }
    
    func getProduct(id: String, callback: @escaping ApiCallback<Product>) {
        isGetProductStarted = true
        
        self.id = id
        
        isNeedToReturnError ? callback(nil, ShopAppError.content(isNetworkError: false)) : callback(TestHelper.productWithoutAlternativePrice, nil)
    }
    
    func searchProducts(perPage: Int, paginationValue: Any?, query: String, callback: @escaping ApiCallback<[Product]>) {
        isSearchProductsStarted = true
        
        self.perPage = perPage
        self.paginationValue = paginationValue as? String
        self.query = query
        
        isNeedToReturnError ? callback(nil, ShopAppError.content(isNetworkError: false)) : callback([], nil)
    }
    
    func getProductVariants(ids: [String], callback: @escaping ApiCallback<[ProductVariant]>) {
        isGetProductVariantListStarted = true
        
        self.ids = ids
        
        isNeedToReturnError ? callback(nil, ShopAppError.content(isNetworkError: false)) : callback([], nil)
    }
    
    // MARK: - Categories
    
    func getCategories(perPage: Int, paginationValue: Any?, callback: @escaping ApiCallback<[ShopApp_Gateway.Category]>) {
        isGetCategoryListStarted = true
        
        self.perPage = perPage
        self.paginationValue = paginationValue as? String

        isNeedToReturnError ? callback(nil, ShopAppError.content(isNetworkError: false)) : callback([], nil)
    }
    
    func getCategory(id: String, perPage: Int, paginationValue: Any?, sortBy: SortType?, callback: @escaping ApiCallback<ShopApp_Gateway.Category>) {
        isGetCategoryStarted = true
        
        self.id = id
        self.perPage = perPage
        self.paginationValue = paginationValue as? String
        self.sortBy = sortBy
        
        isNeedToReturnError ? callback(nil, ShopAppError.content(isNetworkError: false)) : callback(TestHelper.categoryWithFiveProducts, nil)
    }
    
    // MARK: - Articles
    
    func getArticles(perPage: Int, paginationValue: Any?, sortBy: SortType?, callback: @escaping ApiCallback<[Article]>) {
        isGetArticleListStarted = true
        
        self.perPage = perPage
        self.paginationValue = paginationValue as? String
        self.sortBy = sortBy
        
        isNeedToReturnError ? callback(nil, ShopAppError.content(isNetworkError: false)) : callback([], nil)
    }
    
    func getArticle(id: String, callback: @escaping ApiCallback<(article: Article, baseUrl: URL)>) {
        isGetArticleStarted = true
        
        self.id = id
        
        if isNeedToReturnError {
            callback(nil, ShopAppError.content(isNetworkError: false))
        } else {
            let baseUrl = URL(string: "https://www.google.com")!
            let result = (article: TestHelper.fullArticle, baseUrl: baseUrl)
            
            callback(result, nil)
        }
    }
    
    // MARK: - Authentification
    
    func signUp(firstName: String, lastName: String, email: String, password: String, phone: String, callback: @escaping ApiCallback<Void>) {
        isSignUpStarter = true
        
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.password = password
        self.phone = phone
        
        callback((), isNeedToReturnError ? ShopAppError.content(isNetworkError: false) : nil)
    }
    
    func signIn(email: String, password: String, callback: @escaping ApiCallback<Void>) {
        isLoginStarted = true
        
        self.email = email
        self.password = password
        
        callback((), isNeedToReturnError ? ShopAppError.content(isNetworkError: false) : nil)
    }
    
    func signOut(callback: @escaping ApiCallback<Void>) {
        isLogoutStarted = true
        
        callback((), isNeedToReturnError ? ShopAppError.content(isNetworkError: false) : nil)
    }
    
    func isSignedIn(callback: @escaping ApiCallback<Bool>) {
        isNeedToReturnError ? callback(false, ShopAppError.content(isNetworkError: false)) : callback(true, nil)
    }
    
    func resetPassword(email: String, callback: @escaping ApiCallback<Void>) {
        isResetPasswordStarted = true
        
        self.email = email
        
        callback((), isNeedToReturnError ? ShopAppError.content(isNetworkError: false) : nil)
    }
    
    // MARK: - Customer
    
    func getCustomer(callback: @escaping ApiCallback<Customer>) {
        isGetCustomerStarted = true
        
        isNeedToReturnError ? callback(nil, ShopAppError.content(isNetworkError: false)) : callback(TestHelper.customerWithoutAcceptsMarketing, nil)
    }
    
    func updateCustomer(firstName: String, lastName: String, phone: String, callback: @escaping ApiCallback<Customer>) {
        isUpdateCustomerInfoStarted = true
        
        self.firstName = firstName
        self.lastName = lastName
        self.phone = phone
        
        isNeedToReturnError ? callback(nil, ShopAppError.content(isNetworkError: false)) : callback(TestHelper.customerWithoutAcceptsMarketing, nil)
    }
    
    func updateCustomerSettings(isAcceptMarketing: Bool, callback: @escaping ApiCallback<Void>) {
        isUpdateCustomerPromoStarted = true
        
        self.isAcceptMarketing = isAcceptMarketing
        
        isNeedToReturnError ? callback(nil, ShopAppError.content(isNetworkError: false)) : callback((), nil)
    }
    
    func updatePassword(password: String, callback: @escaping ApiCallback<Void>) {
        isUpdateCustomerPasswordStarted = true
        
        self.password = password
        
        isNeedToReturnError ? callback(nil, ShopAppError.content(isNetworkError: false)) : callback((), nil)
    }
    
    func addCustomerAddress(address: Address, callback: @escaping ApiCallback<Void>) {
        isAddCustomerAddressStarted = true
        
        self.address = address
        
        callback((), isNeedToReturnError ? ShopAppError.content(isNetworkError: false) : nil)
    }
    
    func updateCustomerAddress(address: Address, callback: @escaping ApiCallback<Void>) {
        isUpdateCustomerAddressStarted = true
        
        self.address = address
        
        callback((), isNeedToReturnError ? ShopAppError.content(isNetworkError: false) : nil)
    }
    
    func setDefaultShippingAddress(id: String, callback: @escaping ApiCallback<Void>) {
        isUpdateCustomerDefaultAddressStarted = true
        
        self.addressId = id
        
        isNeedToReturnError ? callback(nil, ShopAppError.content(isNetworkError: false)) : callback((), nil)
    }
    
    func deleteCustomerAddress(id: String, callback: @escaping ApiCallback<Void>) {
        isDeleteCustomerAddressStarted = true
        
        addressId = id
        
        callback((), isNeedToReturnError ? ShopAppError.content(isNetworkError: false) : nil)
    }
    
    // MARK: - Payments
    
    func createCheckout(cartProducts: [CartProduct], callback: @escaping ApiCallback<Checkout>) {
        isCreateCheckoutStarted = true
        
        self.cartProducts = cartProducts
        
        isNeedToReturnError ? callback(nil, ShopAppError.content(isNetworkError: false)) : callback(TestHelper.checkoutWithShippingAddress, nil)
    }
    
    func getCheckout(id: String, callback: @escaping ApiCallback<Checkout>) {
        isGetCheckoutStarted = true
        
        checkoutId = id
        
        isNeedToReturnError ? callback(nil, ShopAppError.content(isNetworkError: false)) : callback(TestHelper.checkoutWithShippingAddress, nil)
    }
    
    func setShippingAddress(checkoutId: String, address: Address, callback: @escaping ApiCallback<Bool>) {
        isUpdateShippingAddressStarted = true
        
        self.checkoutId = checkoutId
        self.address = address
        
        isNeedToReturnError ? callback(nil, ShopAppError.content(isNetworkError: false)) : callback(true, nil)
    }
    
    func getShippingRates(checkoutId: String, callback: @escaping ApiCallback<[ShippingRate]>) {
        isGetShippingRatesStarted = true
        
        self.checkoutId = checkoutId
        
        isNeedToReturnError ? callback(nil, ShopAppError.content(isNetworkError: false)) : callback([], nil)
    }
    
    func setShippingRate(checkoutId: String, shippingRate: ShippingRate, callback: @escaping ApiCallback<Checkout>) {
        isUpdateCheckoutStarted = true
        
        self.shippingRate = shippingRate
        self.checkoutId = checkoutId
        
        isNeedToReturnError ? callback(nil, ShopAppError.content(isNetworkError: false)) : callback(TestHelper.checkoutWithShippingAddress, nil)
    }
    
    func completeCheckout(checkout: Checkout, email: String, address: Address, card: Card,  callback: @escaping ApiCallback<Order>) {
        isPayStarted = true
        
        self.card = card
        self.checkout = checkout
        self.billingAddress = address
        self.email = email
        
        isNeedToReturnError ? callback(nil, ShopAppError.content(isNetworkError: false)) : callback(TestHelper.orderWithProducts, nil)
    }
    
    func setupApplePay(checkout: Checkout, email: String, callback: @escaping ApiCallback<Order>) {
        isSetupApplePayStarted = true
        
        self.checkout = checkout
        self.email = email
        
        isNeedToReturnError ? callback(nil, ShopAppError.content(isNetworkError: false)) : callback(TestHelper.orderWithProducts, nil)
    }
    
    func getCountries(callback: @escaping ApiCallback<[Country]>) {
        isGetCountriesStarted = true
        
        isNeedToReturnError ? callback(nil, ShopAppError.content(isNetworkError: false)) : callback([], nil)
    }
    
    // MARK: - Orders
    
    func getOrders(perPage: Int, paginationValue: Any?, callback: @escaping ApiCallback<[Order]>) {
        isGetOrderListStarted = true
        
        self.perPage = perPage
        self.paginationValue = paginationValue as? String
        
        isNeedToReturnError ? callback(nil, ShopAppError.content(isNetworkError: false)) : callback([], nil)
    }
    
    func getOrder(id: String, callback: @escaping ApiCallback<Order>) {
        isGetOrderStarted = true
        
        self.id = id
        
        isNeedToReturnError ? callback(nil, ShopAppError.content(isNetworkError: false)) : callback(TestHelper.orderWithProducts, nil)
    }
    
    // MARK: - Cart
    
    func getCartProducts(callback: @escaping ApiCallback<[CartProduct]>) {
        isNeedToReturnError ? callback(nil, ShopAppError.content(isNetworkError: false)) : callback([], nil)
    }
    
    func addCartProduct(cartProduct: CartProduct, callback: @escaping ApiCallback<Void>) {
        isAddCartProductStarted = true
        
        self.cartProduct = cartProduct
        
        callback((), isNeedToReturnError ? ShopAppError.content(isNetworkError: false) : nil)
    }
    
    func deleteCartProduct(cartItemId: String, callback: @escaping ApiCallback<Void>) {
        isDeleteProductFromCartStarted = true
        
        self.cartItemId = cartItemId
        
        callback((), isNeedToReturnError ? ShopAppError.content(isNetworkError: false) : nil)
    }
    
    func deleteAllCartProducts(callback: @escaping ApiCallback<Void>) {
        isDeleteAllProductsFromCartStarted = true
        
        callback((), isNeedToReturnError ? ShopAppError.content(isNetworkError: false) : nil)
    }
    
    func changeCartProductQuantity(cartItemId: String, quantity: Int, callback: @escaping ApiCallback<Void>) {
        isChangeCartProductQuantityStarted = true
        
        self.cartItemId = cartItemId
        self.quantity = quantity
        
        callback((), isNeedToReturnError ? ShopAppError.content(isNetworkError: false) : nil)
    }
}
