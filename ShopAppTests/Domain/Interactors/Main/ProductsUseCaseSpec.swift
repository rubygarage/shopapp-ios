//
//  ProductsUseCaseSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 4/3/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class ProductsUseCaseSpec: QuickSpec {
    override func spec() {
        var useCase: ProductsUseCase!
        var repositoryMock: ProductRepositoryMock!
        
        beforeEach {
            repositoryMock = ProductRepositoryMock()
            useCase = ProductsUseCase(repository: repositoryMock)
        }
        
        describe("when last arrival product list should be get") {
            context("if callback has result") {
                it("needs to handle result") {
                    repositoryMock.isNeedToReturnError = false
                    
                    useCase.getLastArrivalProducts() { (result, error) in
                        expect(repositoryMock.isGetProductListStarted) == true
                        
                        expect(repositoryMock.perPage) == kItemsPerPage
                        expect(repositoryMock.sortBy?.rawValue) == SortType.recent.rawValue

                        expect(result).toNot(beNil())
                        expect(error).to(beNil())
                    }
                }
            }
            
            context("if callback has error") {
                it("needs to handle error") {
                    repositoryMock.isNeedToReturnError = true
                    
                    useCase.getLastArrivalProducts() { (result, error) in
                        expect(repositoryMock.isGetProductListStarted) == true
                        
                        expect(repositoryMock.perPage) == kItemsPerPage
                        expect(repositoryMock.sortBy?.rawValue) == SortType.recent.rawValue

                        expect(result).to(beNil())
                        expect(error).toNot(beNil())
                    }
                }
            }
        }
        
        describe("when popular product list should be get") {
            context("if callback has result") {
                it("needs to handle result") {
                    repositoryMock.isNeedToReturnError = false
                    
                    useCase.getPopularProducts() { (result, error) in
                        expect(repositoryMock.isGetProductListStarted) == true
                        
                        expect(repositoryMock.perPage) == 4
                        expect(repositoryMock.sortBy?.rawValue) == SortType.relevant.rawValue

                        expect(result).toNot(beNil())
                        expect(error).to(beNil())
                    }
                }
            }
            
            context("if callback has error") {
                it("needs to handle error") {
                    repositoryMock.isNeedToReturnError = true
                    
                    useCase.getPopularProducts() { (result, error) in
                        expect(repositoryMock.isGetProductListStarted) == true
                        
                        expect(repositoryMock.perPage) == 4
                        expect(repositoryMock.sortBy?.rawValue) == SortType.relevant.rawValue

                        expect(result).to(beNil())
                        expect(error).toNot(beNil())
                    }
                }
            }
        }
        
        describe("when product list should be get") {
            var paginationValue: String!
            var sortBy: SortType!
            var keyword: String!
            var excludeKeyword: String!

            beforeEach {
                paginationValue = "pagination"
                sortBy = .name
                keyword = "key"
                excludeKeyword = "exclude"
            }
            
            context("if callback has result") {
                it("needs to handle result") {
                    repositoryMock.isNeedToReturnError = false
                    
                    useCase.getProducts(paginationValue: paginationValue, sortBy: sortBy, keyword: keyword, excludeKeyword: excludeKeyword) { (result, error) in
                        expect(repositoryMock.isGetProductListStarted) == true
                        
                        expect(repositoryMock.perPage) == kItemsPerPage
                        expect(repositoryMock.paginationValue) == paginationValue
                        expect(repositoryMock.sortBy?.rawValue) == sortBy.rawValue
                        expect(repositoryMock.keyword) == keyword
                        expect(repositoryMock.excludeKeyword) == excludeKeyword

                        expect(result).toNot(beNil())
                        expect(error).to(beNil())
                    }
                }
            }
            
            context("if callback has error") {
                it("needs to handle error") {
                    repositoryMock.isNeedToReturnError = true
                    
                    useCase.getProducts(paginationValue: paginationValue, sortBy: sortBy, keyword: keyword, excludeKeyword: excludeKeyword) { (result, error) in
                        expect(repositoryMock.isGetProductListStarted) == true
                        
                        expect(repositoryMock.perPage) == kItemsPerPage
                        expect(repositoryMock.paginationValue) == paginationValue
                        expect(repositoryMock.sortBy?.rawValue) == sortBy.rawValue
                        expect(repositoryMock.keyword) == keyword
                        expect(repositoryMock.excludeKeyword) == excludeKeyword

                        expect(result).to(beNil())
                        expect(error).toNot(beNil())
                    }
                }
            }
        }
        
        describe("when product list should be get with search phrase") {
            var paginationValue: String!
            var searchPhrase: String!
            
            beforeEach {
                paginationValue = "pagination"
                searchPhrase = "search"
            }
            
            context("if callback has result") {
                it("needs to handle result") {
                    repositoryMock.isNeedToReturnError = false
                    
                    useCase.getProducts(paginationValue: paginationValue, searchPhrase: searchPhrase) { (result, error) in
                        expect(repositoryMock.isSearchProductsStarted) == true
                        
                        expect(repositoryMock.perPage) == kItemsPerPage
                        expect(repositoryMock.paginationValue) == paginationValue
                        expect(repositoryMock.query) == searchPhrase
                        
                        expect(result).toNot(beNil())
                        expect(error).to(beNil())
                    }
                }
            }
            
            context("if callback has error") {
                it("needs to handle error") {
                    repositoryMock.isNeedToReturnError = true
                    
                    useCase.getProducts(paginationValue: paginationValue, searchPhrase: searchPhrase) { (result, error) in
                        expect(repositoryMock.isSearchProductsStarted) == true
                        
                        expect(repositoryMock.perPage) == kItemsPerPage
                        expect(repositoryMock.paginationValue) == paginationValue
                        expect(repositoryMock.query) == searchPhrase
                        
                        expect(result).to(beNil())
                        expect(error).toNot(beNil())
                    }
                }
            }
        }
    }
}
