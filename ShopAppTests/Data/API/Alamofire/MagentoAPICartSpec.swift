//
//  MagentoAPICartSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 6/26/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Alamofire
import Nimble
import OHHTTPStubs
import Quick
import ShopApp_Gateway

@testable import ShopApp

class MagentoAPICartSpec: MagentoAPIBaseSpec {
    override func spec() {
        super.spec()

        let quoteId = "\"quoteId\""
        let storeConfigsJson = self.jsonObject(fromFileWithName: "StoreConfigs")
        let cartProductListJson = self.jsonObject(fromFileWithName: "CartProductList") as! [Any]
        let productJson = self.jsonObject(fromFileWithName: "Product") as! [String: Any]
        
        let cartProductListErrorResponseObjects = [storeConfigsJson, quoteId, cartProductListJson, storeConfigsJson, productJson]
        let cartProductListResponseObjects = [storeConfigsJson, quoteId, cartProductListJson, productJson]
        let addCartProductResponseObjects = [quoteId, cartProductListJson.first!]
        let changeOrDeleteCartProductResponseObjects = [quoteId, "true"]
        
        describe("when user gets cart product list") {
            context("if response has error") {
                it("needs to return error") {
                    for index in 0..<cartProductListErrorResponseObjects.count {
                        self.stubResponse(withObjects: cartProductListErrorResponseObjects, indexOfError: index)

                        waitUntil { done in
                            self.api.getCartProducts() { (response, error) in
                                self.checkUnsuccessResponse(response, error: error)

                                done()
                            }
                        }
                    }
                }
            }

            context("if response has objects") {
                it("needs to return cart products") {
                    self.stubResponse(withObjects: cartProductListResponseObjects)

                    waitUntil(timeout: 5) { done in
                        self.api.getCartProducts() { (response, error) in
                            self.checkSuccessResponse(response, error: error, array: cartProductListJson)

                            done()
                        }
                    }
                }
            }
        }

        describe("when user adds cart product") {
            context("if response has error") {
                it("needs to return error") {
                    for index in 0..<addCartProductResponseObjects.count {
                        self.stubResponse(withObjects: addCartProductResponseObjects, indexOfError: index)

                        waitUntil { done in
                            self.api.addCartProduct(cartProduct: CartProduct()) { (response, error) in
                                self.checkUnsuccessResponse(response, error: error)

                                done()
                            }
                        }
                    }
                }
            }

            context("if response hasn't error") {
                it("needs to return true") {
                    self.stubResponse(withObjects: addCartProductResponseObjects)

                    waitUntil(timeout: 5) { done in
                        self.api.addCartProduct(cartProduct: CartProduct()) { (response, error) in
                            self.checkSuccessResponse(response, error: error)
                            
                            done()
                        }
                    }
                }
            }
        }
        
        
        
        
        describe("when user deletes cart product") {
            context("if response has error") {
                it("needs to return error") {
                    for index in 0..<changeOrDeleteCartProductResponseObjects.count {
                        self.stubResponse(withObjects: changeOrDeleteCartProductResponseObjects, indexOfError: index)
                        
                        waitUntil { done in
                            self.api.deleteCartProduct(cartItemId: "id") { (response, error) in
                                self.checkUnsuccessResponse(response, error: error)
                                
                                done()
                            }
                        }
                    }
                }
            }
            
            context("if response hasn't error") {
                it("needs to return true") {
                    self.stubResponse(withObjects: changeOrDeleteCartProductResponseObjects)
                    
                    waitUntil(timeout: 5) { done in
                        self.api.deleteCartProduct(cartItemId: "id") { (response, error) in
                            self.checkSuccessResponse(response, error: error)
                            
                            done()
                        }
                    }
                }
            }
        }
        
        describe("when user changes cart product's quantity") {
            context("if response has error") {
                it("needs to return error") {
                    for index in 0..<changeOrDeleteCartProductResponseObjects.count {
                        self.stubResponse(withObjects: changeOrDeleteCartProductResponseObjects, indexOfError: index)
                        
                        waitUntil { done in
                            self.api.changeCartProductQuantity(cartItemId: "id", quantity: 2) { (response, error) in
                                self.checkUnsuccessResponse(response, error: error)
                                
                                done()
                            }
                        }
                    }
                }
            }
            
            context("if response hasn't error") {
                it("needs to return true") {
                    self.stubResponse(withObjects: changeOrDeleteCartProductResponseObjects)
                    
                    waitUntil(timeout: 5) { done in
                        self.api.changeCartProductQuantity(cartItemId: "id", quantity: 2) { (response, error) in
                            self.checkSuccessResponse(response, error: error)
                            
                            done()
                        }
                    }
                }
            }
        }
    }
}
