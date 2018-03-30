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
    var isGetShopInfoStarted = false
    var isGetProductListStarted = false
    var isGetProductStarted = false
    var isSearchProductsStarted = false
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
    var perPage: Int?
    var paginationValue: String?
    var sortBy: SortingValue?
    var reverse: Bool?
    var id: String?
    var keyPhrase: String?
    var excludePhrase: String?
    var searchQuery: String?
    var email: String?
    var firstName: String?
    var lastName: String?
    var password: String?
    var phone: String?
    var promo: Bool?
    var address: Address?
    var addressId: String?
    var cartProducts: [CartProduct]?
    var checkoutId: String?
    var rate: ShippingRate?
    var card: CreditCard?
    var checkout: Checkout?
    var billingAddress: Address?
    var customerEmail: String?
    
    // MARK: - Shop
    
    func getShopInfo(callback: @escaping RepoCallback<Shop>) {
        isGetShopInfoStarted = true
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback(Shop(), nil)
    }
    
    // MARK: - Products
    
    func getProductList(perPage: Int, paginationValue: Any?, sortBy: SortingValue?, keyPhrase: String?, excludePhrase: String?, reverse: Bool, callback: @escaping RepoCallback<[Product]>) {
        isGetProductListStarted = true
        
        self.perPage = perPage
        self.paginationValue = paginationValue as? String
        self.sortBy = sortBy
        self.keyPhrase = keyPhrase
        self.excludePhrase = excludePhrase
        self.reverse = reverse
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback([], nil)
    }
    
    func getProduct(id: String, callback: @escaping RepoCallback<Product>) {
        isGetProductStarted = true
        
        self.id = id
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback(Product(), nil)
    }
    
    func searchProducts(perPage: Int, paginationValue: Any?, searchQuery: String, callback: @escaping RepoCallback<[Product]>) {
        isSearchProductsStarted = true
        
        self.perPage = perPage
        self.paginationValue = paginationValue as? String
        self.searchQuery = searchQuery
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback([], nil)
    }
    
    // MARK: - Categories
    
    func getCategoryList(perPage: Int, paginationValue: Any?, sortBy: SortingValue?, reverse: Bool, callback: @escaping RepoCallback<[ShopApp_Gateway.Category]>) {
        isGetCategoryListStarted = true
        
        self.perPage = perPage
        self.paginationValue = paginationValue as? String
        self.sortBy = sortBy
        self.reverse = reverse
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback([], nil)
    }
    
    func getCategoryDetails(id: String, perPage: Int, paginationValue: Any?, sortBy: SortingValue?, reverse: Bool, callback: @escaping RepoCallback<ShopApp_Gateway.Category>) {
        isGetCategoryStarted = true
        
        self.id = id
        self.perPage = perPage
        self.paginationValue = paginationValue as? String
        self.sortBy = sortBy
        self.reverse = reverse
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback(Category(), nil)
    }
    
    // MARK: - Articles
    
    func getArticleList(perPage: Int, paginationValue: Any?, sortBy: SortingValue?, reverse: Bool, callback: @escaping RepoCallback<[Article]>) {
        isGetArticleListStarted = true
        
        self.perPage = perPage
        self.paginationValue = paginationValue as? String
        self.sortBy = sortBy
        self.reverse = reverse
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback([], nil)
    }
    
    func getArticle(id: String, callback: @escaping RepoCallback<(article: Article, baseUrl: URL)>) {
        isGetArticleStarted = true
        
        self.id = id
        
        if isNeedToReturnError {
            callback(nil, RepoError())
        } else {
            let article = Article()
            let baseUrl = URL(string: "https://www.google.com")!
            let result = (article: article, baseUrl: baseUrl)
            
            callback(result, nil)
        }
    }
    
    // MARK: - Authentification
    
    func signUp(with email: String, firstName: String?, lastName: String?, password: String, phone: String?, callback: @escaping RepoCallback<Bool>) {
        isSignUpStarter = true
        
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.password = password
        self.phone = phone
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback(true, nil)
    }
    
    func login(with email: String, password: String, callback: @escaping RepoCallback<Bool>) {
        isLoginStarted = true
        
        self.email = email
        self.password = password
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback(true, nil)
    }
    
    func logout(callback: RepoCallback<Bool>) {
        isLogoutStarted = true
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback(true, nil)
    }
    
    func isLoggedIn() -> Bool {
        return !isNeedToReturnError
    }
    
    func resetPassword(with email: String, callback: @escaping RepoCallback<Bool>) {
        isResetPasswordStarted = true
        
        self.email = email
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback(true, nil)
    }
    
    // MARK: - Customer
    
    func getCustomer(callback: @escaping RepoCallback<Customer>) {
        isGetCustomerStarted = true
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback(Customer(), nil)
    }
    
    func updateCustomer(with email: String, firstName: String?, lastName: String?, phone: String?, callback: @escaping RepoCallback<Customer>) {
        isUpdateCustomerInfoStarted = true
        
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.phone = phone
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback(Customer(), nil)
    }
    
    func updateCustomer(with promo: Bool, callback: @escaping RepoCallback<Customer>) {
        isUpdateCustomerPromoStarted = true
        
        self.promo = promo
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback(Customer(), nil)
    }
    
    func updateCustomer(with password: String, callback: @escaping RepoCallback<Customer>) {
        isUpdateCustomerPasswordStarted = true
        
        self.password = password
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback(Customer(), nil)
    }
    
    func addCustomerAddress(with address: Address, callback: @escaping RepoCallback<String>) {
        isAddCustomerAddressStarted = true
        
        self.address = address
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback("", nil)
    }
    
    func updateCustomerAddress(with address: Address, callback: @escaping RepoCallback<Bool>) {
        isUpdateCustomerAddressStarted = true
        
        self.address = address
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback(true, nil)
    }
    
    func updateCustomerDefaultAddress(with addressId: String, callback: @escaping RepoCallback<Customer>) {
        isUpdateCustomerDefaultAddressStarted = true
        
        self.addressId = addressId
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback(Customer(), nil)
    }
    
    func deleteCustomerAddress(with addressId: String, callback: @escaping RepoCallback<Bool>) {
        isDeleteCustomerAddressStarted = true
        
        self.addressId = addressId
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback(true, nil)
    }
    
    // MARK: - Payments
    
    func createCheckout(cartProducts: [CartProduct], callback: @escaping RepoCallback<Checkout>) {
        isCreateCheckoutStarted = true
        
        self.cartProducts = cartProducts
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback(Checkout(), nil)
    }
    
    func getCheckout(with checkoutId: String, callback: @escaping RepoCallback<Checkout>) {
        isGetCheckoutStarted = true
        
        self.checkoutId = checkoutId
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback(Checkout(), nil)
    }
    
    func updateShippingAddress(with checkoutId: String, address: Address, callback: @escaping RepoCallback<Bool>) {
        isUpdateShippingAddressStarted = true
        
        self.checkoutId = checkoutId
        self.address = address
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback(true, nil)
    }
    
    func getShippingRates(with checkoutId: String, callback: @escaping RepoCallback<[ShippingRate]>) {
        isGetShippingRatesStarted = true
        
        self.checkoutId = checkoutId
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback([], nil)
    }
    
    func updateCheckout(with rate: ShippingRate, checkoutId: String, callback: @escaping RepoCallback<Checkout>) {
        isUpdateCheckoutStarted = true
        
        self.rate = rate
        self.checkoutId = checkoutId
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback(Checkout(), nil)
    }
    
    func pay(with card: CreditCard, checkout: Checkout, billingAddress: Address, customerEmail: String, callback: @escaping RepoCallback<Order>) {
        isPayStarted = true
        
        self.card = card
        self.checkout = checkout
        self.billingAddress = billingAddress
        self.customerEmail = customerEmail
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback(Order(), nil)
    }
    
    func setupApplePay(with checkout: Checkout, customerEmail: String, callback: @escaping RepoCallback<Order>) {
        isSetupApplePayStarted = true
        
        self.checkout = checkout
        self.customerEmail = customerEmail
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback(Order(), nil)
    }
    
    func getCountries(callback: @escaping RepoCallback<[Country]>) {
        isGetCountriesStarted = true
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback([], nil)
    }
    
    // MARK: - Orders
    
    func getOrderList(perPage: Int, paginationValue: Any?, callback: @escaping RepoCallback<[Order]>) {
        isGetOrderListStarted = true
        
        self.perPage = perPage
        self.paginationValue = paginationValue as? String
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback([], nil)
    }
    
    func getOrder(id: String, callback: @escaping RepoCallback<Order>) {
        isGetOrderStarted = true
        
        self.id = id
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback(Order(), nil)
    }
}
