//
//  ShopAppCustomerRepositorySpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/28/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick

import ShopApp_Gateway

@testable import ShopApp

class ShopAppCustomerRepositorySpec: QuickSpec {
    override func spec() {
        var repository: ShopAppCustomerRepository!
        var apiMock: APIMock!
        
        beforeEach {
            apiMock = APIMock()
            repository = ShopAppCustomerRepository(api: apiMock)
        }
        
        describe("when customer should be get") {
            context("if callback has result") {
                it("needs to handle result") {
                    apiMock.isNeedToReturnError = false
                    
                    repository.getCustomer() { (result, error) in
                        expect(apiMock.isGetCustomerStarted) == true
                        
                        expect(result).toNot(beNil())
                        expect(error).to(beNil())
                    }
                }
            }
            
            context("if callback has error") {
                it("needs to handle error") {
                    apiMock.isNeedToReturnError = true
                    
                    repository.getCustomer() { (result, error) in
                        expect(apiMock.isGetCustomerStarted) == true
                        
                        expect(result).to(beNil())
                        expect(error).toNot(beNil())
                    }
                }
            }
        }
        
        describe("when customer's info should be update") {
            var email: String!
            var firstName: String!
            var lastName: String!
            var phone: String!
            
            beforeEach {
                email = "user@mail.com"
                firstName = "First"
                lastName = "Last"
                phone = "phone"
            }
            
            context("if callback has result") {
                it("needs to handle result") {
                    apiMock.isNeedToReturnError = false
                    
                    repository.updateCustomer(with: email, firstName: firstName, lastName: lastName, phone: phone) { (result, error) in
                        expect(apiMock.isUpdateCustomerInfoStarted) == true
                        
                        expect(apiMock.email) == email
                        expect(apiMock.firstName) == firstName
                        expect(apiMock.lastName) == lastName
                        expect(apiMock.phone) == phone
                        
                        expect(result).toNot(beNil())
                        expect(error).to(beNil())
                    }
                }
            }
            
            context("if callback has error") {
                it("needs to handle error") {
                    apiMock.isNeedToReturnError = true
                    
                    repository.updateCustomer(with: email, firstName: firstName, lastName: lastName, phone: phone) { (result, error) in
                        expect(apiMock.isUpdateCustomerInfoStarted) == true
                        
                        expect(apiMock.email) == email
                        expect(apiMock.firstName) == firstName
                        expect(apiMock.lastName) == lastName
                        expect(apiMock.phone) == phone
                        
                        expect(result).to(beNil())
                        expect(error).toNot(beNil())
                    }
                }
            }
        }
        
        describe("when customer's promo should be update") {
            var promo: Bool!
            
            beforeEach {
                promo = true
            }
            
            context("if callback has result") {
                it("needs to handle result") {
                    apiMock.isNeedToReturnError = false
                    
                    repository.updateCustomer(with: promo) { (result, error) in
                        expect(apiMock.isUpdateCustomerPromoStarted) == true
                        
                        expect(apiMock.promo) == promo
                        
                        expect(result).toNot(beNil())
                        expect(error).to(beNil())
                    }
                }
            }
            
            context("if callback has error") {
                it("needs to handle error") {
                    apiMock.isNeedToReturnError = true
                    
                    repository.updateCustomer(with: promo) { (result, error) in
                        expect(apiMock.isUpdateCustomerPromoStarted) == true
                        
                        expect(apiMock.promo) == promo
                        
                        expect(result).to(beNil())
                        expect(error).toNot(beNil())
                    }
                }
            }
        }
        
        describe("when customer's password should be update") {
            var password: String!
            
            beforeEach {
                password = "password"
            }
            
            context("if callback has result") {
                it("needs to handle result") {
                    apiMock.isNeedToReturnError = false
                    
                    repository.updateCustomer(with: password) { (result, error) in
                        expect(apiMock.isUpdateCustomerPasswordStarted) == true
                        
                        expect(apiMock.password) == password
                        
                        expect(result).toNot(beNil())
                        expect(error).to(beNil())
                    }
                }
            }
            
            context("if callback has error") {
                it("needs to handle error") {
                    apiMock.isNeedToReturnError = true
                    
                    repository.updateCustomer(with: password) { (result, error) in
                        expect(apiMock.isUpdateCustomerPasswordStarted) == true
                        
                        expect(apiMock.password) == password
                        
                        expect(result).to(beNil())
                        expect(error).toNot(beNil())
                    }
                }
            }
        }
        
        describe("when customer's address should be add") {
            var address: Address!
            
            beforeEach {
                address = Address()
            }
            
            context("if callback has result") {
                it("needs to handle result") {
                    apiMock.isNeedToReturnError = false
                    
                    repository.addCustomerAddress(with: address) { (result, error) in
                        expect(apiMock.isAddCustomerAddressStarted) == true
                        
                        expect(apiMock.address) === address
                        
                        expect(result).toNot(beNil())
                        expect(error).to(beNil())
                    }
                }
            }
            
            context("if callback has error") {
                it("needs to handle error") {
                    apiMock.isNeedToReturnError = true
                    
                    repository.addCustomerAddress(with: address) { (result, error) in
                        expect(apiMock.isAddCustomerAddressStarted) == true
                        
                        expect(apiMock.address) === address
                        
                        expect(result).to(beNil())
                        expect(error).toNot(beNil())
                    }
                }
            }
        }
        
        describe("when customer's address should be update") {
            var address: Address!
            
            beforeEach {
                address = Address()
            }
            
            context("if callback has result") {
                it("needs to handle result") {
                    apiMock.isNeedToReturnError = false
                    
                    repository.updateCustomerAddress(with: address) { (result, error) in
                        expect(apiMock.isUpdateCustomerAddressStarted) == true
                        
                        expect(apiMock.address) === address
                        
                        expect(result).toNot(beNil())
                        expect(error).to(beNil())
                    }
                }
            }
            
            context("if callback has error") {
                it("needs to handle error") {
                    apiMock.isNeedToReturnError = true
                    
                    repository.updateCustomerAddress(with: address) { (result, error) in
                        expect(apiMock.isUpdateCustomerAddressStarted) == true
                        
                        expect(apiMock.address) === address
                        
                        expect(result).to(beNil())
                        expect(error).toNot(beNil())
                    }
                }
            }
        }
        
        describe("when customer's default address should be update") {
            var addressId: String!
            
            beforeEach {
                addressId = "id"
            }
            
            context("if callback has result") {
                it("needs to handle result") {
                    apiMock.isNeedToReturnError = false
                    
                    repository.updateCustomerDefaultAddress(with: addressId) { (result, error) in
                        expect(apiMock.isUpdateCustomerDefaultAddressStarted) == true
                        
                        expect(apiMock.addressId) == addressId
                        
                        expect(result).toNot(beNil())
                        expect(error).to(beNil())
                    }
                }
            }
            
            context("if callback has error") {
                it("needs to handle error") {
                    apiMock.isNeedToReturnError = true
                    
                    repository.updateCustomerDefaultAddress(with: addressId) { (result, error) in
                        expect(apiMock.isUpdateCustomerDefaultAddressStarted) == true
                        
                        expect(apiMock.addressId) == addressId
                        
                        expect(result).to(beNil())
                        expect(error).toNot(beNil())
                    }
                }
            }
        }
        
        describe("when customer's address should be delete") {
            var addressId: String!
            
            beforeEach {
                addressId = "id"
            }
            
            context("if callback has result") {
                it("needs to handle result") {
                    apiMock.isNeedToReturnError = false
                    
                    repository.deleteCustomerAddress(with: addressId) { (result, error) in
                        expect(apiMock.isDeleteCustomerAddressStarted) == true
                        
                        expect(apiMock.addressId) == addressId
                        
                        expect(result).toNot(beNil())
                        expect(error).to(beNil())
                    }
                }
            }
            
            context("if callback has error") {
                it("needs to handle error") {
                    apiMock.isNeedToReturnError = true
                    
                    repository.deleteCustomerAddress(with: addressId) { (result, error) in
                        expect(apiMock.isDeleteCustomerAddressStarted) == true
                        
                        expect(apiMock.addressId) == addressId
                        
                        expect(result).to(beNil())
                        expect(error).toNot(beNil())
                    }
                }
            }
        }
    }
}
