//
//  CartViewModelMock.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 3/9/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Foundation
import ShopApp_Gateway

@testable import ShopApp

class CartViewModelMock: CartViewModel {
    var isNeedToReturnData = false
    var isLoadDataStarted = false
    var isUpdateCartProductStarted = false
    
    override func loadData(showLoading: Bool) {
        if isNeedToReturnData {
            data.value = [TestHelper.cartProductWithQuantityOne]
        }
        isLoadDataStarted = true
    }
    
    override func update(cartProduct: CartProduct, quantity: Int) {
        let product = CartProduct(id: cartProduct.id, productVariant: cartProduct.productVariant, title: cartProduct.title, currency: cartProduct.currency, quantity: quantity)
        
        data.value = [product]
        isUpdateCartProductStarted = true
    }
}
