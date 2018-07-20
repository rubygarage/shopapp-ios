//
//  SignInUseCaseSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 4/2/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class SignInUseCaseSpec: QuickSpec {
    override func spec() {
        var useCase: SignInUseCase!
        var repositoryMock: AuthentificationRepositoryMock!
        
        beforeEach {
            repositoryMock = AuthentificationRepositoryMock()
            useCase = SignInUseCase(repository: repositoryMock)
        }
        
        describe("when user should be login") {
            var email: String!
            var password: String!
            
            beforeEach {
                email = "user@mail.com"
                password = "password"
            }
            
            context("if callback has result") {
                it("needs to handle result") {
                    repositoryMock.isNeedToReturnError = false
                    
                    useCase.signIn(email: email, password: password) { (_, error) in
                        expect(repositoryMock.isLoginStarted) == true
                        
                        expect(repositoryMock.email) == email
                        expect(repositoryMock.password) == password
                        
                        expect(error).to(beNil())
                    }
                }
            }
            
            context("if callback has error") {
                it("needs to handle error") {
                    repositoryMock.isNeedToReturnError = true
                    
                    useCase.signIn(email: email, password: password) { (_, error) in
                        expect(repositoryMock.isLoginStarted) == true
                        
                        expect(repositoryMock.email) == email
                        expect(repositoryMock.password) == password
                        
                        expect(error).toNot(beNil())
                    }
                }
            }
        }
        
        describe("when user should get login status") {
            context("if callback has result") {
                it("needs to handle result") {
                    repositoryMock.isNeedToReturnError = false
                    
                    useCase.isSignedIn() { (isSignedIn, _) in
                        expect(repositoryMock.isGetLoginStatusStarted) == true
                        
                        expect(isSignedIn) == true
                    }
                }
            }
            
            context("if callback has error") {
                it("needs to handle error") {
                    repositoryMock.isNeedToReturnError = true
                    
                    useCase.isSignedIn() { (isSignedIn, _) in
                        expect(repositoryMock.isGetLoginStatusStarted) == true
                        
                        expect(isSignedIn) == false
                    }
                }
            }
        }
    }
}
