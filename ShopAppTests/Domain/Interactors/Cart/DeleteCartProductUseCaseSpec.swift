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
            var productVariantId: String!
            
            beforeEach {
                productVariantId = "id"
            }
            
            context("if callback has result") {
                it("needs to handle result") {
                    repositoryMock.isNeedToReturnError = false
                    
                    useCase.deleteProductFromCart(productVariantId: productVariantId) { (result, error) in
                        expect(repositoryMock.isDeleteProductFromCartStarted) == true
                        
                        expect(repositoryMock.productVariantId) == productVariantId
                        
                        expect(result) == true
                        expect(error).to(beNil())
                    }
                }
            }
            
            context("if callback has error") {
                it("needs to handle error") {
                    repositoryMock.isNeedToReturnError = true
                    
                    useCase.deleteProductFromCart(productVariantId: productVariantId) { (result, error) in
                        expect(repositoryMock.isDeleteProductFromCartStarted) == true
                        
                        expect(repositoryMock.productVariantId) == productVariantId
                        
                        expect(result) == false
                        expect(error).toNot(beNil())
                    }
                }
            }
        }
        
        describe("when products should be delete") {
            var productVariantIds: [String?]!
            
            beforeEach {
                productVariantIds = ["id"]
            }
            
            context("if callback has result") {
                it("needs to handle result") {
                    repositoryMock.isNeedToReturnError = false
                    
                    useCase.deleteProductsFromCart(with: productVariantIds) { (result, error) in
                        expect(repositoryMock.isDeleteProductsFromCartStarted) == true
                        
                        expect(repositoryMock.productVariantIds).to(equal(productVariantIds))
                        
                        expect(result) == true
                        expect(error).to(beNil())
                    }
                }
            }
            
            context("if callback has error") {
                it("needs to handle error") {
                    repositoryMock.isNeedToReturnError = true
                    
                    useCase.deleteProductsFromCart(with: productVariantIds) { (result, error) in
                        expect(repositoryMock.isDeleteProductsFromCartStarted) == true
                        
                        expect(repositoryMock.productVariantIds).to(equal(productVariantIds))
                        
                        expect(result) == false
                        expect(error).toNot(beNil())
                    }
                }
            }
        }
    }
}
