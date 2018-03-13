//
//  ChangeCartProductUseCaseMock.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 3/7/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

@testable import ShopApp

class ChangeCartProductUseCaseMock: ChangeCartProductUseCase {
    var isNeedToReturnError = false
    
    override func changeCartProductQuantity(productVariantId: String?, quantity: Int, _ callback: @escaping RepoCallback<CartProduct>) {
        if isNeedToReturnError {
            callback(nil, RepoError())
        } else {
            let cartProduct = CartProduct()
            cartProduct.quantity = quantity
            callback(cartProduct, nil)
        }
    }
}
