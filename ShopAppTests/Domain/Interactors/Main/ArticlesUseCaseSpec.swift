//
//  ArticlesUseCaseSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 4/3/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class ArticlesUseCaseSpec: QuickSpec {
    override func spec() {
        var useCase: ArticlesUseCase!
        var repositoryMock: ArticleRepositoryMock!
        
        beforeEach {
            repositoryMock = ArticleRepositoryMock()
            useCase = ArticlesUseCase(repository: repositoryMock)
        }
        
        describe("when article list should be get") {
            var paginationValue: String!
            
            beforeEach {
                paginationValue = "pagination"
            }
            
            context("if callback has result") {
                it("needs to handle result") {
                    repositoryMock.isNeedToReturnError = false
                    
                    useCase.getArticles(paginationValue: paginationValue) { (result, error) in
                        expect(repositoryMock.isGetArticleListStarted) == true
                        
                        expect(repositoryMock.perPage) == kItemsPerPage
                        expect(repositoryMock.paginationValue) == paginationValue
                        expect(repositoryMock.sortBy?.rawValue) == SortType.createdAt.rawValue

                        expect(result).toNot(beNil())
                        expect(error).to(beNil())
                    }
                }
            }
            
            context("if callback has error") {
                it("needs to handle error") {
                    repositoryMock.isNeedToReturnError = true
                    
                    useCase.getArticles(paginationValue: paginationValue) { (result, error) in
                        expect(repositoryMock.isGetArticleListStarted) == true
                        
                        expect(repositoryMock.perPage) == kItemsPerPage
                        expect(repositoryMock.paginationValue) == paginationValue
                        expect(repositoryMock.sortBy?.rawValue) == SortType.createdAt.rawValue
                        
                        expect(result).to(beNil())
                        expect(error).toNot(beNil())
                    }
                }
            }
        }
    }
}
