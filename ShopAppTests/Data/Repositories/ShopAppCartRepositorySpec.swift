//
//  ShopAppCartRepositorySpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/28/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class ShopAppCartRepositorySpec: QuickSpec {
    override func spec() {
        var repository: ShopAppCartRepository!
        var apiMock: APIMock!
        
        beforeEach {
            apiMock = APIMock()
            repository = ShopAppCartRepository(api: apiMock)
        }
        
        describe("when cart product list should be get") {
            context("if callback has result") {
                it("needs to handle result") {
                    apiMock.isNeedToReturnError = false
                    
                    repository.getCartProducts() { (list, error) in
                        expect(list).toNot(beNil())
                        expect(error).to(beNil())
                    }
                }
            }
            
            context("if callback has error") {
                it("needs to handle error") {
                    apiMock.isNeedToReturnError = true
                    
                    repository.getCartProducts() { (list, error) in
                        expect(list).to(beNil())
                        expect(error).toNot(beNil())
                    }
                }
            }
        }
        
        describe("when cart product should be add") {
            var cartProduct: CartProduct!
            
            beforeEach {
                cartProduct = CartProduct()
            }
            
            context("if callback has result") {
                it("needs to handle result") {
                    apiMock.isNeedToReturnError = false
                    
                    repository.addCartProduct(cartProduct: cartProduct) { (result, error) in
                        expect(apiMock.isAddCartProductStarted) == true
                        
                        expect(apiMock.cartProduct) === cartProduct
                        
                        expect(result) == true
                        expect(error).to(beNil())
                    }
                }
            }
            
            context("if callback has error") {
                it("needs to handle error") {
                    apiMock.isNeedToReturnError = true
                    
                    repository.addCartProduct(cartProduct: cartProduct) { (result, error) in
                        expect(apiMock.isAddCartProductStarted) == true
                        
                        expect(apiMock.cartProduct) === cartProduct
                        
                        expect(result) == false
                        expect(error).toNot(beNil())
                    }
                }
            }
        }
        
        describe("when cart product should be delete") {
            var productVariantId: String!
            
            beforeEach {
                productVariantId = "id"
            }
            
            context("if callback has result") {
                it("needs to handle result") {
                    apiMock.isNeedToReturnError = false
                    
                    repository.deleteCartProduct(cartItemId: productVariantId) { (result, error) in
                        expect(apiMock.isDeleteProductFromCartStarted) == true
                        
                        expect(apiMock.cartItemId) == productVariantId
                        
                        expect(result).toNot(beNil())
                        expect(error).to(beNil())
                    }
                }
            }
            
            context("if callback has error") {
                it("needs to handle error") {
                    apiMock.isNeedToReturnError = true
                    
                    repository.deleteCartProduct(cartItemId: productVariantId) { (result, error) in
                        expect(apiMock.isDeleteProductFromCartStarted) == true
                        
                        expect(apiMock.cartItemId) == productVariantId
                        
                        expect(result).to(beNil())
                        expect(error).toNot(beNil())
                    }
                }
            }
        }
        
        describe("when all cart products should be delete") {
            context("if callback has result") {
                it("needs to handle result") {
                    apiMock.isNeedToReturnError = false
                    
                    repository.deleteAllCartProducts() { (result, error) in
                        expect(apiMock.isDeleteAllProductsFromCartStarted) == true

                        expect(result).toNot(beNil())
                        expect(error).to(beNil())
                    }
                }
            }
            
            context("if callback has error") {
                it("needs to handle error") {
                    apiMock.isNeedToReturnError = true
                    
                    repository.deleteAllCartProducts() { (result, error) in
                        expect(apiMock.isDeleteAllProductsFromCartStarted) == true

                        expect(result).to(beNil())
                        expect(error).toNot(beNil())
                    }
                }
            }
        }
        
        describe("when cart product should be change") {
            var productVariantId: String!
            var quantity: Int!
            
            beforeEach {
                productVariantId = "id"
                quantity = 5
            }
            
            context("if callback has result") {
                it("needs to handle result") {
                    apiMock.isNeedToReturnError = false
                    
                    repository.changeCartProductQuantity(cartItemId: productVariantId, quantity: quantity) { (result, error) in
                        expect(apiMock.isChangeCartProductQuantityStarted) == true
                        
                        expect(apiMock.cartItemId) == productVariantId
                        expect(apiMock.quantity) == quantity
                        
                        expect(result) == true
                        expect(error).to(beNil())
                    }
                }
            }
            
            context("if callback has error") {
                it("needs to handle error") {
                    apiMock.isNeedToReturnError = true
                    
                    repository.changeCartProductQuantity(cartItemId: productVariantId, quantity: quantity) { (result, error) in
                        expect(apiMock.isChangeCartProductQuantityStarted) == true
                        
                        expect(apiMock.cartItemId) == productVariantId
                        expect(apiMock.quantity) == quantity
                        
                        expect(result) == false
                        expect(error).toNot(beNil())
                    }
                }
            }
        }
    }
}
