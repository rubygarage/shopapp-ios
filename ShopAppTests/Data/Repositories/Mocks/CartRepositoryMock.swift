//
//  CartRepositoryMock.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 3/7/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

@testable import ShopApp

class CartRepositoryMock: CartRepository {
    var isNeedToReturnError = false
    var isGetCartProductListStarted = false
    var isAddCartProductStarted = false
    var isDeleteProductFromCartStarted = false
    var isDeleteProductsFromCartStarted = false
    var isDeleteAllProductsFromCartStarted = false
    var isChangeCartProductQuantityStarted = false
    var cartProduct: CartProduct?
    var cartItemId: String?
    var cartItemIds: [String?]?
    var quantity: Int?
    
    func getCartProducts(callback: @escaping ([CartProduct]?, RepoError?) -> Void) {
        isGetCartProductListStarted = true
        
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
        
        isNeedToReturnError ? callback(false, RepoError()) : callback(true, nil)
    }
    
    func deleteCartProducts(cartItemIds: [String], callback: @escaping RepoCallback<Bool>) {
        isDeleteProductsFromCartStarted = true
        
        self.cartItemIds = cartItemIds
        
        isNeedToReturnError ? callback(false, RepoError()) : callback(true, nil)
    }
    
    func deleteAllCartProducts(callback: @escaping RepoCallback<Bool>) {
        isDeleteAllProductsFromCartStarted = true
        
        isNeedToReturnError ? callback(false, RepoError()) : callback(true, nil)
    }
    
    func changeCartProductQuantity(cartItemId: String, quantity: Int, callback: @escaping RepoCallback<Bool>) {
        isChangeCartProductQuantityStarted = true
        
        self.cartItemId = cartItemId
        self.quantity = quantity
        
        isNeedToReturnError ? callback(false, RepoError()) : callback(true, nil)
    }
}
