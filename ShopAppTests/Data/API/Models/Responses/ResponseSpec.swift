//
//  ResponseSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 5/14/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick

@testable import ShopApp

class ResponseSpec: QuickSpec {
    override func spec() {
        describe("when object method of response used") {
            it("should dencode dictionary to model") {
                let object = ModelTestHelper.ComplexModelTest.object(from: ModelTestHelper.complexParameters)
                
                expect(object?.string) == "string"
                expect(object?.array.first) == "array"
                expect(object?.simpleRequestBody.date) == ModelTestHelper.date
            }
        }
        
        describe("when objects method of response used") {
            it("should dencode array of dictionaries to array of models") {
                let objects = ModelTestHelper.ComplexModelTest.objects(from: [ModelTestHelper.complexParameters])
                
                expect(objects?.first?.string) == "string"
                expect(objects?.first?.array.first) == "array"
                expect(objects?.first?.simpleRequestBody.date) == ModelTestHelper.date
            }
        }
    }
}
