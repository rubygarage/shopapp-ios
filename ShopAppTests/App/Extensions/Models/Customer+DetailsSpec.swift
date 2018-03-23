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
            var customer: Customer!
            var customerNameLocalized: String!
            
            beforeEach {
                customer = Customer()
                customerNameLocalized = "Label.FullName".localizable
            }
            
            context("if address has first and last names") {
                it("needs to return correct formatted string") {
                    customer.firstName = "First"
                    customer.lastName = "Last"
                    
                    expect(customer.fullName) == String.localizedStringWithFormat(customerNameLocalized, customer.firstName!, customer.lastName!)
                }
            }
            
            context("if address hasn't first and last names") {
                it("needs to return correct formatted string") {
                    customer.email = "Email"
                    
                    expect(customer.fullName) == customer.email
                }
            }
        }
    }
}
