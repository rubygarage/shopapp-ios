//
//  MagentoAPICustomerSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 5/21/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Alamofire
import Nimble
import OHHTTPStubs
import Quick
import ShopApp_Gateway

@testable import ShopApp

class MagentoAPICustomerSpec: MagentoAPIBaseSpec {
    override func spec() {
        super.spec()
        
        let errorMessage = "error"
        let token = "\"token\""
        
        let customerJson = self.jsonObject(fromFileWithName: "Customer") as! [String: Any]
        let customerWithAddressJson = self.jsonObject(fromFileWithName: "CustomerWithAddress") as! [String: Any]
        let customerWithAddressesJson = self.jsonObject(fromFileWithName: "CustomerWithAddresses") as! [String: Any]
        let countriesJson = self.jsonObject(fromFileWithName: "Countries") as! [Any]
        
        let customerAddresses = customerWithAddressesJson["addresses"] as! [Any]
        let customerFirstAddress = customerAddresses.first! as! [String: Any]
        let customerLastAddress = customerAddresses.last! as! [String: Any]
        let customerFirstAddressId = String(customerFirstAddress["id"] as! Int)
        let customerLastAddressId = String(customerLastAddress["id"] as! Int)
        
        let signUpResponseObjects: [Any] = [customerJson, token]
        let getCustomerResponseObjects: [Any] = [customerJson, countriesJson]
        let updatePasswordResponseObjects: [Any] = ["true", customerJson, countriesJson]
        let addAddressDataErrorResponseObjects: [Any] = [customerJson, countriesJson, countriesJson]
        let addAddressApiErrorResponseObjects: [Any] = [customerJson, countriesJson, countriesJson, customerWithAddressJson]
        let addAddressResponseObjects: [Any] = [customerWithAddressJson, countriesJson, countriesJson, customerWithAddressesJson]
        let updateAddressDataErrorResponseObjects: [Any] = [customerWithAddressJson, countriesJson, countriesJson]
        let updateAddressResponseObjects: [Any] = [customerWithAddressJson, countriesJson, countriesJson, customerWithAddressJson]
        let deleteAddressApiErrorResponseObjects: [Any] = [customerWithAddressesJson, countriesJson, customerWithAddressJson]
        let addressDataErrorResponseObjects: [Any] = [customerWithAddressesJson, countriesJson]
        let addressResponseObjects: [Any] = [customerWithAddressesJson, countriesJson, customerWithAddressesJson]

        describe("when user signs up") {
            context("if response has error") {
                context("because of request data") {
                    it("needs to return error") {
                        self.stubResponse(withErrorMessage: "")
                        
                        waitUntil { done in
                            self.api.signUp(with: "user@mail.com", firstName: nil, lastName: nil, password: "password", phone: nil) { (response, error) in
                                self.checkUnsuccessResponse(response, error: error)
                                
                                done()
                            }
                        }
                    }
                }
                
                context("because of api") {
                    it("needs to return error") {
                        for index in 0..<signUpResponseObjects.count {
                            self.stubResponse(withObjects: signUpResponseObjects, indexOfError: index)
                            
                            waitUntil { done in
                                self.api.signUp(with: "user@mail.com", firstName: "First", lastName: "Last", password: "password", phone: nil) { (response, error) in
                                    self.checkUnsuccessResponse(response, error: error)
                                    
                                    done()
                                }
                            }
                        }
                    }
                }
            }
            
            context("if response has objects") {
                it("needs to return success") {
                    self.stubResponse(withObjects: signUpResponseObjects)
                    
                    waitUntil { done in
                        self.api.signUp(with: "user@mail.com", firstName: "First", lastName: "Last", password: "password", phone: nil) { (response, error) in
                            self.checkSuccessResponse(response, error: error)
                            
                            done()
                        }
                    }
                }
            }
        }
        
        describe("when user logs in") {
            context("if response has error") {
                it("needs to return error") {
                    self.stubResponse(withErrorMessage: errorMessage)
                    
                    waitUntil { done in
                        self.api.login(with: "user@mail.com", password: "password") { (response, error) in
                            self.checkUnsuccessResponse(response, error: error, errorMessage: errorMessage)
                            
                            done()
                        }
                    }
                }
            }
            
            context("if response has objects") {
                it("needs to return success") {
                    self.stubResponse(withObject: token)
                    
                    waitUntil { done in
                        self.api.login(with: "user@mail.com", password: "password") { (response, error) in
                            self.checkSuccessResponse(response, error: error)
                            
                            done()
                        }
                    }
                }
            }
        }
        
        describe("when user logs out") {
            it("needs to return success") {
                waitUntil { done in
                    self.api.logout { (response, error) in
                        self.checkSuccessResponse(response, error: error)
                        
                        done()
                    }
                }
            }
        }
        
        describe("when user checks logged in status") {
            context("and it's false") {
                it("needs to return fail") {
                    self.logout()
                    
                    expect(self.api.isLoggedIn()) == false
                }
            }
            
            context("and it's true") {
                it("needs to return success") {
                    self.login()
                    
                    expect(self.api.isLoggedIn()) == true
                }
            }
        }
        
        describe("when user resets password") {
            context("if response has error") {
                it("needs to return error") {
                    self.stubResponse(withErrorMessage: errorMessage)
                    
                    waitUntil { done in
                        self.api.resetPassword(with: "user@mail.com") { (response, error) in
                            self.checkUnsuccessResponse(response, error: error, errorMessage: errorMessage)
                            
                            done()
                        }
                    }
                }
            }
            
            context("if response has objects") {
                it("needs to return success") {
                    self.stubResponse(withObject: "false")
                    
                    waitUntil { done in
                        self.api.resetPassword(with: "user@mail.com") { (response, error) in
                            self.checkSuccessResponse(response, error: error)
                            
                            done()
                        }
                    }
                }
            }
        }
        
        describe("when user gets info") {
            beforeEach {
                self.login()
            }
            
            context("if response has error") {
                context("because of session data") {
                    it("needs to return error") {
                        self.logout()
                        self.stubResponse(withErrorMessage: "")
                        
                        waitUntil { done in
                            self.api.getCustomer { (response, error) in
                                self.checkUnsuccessResponse(response, error: error)
                                
                                done()
                            }
                        }
                    }
                }

                context("because of api") {
                    it("needs to return error") {
                        for index in 0..<getCustomerResponseObjects.count {
                            self.stubResponse(withObjects: getCustomerResponseObjects, indexOfError: index)
                            
                            waitUntil { done in
                                self.api.getCustomer { (response, error) in
                                    self.checkUnsuccessResponse(response, error: error)
                                    
                                    done()
                                }
                            }
                        }
                    }
                }
            }

            context("if response has objects") {
                it("needs to return customer") {
                    self.stubResponse(withObjects: getCustomerResponseObjects)
                    
                    waitUntil { done in
                        self.api.getCustomer { (response, error) in
                            self.checkCustomerResponse(response, error: error, customer: customerJson)
                            
                            done()
                        }
                    }
                }
            }
        }
        
        describe("when user updates info") {
            beforeEach {
                self.login()
            }
            
            context("if response has error") {
                context("because of session or request data") {
                    it("needs to return error") {
                        self.logout()
                        self.stubResponse(withErrorMessage: "")
                        
                        waitUntil { done in
                            self.api.updateCustomer(with: "user@mail.com", firstName: nil, lastName: nil, phone: nil) { (response, error) in
                                self.checkUnsuccessResponse(response, error: error)
                                
                                done()
                            }
                        }
                    }
                }
                
                context("because of api") {
                    it("needs to return error") {
                        self.stubResponse(withErrorMessage: errorMessage)
                        
                        waitUntil { done in
                            self.api.updateCustomer(with: "user@mail.com", firstName: "First", lastName: "Last", phone: nil) { (response, error) in
                                self.checkUnsuccessResponse(response, error: error, errorMessage: errorMessage)
                                
                                done()
                            }
                        }
                    }
                }
            }
            
            context("if response has objects") {
                it("needs to return customer") {
                    self.stubResponse(withObject: customerJson)
                    
                    waitUntil { done in
                        self.api.updateCustomer(with: "user@mail.com", firstName: "First", lastName: "Last", phone: nil) { (response, error) in
                            self.checkCustomerResponse(response, error: error, customer: customerJson)
                            
                            done()
                        }
                    }
                }
            }
        }
        
        describe("when user updates password") {
            beforeEach {
                self.login()
            }
            
            context("if response has error") {
                context("because of session data") {
                    it("needs to return error") {
                        self.logout()
                        self.stubResponse(withErrorMessage: "")
                        
                        waitUntil { done in
                            self.api.updateCustomer(with: "password") { (response, error) in
                                self.checkUnsuccessResponse(response, error: error)
                                
                                done()
                            }
                        }
                    }
                }
                
                context("because of api") {
                    it("needs to return error") {
                        for index in 0..<updatePasswordResponseObjects.count {
                            self.stubResponse(withObjects: updatePasswordResponseObjects, indexOfError: index)
                            
                            waitUntil { done in
                                self.api.updateCustomer(with: "password") { (response, error) in
                                    self.checkUnsuccessResponse(response, error: error)
                                    
                                    done()
                                }
                            }
                        }
                    }
                }
            }
            
            context("if response has objects") {
                it("needs to return customer") {
                    self.stubResponse(withObjects: updatePasswordResponseObjects)
                    
                    waitUntil { done in
                        self.api.updateCustomer(with: "password") { (response, error) in
                            self.checkCustomerResponse(response, error: error, customer: customerJson)
                            
                            done()
                        }
                    }
                }
            }
        }
        
        describe("when user adds address") {
            beforeEach {
                self.login()
            }
            
            context("if response has error") {
                context("because of request data") {
                    it("needs to return error") {
                        let address = self.buildAddress(isShouldBeEmpty: true)

                        self.stubResponse(withObjects: addAddressDataErrorResponseObjects)

                        waitUntil { done in
                            self.api.addCustomerAddress(with: address) { (response, error) in
                                self.checkUnsuccessResponse(response, error: error)

                                done()
                            }
                        }
                    }
                }
                
                context("because of api") {
                    it("needs to return error") {
                        let address = self.buildAddress()
                        for index in 0..<addAddressApiErrorResponseObjects.count {
                            self.stubResponse(withObjects: addAddressApiErrorResponseObjects, indexOfError: index)

                            waitUntil { done in
                                self.api.addCustomerAddress(with: address) { (response, error) in
                                    self.checkUnsuccessResponse(response, error: error)

                                    done()
                                }
                            }
                        }
                    }
                }
            }
            
            context("if response has objects") {
                it("needs to return id") {
                    let address = self.buildAddress()

                    self.stubResponse(withObjects: addAddressResponseObjects)

                    waitUntil { done in
                        self.api.addCustomerAddress(with: address) { (response, error) in
                            expect(response) == customerLastAddressId
                            expect(error).to(beNil())

                            done()
                        }
                    }
                }
            }
        }
        
        describe("when user updates address") {
            beforeEach {
                self.login()
            }
            
            context("if response has error") {
                context("because of request data") {
                    it("needs to return error") {
                        let address = self.buildAddress(isShouldBeEmpty: true)

                        self.stubResponse(withObjects: updateAddressDataErrorResponseObjects)

                        waitUntil { done in
                            self.api.updateCustomerAddress(with: address) { (response, error) in
                                self.checkUnsuccessResponse(response, error: error)

                                done()
                            }
                        }
                    }
                }
                
                context("because of api") {
                    it("needs to return error") {
                        let address = self.buildAddress(id: customerFirstAddressId)

                        for index in 0..<updateAddressResponseObjects.count {
                            self.stubResponse(withObjects: updateAddressResponseObjects, indexOfError: index)

                            waitUntil { done in
                                self.api.updateCustomerAddress(with: address) { (response, error) in
                                    self.checkUnsuccessResponse(response, error: error)

                                    done()
                                }
                            }
                        }
                    }
                }
            }
            
            context("if response has objects") {
                it("needs to return success") {
                    let address = self.buildAddress(id: customerFirstAddressId)
                    
                    self.stubResponse(withObjects: updateAddressResponseObjects)

                    waitUntil { done in
                        self.api.updateCustomerAddress(with: address) { (response, error) in
                            expect(response) == true
                            expect(error).to(beNil())

                            done()
                        }
                    }
                }
            }
        }
 
        describe("when user updates default address") {
            beforeEach {
                self.login()
            }
            
            context("if response has error") {
                context("because of request data") {
                    it("needs to return error") {
                        self.stubResponse(withObjects: addressDataErrorResponseObjects)
                        
                        waitUntil { done in
                            self.api.updateCustomerDefaultAddress(with: "id") { (response, error) in
                                self.checkUnsuccessResponse(response, error: error)
                                
                                done()
                            }
                        }
                    }
                }
                
                context("because of api") {
                    it("needs to return error") {
                        for index in 0..<addressResponseObjects.count {
                            self.stubResponse(withObjects: addressResponseObjects, indexOfError: index)
                            
                            waitUntil { done in
                                self.api.updateCustomerDefaultAddress(with: customerLastAddressId) { (response, error) in
                                    self.checkUnsuccessResponse(response, error: error)
                                    
                                    done()
                                }
                            }
                        }
                    }
                }
            }
            
            context("if response has objects") {
                it("needs to return customer") {
                    self.stubResponse(withObjects: addressResponseObjects)
                    
                    waitUntil { done in
                        self.api.updateCustomerDefaultAddress(with: customerLastAddressId) { (response, error) in
                            self.checkCustomerResponse(response, error: error, customer: customerJson)
                            
                            done()
                        }
                    }
                }
            }
        }
        
        describe("when user deletes address") {
            beforeEach {
                self.login()
            }
            
            context("if response has error") {
                context("because of request data") {
                    it("needs to return error") {
                        self.stubResponse(withObjects: addressDataErrorResponseObjects)
                        
                        waitUntil { done in
                            self.api.deleteCustomerAddress(with: "id") { (response, error) in
                                self.checkUnsuccessResponse(response, error: error)
                                
                                done()
                            }
                        }
                    }
                }
                
                context("because of api") {
                    it("needs to return error") {
                        for index in 0..<deleteAddressApiErrorResponseObjects.count {
                            self.stubResponse(withObjects: deleteAddressApiErrorResponseObjects, indexOfError: index)
                            
                            waitUntil { done in
                                self.api.deleteCustomerAddress(with: customerLastAddressId) { (response, error) in
                                    self.checkUnsuccessResponse(response, error: error)
                                    
                                    done()
                                }
                            }
                        }
                    }
                }
            }
            
            context("if response has objects") {
                it("needs to return customer") {
                    self.stubResponse(withObjects: addressResponseObjects)
                    
                    waitUntil { done in
                        self.api.deleteCustomerAddress(with: customerLastAddressId) { (response, error) in
                            self.checkSuccessResponse(response, error: error)
                            
                            done()
                        }
                    }
                }
            }
        }
    }
    
    private func login() {
        let sessionService = SessionService()
        sessionService.save(token: "token", email: "user@mail.com", password: "password")
    }
    
    private func logout() {
        let sessionService = SessionService()
        sessionService.removeData()
    }
    
    private func checkCustomerResponse(_ response: Customer?, error: RepoError?, customer: [String: Any]) {
        expect(response?.email) == customer["email"] as? String
        expect(error).to(beNil())
    }
    
    private func buildAddress(isShouldBeEmpty: Bool = false, id: String? = nil) -> Address {
        let address = Address()
        
        guard !isShouldBeEmpty else {
            return address
        }
        
        let country = Country()
        country.id = "AD"
        
        address.country = country
        address.firstName = "First"
        address.lastName = "Last"
        address.address = "Main"
        address.city = "City"
        address.zip = "Zip"
        address.phone = "Phone"
        
        if let id = id {
            address.id = id
        }
        
        return address
    }
}
