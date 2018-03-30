//
//  ShopAppCategoryRepositorySpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/28/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class ShopAppCategoryRepositorySpec: QuickSpec {
    override func spec() {
        var repository: ShopAppCategoryRepository!
        var apiMock: APIMock!
        
        beforeEach {
            apiMock = APIMock()
            repository = ShopAppCategoryRepository(api: apiMock)
        }
        
        describe("when category list should be get") {
            var perPage: Int!
            var paginationValue: String!
            var sortBy: SortingValue!
            var reverse: Bool!
            
            beforeEach {
                perPage = 5
                paginationValue = "pagination"
                sortBy = .name
                reverse = true
            }
            
            context("if callback has result") {
                it("needs to handle result") {
                    apiMock.isNeedToReturnError = false
                    
                    repository.getCategoryList(perPage: perPage, paginationValue: paginationValue, sortBy: sortBy, reverse: reverse) { (result, error) in
                        expect(apiMock.isGetCategoryListStarted) == true
                        
                        expect(apiMock.perPage) == perPage
                        expect(apiMock.paginationValue) == paginationValue
                        expect(apiMock.sortBy?.rawValue) == sortBy.rawValue
                        expect(apiMock.reverse) == reverse
                        
                        expect(result).toNot(beNil())
                        expect(error).to(beNil())
                    }
                }
            }
            
            context("if callback has error") {
                it("needs to handle error") {
                    apiMock.isNeedToReturnError = true
                    
                    repository.getCategoryList(perPage: perPage, paginationValue: paginationValue, sortBy: sortBy, reverse: reverse) { (result, error) in
                        expect(apiMock.isGetCategoryListStarted) == true
                        
                        expect(apiMock.perPage) == perPage
                        expect(apiMock.paginationValue) == paginationValue
                        expect(apiMock.sortBy?.rawValue) == sortBy.rawValue
                        expect(apiMock.reverse) == reverse
                        
                        expect(result).to(beNil())
                        expect(error).toNot(beNil())
                    }
                }
            }
        }
        
        describe("when category details should be get") {
            var id: String!
            var perPage: Int!
            var paginationValue: String!
            var sortBy: SortingValue!
            var reverse: Bool!
            
            beforeEach {
                id = "id"
                perPage = 5
                paginationValue = "pagination"
                sortBy = .name
                reverse = true
            }
            
            context("if callback has result") {
                it("needs to handle result") {
                    apiMock.isNeedToReturnError = false
                    
                    repository.getCategoryDetails(id: id, perPage: perPage, paginationValue: paginationValue, sortBy: sortBy, reverse: reverse) { (result, error) in
                        expect(apiMock.isGetCategoryStarted) == true
                        
                        expect(apiMock.id) == id
                        expect(apiMock.perPage) == perPage
                        expect(apiMock.paginationValue) == paginationValue
                        expect(apiMock.sortBy?.rawValue) == sortBy.rawValue
                        expect(apiMock.reverse) == reverse
                        
                        expect(result).toNot(beNil())
                        expect(error).to(beNil())
                    }
                }
            }
            
            context("if callback has error") {
                it("needs to handle error") {
                    apiMock.isNeedToReturnError = true
                    
                    repository.getCategoryDetails(id: id, perPage: perPage, paginationValue: paginationValue, sortBy: sortBy, reverse: reverse) { (result, error) in
                        expect(apiMock.isGetCategoryStarted) == true
                        
                        expect(apiMock.id) == id
                        expect(apiMock.perPage) == perPage
                        expect(apiMock.paginationValue) == paginationValue
                        expect(apiMock.sortBy?.rawValue) == sortBy.rawValue
                        expect(apiMock.reverse) == reverse
                        
                        expect(result).to(beNil())
                        expect(error).toNot(beNil())
                    }
                }
            }
        }
    }
}
