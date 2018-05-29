//
//  MagentoCustomerAdapterSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 5/16/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class MagentoCustomerAdapterSpec: QuickSpec {
    override func spec() {
        describe("when adapter used") {
            it("needs to adapt magento response to shopapp model") {
                let response = GetCustomerResponse.init(email: "user@mail.com", firstName: "first", lastName: "last", addresses: [MagentoAdaptersTestHepler.addressResponse])
                let object = MagentoCustomerAdapter.adapt(response)
                
                expect(object.email) == response.email
                expect(object.firstName) == response.firstName
                expect(object.lastName) == response.lastName
                expect(object.addresses?.first?.id) == String(response.addresses.first!.id)
                expect(object.defaultAddress?.id) == String(response.addresses.first!.id)
            }
        }
        
        describe("when update method used") {
            it("needs to update customer with countries") {
                let zaporozhye = MagentoAdaptersTestHepler.zaporozhye
                let ukraine = MagentoAdaptersTestHepler.ukraine
                
                let state = State()
                state.id = zaporozhye.id
                
                let country = Country()
                country.id = ukraine.id
                
                let address = Address()
                address.country = country
                address.state = state
                
                let customer = Customer()
                customer.addresses = [address]
                
                MagentoCustomerAdapter.update(customer, with: [ukraine])
                
                expect(customer.addresses?.first?.country?.id) == ukraine.id
                expect(customer.addresses?.first?.state?.id) == zaporozhye.id
            }
        }
    }
}
