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
            context("and customer has first and last name") {
                let customer = TestHelper.customerWithoutAcceptsMarketing
                let customerNameLocalized = "Label.FullName".localizable
                
                it("needs to return correct formatted string") {
                    expect(customer.fullName) == String.localizedStringWithFormat(customerNameLocalized, customer.firstName, customer.lastName)
                }
            }
            
            context("but customer's first and last names are empty") {
                let customer = Customer(id: "id", email: "email", firstName: "", lastName: "", phone: "phone", isAcceptsMarketing: false, defaultAddress: TestHelper.fullAddress, addresses: [TestHelper.fullAddress])
                
                expect(customer.fullName) == customer.email
            }
        }
    }
}
