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
    
    func setupProvider(callback: @escaping RepoCallback<Void>)

    // MARK: - Shop
    
    func getShop(callback: @escaping RepoCallback<Shop>)
    
    // MARK: - Products
    
    func getProducts(perPage: Int, paginationValue: Any?, sortBy: SortType?, keyword: String?, excludeKeyword: String?, callback: @escaping RepoCallback<[Product]>)

    func getProduct(id: String, callback: @escaping RepoCallback<Product>)

    func searchProducts(perPage: Int, paginationValue: Any?, query: String, callback: @escaping RepoCallback<[Product]>)

    func getProductVariants(ids: [String], callback: @escaping RepoCallback<[ProductVariant]>)
    
    // MARK: - Categories
    
    func getCategories(perPage: Int, paginationValue: Any?, callback: @escaping RepoCallback<[Category]>)

    func getCategory(id: String, perPage: Int, paginationValue: Any?, sortBy: SortType?, callback: @escaping RepoCallback<Category>)
    
    // MARK: - Articles
    
    func getArticles(perPage: Int, paginationValue: Any?, sortBy: SortType?, callback: @escaping RepoCallback<[Article]>)

    func getArticle(id: String, callback: @escaping RepoCallback<(article: Article, baseUrl: URL)>)
    
    // MARK: - Authentification
    
    func signUp(firstName: String, lastName: String, email: String, password: String, phone: String, callback: @escaping RepoCallback<Bool>)

    func signIn(email: String, password: String, callback: @escaping RepoCallback<Bool>)

    func signOut(callback: @escaping RepoCallback<Bool>)

    func isSignedIn(callback: @escaping RepoCallback<Bool>)

    func resetPassword(email: String, callback: @escaping RepoCallback<Bool>)
    
    // MARK: - Customer
    
    func getCustomer(callback: @escaping RepoCallback<Customer>)

    func updateCustomer(firstName: String, lastName: String, phone: String, callback: @escaping RepoCallback<Customer>)

    func updateCustomerSettings(isAcceptMarketing: Bool, callback: @escaping RepoCallback<Customer>)

    func updatePassword(password: String, callback: @escaping RepoCallback<Customer>)

    func addCustomerAddress(address: Address, callback: @escaping RepoCallback<String>)

    func updateCustomerAddress(address: Address, callback: @escaping RepoCallback<Bool>)

    func setDefaultShippingAddress(id: String, callback: @escaping RepoCallback<Customer>)

    func deleteCustomerAddress(id: String, callback: @escaping RepoCallback<Bool>)
    
    // MARK: - Payments
    
    func createCheckout(cartProducts: [CartProduct], callback: @escaping RepoCallback<Checkout>)

    func getCheckout(id: String, callback: @escaping RepoCallback<Checkout>)

    func setShippingAddress(checkoutId: String, address: Address, callback: @escaping RepoCallback<Bool>)

    func getShippingRates(checkoutId: String, callback: @escaping RepoCallback<[ShippingRate]>)

    func setShippingRate(checkoutId: String, shippingRate: ShippingRate, callback: @escaping RepoCallback<Checkout>)

    func completeCheckout(checkout: Checkout, email: String, address: Address, card: CreditCard, callback: @escaping RepoCallback<Order>)

    func setupApplePay(checkout: Checkout, email: String, callback: @escaping RepoCallback<Order>)

    // MARK: - Countries

    func getCountries(callback: @escaping RepoCallback<[Country]>)
    
    // MARK: - Orders
    
    func getOrders(perPage: Int, paginationValue: Any?, callback: @escaping RepoCallback<[Order]>)

    func getOrder(id: String, callback: @escaping RepoCallback<Order>)
    
    // MARK: - Cart
    
    func getCartProducts(callback: @escaping RepoCallback<[CartProduct]>)

    func addCartProduct(cartProduct: CartProduct, callback: @escaping RepoCallback<Bool>)

    func deleteCartProduct(cartItemId: String, callback: @escaping RepoCallback<Bool>)

    func deleteAllCartProducts(callback: @escaping RepoCallback<Bool>)

    func changeCartProductQuantity(cartItemId: String, quantity: Int, callback: @escaping RepoCallback<Bool>)
}
