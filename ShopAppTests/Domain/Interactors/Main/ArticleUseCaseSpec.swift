//
//  ArticleUseCaseSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 4/3/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class ArticleUseCaseSpec: QuickSpec {
    override func spec() {
        var useCase: ArticleUseCase!
        var repositoryMock: ArticleRepositoryMock!
        
        beforeEach {
            repositoryMock = ArticleRepositoryMock()
            useCase = ArticleUseCase(repository: repositoryMock)
        }
        
        describe("when article should be get") {
            var id: String!
            
            beforeEach {
                id = "id"
            }
            
            context("if callback has result") {
                it("needs to handle result") {
                    repositoryMock.isNeedToReturnError = false
                    
                    useCase.getArticle(with: id) { (result, error) in
                        expect(repositoryMock.isGetArticleStarted) == true
                        
                        expect(repositoryMock.id) == id
                        
                        expect(result).toNot(beNil())
                        expect(error).to(beNil())
                    }
                }
            }
            
            context("if callback has error") {
                it("needs to handle error") {
                    repositoryMock.isNeedToReturnError = true
                    
                    useCase.getArticle(with: id) { (result, error) in
                        expect(repositoryMock.isGetArticleStarted) == true
                        
                        expect(repositoryMock.id) == id
                        
                        expect(result).to(beNil())
                        expect(error).toNot(beNil())
                    }
                }
            }
        }
    }
}
