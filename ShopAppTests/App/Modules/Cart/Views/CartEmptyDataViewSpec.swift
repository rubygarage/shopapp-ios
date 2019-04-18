//
//  CartEmptyDataViewSpec.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 3/12/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick

@testable import ShopApp

class CartEmptyDataViewSpec: QuickSpec {
    override func spec() {
        var view: CartEmptyDataView!
        var emptyCartLabel: UILabel!
        var startShoppingButton: UIButton!
        var delegateMock: CartEmptyDataViewDelegateMock!
        
        beforeEach {
            view = CartEmptyDataView()
            emptyCartLabel = self.findView(withAccessibilityLabel: "emptyCartLabel", in: view) as? UILabel
            startShoppingButton = self.findView(withAccessibilityLabel: "startShoppingButton", in: view) as? UIButton
        }
        
        describe("when view loaded") {
            it("should have correct labels titles") {
                expect(emptyCartLabel.text) == "Label.YourCartIsEmpty".localizable
            }
            
            it("should have correct button title") {
                expect(startShoppingButton.title(for: .normal)) == "Button.StartShopping".localizable.uppercased()
            }
        }
        
        describe("when start shopping button did press") {
            it("needs to dismiss view") {
                delegateMock = CartEmptyDataViewDelegateMock()
                view.delegate = delegateMock
                startShoppingButton.sendActions(for: .touchUpInside)
                
                expect(delegateMock.view) === view
            }
        }
    }
}
