//
//  DeleteCartProductUseCaseSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 4/3/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class DeleteCartProductUseCaseSpec: QuickSpec {
    override func spec() {
        var useCase: DeleteCartProductUseCase!
        var repositoryMock: CartRepositoryMock!
        
        beforeEach {
            repositoryMock = CartRepositoryMock()
            useCase = DeleteCartProductUseCase(repository: repositoryMock)
        }
        
        describe("when product should be delete from cart") {
            var cartItemId: String!
            
            beforeEach {
                cartItemId = "id"
            }
            
            context("if callback has result") {
                it("needs to handle result") {
                    repositoryMock.isNeedToReturnError = false
                    
                    useCase.deleteCartProduct(cartItemId: cartItemId) { (result, error) in
                        expect(repositoryMock.isDeleteProductFromCartStarted) == true
                        
                        expect(repositoryMock.cartItemId) == cartItemId
                        
                        expect(result) == true
                        expect(error).to(beNil())
                    }
                }
            }
            
            context("if callback has error") {
                it("needs to handle error") {
                    repositoryMock.isNeedToReturnError = true
                    
                    useCase.deleteCartProduct(cartItemId: cartItemId) { (result, error) in
                        expect(repositoryMock.isDeleteProductFromCartStarted) == true
                        
                        expect(repositoryMock.cartItemId) == cartItemId
                        
                        expect(result) == false
                        expect(error).toNot(beNil())
                    }
                }
            }
        }
        
        describe("when products should be delete") {
            var productVariantIds: [String]!
            
            beforeEach {
                productVariantIds = ["id"]
            }
            
            context("if callback has result") {
                it("needs to handle result") {
                    repositoryMock.isNeedToReturnError = false
                    
                    useCase.deleteCartProducts(cartItemIds: productVariantIds) { (result, error) in
                        expect(repositoryMock.isDeleteProductsFromCartStarted) == true
                        
                        expect(repositoryMock.cartItemIds).to(equal(productVariantIds))
                        
                        expect(result) == true
                        expect(error).to(beNil())
                    }
                }
            }
            
            context("if callback has error") {
                it("needs to handle error") {
                    repositoryMock.isNeedToReturnError = true
                    
                    useCase.deleteCartProducts(cartItemIds: productVariantIds) { (result, error) in
                        expect(repositoryMock.isDeleteProductsFromCartStarted) == true
                        
                        expect(repositoryMock.cartItemIds).to(equal(productVariantIds))
                        
                        expect(result) == false
                        expect(error).toNot(beNil())
                    }
                }
            }
        }
    }
}
