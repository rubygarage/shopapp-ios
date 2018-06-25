//
//  ShopAppCartRepository.swift
//  ShopApp
//
//  Created by Evgeniy Antonov on 11/7/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import ShopApp_Gateway

class ShopAppCartRepository: CartRepository {
    private let api: API

    init(api: API) {
        self.api = api
    }

    func getCartProducts(callback: @escaping ApiCallback<[CartProduct]>) {
        api.getCartProducts(callback: callback)
    }
    
    func addCartProduct(cartProduct: CartProduct, callback: @escaping ApiCallback<Void>) {
        api.addCartProduct(cartProduct: cartProduct, callback: callback)
    }
    
    func deleteCartProduct(cartItemId: String, callback: @escaping ApiCallback<Void>) {
        api.deleteCartProduct(cartItemId: cartItemId, callback: callback)
    }
    
    func deleteAllCartProducts(callback: @escaping ApiCallback<Void>) {
        api.deleteAllCartProducts(callback: callback)
    }
    
    func changeCartProductQuantity(cartItemId: String, quantity: Int, callback: @escaping ApiCallback<Void>) {
        api.changeCartProductQuantity(cartItemId: cartItemId, quantity: quantity, callback: callback)
    }
}
