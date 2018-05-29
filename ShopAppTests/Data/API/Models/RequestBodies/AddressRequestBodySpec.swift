//
//  AddressRequestBodySpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 5/14/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick

@testable import ShopApp

class AddressRequestBodySpec: QuickSpec {
    override func spec() {
        describe("when initializer called") {
            it("should have all properties") {
                let object = RequestBodiesTestHelper.addressRequestBody
                
                expect(object.id) == 0
                expect(object.countryId) == "id"
                expect(object.firstName) == "first"
                expect(object.lastName) == "last"
                expect(object.streets.first) == "street"
                expect(object.city) == "city"
                expect(object.regionId) == 1
                expect(object.postcode) == "postcode"
                expect(object.telephone) == "telephone"
                expect(object.isDefaultAddress) == true
            }
        }
    }
}
