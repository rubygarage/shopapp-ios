//
//  DAO.swift
//  ShopApp
//
//  Created by Evgeniy Antonov on 11/8/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import ShopApp_Gateway

protocol DAO {
    func getCartProductList(callback: @escaping RepoCallback<[CartProduct]>)
    func addCartProduct(cartProduct: CartProduct, callback: @escaping RepoCallback<CartProduct>)
    func deleteProductFromCart(with productVariantId: String?, callback: @escaping RepoCallback<Bool>)
    func deleteAllProductsFromCart(with callback: @escaping RepoCallback<Bool>)
    func changeCartProductQuantity(with productVariantId: String?, quantity: Int, callback: @escaping RepoCallback<CartProduct>)
}
