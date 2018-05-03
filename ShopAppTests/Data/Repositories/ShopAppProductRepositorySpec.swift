//
//  ShopAppProductRepositorySpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/28/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class ShopAppProductRepositorySpec: QuickSpec {
    override func spec() {
        var repository: ShopAppProductRepository!
        var apiMock: APIMock!
        
        beforeEach {
            apiMock = APIMock()
            repository = ShopAppProductRepository(api: apiMock)
        }
        
        describe("when product list should be get") {
            var perPage: Int!
            var paginationValue: String!
            var sortBy: SortingValue!
            var keyPhrase: String!
            var excludePhrase: String!
            var reverse: Bool!
            
            beforeEach {
                perPage = 5
                paginationValue = "pagination"
                sortBy = .name
                keyPhrase = "key"
                excludePhrase = "exclude"
                reverse = true
            }
            
            context("if callback has result") {
                it("needs to handle result") {
                    apiMock.isNeedToReturnError = false
                    
                    repository.getProductList(perPage: perPage, paginationValue: paginationValue, sortBy: sortBy, keyPhrase: keyPhrase, excludePhrase: excludePhrase, reverse: reverse) { (result, error) in
                        expect(apiMock.isGetProductListStarted) == true
                        
                        expect(apiMock.perPage) == perPage
                        expect(apiMock.paginationValue) == paginationValue
                        expect(apiMock.sortBy?.rawValue) == sortBy.rawValue
                        expect(apiMock.keyPhrase) == keyPhrase
                        expect(apiMock.excludePhrase) == excludePhrase
                        expect(apiMock.reverse) == reverse
                        
                        expect(result).toNot(beNil())
                        expect(error).to(beNil())
                    }
                }
            }
            
            context("if callback has error") {
                it("needs to handle error") {
                    apiMock.isNeedToReturnError = true
                    
                    repository.getProductList(perPage: perPage, paginationValue: paginationValue, sortBy: sortBy, keyPhrase: keyPhrase, excludePhrase: excludePhrase, reverse: reverse) { (result, error) in
                        expect(apiMock.isGetProductListStarted) == true
                        
                        expect(apiMock.perPage) == perPage
                        expect(apiMock.paginationValue) == paginationValue
                        expect(apiMock.sortBy?.rawValue) == sortBy.rawValue
                        expect(apiMock.keyPhrase) == keyPhrase
                        expect(apiMock.excludePhrase) == excludePhrase
                        expect(apiMock.reverse) == reverse
                        
                        expect(result).to(beNil())
                        expect(error).toNot(beNil())
                    }
                }
            }
        }
        
        describe("when product should be get") {
            var id: String!
            
            beforeEach {
                id = "id"
            }
            
            context("if callback has result") {
                it("needs to handle result") {
                    apiMock.isNeedToReturnError = false
                    
                    repository.getProduct(id: id) { (result, error) in
                        expect(apiMock.isGetProductStarted) == true
                        
                        expect(apiMock.id) == id
                        
                        expect(result).toNot(beNil())
                        expect(error).to(beNil())
                    }
                }
            }
            
            context("if callback has error") {
                it("needs to handle error") {
                    apiMock.isNeedToReturnError = true
                    
                    repository.getProduct(id: id) { (result, error) in
                        expect(apiMock.isGetProductStarted) == true
                        
                        expect(apiMock.id) == id
                        
                        expect(result).to(beNil())
                        expect(error).toNot(beNil())
                    }
                }
            }
        }
        
        describe("when product should be search") {
            var perPage: Int!
            var paginationValue: String!
            var searchQuery: String!
            
            beforeEach {
                perPage = 5
                paginationValue = "pagination"
                searchQuery = "search"
            }
            
            context("if callback has result") {
                it("needs to handle result") {
                    apiMock.isNeedToReturnError = false
                    
                    repository.searchProducts(perPage: perPage, paginationValue: paginationValue, searchQuery: searchQuery) { (result, error) in
                        expect(apiMock.isSearchProductsStarted) == true
                        
                        expect(apiMock.perPage) == perPage
                        expect(apiMock.paginationValue) == paginationValue
                        expect(apiMock.searchQuery) == searchQuery
                        
                        expect(result).toNot(beNil())
                        expect(error).to(beNil())
                    }
                }
            }
            
            context("if callback has error") {
                it("needs to handle error") {
                    apiMock.isNeedToReturnError = true
                    
                    repository.searchProducts(perPage: perPage, paginationValue: paginationValue, searchQuery: searchQuery) { (result, error) in
                        expect(apiMock.isSearchProductsStarted) == true
                        
                        expect(apiMock.perPage) == perPage
                        expect(apiMock.paginationValue) == paginationValue
                        expect(apiMock.searchQuery) == searchQuery
                        
                        expect(result).to(beNil())
                        expect(error).toNot(beNil())
                    }
                }
            }
        }
        
        describe("when product variant list should be get") {
            var ids: [String]!
            
            beforeEach {
                ids = ["id1"]
            }
            
            context("if callback has result") {
                it("needs to handle result") {
                    apiMock.isNeedToReturnError = false
                    
                    repository.getProductVariantList(ids: ids) { (result, error) in
                        expect(apiMock.isGetProductVariantListStarted) == true
                        
                        expect(apiMock.ids) == ids
                        
                        expect(result).toNot(beNil())
                        expect(error).to(beNil())
                    }
                }
            }
            context("if callback has error") {
                it("needs to handle error") {
                    apiMock.isNeedToReturnError = true
                    
                    repository.getProductVariantList(ids: ids) { (result, error) in
                        expect(apiMock.isGetProductVariantListStarted) == true
                        
                        expect(apiMock.ids) == ids
                        
                        expect(result).to(beNil())
                        expect(error).toNot(beNil())
                    }
                }
            }
        }
    }
}
