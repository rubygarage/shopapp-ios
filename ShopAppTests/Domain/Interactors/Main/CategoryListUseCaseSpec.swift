//
//  CategoryListUseCaseSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 4/3/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class CategoryListUseCaseSpec: QuickSpec {
    override func spec() {
        var useCase: CategoryListUseCase!
        var repositoryMock: CategoryRepositoryMock!
        
        beforeEach {
            repositoryMock = CategoryRepositoryMock()
            useCase = CategoryListUseCase(repository: repositoryMock)
        }
        
        describe("when category list should be get") {
            var paginationValue: String!
            
            beforeEach {
                paginationValue = "pagination"
            }
            
            context("if callback has result") {
                it("needs to handle result") {
                    repositoryMock.isNeedToReturnError = false
                    
                    useCase.getCategoryList(paginationValue: paginationValue) { (result, error) in
                        expect(repositoryMock.isGetCategoryListStarted) == true
                        
                        expect(repositoryMock.perPage) == kItemsPerPage
                        expect(repositoryMock.paginationValue) == paginationValue
                        expect(repositoryMock.reverse) == false
                        
                        expect(result).toNot(beNil())
                        expect(error).to(beNil())
                    }
                }
            }
            
            context("if callback has error") {
                it("needs to handle error") {
                    repositoryMock.isNeedToReturnError = true
                    
                    useCase.getCategoryList(paginationValue: paginationValue) { (result, error) in
                        expect(repositoryMock.isGetCategoryListStarted) == true
                        
                        expect(repositoryMock.perPage) == kItemsPerPage
                        expect(repositoryMock.paginationValue) == paginationValue
                        expect(repositoryMock.reverse) == false
                        
                        expect(result).to(beNil())
                        expect(error).toNot(beNil())
                    }
                }
            }
        }
    }
}
