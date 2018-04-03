//
//  LogoutUseCaseSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 4/2/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class LogoutUseCaseSpec: QuickSpec {
    override func spec() {
        var useCase: LogoutUseCase!
        var repositoryMock: AuthentificationRepositoryMock!
        
        beforeEach {
            repositoryMock = AuthentificationRepositoryMock()
            useCase = LogoutUseCase(repository: repositoryMock)
        }
        
        describe("when user should be logout") {
            context("if callback has result") {
                it("needs to handle result") {
                    repositoryMock.isNeedToReturnError = false
                    
                    useCase.logout() { result in
                        expect(repositoryMock.isLogoutStarted) == true
                        
                        expect(result) == true
                    }
                }
            }
            
            context("if callback has error") {
                it("needs to handle error") {
                    repositoryMock.isNeedToReturnError = true
                    
                    useCase.logout() { result in
                        expect(repositoryMock.isLogoutStarted) == true
                        
                        expect(result) == false
                    }
                }
            }
        }
    }
}
