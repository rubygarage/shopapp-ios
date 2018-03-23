//
//  String+LocalizationSpec.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 3/22/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick

@testable import ShopApp

class String_LocalizationSpec: QuickSpec {
    override func spec() {
        describe("when localizable string created") {
            context("if localizable identifier found") {
                it("should return localizable string") {
                    let key = "Alert.Error"
                    
                    expect(key.localizable) == NSLocalizedString(key, comment: "")
                }
            }
            
            context("and if not found") {
                it("shouldn't return localizable string") {
                    let key = "Test.Alert.Error"
                    
                    expect(key.localizable) == key
                }
            }
        }
    }
}
