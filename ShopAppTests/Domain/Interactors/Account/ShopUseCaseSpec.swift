//
//  ShopUseCaseSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 4/2/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class ShopUseCaseSpec: QuickSpec {
    override func spec() {
        var useCase: ShopUseCase!
        var repositoryMock: ShopRepositoryMock!
        
        beforeEach {
            repositoryMock = ShopRepositoryMock()
            useCase = ShopUseCase(repository: repositoryMock)
        }
        
        describe("when shop should be get") {
            it("needs to handle result") {
                repositoryMock.isNeedToReturnError = false
                
                useCase.getShop() { result in
                    expect(repositoryMock.isGetShopStarted) == true
                    
                    expect(result).toNot(beNil())
                }
            }
        }
    }
}
