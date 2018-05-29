//
//  MagentoAPIProductSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 5/21/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Alamofire
import Nimble
import OHHTTPStubs
import Quick
import ShopApp_Gateway

@testable import ShopApp

class MagentoAPIProductSpec: MagentoAPIBaseSpec {
    override func spec() {
        super.spec()
        
        let storeConfigsJson = self.jsonObject(fromFileWithName: "StoreConfigs")
        let productListJson = self.jsonObject(fromFileWithName: "ProductList") as! [String: Any]
        let productJson = self.jsonObject(fromFileWithName: "Product") as! [String: Any]
        
        let products = productListJson["items"] as! [Any]
        let productSku = productJson["sku"] as! String
        
        let productListResponseObjects = [storeConfigsJson, productListJson]
        let productResponseObjects = [storeConfigsJson, productJson]
        
        describe("when user gets product list") {
            context("if response has error") {
                it("needs to return error") {
                    for index in 0..<productListResponseObjects.count {
                        self.stubResponse(withObjects: productListResponseObjects, indexOfError: index)
                        
                        waitUntil { done in
                            self.api.getProductList(perPage: 10, paginationValue: "2", sortBy: .createdAt, keyPhrase: nil, excludePhrase: nil, reverse: false) { (response, error) in
                                self.checkUnsuccessResponse(response, error: error)
                                
                                done()
                            }
                        }
                    }
                }
            }
            
            context("if response has objects") {
                context("and sort by value is popular") {
                    it("needs to return empty array") {
                        self.stubResponse(withObjects: productListResponseObjects)
                        
                        waitUntil { done in
                            self.api.getProductList(perPage: 10, paginationValue: nil, sortBy: .popular, keyPhrase: nil, excludePhrase: nil, reverse: false) { (response, error) in
                                self.checkSuccessResponse(response, error: error, array: [])
                                
                                done()
                            }
                        }
                    }
                }
                
                context("and sort by value is created at") {
                    it("needs to return products") {
                        self.stubResponse(withObjects: productListResponseObjects)
                        
                        waitUntil { done in
                            self.api.getProductList(perPage: 10, paginationValue: "2", sortBy: .createdAt, keyPhrase: nil, excludePhrase: nil, reverse: false) { (response, error) in
                                self.checkSuccessResponse(response, error: error, array: products)
                                
                                done()
                            }
                        }
                    }
                }
                
                context("and sort by value is type") {
                    it("needs to return products") {
                        self.stubResponse(withObjects: productListResponseObjects)
                        
                        waitUntil { done in
                            self.api.getProductList(perPage: 10, paginationValue: nil, sortBy: .type, keyPhrase: "key", excludePhrase: "exclude", reverse: false) { (response, error) in
                                self.checkSuccessResponse(response, error: error, array: products)
                                
                                done()
                            }
                        }
                    }
                }
            }
        }
        
        describe("when user gets product") {
            context("if response has error") {
                it("needs to return error") {
                    for index in 0..<productResponseObjects.count {
                        self.stubResponse(withObjects: productResponseObjects, indexOfError: index)
                        
                        waitUntil { done in
                            self.api.getProduct(id: "id") { (response, error) in
                                self.checkUnsuccessResponse(response, error: error)
                                
                                done()
                            }
                        }
                    }
                }
            }

            context("if response has object") {
                it("needs to return product") {
                    self.stubResponse(withObjects: productResponseObjects)
                    
                    waitUntil { done in
                        self.api.getProduct(id: "id") { (response, error) in
                            expect(response?.id) == productSku
                            expect(error).to(beNil())
                            
                            done()
                        }
                    }
                }
            }
        }
        
        describe("when user gets product by search") {
            context("if response has error") {
                it("needs to return error") {
                    for index in 0..<productListResponseObjects.count {
                        self.stubResponse(withObjects: productListResponseObjects, indexOfError: index)
                        
                        waitUntil { done in
                            self.api.searchProducts(perPage: 10, paginationValue: "2", searchQuery: "search") { (response, error) in
                                self.checkUnsuccessResponse(response, error: error)
                                
                                done()
                            }
                        }
                    }
                }
            }
            
            context("if response has object") {
                it("needs to return products") {
                    self.stubResponse(withObjects: productListResponseObjects)
                    
                    waitUntil { done in
                        self.api.searchProducts(perPage: 10, paginationValue: "2", searchQuery: "search") { (response, error) in
                            self.checkSuccessResponse(response, error: error, array: products)
                            
                            done()
                        }
                    }
                }
            }
        }
        
        describe("when user gets product variant list") {
            context("if response has error") {
                it("needs to return error") {
                    for index in 0..<productListResponseObjects.count {
                        self.stubResponse(withObjects: productListResponseObjects, indexOfError: index)
                        
                        waitUntil { done in
                            self.api.getProductVariantList(ids: ["first_id", "second_id"]) { (response, error) in
                                self.checkUnsuccessResponse(response, error: error)
                                
                                done()
                            }
                        }
                    }
                }
            }
            
            context("if response has object") {
                it("needs to return product variants") {
                    self.stubResponse(withObjects: productListResponseObjects)
                    
                    waitUntil { done in
                        self.api.getProductVariantList(ids: ["first_id", "second_id"]) { (response, error) in
                            self.checkSuccessResponse(response, error: error, array: products)
                            
                            done()
                        }
                    }
                }
            }
        }
    }
}
