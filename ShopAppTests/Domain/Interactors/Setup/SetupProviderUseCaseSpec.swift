//
//  SetupProviderUseCaseSpec.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 4/26/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick

@testable import ShopApp

class SetupProviderUseCaseSpec: QuickSpec {
    override func spec() {
        var useCase: SetupProviderUseCase!
        var repositoryMock: SetupProviderRepositoryMock!
        
        beforeEach {
            repositoryMock = SetupProviderRepositoryMock()
            useCase = SetupProviderUseCase(repository: repositoryMock)
        }
        
        describe("when product variant list should be get") {
            context("if callback has result") {
                it("needs to handle result") {
                    repositoryMock.isNeedToReturnError = false
                    
                    useCase.setupProvider(callback: { (_, error) in
                        expect(repositoryMock.isSetupProviderStarted) == true
                        
                        expect(error).to(beNil())
                    })
                }
            }
            
            context("if callback has error") {
                it("needs to handle error") {
                    repositoryMock.isNeedToReturnError = true
                    
                    useCase.setupProvider(callback: { (_, error) in
                        expect(repositoryMock.isSetupProviderStarted) == true
                        
                        expect(error).toNot(beNil())
                    })
                }
            }
        }
    }
}
