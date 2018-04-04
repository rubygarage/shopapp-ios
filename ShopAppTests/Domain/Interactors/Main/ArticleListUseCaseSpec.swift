//
//  ArticleListUseCaseSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 4/3/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class ArticleListUseCaseSpec: QuickSpec {
    override func spec() {
        var useCase: ArticleListUseCase!
        var repositoryMock: ArticleRepositoryMock!
        
        beforeEach {
            repositoryMock = ArticleRepositoryMock()
            useCase = ArticleListUseCase(repository: repositoryMock)
        }
        
        describe("when reversed article list should be get") {
            context("if callback has result") {
                it("needs to handle result") {
                    repositoryMock.isNeedToReturnError = false
                    
                    useCase.getReverseArticleList() { (result, error) in
                        expect(repositoryMock.isGetArticleListStarted) == true
                        
                        expect(repositoryMock.perPage) == kItemsPerPage
                        expect(repositoryMock.reverse) == true
                        
                        expect(result).toNot(beNil())
                        expect(error).to(beNil())
                    }
                }
            }
            
            context("if callback has error") {
                it("needs to handle error") {
                    repositoryMock.isNeedToReturnError = true
                    
                    useCase.getReverseArticleList() { (result, error) in
                        expect(repositoryMock.isGetArticleListStarted) == true
                        
                        expect(repositoryMock.perPage) == kItemsPerPage
                        expect(repositoryMock.reverse) == true
                        
                        expect(result).to(beNil())
                        expect(error).toNot(beNil())
                    }
                }
            }
        }
        
        describe("when article list should be get") {
            var paginationValue: String!
            
            beforeEach {
                paginationValue = "pagination"
            }
            
            context("if callback has result") {
                it("needs to handle result") {
                    repositoryMock.isNeedToReturnError = false
                    
                    useCase.getArticleList(with: paginationValue) { (result, error) in
                        expect(repositoryMock.isGetArticleListStarted) == true
                        
                        expect(repositoryMock.perPage) == kItemsPerPage
                        expect(repositoryMock.paginationValue) == paginationValue
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
                    
                    useCase.getArticleList(with: paginationValue) { (result, error) in
                        expect(repositoryMock.isGetArticleListStarted) == true
                        
                        expect(repositoryMock.perPage) == kItemsPerPage
                        expect(repositoryMock.paginationValue) == paginationValue
                        expect(repositoryMock.sortBy?.rawValue) == SortingValue.createdAt.rawValue
                        expect(repositoryMock.reverse) == true
                        
                        expect(result).to(beNil())
                        expect(error).toNot(beNil())
                    }
                }
            }
        }
    }
}
