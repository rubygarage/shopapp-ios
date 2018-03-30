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
        var daoMock: DAOMock!
        
        beforeEach {
            daoMock = DAOMock()
            repository = ShopAppCartRepository(dao: daoMock)
        }
        
        describe("when cart product list should be get") {
            context("if callback has result") {
                it("needs to handle result") {
                    daoMock.isNeedToReturnError = false
                    
                    repository.getCartProductList() { (list, error) in
                        expect(list).toNot(beNil())
                        expect(error).to(beNil())
                    }
                }
            }
            
            context("if callback has error") {
                it("needs to handle error") {
                    daoMock.isNeedToReturnError = true
                    
                    repository.getCartProductList() { (list, error) in
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
                    daoMock.isNeedToReturnError = false
                    
                    repository.addCartProduct(cartProduct: cartProduct) { (result, error) in
                        expect(daoMock.isAddCartProductStarted) == true
                        
                        expect(daoMock.cartProduct) === cartProduct
                        
                        expect(result).toNot(beNil())
                        expect(error).to(beNil())
                    }
                }
            }
            
            context("if callback has error") {
                it("needs to handle error") {
                    daoMock.isNeedToReturnError = true
                    
                    repository.addCartProduct(cartProduct: cartProduct) { (result, error) in
                        expect(daoMock.isAddCartProductStarted) == true
                        
                        expect(daoMock.cartProduct) === cartProduct
                        
                        expect(result).to(beNil())
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
                    daoMock.isNeedToReturnError = false
                    
                    repository.deleteProductFromCart(with: productVariantId) { (result, error) in
                        expect(daoMock.isDeleteProductFromCartStarted) == true
                        
                        expect(daoMock.productVariantId) == productVariantId
                        
                        expect(result).toNot(beNil())
                        expect(error).to(beNil())
                    }
                }
            }
            
            context("if callback has error") {
                it("needs to handle error") {
                    daoMock.isNeedToReturnError = true
                    
                    repository.deleteProductFromCart(with: productVariantId) { (result, error) in
                        expect(daoMock.isDeleteProductFromCartStarted) == true
                        
                        expect(daoMock.productVariantId) == productVariantId
                        
                        expect(result).to(beNil())
                        expect(error).toNot(beNil())
                    }
                }
            }
        }
        
        describe("when all cart products should be delete") {
            context("if callback has result") {
                it("needs to handle result") {
                    daoMock.isNeedToReturnError = false
                    
                    repository.deleteAllProductsFromCart() { (result, error) in
                        expect(daoMock.isDeleteAllProductsFromCartStarted) == true

                        expect(result).toNot(beNil())
                        expect(error).to(beNil())
                    }
                }
            }
            
            context("if callback has error") {
                it("needs to handle error") {
                    daoMock.isNeedToReturnError = true
                    
                    repository.deleteAllProductsFromCart() { (result, error) in
                        expect(daoMock.isDeleteAllProductsFromCartStarted) == true

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
                    daoMock.isNeedToReturnError = false
                    
                    repository.changeCartProductQuantity(with: productVariantId, quantity: quantity) { (result, error) in
                        expect(daoMock.isChangeCartProductQuantityStarted) == true
                        
                        expect(daoMock.productVariantId) == productVariantId
                        expect(daoMock.quantity) == quantity
                        
                        expect(result).toNot(beNil())
                        expect(error).to(beNil())
                    }
                }
            }
            
            context("if callback has error") {
                it("needs to handle error") {
                    daoMock.isNeedToReturnError = true
                    
                    repository.changeCartProductQuantity(with: productVariantId, quantity: quantity) { (result, error) in
                        expect(daoMock.isChangeCartProductQuantityStarted) == true
                        
                        expect(daoMock.productVariantId) == productVariantId
                        expect(daoMock.quantity) == quantity
                        
                        expect(result).to(beNil())
                        expect(error).toNot(beNil())
                    }
                }
            }
        }
    }
}
