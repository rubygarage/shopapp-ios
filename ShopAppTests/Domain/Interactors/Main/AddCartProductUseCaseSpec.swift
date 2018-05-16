//
//  AddCartProductUseCaseSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 4/3/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class AddCartProductUseCaseSpec: QuickSpec {
    override func spec() {
        var useCase: AddCartProductUseCase!
        var repositoryMock: CartRepositoryMock!
        
        beforeEach {
            repositoryMock = CartRepositoryMock()
            useCase = AddCartProductUseCase(repository: repositoryMock)
        }
        
        describe("when product should be add to cart") {
            var cartProduct: CartProduct!
            
            beforeEach {
                cartProduct = CartProduct()
            }
            
            context("if callback has result") {
                it("needs to handle result") {
                    repositoryMock.isNeedToReturnError = false
                    
                    useCase.addCartProduct(cartProduct) { (result, error) in
                        expect(repositoryMock.isAddCartProductStarted) == true
                        
                        expect(repositoryMock.cartProduct) === cartProduct
                        
                        expect(result) == true
                        expect(error).to(beNil())
                    }
                }
            }
            
            context("if callback has error") {
                it("needs to handle error") {
                    repositoryMock.isNeedToReturnError = true
                    
                    useCase.addCartProduct(cartProduct) { (result, error) in
                        expect(repositoryMock.isAddCartProductStarted) == true
                        
                        expect(repositoryMock.cartProduct) === cartProduct
                        
                        expect(result) == false
                        expect(error).toNot(beNil())
                    }
                }
            }
        }
    }
}
