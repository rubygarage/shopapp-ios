//
//  ShopAppArticleRepositorySpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/28/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class ShopAppArticleRepositorySpec: QuickSpec {
    override func spec() {
        var repository: ShopAppArticleRepository!
        var apiMock: APIMock!
        
        beforeEach {
            apiMock = APIMock()
            repository = ShopAppArticleRepository(api: apiMock)
        }
        
        describe("when article list should be get") {
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
                    
                    repository.getArticleList(perPage: perPage, paginationValue: paginationValue, sortBy: sortBy, reverse: reverse) { (result, error) in
                        expect(apiMock.isGetArticleListStarted) == true
                        
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
                    
                    repository.getArticleList(perPage: perPage, paginationValue: paginationValue, sortBy: sortBy, reverse: reverse) { (result, error) in
                        expect(apiMock.isGetArticleListStarted) == true
                        
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
        
        describe("when article should be get") {
            var id: String!
            
            beforeEach {
                id = "id"
            }
            
            context("if callback has result") {
                it("needs to handle result") {
                    apiMock.isNeedToReturnError = false
                    
                    repository.getArticle(id: id) { (result, error) in
                        expect(apiMock.isGetArticleStarted) == true
                        
                        expect(apiMock.id) == id
                        
                        expect(result).toNot(beNil())
                        expect(error).to(beNil())
                    }
                }
            }
            
            context("if callback has error") {
                it("needs to handle error") {
                    apiMock.isNeedToReturnError = true
                    
                    repository.getArticle(id: id) { (result, error) in
                        expect(apiMock.isGetArticleStarted) == true
                        
                        expect(apiMock.id) == id
                        
                        expect(result).to(beNil())
                        expect(error).toNot(beNil())
                    }
                }
            }
        }
    }
}
