//
//  SignUpUseCaseSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 4/2/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class SignUpUseCaseSpec: QuickSpec {
    override func spec() {
        var useCase: SignUpUseCase!
        var repositoryMock: AuthentificationRepositoryMock!
        
        beforeEach {
            repositoryMock = AuthentificationRepositoryMock()
            useCase = SignUpUseCase(repository: repositoryMock)
        }
        
        describe("when user should be sign up") {
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
                    repositoryMock.isNeedToReturnError = false
                    
                    useCase.signUp(with: email, firstName: firstName, lastName: lastName, password: password, phone: phone) { (result, error) in
                        expect(repositoryMock.isSignUpStarted) == true
                        
                        expect(repositoryMock.email) == email
                        expect(repositoryMock.firstName) == firstName
                        expect(repositoryMock.lastName) == lastName
                        expect(repositoryMock.password) == password
                        expect(repositoryMock.phone) == phone
                        
                        expect(result).toNot(beNil())
                        expect(error).to(beNil())
                    }
                }
            }
            
            context("if callback has error") {
                it("needs to handle error") {
                    repositoryMock.isNeedToReturnError = true
                    
                    useCase.signUp(with: email, firstName: firstName, lastName: lastName, password: password, phone: phone) { (result, error) in
                        expect(repositoryMock.isSignUpStarted) == true
                        
                        expect(repositoryMock.email) == email
                        expect(repositoryMock.firstName) == firstName
                        expect(repositoryMock.lastName) == lastName
                        expect(repositoryMock.password) == password
                        expect(repositoryMock.phone) == phone
                        
                        expect(result).toNot(beNil())
                        expect(error).toNot(beNil())
                    }
                }
            }
        }
    }
}
