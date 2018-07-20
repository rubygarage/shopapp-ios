//
//  CartProductsUseCaseSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 4/3/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class CartProductsUseCaseSpec: QuickSpec {
    override func spec() {
        var useCase: CartProductsUseCase!
        var repositoryMock: CartRepositoryMock!
        
        beforeEach {
            repositoryMock = CartRepositoryMock()
            useCase = CartProductsUseCase(repository: repositoryMock)
        }
        
        describe("when product list should be get from cart") {
            context("if callback has result") {
                it("needs to handle result") {
                    repositoryMock.isNeedToReturnError = false
                    
                    useCase.getCartProducts() { (result, error) in
                        expect(repositoryMock.isGetCartProductListStarted) == true
                        
                        expect(result).toNot(beNil())
                        expect(error).to(beNil())
                    }
                }
            }
            
            context("if callback has error") {
                it("needs to handle error") {
                    repositoryMock.isNeedToReturnError = true
                    
                    useCase.getCartProducts() { (result, error) in
                        expect(repositoryMock.isGetCartProductListStarted) == true
                        
                        expect(result).to(beNil())
                        expect(error).toNot(beNil())
                    }
                }
            }
        }
    }
}
