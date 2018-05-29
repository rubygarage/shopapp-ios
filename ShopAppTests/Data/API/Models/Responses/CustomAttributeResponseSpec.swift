//
//  CustomAttributeResponseSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 5/14/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick

@testable import ShopApp

class CustomAttributeResponseSpec: QuickSpec {
    override func spec() {
        describe("when object method of customer attribute response used") {
            context("if dictionary has value as string") {
                it("should dencode dictionary to model with data") {
                    let parameters: [String : Any] = ["attribute_code": "code", "value": "string"]
                    let object = CustomAttributeResponse.object(from: parameters)
                    
                    expect(object?.attributeCode) == "code"
                    expect(object?.value.data) == "string"
                    expect(object?.value.dataList).to(beNil())
                }
            }
            
            context("if dictionary has value as array of strings") {
                it("should dencode dictionary to model with data list") {
                    let parameters: [String : Any] = ["attribute_code": "code", "value": ["string"]]
                    let object = CustomAttributeResponse.object(from: parameters)
                    
                    expect(object?.attributeCode) == "code"
                    expect(object?.value.data).to(beNil())
                    expect(object?.value.dataList?.first) == "string"
                }
            }
        }
    }
}
