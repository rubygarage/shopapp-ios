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

    func getCartProducts(callback: @escaping RepoCallback<[CartProduct]>) {
        api.getCartProducts(callback: callback)
    }
    
    func addCartProduct(cartProduct: CartProduct, callback: @escaping RepoCallback<Bool>) {
        api.addCartProduct(cartProduct: cartProduct, callback: callback)
    }
    
    func deleteCartProduct(productVariantId: String, callback: @escaping RepoCallback<Bool>) {
        api.deleteCartProduct(productVariantId: productVariantId, callback: callback)
    }
    
    func deleteCartProducts(productVariantIds: [String], callback: @escaping RepoCallback<Bool>) {
        api.deleteCartProducts(productVariantIds: productVariantIds, callback: callback)
    }
    
    func deleteAllCartProducts(callback: @escaping RepoCallback<Bool>) {
        api.deleteAllCartProducts(callback: callback)
    }
    
    func changeCartProductQuantity(productVariantId: String, quantity: Int, callback: @escaping RepoCallback<Bool>) {
        api.changeCartProductQuantity(productVariantId: productVariantId, quantity: quantity, callback: callback)
    }
}
