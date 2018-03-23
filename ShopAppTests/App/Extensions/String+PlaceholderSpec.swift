//
//  String+PlaceholderSpec.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 3/22/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick

@testable import ShopApp

class String_PlaceholderSpec: QuickSpec {
    override func spec() {
        describe("when string created") {
            it("should add '*' symbol to end of text") {
                let text = "Text"
                let expectedText = "Text*"
                
                expect(text.required) == expectedText
            }
        }
    }
}
