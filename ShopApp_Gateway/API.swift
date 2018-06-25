//
//  API.swift
//  ShopApp_Gateway
//
//  Created by Evgeniy Antonov on 10/23/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import Foundation

public protocol API {
    
    // MARK: - Setup
    
    func setupProvider(callback: @escaping ApiCallback<Void>)

    // MARK: - Shop
    
    func getShop(callback: @escaping ApiCallback<Shop>)
    
    // MARK: - Products
    
    func getProducts(perPage: Int, paginationValue: Any?, sortBy: SortType?, keyword: String?, excludeKeyword: String?, callback: @escaping ApiCallback<[Product]>)

    func getProduct(id: String, callback: @escaping ApiCallback<Product>)

    func searchProducts(perPage: Int, paginationValue: Any?, query: String, callback: @escaping ApiCallback<[Product]>)

    func getProductVariants(ids: [String], callback: @escaping ApiCallback<[ProductVariant]>)
    
    // MARK: - Categories
    
    func getCategories(perPage: Int, paginationValue: Any?, callback: @escaping ApiCallback<[Category]>)

    func getCategory(id: String, perPage: Int, paginationValue: Any?, sortBy: SortType?, callback: @escaping ApiCallback<Category>)
    
    // MARK: - Articles
    
    func getArticles(perPage: Int, paginationValue: Any?, sortBy: SortType?, callback: @escaping ApiCallback<[Article]>)

    func getArticle(id: String, callback: @escaping ApiCallback<(article: Article, baseUrl: URL)>)
    
    // MARK: - Authentification
    
    func signUp(firstName: String, lastName: String, email: String, password: String, phone: String, callback: @escaping ApiCallback<Void>)

    func signIn(email: String, password: String, callback: @escaping ApiCallback<Void>)

    func signOut(callback: @escaping ApiCallback<Void>)

    func isSignedIn(callback: @escaping ApiCallback<Bool>)

    func resetPassword(email: String, callback: @escaping ApiCallback<Void>)
    
    // MARK: - Customer
    
    func getCustomer(callback: @escaping ApiCallback<Customer>)

    func updateCustomer(firstName: String, lastName: String, phone: String, callback: @escaping ApiCallback<Customer>)

    func updateCustomerSettings(isAcceptMarketing: Bool, callback: @escaping ApiCallback<Void>)

    func updatePassword(password: String, callback: @escaping ApiCallback<Void>)

    func addCustomerAddress(address: Address, callback: @escaping ApiCallback<Void>)

    func updateCustomerAddress(address: Address, callback: @escaping ApiCallback<Void>)

    func setDefaultShippingAddress(id: String, callback: @escaping ApiCallback<Void>)

    func deleteCustomerAddress(id: String, callback: @escaping ApiCallback<Void>)
    
    // MARK: - Payments
    
    func createCheckout(cartProducts: [CartProduct], callback: @escaping ApiCallback<Checkout>)

    func getCheckout(id: String, callback: @escaping ApiCallback<Checkout>)

    func setShippingAddress(checkoutId: String, address: Address, callback: @escaping ApiCallback<Bool>)

    func getShippingRates(checkoutId: String, callback: @escaping ApiCallback<[ShippingRate]>)

    func setShippingRate(checkoutId: String, shippingRate: ShippingRate, callback: @escaping ApiCallback<Checkout>)

    func completeCheckout(checkout: Checkout, email: String, address: Address, card: Card, callback: @escaping ApiCallback<Order>)

    func setupApplePay(checkout: Checkout, email: String, callback: @escaping ApiCallback<Order>)

    // MARK: - Countries

    func getCountries(callback: @escaping ApiCallback<[Country]>)
    
    // MARK: - Orders
    
    func getOrders(perPage: Int, paginationValue: Any?, callback: @escaping ApiCallback<[Order]>)

    func getOrder(id: String, callback: @escaping ApiCallback<Order>)
    
    // MARK: - Cart
    
    func getCartProducts(callback: @escaping ApiCallback<[CartProduct]>)

    func addCartProduct(cartProduct: CartProduct, callback: @escaping ApiCallback<Void>)

    func deleteCartProduct(cartItemId: String, callback: @escaping ApiCallback<Void>)

    func deleteAllCartProducts(callback: @escaping ApiCallback<Void>)

    func changeCartProductQuantity(cartItemId: String, quantity: Int, callback: @escaping ApiCallback<Void>)
}
