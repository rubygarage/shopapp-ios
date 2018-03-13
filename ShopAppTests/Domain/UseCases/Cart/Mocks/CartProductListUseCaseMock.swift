//
//  CartProductListUseCaseMock.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 3/7/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

@testable import ShopApp

class CartProductListUseCaseMock: CartProductListUseCase {
    var isNeedToReturnError = false
    var isNeedToReturnEmptyData = false
    var isNeedToReturnQuantity = false
    
    override func getCartProductList(_ callback: @escaping RepoCallback<[CartProduct]>) {
        if isNeedToReturnError {
            callback(nil, RepoError())
        } else {
            let cartProduct = CartProduct()
            cartProduct.quantity = isNeedToReturnQuantity ? 5 : 0
            let response = isNeedToReturnEmptyData ? [] : [cartProduct]
            callback(response, nil)
        }
    }
}
