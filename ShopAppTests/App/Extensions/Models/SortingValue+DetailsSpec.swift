//
//  SortingValue+DetailsSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/23/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class SortingValue_DetailsSpec: QuickSpec {
    override func spec() {
        describe("when all values used") {
            it("needs to return localizable strings in correct order") {
                expect(SortingValue.allValues) == ["SortingValue.CreatedAt".localizable,
                                                   "SortingValue.Name".localizable,
                                                   "SortingValue.Popular".localizable,
                                                   "SortingValue.Type".localizable,
                                                   "SortingValue.PriceHighToLow".localizable,
                                                   "SortingValue.PriceLowToHigh".localizable]
            }
        }
    }
}
