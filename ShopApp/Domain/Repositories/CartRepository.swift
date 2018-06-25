//
//  CartRepository.swift
//  ShopApp
//
//  Created by Evgeniy Antonov on 11/7/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import ShopApp_Gateway

protocol CartRepository {
    func getCartProducts(callback: @escaping ApiCallback<[CartProduct]>)

    func addCartProduct(cartProduct: CartProduct, callback: @escaping ApiCallback<Void>)

    func deleteCartProduct(cartItemId: String, callback: @escaping ApiCallback<Void>)

    func deleteAllCartProducts(callback: @escaping ApiCallback<Void>)

    func changeCartProductQuantity(cartItemId: String, quantity: Int, callback: @escaping ApiCallback<Void>)
}
