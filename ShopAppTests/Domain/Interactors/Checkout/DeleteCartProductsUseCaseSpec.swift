//
//  DeleteCartProductsUseCaseSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 4/3/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class DeleteCartProductsUseCaseSpec: QuickSpec {
    override func spec() {
        var useCase: DeleteCartProductsUseCase!
        var repositoryMock: CartRepositoryMock!
        
        beforeEach {
            repositoryMock = CartRepositoryMock()
            useCase = DeleteCartProductsUseCase(repository: repositoryMock)
        }
        
        describe("when all products should be delete from cart") {
            context("if callback has result") {
                it("needs to handle result") {
                    repositoryMock.isNeedToReturnError = false
                    
                    useCase.clearCart() { (result, error) in
                        expect(repositoryMock.isDeleteAllProductsFromCartStarted) == true
                        
                        expect(result) == true
                        expect(error).to(beNil())
                    }
                }
            }
            
            context("if callback has error") {
                it("needs to handle error") {
                    repositoryMock.isNeedToReturnError = true
                    
                    useCase.clearCart() { (result, error) in
                        expect(repositoryMock.isDeleteAllProductsFromCartStarted) == true
                        
                        expect(result) == false
                        expect(error).toNot(beNil())
                    }
                }
            }
        }
    }
}
