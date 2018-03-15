//
//  CartRepositoryMock.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 3/7/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

@testable import ShopApp

class CartRepositoryMock: CartRepository {
    func getCartProductList(callback: @escaping RepoCallback<[CartProduct]>) {}
    func addCartProduct(cartProduct: CartProduct, callback: @escaping RepoCallback<CartProduct>) {}
    func deleteProductFromCart(with productVariantId: String?, callback: @escaping RepoCallback<Bool>) {}
    func deleteAllProductsFromCart(with callback: @escaping RepoCallback<Bool>) {}
    func changeCartProductQuantity(with productVariantId: String?, quantity: Int, callback: @escaping RepoCallback<CartProduct>) {}
}
