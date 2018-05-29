//
//  UpdateCustomerRequestBodySpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 5/14/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick

@testable import ShopApp

class UpdateCustomerRequestBodySpec: QuickSpec {
    override func spec() {
        describe("when initializer called") {
            it("should have all properties") {
                let object = RequestBodiesTestHelper.updateCustomerRequestBody
                
                expect(object.customer.email) == "user@mail.com"
                expect(object.customer.websiteId) == 1
            }
        }
    }
}
