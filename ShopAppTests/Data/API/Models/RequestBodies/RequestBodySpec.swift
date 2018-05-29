//
//  RequestBodySpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 5/14/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick

@testable import ShopApp

class RequestBodySpec: QuickSpec {
    override func spec() {
        describe("when parameters of request body used") {
            it("should encode model to dictionary") {
                let simpleObject = ModelTestHelper.SimpleModelTest(date: ModelTestHelper.date)
                let complexObject = ModelTestHelper.ComplexModelTest(string: "string", array: ["array"], simpleRequestBody: simpleObject)
                let parameters = complexObject.parameters!
                
                expect(NSDictionary(dictionary: parameters).isEqual(to: ModelTestHelper.complexParameters)) == true
            }
        }
    }
}
