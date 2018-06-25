//
//  Address+DetailsSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/23/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class Address_DetailsSpec: QuickSpec {
    override func spec() {
        describe("when full name used") {
            var address: Address!
            var addressNameLocalized: String!
            
            beforeEach {
                address = TestHelper.fullAddress
                addressNameLocalized = "Label.FullName".localizable
            }
            
            it("needs to return correct formatted string") {
                expect(address.fullName) == String.localizedStringWithFormat(addressNameLocalized, address.firstName, address.lastName)
            }
        }
        
        describe("when full address used") {
            var address: Address!
            
            beforeEach {
                address = TestHelper.fullAddress
            }
            
            it("needs to return correct formatted string") {
                expect(address.fullAddress) == [address.street, address.secondStreet!, address.city, address.zip, address.country].joined(separator: ", ")
            }
        }
    }
}
