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
    var card: CreditCard?
    var checkout: Checkout?
    var billingAddress: Address?
    var ids: [String]?
    var cartProduct: CartProduct?
    var cartItemId: String?
    var cartItemIds: [String?]?
    var quantity: Int?

    // MARK: - Shop
    
    func getShop(callback: @escaping RepoCallback<Shop>) {
        isGetShopInfoStarted = true
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback(Shop(), nil)
    }
    
    func getConfig() -> Config {
        return Config(isPopularEnabled: false, isBlogEnabled: false, isOrdersEnabled: false)
    }
    
    // MARK: - Products
    
    func getProducts(perPage: Int, paginationValue: Any?, sortBy: SortType?, keyword: String?, excludeKeyword: String?, callback: @escaping RepoCallback<[Product]>) {
        isGetProductListStarted = true
        
        self.perPage = perPage
        self.paginationValue = paginationValue as? String
        self.sortBy = sortBy
        self.keyword = keyword
        self.excludeKeyword = excludeKeyword
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback([], nil)
    }
    
    func getProduct(id: String, callback: @escaping RepoCallback<Product>) {
        isGetProductStarted = true
        
        self.id = id
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback(Product(), nil)
    }
    
    func searchProducts(perPage: Int, paginationValue: Any?, query: String, callback: @escaping RepoCallback<[Product]>) {
        isSearchProductsStarted = true
        
        self.perPage = perPage
        self.paginationValue = paginationValue as? String
        self.query = query
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback([], nil)
    }
    
    func getProductVariants(ids: [String], callback: @escaping RepoCallback<[ProductVariant]>) {
        isGetProductVariantListStarted = true
        
        self.ids = ids
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback([], nil)
    }
    
    // MARK: - Categories
    
    func getCategories(perPage: Int, paginationValue: Any?, parentCategoryId: String?, callback: @escaping RepoCallback<[ShopApp_Gateway.Category]>) {
        isGetCategoryListStarted = true
        
        self.perPage = perPage
        self.paginationValue = paginationValue as? String

        isNeedToReturnError ? callback(nil, RepoError()) : callback([], nil)
    }
    
    func getCategory(id: String, perPage: Int, paginationValue: Any?, sortBy: SortType?, callback: @escaping RepoCallback<ShopApp_Gateway.Category>) {
        isGetCategoryStarted = true
        
        self.id = id
        self.perPage = perPage
        self.paginationValue = paginationValue as? String
        self.sortBy = sortBy
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback(Category(), nil)
    }
    
    // MARK: - Articles
    
    func getArticles(perPage: Int, paginationValue: Any?, sortBy: SortType?, callback: @escaping RepoCallback<[Article]>) {
        isGetArticleListStarted = true
        
        self.perPage = perPage
        self.paginationValue = paginationValue as? String
        self.sortBy = sortBy
        
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
    
    func signUp(firstName: String, lastName: String, email: String, password: String, phone: String, callback: @escaping RepoCallback<Bool>) {
        isSignUpStarter = true
        
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.password = password
        self.phone = phone
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback(true, nil)
    }
    
    func signIn(email: String, password: String, callback: @escaping RepoCallback<Bool>) {
        isLoginStarted = true
        
        self.email = email
        self.password = password
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback(true, nil)
    }
    
    func signOut(callback: @escaping RepoCallback<Bool>) {
        isLogoutStarted = true
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback(true, nil)
    }
    
    func isSignedIn(callback: @escaping RepoCallback<Bool>) {
        isNeedToReturnError ? callback(false, RepoError()) : callback(true, nil)
    }
    
    func resetPassword(email: String, callback: @escaping RepoCallback<Bool>) {
        isResetPasswordStarted = true
        
        self.email = email
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback(true, nil)
    }
    
    // MARK: - Customer
    
    func getCustomer(callback: @escaping RepoCallback<Customer>) {
        isGetCustomerStarted = true
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback(Customer(), nil)
    }
    
    func updateCustomer(firstName: String, lastName: String, phone: String, callback: @escaping RepoCallback<Customer>) {
        isUpdateCustomerInfoStarted = true
        
        self.firstName = firstName
        self.lastName = lastName
        self.phone = phone
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback(Customer(), nil)
    }
    
    func updateCustomerSettings(isAcceptMarketing: Bool, callback: @escaping RepoCallback<Customer>) {
        isUpdateCustomerPromoStarted = true
        
        self.isAcceptMarketing = isAcceptMarketing
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback(Customer(), nil)
    }
    
    func updatePassword(password: String, callback: @escaping RepoCallback<Customer>) {
        isUpdateCustomerPasswordStarted = true
        
        self.password = password
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback(Customer(), nil)
    }
    
    func addCustomerAddress(address: Address, callback: @escaping RepoCallback<String>) {
        isAddCustomerAddressStarted = true
        
        self.address = address
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback("", nil)
    }
    
    func updateCustomerAddress(address: Address, callback: @escaping RepoCallback<Bool>) {
        isUpdateCustomerAddressStarted = true
        
        self.address = address
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback(true, nil)
    }
    
    func setDefaultShippingAddress(addressId: String, callback: @escaping RepoCallback<Customer>) {
        isUpdateCustomerDefaultAddressStarted = true
        
        self.addressId = addressId
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback(Customer(), nil)
    }
    
    func deleteCustomerAddress(addressId: String, callback: @escaping RepoCallback<Bool>) {
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
    
    func getCheckout(checkoutId: String, callback: @escaping RepoCallback<Checkout>) {
        isGetCheckoutStarted = true
        
        self.checkoutId = checkoutId
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback(Checkout(), nil)
    }
    
    func setShippingAddress(checkoutId: String, address: Address, callback: @escaping RepoCallback<Bool>) {
        isUpdateShippingAddressStarted = true
        
        self.checkoutId = checkoutId
        self.address = address
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback(true, nil)
    }
    
    func getShippingRates(checkoutId: String, callback: @escaping RepoCallback<[ShippingRate]>) {
        isGetShippingRatesStarted = true
        
        self.checkoutId = checkoutId
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback([], nil)
    }
    
    func setShippingRate(checkoutId: String, shippingRate: ShippingRate, callback: @escaping RepoCallback<Checkout>) {
        isUpdateCheckoutStarted = true
        
        self.shippingRate = shippingRate
        self.checkoutId = checkoutId
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback(Checkout(), nil)
    }
    
    func completeCheckout(checkout: Checkout, email: String, address: Address, card: CreditCard,  callback: @escaping RepoCallback<Order>) {
        isPayStarted = true
        
        self.card = card
        self.checkout = checkout
        self.billingAddress = address
        self.email = email
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback(Order(), nil)
    }
    
    func setupApplePay(checkout: Checkout, email: String, callback: @escaping RepoCallback<Order>) {
        isSetupApplePayStarted = true
        
        self.checkout = checkout
        self.email = email
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback(Order(), nil)
    }
    
    func getCountries(callback: @escaping RepoCallback<[Country]>) {
        isGetCountriesStarted = true
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback([], nil)
    }
    
    // MARK: - Orders
    
    func getOrders(perPage: Int, paginationValue: Any?, callback: @escaping RepoCallback<[Order]>) {
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
    
    // MARK: - Cart
    
    func getCartProducts(callback: @escaping ([CartProduct]?, RepoError?) -> Void) {
        isNeedToReturnError ? callback(nil, RepoError()) : callback([], nil)
    }
    
    func addCartProduct(cartProduct: CartProduct, callback: @escaping RepoCallback<Bool>) {
        isAddCartProductStarted = true
        
        self.cartProduct = cartProduct
        
        isNeedToReturnError ? callback(false, RepoError()) : callback(true, nil)
    }
    
    func deleteCartProduct(cartItemId: String, callback: @escaping RepoCallback<Bool>) {
        isDeleteProductFromCartStarted = true
        
        self.cartItemId = cartItemId
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback(true, nil)
    }
    
    func deleteCartProducts(cartItemIds: [String], callback: @escaping RepoCallback<Bool>) {
        isDeleteProductsFromCartStarted = true
        
        self.cartItemIds = cartItemIds
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback(true, nil)
    }
    
    func deleteAllCartProducts(callback: @escaping RepoCallback<Bool>) {
        isDeleteAllProductsFromCartStarted = true
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback(true, nil)
    }
    
    func changeCartProductQuantity(cartItemId: String, quantity: Int, callback: @escaping RepoCallback<Bool>) {
        isChangeCartProductQuantityStarted = true
        
        self.cartItemId = cartItemId
        self.quantity = quantity
        
        isNeedToReturnError ? callback(false, RepoError()) : callback(true, nil)
    }
}
