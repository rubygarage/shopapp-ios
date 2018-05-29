//
//  MagentoCountryAdapterSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 5/16/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class MagentoCountryAdapterSpec: QuickSpec {
    override func spec() {
        describe("when adapter used") {
            it("needs to adapt magento response to shopapp model") {
                let response = MagentoAdaptersTestHepler.countryResponse
                let object = MagentoCountryAdapter.adapt(response)
                
                expect(object.id) == response.id
                expect(object.name) == response.name
                expect(object.states.first?.id) == response.regions?.first?.id
            }
        }
    }
}
