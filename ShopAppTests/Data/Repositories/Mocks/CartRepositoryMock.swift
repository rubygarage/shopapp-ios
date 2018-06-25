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
    
    func getCartProducts(callback: @escaping ApiCallback<[CartProduct]>) {
        isGetCartProductListStarted = true
        
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
    
    func deleteCartProducts(cartItemIds: [String], callback: @escaping ApiCallback<Void>) {
        isDeleteProductsFromCartStarted = true
        
        self.cartItemIds = cartItemIds
        
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
