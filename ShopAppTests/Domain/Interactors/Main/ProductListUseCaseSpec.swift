//
//  ProductListUseCaseSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 4/3/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class ProductListUseCaseSpec: QuickSpec {
    override func spec() {
        var useCase: ProductListUseCase!
        var repositoryMock: ProductRepositoryMock!
        
        beforeEach {
            repositoryMock = ProductRepositoryMock()
            useCase = ProductListUseCase(repository: repositoryMock)
        }
        
        describe("when last arrival product list should be get") {
            context("if callback has result") {
                it("needs to handle result") {
                    repositoryMock.isNeedToReturnError = false
                    
                    useCase.getLastArrivalProductList() { (result, error) in
                        expect(repositoryMock.isGetProductListStarted) == true
                        
                        expect(repositoryMock.perPage) == kItemsPerPage
                        expect(repositoryMock.sortBy?.rawValue) == SortingValue.createdAt.rawValue
                        expect(repositoryMock.reverse) == true
                        
                        expect(result).toNot(beNil())
                        expect(error).to(beNil())
                    }
                }
            }
            
            context("if callback has error") {
                it("needs to handle error") {
                    repositoryMock.isNeedToReturnError = true
                    
                    useCase.getLastArrivalProductList() { (result, error) in
                        expect(repositoryMock.isGetProductListStarted) == true
                        
                        expect(repositoryMock.perPage) == kItemsPerPage
                        expect(repositoryMock.sortBy?.rawValue) == SortingValue.createdAt.rawValue
                        expect(repositoryMock.reverse) == true
                        
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
                    
                    useCase.getPopularProductList() { (result, error) in
                        expect(repositoryMock.isGetProductListStarted) == true
                        
                        expect(repositoryMock.perPage) == 4
                        expect(repositoryMock.sortBy?.rawValue) == SortingValue.popular.rawValue
                        expect(repositoryMock.reverse) == false
                        
                        expect(result).toNot(beNil())
                        expect(error).to(beNil())
                    }
                }
            }
            
            context("if callback has error") {
                it("needs to handle error") {
                    repositoryMock.isNeedToReturnError = true
                    
                    useCase.getPopularProductList() { (result, error) in
                        expect(repositoryMock.isGetProductListStarted) == true
                        
                        expect(repositoryMock.perPage) == 4
                        expect(repositoryMock.sortBy?.rawValue) == SortingValue.popular.rawValue
                        expect(repositoryMock.reverse) == false
                        
                        expect(result).to(beNil())
                        expect(error).toNot(beNil())
                    }
                }
            }
        }
        
        describe("when product list should be get") {
            var paginationValue: String!
            var sortBy: SortingValue!
            var keyPhrase: String!
            var excludePhrase: String!
            var reverse: Bool!
            
            beforeEach {
                paginationValue = "pagination"
                sortBy = .name
                keyPhrase = "key"
                excludePhrase = "exclude"
                reverse = true
            }
            
            context("if callback has result") {
                it("needs to handle result") {
                    repositoryMock.isNeedToReturnError = false
                    
                    useCase.getProductList(with: paginationValue, sortingValue: sortBy, keyPhrase: keyPhrase, excludePhrase: excludePhrase, reverse: reverse) { (result, error) in
                        expect(repositoryMock.isGetProductListStarted) == true
                        
                        expect(repositoryMock.perPage) == kItemsPerPage
                        expect(repositoryMock.paginationValue) == paginationValue
                        expect(repositoryMock.sortBy?.rawValue) == sortBy.rawValue
                        expect(repositoryMock.keyPhrase) == keyPhrase
                        expect(repositoryMock.excludePhrase) == excludePhrase
                        expect(repositoryMock.reverse) == reverse
                        
                        expect(result).toNot(beNil())
                        expect(error).to(beNil())
                    }
                }
            }
            
            context("if callback has error") {
                it("needs to handle error") {
                    repositoryMock.isNeedToReturnError = true
                    
                    useCase.getProductList(with: paginationValue, sortingValue: sortBy, keyPhrase: keyPhrase, excludePhrase: excludePhrase, reverse: reverse) { (result, error) in
                        expect(repositoryMock.isGetProductListStarted) == true
                        
                        expect(repositoryMock.perPage) == kItemsPerPage
                        expect(repositoryMock.paginationValue) == paginationValue
                        expect(repositoryMock.sortBy?.rawValue) == sortBy.rawValue
                        expect(repositoryMock.keyPhrase) == keyPhrase
                        expect(repositoryMock.excludePhrase) == excludePhrase
                        expect(repositoryMock.reverse) == reverse
                        
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
                    
                    useCase.getProductList(with: paginationValue, searchPhrase: searchPhrase) { (result, error) in
                        expect(repositoryMock.isSearchProductsStarted) == true
                        
                        expect(repositoryMock.perPage) == kItemsPerPage
                        expect(repositoryMock.paginationValue) == paginationValue
                        expect(repositoryMock.searchQuery) == searchPhrase
                        
                        expect(result).toNot(beNil())
                        expect(error).to(beNil())
                    }
                }
            }
            
            context("if callback has error") {
                it("needs to handle error") {
                    repositoryMock.isNeedToReturnError = true
                    
                    useCase.getProductList(with: paginationValue, searchPhrase: searchPhrase) { (result, error) in
                        expect(repositoryMock.isSearchProductsStarted) == true
                        
                        expect(repositoryMock.perPage) == kItemsPerPage
                        expect(repositoryMock.paginationValue) == paginationValue
                        expect(repositoryMock.searchQuery) == searchPhrase
                        
                        expect(result).to(beNil())
                        expect(error).toNot(beNil())
                    }
                }
            }
        }
    }
}
