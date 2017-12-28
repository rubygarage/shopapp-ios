//
//  CartRepositoryInterface.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/7/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

protocol CartRepositoryInterface {
    func getCartProductList(callback: @escaping RepoCallback<[CartProduct]>)
    func addCartProduct(cartProduct: CartProduct, callback: @escaping RepoCallback<CartProduct>)
    func deleteProductFromCart(with productVariantId: String?, callback: @escaping RepoCallback<Bool>)
    func changeCartProductQuantity(with productVariantId: String?, quantity: Int, callback: @escaping RepoCallback<CartProduct>)
}
