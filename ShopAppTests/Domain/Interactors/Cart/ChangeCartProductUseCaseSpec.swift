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
            var cartItemId: String!
            var quantity: Int!
            
            beforeEach {
                cartItemId = "id"
                quantity = 5
            }
            
            context("if callback has result") {
                it("needs to handle result") {
                    repositoryMock.isNeedToReturnError = false
                    
                    useCase.changeCartProductQuantity(cartItemId: cartItemId, quantity: quantity) { (result, error) in
                        expect(repositoryMock.isChangeCartProductQuantityStarted) == true
                        
                        expect(repositoryMock.cartItemId) == cartItemId
                        expect(repositoryMock.quantity) == quantity
                        
                        expect(result) == true
                        expect(error).to(beNil())
                    }
                }
            }
            
            context("if callback has error") {
                it("needs to handle error") {
                    repositoryMock.isNeedToReturnError = true
                    
                    useCase.changeCartProductQuantity(cartItemId: cartItemId, quantity: quantity) { (result, error) in
                        expect(repositoryMock.isChangeCartProductQuantityStarted) == true
                        
                        expect(repositoryMock.cartItemId) == cartItemId
                        expect(repositoryMock.quantity) == quantity
                        
                        expect(result) == false
                        expect(error).toNot(beNil())
                    }
                }
            }
        }
    }
}
