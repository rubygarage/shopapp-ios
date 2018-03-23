//
//  CartRepository.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/7/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import ShopApp_Gateway

class AppCartRepository: CartRepository {

    private let dao: DAOInterface

    init(dao: DAOInterface) {
        self.dao = dao
    }

    func getCartProductList(callback: @escaping RepoCallback<[CartProduct]>) {
        callback(dao.getCartProductList(), nil)
    }
    
    func addCartProduct(cartProduct: CartProduct, callback: @escaping RepoCallback<CartProduct>) {
        dao.addCartProduct(cartProduct: cartProduct, callback: callback)
    }
    
    func deleteProductFromCart(with productVariantId: String?, callback: @escaping RepoCallback<Bool>) {
        dao.deleteProductFromCart(with: productVariantId, callback: callback)
    }
    
    func deleteAllProductsFromCart(with callback: @escaping RepoCallback<Bool>) {
        dao.deleteAllProductsFromCart(with: callback)
    }
    
    func changeCartProductQuantity(with productVariantId: String?, quantity: Int, callback: @escaping RepoCallback<CartProduct>) {
        dao.changeCartProductQuantity(with: productVariantId, quantity: quantity, callback: callback)
    }
}
