//
//  QuantityDropDownViewDelegateMock.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/20/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick

@testable import ShopApp

class QuantityDropDownViewDelegateMock: QuantityDropDownViewDelegate {
    var view: QuantityDropDownView?
    var quantity: Int?
    
    // MARK: - QuantityDropDownViewDelegate
    
    func quantityDropDownView(_ view: QuantityDropDownView, didChange quantity: Int) {
        self.view = view
        self.quantity = quantity
    }
    
    func quantityDropDownView(_ view: QuantityDropDownView, didSelectMoreWith quantity: Int) {
        self.view = view
        self.quantity = quantity
    }
}
