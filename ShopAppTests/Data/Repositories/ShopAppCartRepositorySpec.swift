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
            var cartItemId: String!
            
            beforeEach {
                cartItemId = "id"
            }
            
            context("if callback has result") {
                it("needs to handle result") {
                    apiMock.isNeedToReturnError = false
                    
                    repository.deleteCartProduct(cartItemId: cartItemId) { (result, error) in
                        expect(apiMock.isDeleteProductFromCartStarted) == true
                        
                        expect(apiMock.cartItemId) == cartItemId
                        
                        expect(result).toNot(beNil())
                        expect(error).to(beNil())
                    }
                }
            }
            
            context("if callback has error") {
                it("needs to handle error") {
                    apiMock.isNeedToReturnError = true
                    
                    repository.deleteCartProduct(cartItemId: cartItemId) { (result, error) in
                        expect(apiMock.isDeleteProductFromCartStarted) == true
                        
                        expect(apiMock.cartItemId) == cartItemId
                        
                        expect(result).to(beNil())
                        expect(error).toNot(beNil())
                    }
                }
            }
        }
        
        describe("when selected cart products should be delete") {
            var cartItemIds: [String]!
            
            beforeEach {
                cartItemIds = ["id"]
            }
            
            context("if callback has result") {
                it("needs to handle result") {
                    apiMock.isNeedToReturnError = false
                    
                    repository.deleteCartProducts(cartItemIds: cartItemIds) { (result, error) in
                        expect(apiMock.isDeleteProductsFromCartStarted) == true
                        
                        expect(apiMock.cartItemIds).to(equal(cartItemIds))
                        
                        expect(result).toNot(beNil())
                        expect(error).to(beNil())
                    }
                }
            }
            
            context("if callback has error") {
                it("needs to handle error") {
                    apiMock.isNeedToReturnError = true
                    
                    repository.deleteCartProducts(cartItemIds: cartItemIds) { (result, error) in
                        expect(apiMock.isDeleteProductsFromCartStarted) == true
                        
                        expect(apiMock.cartItemIds).to(equal(cartItemIds))
                        
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
            var cartItemId: String!
            var quantity: Int!
            
            beforeEach {
                cartItemId = "id"
                quantity = 5
            }
            
            context("if callback has result") {
                it("needs to handle result") {
                    apiMock.isNeedToReturnError = false
                    
                    repository.changeCartProductQuantity(cartItemId: cartItemId, quantity: quantity) { (result, error) in
                        expect(apiMock.isChangeCartProductQuantityStarted) == true
                        
                        expect(apiMock.cartItemId) == cartItemId
                        expect(apiMock.quantity) == quantity
                        
                        expect(result) == true
                        expect(error).to(beNil())
                    }
                }
            }
            
            context("if callback has error") {
                it("needs to handle error") {
                    apiMock.isNeedToReturnError = true
                    
                    repository.changeCartProductQuantity(cartItemId: cartItemId, quantity: quantity) { (result, error) in
                        expect(apiMock.isChangeCartProductQuantityStarted) == true
                        
                        expect(apiMock.cartItemId) == cartItemId
                        expect(apiMock.quantity) == quantity
                        
                        expect(result) == false
                        expect(error).toNot(beNil())
                    }
                }
            }
        }
    }
}
