//
//  ResetPasswordRequestBodySpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 5/14/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick

@testable import ShopApp

class ResetPasswordRequestBodySpec: QuickSpec {
    override func spec() {
        describe("when initializer called") {
            it("should have all properties") {
                let object = RequestBodiesTestHelper.resetPasswordRequestBody
                
                expect(object.email) == "user@mail.com"
            }
        }
    }
}
