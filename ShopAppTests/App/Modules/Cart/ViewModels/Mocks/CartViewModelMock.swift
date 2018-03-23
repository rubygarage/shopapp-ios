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
            data.value = [generatedCartProduct]
        }
        isLoadDataStarted = true
    }
    
    override func update(cartProduct: CartProduct, quantity: Int) {
        cartProduct.quantity = quantity
        data.value = [cartProduct]
        isUpdateCartProductStarted = true
    }
    
    private var generatedCartProduct: CartProduct {
        let cartProduct = CartProduct()
        cartProduct.currency = "Currency"
        cartProduct.quantity = 10
        
        let productVariant = ProductVariant()
        productVariant.price = Decimal(integerLiteral: 5)
        cartProduct.productVariant = productVariant
        
        return cartProduct
    }
}
