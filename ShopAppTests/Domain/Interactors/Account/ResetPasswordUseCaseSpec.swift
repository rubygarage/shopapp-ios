//
//  ResetPasswordUseCaseSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 4/2/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class ResetPasswordUseCaseSpec: QuickSpec {
    override func spec() {
        var useCase: ResetPasswordUseCase!
        var repositoryMock: AuthentificationRepositoryMock!
        
        beforeEach {
            repositoryMock = AuthentificationRepositoryMock()
            useCase = ResetPasswordUseCase(repository: repositoryMock)
        }
        
        describe("when user should reset password") {
            var email: String!
            
            beforeEach {
                email = "user@mail.com"
            }
            
            context("if callback has result") {
                it("needs to handle result") {
                    repositoryMock.isNeedToReturnError = false
                    
                    useCase.resetPassword(with: email) { (result, error) in
                        expect(repositoryMock.isResetPasswordStarted) == true
                        
                        expect(repositoryMock.email) == email
                        
                        expect(result).toNot(beNil())
                        expect(error).to(beNil())
                    }
                }
            }
            
            context("if callback has error") {
                it("needs to handle error") {
                    repositoryMock.isNeedToReturnError = true
                    
                    useCase.resetPassword(with: email) { (result, error) in
                        expect(repositoryMock.isResetPasswordStarted) == true
                        
                        expect(repositoryMock.email) == email
                        
                        expect(result).toNot(beNil())
                        expect(error).toNot(beNil())
                    }
                }
            }
        }
    }
}
