//
//  CartButtonViewModelMock.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/15/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick

@testable import ShopApp

class CartButtonViewModelMock: CartButtonViewModel {
    var isGettingCountStarted = false
    var isNeedToReturnCount = false
    
    override func getCartItemsCount() {
        isGettingCountStarted = true
        
        if isNeedToReturnCount {
            cartItemsCount.onNext(1)
        }
    }
}
