//
//  SignOutUseCaseSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 4/2/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class SignOutUseCaseSpec: QuickSpec {
    override func spec() {
        var useCase: SignOutUseCase!
        var repositoryMock: AuthentificationRepositoryMock!
        
        beforeEach {
            repositoryMock = AuthentificationRepositoryMock()
            useCase = SignOutUseCase(repository: repositoryMock)
        }
        
        describe("when user should be logout") {
            context("if callback has result") {
                it("needs to handle result") {
                    repositoryMock.isNeedToReturnError = false
                    
                    useCase.signOut() { (_, error) in
                        expect(repositoryMock.isLogoutStarted) == true
                        
                        expect(error).to(beNil())
                    }
                }
            }
            
            context("if callback has error") {
                it("needs to handle error") {
                    repositoryMock.isNeedToReturnError = true
                    
                    useCase.signOut() { (_, error) in
                        expect(repositoryMock.isLogoutStarted) == true
                        
                        expect(error).toNot(beNil())
                    }
                }
            }
        }
    }
}
