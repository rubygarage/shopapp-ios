//
//  CartHeaderViewSpec.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 3/9/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick

@testable import ShopApp

class CartHeaderViewSpec: QuickSpec {
    override func spec() {
        var view: CartHeaderView!
        var totalItemsCountLabel: UILabel!
        var totalPriceLabel: UILabel!
        
        beforeEach {
            view = CartHeaderView(productsCounts: 5, totalPrice: 100, currency: "USD")
            totalItemsCountLabel = self.findView(withAccessibilityLabel: "totalItemsCountLabel", in: view) as? UILabel
            totalPriceLabel = self.findView(withAccessibilityLabel: "totalPriceLabel", in: view) as? UILabel
        }
        
        describe("when view initialized") {
            it("should have correct labels texts") {
                let format = "OrdersCount".localizable
                let formatter = NumberFormatter.formatter(with: "USD")
                
                expect(totalItemsCountLabel.text) == String.localizedStringWithFormat(format, 5)
                expect(totalPriceLabel.text) == formatter.string(from: 100)
            }
        }
    }
}
