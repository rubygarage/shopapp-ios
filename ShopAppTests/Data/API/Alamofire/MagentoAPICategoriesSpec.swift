//
//  MagentoAPISpec.swift
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

class MagentoAPICategoriesSpec: MagentoAPIBaseSpec {
    override func spec() {
        super.spec()
        
        let errorMessage = "error"
        
        let storeConfigsJson = self.jsonObject(fromFileWithName: "StoreConfigs")
        let categoryListJson = self.jsonObject(fromFileWithName: "CategoryList") as! [String: Any]
        let categoryDetailsJson = self.jsonObject(fromFileWithName: "CategoryDetails") as! [String: Any]
        let productListJson = self.jsonObject(fromFileWithName: "ProductList") as! [String: Any]

        let childrenCategories = categoryListJson["children_data"] as! [Any]
        let categoryId = String(categoryDetailsJson["id"] as! Int)
        let products = productListJson["items"] as! [Any]
        
        let responseObjects = [storeConfigsJson, productListJson, categoryDetailsJson]
        
        describe("when user gets category list") {
            context("if response has error") {
                it("needs to return error") {
                    self.stubResponse(withErrorMessage: errorMessage)
                    
                    waitUntil { done in
                        self.api.getCategoryList(perPage: 10, paginationValue: nil, sortBy: nil, reverse: false, parentCategoryId: nil) { (response, error) in
                            self.checkUnsuccessResponse(response, error: error, errorMessage: errorMessage)
                            
                            done()
                        }
                    }
                }
            }
            
            context("if response has objects") {
                it("needs to return categories") {
                    self.stubResponse(withObject: categoryListJson)
                    
                    waitUntil { done in
                        self.api.getCategoryList(perPage: 10, paginationValue: nil, sortBy: nil, reverse: false, parentCategoryId: "id") { (response, error) in
                            self.checkSuccessResponse(response, error: error, array: childrenCategories)
                            
                            done()
                        }
                    }
                }
            }
        }
        
        describe("when user gets category details") {
            context("if response has error") {
                it("needs to return error") {
                    for index in 0..<responseObjects.count {
                        self.stubResponse(withObjects: responseObjects, indexOfError: index)
                        
                        waitUntil { done in
                            self.api.getCategoryDetails(id: "id", perPage: 10, paginationValue: "2", sortBy: .name, reverse: false) { (response, error) in
                                self.checkUnsuccessResponse(response, error: error)
                                
                                done()
                            }
                        }
                    }
                }
            }
            
            context("if response has objects") {
                it("needs to return product variants") {
                    self.stubResponse(withObjects: responseObjects)
                    
                    waitUntil { done in
                        self.api.getCategoryDetails(id: "id", perPage: 10, paginationValue: "2", sortBy: .createdAt, reverse: false) { (response, error) in
                            expect(response?.id) == categoryId
                            expect(response?.products?.count) == products.count
                            expect(error).to(beNil())
                            
                            done()
                        }
                    }
                }
            }
        }
    }
}
