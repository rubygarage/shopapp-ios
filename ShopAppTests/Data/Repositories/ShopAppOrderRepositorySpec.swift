//
//  ShopAppOrderRepositorySpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/28/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick

import ShopApp_Gateway

@testable import ShopApp

class ShopAppOrderRepositorySpec: QuickSpec {
    override func spec() {
        var repository: ShopAppOrderRepository!
        var apiMock: APIMock!
        
        beforeEach {
            apiMock = APIMock()
            repository = ShopAppOrderRepository(api: apiMock)
        }
        
        describe("when order list should be get") {
            var perPage: Int!
            var paginationValue: String!
            
            beforeEach {
                perPage = 5
                paginationValue = "pagination"
            }
            
            context("if callback has result") {
                it("needs to handle result") {
                    apiMock.isNeedToReturnError = false
                    
                    repository.getOrderList(perPage: perPage, paginationValue: paginationValue) { (result, error) in
                        expect(apiMock.isGetOrderListStarted) == true
                        
                        expect(apiMock.perPage) == perPage
                        expect(apiMock.paginationValue) == paginationValue
                        
                        expect(result).toNot(beNil())
                        expect(error).to(beNil())
                    }
                }
            }
            
            context("if callback has error") {
                it("needs to handle error") {
                    apiMock.isNeedToReturnError = true
                    
                    repository.getOrderList(perPage: perPage, paginationValue: paginationValue) { (result, error) in
                        expect(apiMock.isGetOrderListStarted) == true
                        
                        expect(apiMock.perPage) == perPage
                        expect(apiMock.paginationValue) == paginationValue
                        
                        expect(result).to(beNil())
                        expect(error).toNot(beNil())
                    }
                }
            }
        }
        
        describe("when order should be get") {
            var id: String!
            
            beforeEach {
                id = "id"
            }
            
            context("if callback has result") {
                it("needs to handle result") {
                    apiMock.isNeedToReturnError = false
                    
                    repository.getOrder(id: id) { (result, error) in
                        expect(apiMock.isGetOrderStarted) == true
                        
                        expect(apiMock.id) == id
                        
                        expect(result).toNot(beNil())
                        expect(error).to(beNil())
                    }
                }
            }
            
            context("if callback has error") {
                it("needs to handle error") {
                    apiMock.isNeedToReturnError = true
                    
                    repository.getOrder(id: id) { (result, error) in
                        expect(apiMock.isGetOrderStarted) == true
                        
                        expect(apiMock.id) == id
                        
                        expect(result).to(beNil())
                        expect(error).toNot(beNil())
                    }
                }
            }
        }
    }
}
