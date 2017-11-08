//
//  CartRepository.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/7/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import Foundation

extension Repository: CartRepositoryInterface {
    func getCartProductList(callback: @escaping RepoCallback<[CartProduct]>) {
        callback(DAOCore?.getCartProductList(), nil)
    }
    
    func addCartProduct(cartProduct: CartProduct, callback: @escaping RepoCallback<CartProduct>) {
        DAOCore?.addCartProduct(cartProduct: cartProduct, callback: callback)
    }
}
