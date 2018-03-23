//
//  QuantityTextFieldViewDelegateMock.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/20/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick

@testable import ShopApp

class QuantityTextFieldViewDelegateMock: QuantityTextFieldViewDelegate {
    var view: QuantityTextFieldView?
    var quantity: Int?
    
    // MARK: - QuantityTextFieldViewDelegate
    
    func quantityTextFieldView(_ view: QuantityTextFieldView, didEndEditingWith quantity: Int) {
        self.view = view
        self.quantity = quantity
    }
}
