//
//  ChangeCartProductUseCaseSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 4/3/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class ChangeCartProductUseCaseSpec: QuickSpec {
    override func spec() {
        var useCase: ChangeCartProductUseCase!
        var repositoryMock: CartRepositoryMock!
        
        beforeEach {
            repositoryMock = CartRepositoryMock()
            useCase = ChangeCartProductUseCase(repository: repositoryMock)
        }
        
        describe("when product's quantity should be change") {
            var productVariantId: String!
            var quantity: Int!
            
            beforeEach {
                productVariantId = "id"
                quantity = 5
            }
            
            context("if callback has result") {
                it("needs to handle result") {
                    repositoryMock.isNeedToReturnError = false
                    
                    useCase.changeCartProductQuantity(cartItemId: productVariantId, quantity: quantity) { (_, error) in
                        expect(repositoryMock.isChangeCartProductQuantityStarted) == true
                        
                        expect(repositoryMock.cartItemId) == productVariantId
                        expect(repositoryMock.quantity) == quantity

                        expect(error).to(beNil())
                    }
                }
            }
            
            context("if callback has error") {
                it("needs to handle error") {
                    repositoryMock.isNeedToReturnError = true
                    
                    useCase.changeCartProductQuantity(cartItemId: productVariantId, quantity: quantity) { (_, error) in
                        expect(repositoryMock.isChangeCartProductQuantityStarted) == true
                        
                        expect(repositoryMock.cartItemId) == productVariantId
                        expect(repositoryMock.quantity) == quantity

                        expect(error).toNot(beNil())
                    }
                }
            }
        }
    }
}
