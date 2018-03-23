//
//  NumberFormatter+CurrencySpec.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 3/22/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick

@testable import ShopApp

class NumberFormatter_CurrencySpec: QuickSpec {
    override func spec() {
        describe("when formatter created") {
            it("shoud return number formatter with correct properties") {
                let currencyCode = "USD"
                let formatter = NumberFormatter.formatter(with: currencyCode)
                
                expect(formatter.numberStyle.rawValue) == NumberFormatter.Style.currency.rawValue
                expect(formatter.currencyCode) == currencyCode
            }
        }
    }
}
