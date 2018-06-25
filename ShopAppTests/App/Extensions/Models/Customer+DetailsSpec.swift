//
//  Customer+DetailsSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/23/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class Customer_DetailsSpec: QuickSpec {
    override func spec() {
        describe("when full name used") {
            let customer = TestHelper.customerWithoutAcceptsMarketing
            let customerNameLocalized = "Label.FullName".localizable
            
            it("needs to return correct formatted string") {
                expect(customer.fullName) == String.localizedStringWithFormat(customerNameLocalized, customer.firstName, customer.lastName)
            }
        }
    }
}
