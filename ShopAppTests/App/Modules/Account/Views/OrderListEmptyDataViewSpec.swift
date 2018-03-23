//
//  OrderListEmptyDataViewSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/2/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick

@testable import ShopApp

class OrderListEmptyDataViewSpec: QuickSpec {
    override func spec() {
        var view: OrderListEmptyDataView!
        var delegateMock: OrderListEmptyDataViewDelegateMock!
        var emptyOrderListLabel: UILabel!
        var startShoppingButton: UIButton!
        
        beforeEach {
            view = OrderListEmptyDataView()
            
            emptyOrderListLabel = self.findView(withAccessibilityLabel: "emptyOrderList", in: view) as! UILabel
            startShoppingButton = self.findView(withAccessibilityLabel: "startShopping", in: view) as! UIButton
        }
        
        describe("when view initialized") {
            it("should have correct label text") {
                expect(emptyOrderListLabel.text) == "Label.NoOrdersYet".localizable
            }
            
            it("should have correct button text") {
                expect(startShoppingButton.title(for: .normal)) == "Button.StartShopping".localizable.uppercased()
            }
        }
        
        describe("when start shopping pressed") {
            it("needs to move to home screen") {
                delegateMock = OrderListEmptyDataViewDelegateMock()
                view.delegate = delegateMock
                startShoppingButton.sendActions(for: .touchUpInside)
                
                expect(delegateMock.view) === view
            }
        }
    }
}
