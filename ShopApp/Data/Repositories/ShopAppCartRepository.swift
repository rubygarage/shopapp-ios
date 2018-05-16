//
//  ShopAppCartRepository.swift
//  ShopApp
//
//  Created by Evgeniy Antonov on 11/7/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import ShopApp_Gateway

class ShopAppCartRepository: CartRepository {
    private let dao: DAO

    init(dao: DAO) {
        self.dao = dao
    }

    func getCartProductList(callback: @escaping RepoCallback<[CartProduct]>) {
        dao.getCartProductList(callback: callback)
    }
    
    func addCartProduct(cartProduct: CartProduct, callback: @escaping RepoCallback<Bool>) {
        dao.addCartProduct(cartProduct: cartProduct, callback: callback)
    }
    
    func deleteProductFromCart(with productVariantId: String?, callback: @escaping RepoCallback<Bool>) {
        dao.deleteProductFromCart(with: productVariantId, callback: callback)
    }
    
    func deleteProductsFromCart(with productVariantIds: [String?], callback: @escaping RepoCallback<Bool>) {
        dao.deleteProductsFromCart(with: productVariantIds, callback: callback)
    }
    
    func deleteAllProductsFromCart(with callback: @escaping RepoCallback<Bool>) {
        dao.deleteAllProductsFromCart(with: callback)
    }
    
    func changeCartProductQuantity(with productVariantId: String?, quantity: Int, callback: @escaping RepoCallback<Bool>) {
        dao.changeCartProductQuantity(with: productVariantId, quantity: quantity, callback: callback)
    }
}
