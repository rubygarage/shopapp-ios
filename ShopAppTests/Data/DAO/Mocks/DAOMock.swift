//
//  DAOMock.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/28/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

@testable import ShopApp

class DAOMock: DAO {
    var isNeedToReturnError = false
    var isAddCartProductStarted = false
    var isDeleteProductFromCartStarted = false
    var isDeleteAllProductsFromCartStarted = false
    var isChangeCartProductQuantityStarted = false
    var cartProduct: CartProduct?
    var productVariantId: String?
    var quantity: Int?
    
    func getCartProductList(callback: @escaping ([CartProduct]?, RepoError?) -> Void) {
        isNeedToReturnError ? callback(nil, RepoError()) : callback([], nil)
    }
    
    func addCartProduct(cartProduct: CartProduct, callback: @escaping RepoCallback<Bool>) {
        isAddCartProductStarted = true
        
        self.cartProduct = cartProduct
        
        isNeedToReturnError ? callback(false, RepoError()) : callback(true, nil)
    }
    
    func deleteProductFromCart(with productVariantId: String?, callback: @escaping RepoCallback<Bool>) {
        isDeleteProductFromCartStarted = true
        
        self.productVariantId = productVariantId
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback(true, nil)
    }
    
    func deleteAllProductsFromCart(with callback: @escaping RepoCallback<Bool>) {
        isDeleteAllProductsFromCartStarted = true
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback(true, nil)
    }
    
    func changeCartProductQuantity(with productVariantId: String?, quantity: Int, callback: @escaping RepoCallback<Bool>) {
        isChangeCartProductQuantityStarted = true
        
        self.productVariantId = productVariantId
        self.quantity = quantity
        
        isNeedToReturnError ? callback(false, RepoError()) : callback(true, nil)
    }
}
