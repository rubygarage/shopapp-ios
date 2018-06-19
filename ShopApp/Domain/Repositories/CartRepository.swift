//
//  CartRepository.swift
//  ShopApp
//
//  Created by Evgeniy Antonov on 11/7/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import ShopApp_Gateway

protocol CartRepository {
    func getCartProducts(callback: @escaping RepoCallback<[CartProduct]>)

    func addCartProduct(cartProduct: CartProduct, callback: @escaping RepoCallback<Bool>)

    func deleteCartProduct(cartItemId: String, callback: @escaping RepoCallback<Bool>)

    func deleteAllCartProducts(callback: @escaping RepoCallback<Bool>)

    func changeCartProductQuantity(cartItemId: String, quantity: Int, callback: @escaping RepoCallback<Bool>)
}
