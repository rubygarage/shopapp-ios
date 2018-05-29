//
//  MagentoAddressAdapterSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 5/16/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class MagentoAddressAdapterSpec: QuickSpec {
    override func spec() {
        describe("when adapter used") {
            it("needs to adapt magento response to shopapp model") {
                let response = MagentoAdaptersTestHepler.addressResponse
                let object = MagentoAddressAdapter.adapt(response)
                
                expect(object.id) == String(response.id)
                expect(object.firstName) == response.firstName
                expect(object.lastName) == response.lastName
                expect(object.address) == response.streets.first
                expect(object.city) == response.city
                expect(object.zip) == response.postcode
                expect(object.phone) == response.telephone
                expect(object.country?.id) == response.countryId
                expect(object.secondAddress) == response.streets.last
                expect(object.state?.id) == String(response.regionId!)
            }
            
            it("needs to adapt shopapp model to magento request body") {
                let country = Country()
                country.id = "country id"
                
                let state = State()
                state.id = "1"
                
                let address = Address()
                address.id = "0"
                address.country = country
                address.firstName = "first"
                address.lastName = "last"
                address.address = "main street"
                address.secondAddress = "additional street"
                address.city = "city"
                address.zip = "zip"
                address.phone = "phone"
                address.state = state
                
                let defaultAddress = Address()
                defaultAddress.id = address.id
                
                let requestBody = MagentoAddressAdapter.adapt(address, defaultAddress: defaultAddress)
                
                expect(requestBody?.id) == Int(address.id)
                expect(requestBody?.countryId) == address.country?.id
                expect(requestBody?.firstName) == address.firstName
                expect(requestBody?.lastName) == address.lastName
                expect(requestBody?.streets.contains(address.address!)) == true
                expect(requestBody?.streets.contains(address.secondAddress!)) == true
                expect(requestBody?.city) == address.city
                expect(requestBody?.regionId) == Int(address.state!.id)
                expect(requestBody?.postcode) == address.zip
                expect(requestBody?.telephone) == address.phone
                expect(requestBody?.isDefaultAddress) == (address.id == defaultAddress.id)
            }
        }
        
        describe("when update method used") {
            it("needs to update address with countries") {
                let zaporozhye = MagentoAdaptersTestHepler.zaporozhye
                let ukraine = MagentoAdaptersTestHepler.ukraine
                
                let state = State()
                state.name = zaporozhye.name
                
                let country = Country()
                country.name = ukraine.name
                
                let address = Address()
                address.country = country
                address.state = state
                
                MagentoAddressAdapter.update(address, with: [ukraine])
                
                expect(address.country?.id) == ukraine.id
                expect(address.state?.id) == zaporozhye.id
            }
        }
        
        describe("when additional method used") {
            var oldResponse: AddressResponse!
            var newResponse: AddressResponse!
            var address: Address!
            
            beforeEach {
                oldResponse = MagentoAdaptersTestHepler.addressResponse
                
                newResponse = MagentoAdaptersTestHepler.addressResponse
                newResponse.id = 1
                
                address = Address()
                address.id = "0"
            }
            
            context("if there is no one customer addresses") {
                it("needs to return id of new address") {
                    let id = MagentoAddressAdapter.idOfAddedAddress(customerAddresses: nil, responseAddresses: [newResponse])
                    
                    expect(id) == String(newResponse.id)
                }
            }
            
            context("if if there is at least one customer addresses") {
                it("needs to return id of new address") {
                    let id = MagentoAddressAdapter.idOfAddedAddress(customerAddresses: [address], responseAddresses: [oldResponse, newResponse])
                    
                    expect(id) == String(newResponse.id)
                }
            }
        }
    }
}
