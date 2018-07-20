//
//  CartProductsUseCaseMock.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 3/7/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

@testable import ShopApp

class CartProductsUseCaseMock: CartProductsUseCase {
    var isNeedToReturnError = false
    var isNeedToReturnEmptyData = false
    var isNeedToReturnQuantity = false
    
    override func getCartProducts(_ callback: @escaping ApiCallback<[CartProduct]>) {
        if isNeedToReturnError {
            callback(nil, ShopAppError.content(isNetworkError: false))
        } else {
            let cartProduct = isNeedToReturnQuantity ? TestHelper.cartProductWithQuantityTwo : TestHelper.cartProductWithQuantityZero
            let response = isNeedToReturnEmptyData ? [] : [cartProduct]
            callback(response, nil)
        }
    }
}
