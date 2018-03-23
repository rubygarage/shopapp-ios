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
                address = Address()
                addressNameLocalized = "Label.FullName".localizable
            }
            
            context("if address has first and last names") {
                it("needs to return correct formatted string") {
                    address.firstName = "First"
                    address.lastName = "Last"
                    
                    expect(address.fullName) == String.localizedStringWithFormat(addressNameLocalized, address.firstName!, address.lastName!)
                }
            }
            
            context("if address has first name only") {
                it("needs to return correct formatted string") {
                    address.firstName = "First"
                    
                    expect(address.fullName) == String.localizedStringWithFormat(addressNameLocalized, address.firstName!, "")
                }
            }
            
            context("if address has last name only") {
                it("needs to return correct formatted string") {
                    address.lastName = "Last"
                    
                    expect(address.fullName) == String.localizedStringWithFormat(addressNameLocalized, "", address.lastName!)
                }
            }
        }
        
        describe("when full address used") {
            var address: Address!
            
            beforeEach {
                address = Address()
            }
            
            context("if address has first address only") {
                it("needs to return correct formatted string") {
                    address.address = "Address"
                    
                    expect(address.fullAddress) == address.address
                }
            }
            
            context("if address has first and second addresses") {
                it("needs to return correct formatted string") {
                    address.address = "Address"
                    address.secondAddress = "Second address"
                    
                    expect(address.fullAddress) == [address.address!, address.secondAddress!].joined(separator: ", ")
                }
            }
            
            context("if address has first, second addresses, city, zip and country") {
                it("needs to return correct formatted string") {
                    address.address = "Address"
                    address.secondAddress = "Second address"
                    address.city = "City"
                    address.zip = "Zip"
                    address.country = "Country"
                    
                    expect(address.fullAddress) == [address.address!, address.secondAddress!, address.city!, address.zip!, address.country!].joined(separator: ", ")
                }
            }
        }
    }
}
