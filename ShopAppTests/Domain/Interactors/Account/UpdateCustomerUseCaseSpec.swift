//
//  UpdateCustomerUseCaseSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 4/2/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class UpdateCustomerUseCaseSpec: QuickSpec {
    override func spec() {
        var useCase: UpdateCustomerUseCase!
        var repositoryMock: CustomerRepositoryMock!
        
        beforeEach {
            repositoryMock = CustomerRepositoryMock()
            useCase = UpdateCustomerUseCase(repository: repositoryMock)
        }
        
        describe("when user's promo should be update") {
            var isAcceptMarketing: Bool!
            
            beforeEach {
                isAcceptMarketing = true
            }
            
            context("if callback has result") {
                it("needs to handle result") {
                    repositoryMock.isNeedToReturnError = false
                    
                    useCase.updateCustomerSettings(isAcceptMarketing: isAcceptMarketing) { (result, error) in
                        expect(repositoryMock.isUpdateCustomerPromoStarted) == true
                        
                        expect(repositoryMock.isAcceptMarketing) == isAcceptMarketing
                        
                        expect(result).toNot(beNil())
                        expect(error).to(beNil())
                    }
                }
            }
            
            context("if callback has error") {
                it("needs to handle error") {
                    repositoryMock.isNeedToReturnError = true
                    
                    useCase.updateCustomerSettings(isAcceptMarketing: isAcceptMarketing) { (result, error) in
                        expect(repositoryMock.isUpdateCustomerPromoStarted) == true
                        
                        expect(repositoryMock.isAcceptMarketing) == isAcceptMarketing
                        
                        expect(result).to(beNil())
                        expect(error).toNot(beNil())
                    }
                }
            }
        }
        
        describe("when user's info should be update") {
            var firstName: String!
            var lastName: String!
            var phone: String!
            
            beforeEach {
                firstName = "First"
                lastName = "Last"
                phone = "phone"
            }
            
            context("if callback has result") {
                it("needs to handle result") {
                    repositoryMock.isNeedToReturnError = false
                    
                    useCase.updateCustomer(firstName: firstName, lastName: lastName, phone: phone) { (result, error) in
                        expect(repositoryMock.isUpdateCustomerInfoStarted) == true
                        
                        expect(repositoryMock.firstName) == firstName
                        expect(repositoryMock.lastName) == lastName
                        expect(repositoryMock.phone) == phone
                        
                        expect(result).toNot(beNil())
                        expect(error).to(beNil())
                    }
                }
            }
            
            context("if callback has error") {
                it("needs to handle error") {
                    repositoryMock.isNeedToReturnError = true
                    
                    useCase.updateCustomer(firstName: firstName, lastName: lastName, phone: phone) { (result, error) in
                        expect(repositoryMock.isUpdateCustomerInfoStarted) == true
                        
                        expect(repositoryMock.firstName) == firstName
                        expect(repositoryMock.lastName) == lastName
                        expect(repositoryMock.phone) == phone
                        
                        expect(result).to(beNil())
                        expect(error).toNot(beNil())
                    }
                }
            }
        }
        
        describe("when user's password should be update") {
            var password: String!
            
            beforeEach {
                password = "password"
            }
            
            context("if callback has result") {
                it("needs to handle result") {
                    repositoryMock.isNeedToReturnError = false
                    
                    useCase.updatePassword(password: password) { (result, error) in
                        expect(repositoryMock.isUpdateCustomerPasswordStarted) == true
                        
                        expect(repositoryMock.password) == password
                        
                        expect(result).toNot(beNil())
                        expect(error).to(beNil())
                    }
                }
            }
            
            context("if callback has error") {
                it("needs to handle error") {
                    repositoryMock.isNeedToReturnError = true
                    
                    useCase.updatePassword(password: password) { (result, error) in
                        expect(repositoryMock.isUpdateCustomerPasswordStarted) == true
                        
                        expect(repositoryMock.password) == password
                        
                        expect(result).to(beNil())
                        expect(error).toNot(beNil())
                    }
                }
            }
        }
    }
}
