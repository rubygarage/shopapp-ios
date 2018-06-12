//
//  SortType+DetailsSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/23/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class SortType_DetailsSpec: QuickSpec {
    override func spec() {
        describe("when all values used") {
            it("needs to return localizable strings in correct order") {
                expect(SortType.allValues) == ["SortType.CreatedAt".localizable,
                                               "SortType.Name".localizable,
                                               "SortType.Popular".localizable,
                                               "SortType.Type".localizable,
                                               "SortType.PriceHighToLow".localizable,
                                               "SortType.PriceLowToHigh".localizable]
            }
        }
    }
}
