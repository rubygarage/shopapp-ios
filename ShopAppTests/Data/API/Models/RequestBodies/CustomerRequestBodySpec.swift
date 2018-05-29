//
//  CustomerRequestBodySpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 5/14/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick

@testable import ShopApp

class CustomerRequestBodySpec: QuickSpec {
    override func spec() {
        describe("when initializer called") {
            it("should have all properties") {
                let object = RequestBodiesTestHelper.customerRequestBody
                
                expect(object.email) == "user@mail.com"
                expect(object.firstName) == "first"
                expect(object.lastName) == "last"
                expect(object.addresses.first?.id) == 0
            }
        }
    }
}
