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

            beforeEach {
                perPage = 5
                paginationValue = "pagination"
            }
            
            context("if callback has result") {
                it("needs to handle result") {
                    apiMock.isNeedToReturnError = false
                    
                    repository.getCategories(perPage: perPage, paginationValue: paginationValue) { (result, error) in
                        expect(apiMock.isGetCategoryListStarted) == true
                        
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
                    
                    repository.getCategories(perPage: perPage, paginationValue: paginationValue) { (result, error) in
                        expect(apiMock.isGetCategoryListStarted) == true
                        
                        expect(apiMock.perPage) == perPage
                        expect(apiMock.paginationValue) == paginationValue
                        
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
            var sortBy: SortType!

            beforeEach {
                id = "id"
                perPage = 5
                paginationValue = "pagination"
                sortBy = .name
            }
            
            context("if callback has result") {
                it("needs to handle result") {
                    apiMock.isNeedToReturnError = false
                    
                    repository.getCategory(id: id, perPage: perPage, paginationValue: paginationValue, sortBy: sortBy) { (result, error) in
                        expect(apiMock.isGetCategoryStarted) == true
                        
                        expect(apiMock.id) == id
                        expect(apiMock.perPage) == perPage
                        expect(apiMock.paginationValue) == paginationValue
                        expect(apiMock.sortBy?.rawValue) == sortBy.rawValue

                        expect(result).toNot(beNil())
                        expect(error).to(beNil())
                    }
                }
            }
            
            context("if callback has error") {
                it("needs to handle error") {
                    apiMock.isNeedToReturnError = true
                    
                    repository.getCategory(id: id, perPage: perPage, paginationValue: paginationValue, sortBy: sortBy) { (result, error) in
                        expect(apiMock.isGetCategoryStarted) == true
                        
                        expect(apiMock.id) == id
                        expect(apiMock.perPage) == perPage
                        expect(apiMock.paginationValue) == paginationValue
                        expect(apiMock.sortBy?.rawValue) == sortBy.rawValue

                        expect(result).to(beNil())
                        expect(error).toNot(beNil())
                    }
                }
            }
        }
    }
}
