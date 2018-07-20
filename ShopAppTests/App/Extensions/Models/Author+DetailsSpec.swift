//
//  Author+DetailsSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 6/25/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class Author_DetailsSpec: QuickSpec {
    override func spec() {
        describe("when full name used") {
            var author: Author!
            var authorNameLocalized: String!
            
            beforeEach {
                author = TestHelper.author
                authorNameLocalized = "Label.FullName".localizable
            }
            
            it("needs to return correct formatted string") {
                expect(author.fullName) == String.localizedStringWithFormat(authorNameLocalized, author.firstName, author.lastName)
            }
        }
    }
}
