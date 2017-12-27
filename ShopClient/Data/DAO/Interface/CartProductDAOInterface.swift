//
//  CartProductDAOInterface.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/8/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

protocol CartProductDAOInterface {
    func getCartProductList() -> [CartProduct]
    func addCartProduct(cartProduct: CartProduct, callback: @escaping RepoCallback<CartProduct>)
    func deleteProductFromCart(with productVariantId: String?, callback: @escaping RepoCallback<Bool>)
    func changeCartProductQuantity(with productVariantId: String?, quantity: Int, callback: @escaping RepoCallback<CartProduct>)
}
