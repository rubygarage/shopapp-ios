//
//  ShopAppAuthentificationRepositorySpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/28/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick

import ShopApp_Gateway

@testable import ShopApp

class ShopAppAuthentificationRepositorySpec: QuickSpec {
    override func spec() {
        var repository: ShopAppAuthentificationRepository!
        var apiMock: APIMock!
        
        beforeEach {
            apiMock = APIMock()
            repository = ShopAppAuthentificationRepository(api: apiMock)
        }
        
        describe("when user should sign up") {
            var email: String!
            var firstName: String!
            var lastName: String!
            var password: String!
            var phone: String!
            
            beforeEach {
                email = "user@mail.com"
                firstName = "First"
                lastName = "Last"
                password = "password"
                phone = "phone"
            }
            
            context("if callback has result") {
                it("needs to handle result") {
                    apiMock.isNeedToReturnError = false
                    
                    repository.signUp(with: email, firstName: firstName, lastName: lastName, password: password, phone: phone) { (result, error) in
                        expect(apiMock.isSignUpStarter) == true
                        
                        expect(apiMock.email) == email
                        expect(apiMock.firstName) == firstName
                        expect(apiMock.lastName) == lastName
                        expect(apiMock.password) == password
                        expect(apiMock.phone) == phone
                        
                        expect(result).toNot(beNil())
                        expect(error).to(beNil())
                    }
                }
            }
            
            context("if callback has error") {
                it("needs to handle error") {
                    apiMock.isNeedToReturnError = true
                    
                    repository.signUp(with: email, firstName: firstName, lastName: lastName, password: password, phone: phone) { (result, error) in
                        expect(apiMock.isSignUpStarter) == true
                        
                        expect(apiMock.email) == email
                        expect(apiMock.firstName) == firstName
                        expect(apiMock.lastName) == lastName
                        expect(apiMock.password) == password
                        expect(apiMock.phone) == phone
                        
                        expect(result).to(beNil())
                        expect(error).toNot(beNil())
                    }
                }
            }
        }
        
        describe("when user should login") {
            var email: String!
            var password: String!
            
            beforeEach {
                email = "user@mail.com"
                password = "password"
            }
            
            context("if callback has result") {
                it("needs to handle result") {
                    apiMock.isNeedToReturnError = false
                    
                    repository.login(with: email, password: password) { (result, error) in
                        expect(apiMock.isLoginStarted) == true
                        
                        expect(apiMock.email) == email
                        expect(apiMock.password) == password
                        
                        expect(result).toNot(beNil())
                        expect(error).to(beNil())
                    }
                }
            }
            
            context("if callback has error") {
                it("needs to handle error") {
                    apiMock.isNeedToReturnError = true
                    
                    repository.login(with: email, password: password) { (result, error) in
                        expect(apiMock.isLoginStarted) == true
                        
                        expect(apiMock.email) == email
                        expect(apiMock.password) == password
                        
                        expect(result).to(beNil())
                        expect(error).toNot(beNil())
                    }
                }
            }
        }
        
        describe("when user should logout") {
            context("if callback has result") {
                it("needs to handle result") {
                    apiMock.isNeedToReturnError = false
                    
                    repository.logout() { (result, error) in
                        expect(apiMock.isLogoutStarted) == true
                        
                        expect(result).toNot(beNil())
                        expect(error).to(beNil())
                    }
                }
            }
            
            context("if callback has error") {
                it("needs to handle error") {
                    apiMock.isNeedToReturnError = true
                    
                    repository.logout() { (result, error) in
                        expect(apiMock.isLogoutStarted) == true
                        
                        expect(result).to(beNil())
                        expect(error).toNot(beNil())
                    }
                }
            }
        }
        
        describe("when user should check logged status") {
            context("if callback has result") {
                it("needs to handle result") {
                    apiMock.isNeedToReturnError = false
                    
                    expect(repository.isLoggedIn()) == true
                }
            }
            
            context("if callback has error") {
                it("needs to handle error") {
                    apiMock.isNeedToReturnError = true
                    
                    expect(repository.isLoggedIn()) == false
                }
            }
        }
        
        describe("when user should reset password") {
            var email: String!
            
            beforeEach {
                email = "user@mail.com"
            }
            
            context("if callback has result") {
                it("needs to handle result") {
                    apiMock.isNeedToReturnError = false
                    
                    repository.resetPassword(with: email) { (result, error) in
                        expect(apiMock.isResetPasswordStarted) == true
                        
                        expect(apiMock.email) == email
                        
                        expect(result).toNot(beNil())
                        expect(error).to(beNil())
                    }
                }
            }
            
            context("if callback has error") {
                it("needs to handle error") {
                    apiMock.isNeedToReturnError = true
                    
                    repository.resetPassword(with: email) { (result, error) in
                        expect(apiMock.isResetPasswordStarted) == true
                        
                        expect(apiMock.email) == email
                        
                        expect(result).to(beNil())
                        expect(error).toNot(beNil())
                    }
                }
            }
        }
    }
}
