//
//  MagentoStateAdapterSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 5/16/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class MagentoStateAdapterSpec: QuickSpec {
    override func spec() {
        describe("when adapter used") {
            it("needs to adapt magento response to shopapp model") {
                let response = MagentoAdaptersTestHepler.regionResponse
                let object = MagentoStateAdapter.adapt(response)
                
                expect(object.id) == response.id
                expect(object.name) == response.name
            }
        }
    }
}
