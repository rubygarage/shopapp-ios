//
//  CategoryUseCaseSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 4/3/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class CategoryUseCaseSpec: QuickSpec {
    override func spec() {
        var useCase: CategoryUseCase!
        var repositoryMock: CategoryRepositoryMock!
        
        beforeEach {
            repositoryMock = CategoryRepositoryMock()
            useCase = CategoryUseCase(repository: repositoryMock)
        }
        
        describe("when category should be get") {
            var id: String!
            var paginationValue: String!
            var sortingValue: SortingValue!
            var reverse: Bool!
            
            beforeEach {
                id = "id"
                paginationValue = "pagination"
                sortingValue = .name
                reverse = true
            }
            
            context("if callback has result") {
                it("needs to handle result") {
                    repositoryMock.isNeedToReturnError = false
                    
                    useCase.getCategory(with: id, paginationValue: paginationValue, sortingValue: sortingValue, reverse: reverse) { (result, error) in
                        expect(repositoryMock.isGetCategoryDetailsStarted) == true
                        
                        expect(repositoryMock.id) == id
                        expect(repositoryMock.perPage) == kItemsPerPage
                        expect(repositoryMock.paginationValue) == paginationValue
                        expect(repositoryMock.sortBy?.rawValue) == sortingValue.rawValue
                        expect(repositoryMock.reverse) == reverse
                        
                        expect(result).toNot(beNil())
                        expect(error).to(beNil())
                    }
                }
            }
            
            context("if callback has error") {
                it("needs to handle error") {
                    repositoryMock.isNeedToReturnError = true
                    
                    useCase.getCategory(with: id, paginationValue: paginationValue, sortingValue: sortingValue, reverse: reverse) { (result, error) in
                        expect(repositoryMock.isGetCategoryDetailsStarted) == true
                        
                        expect(repositoryMock.id) == id
                        expect(repositoryMock.perPage) == kItemsPerPage
                        expect(repositoryMock.paginationValue) == paginationValue
                        expect(repositoryMock.sortBy?.rawValue) == sortingValue.rawValue
                        expect(repositoryMock.reverse) == reverse
                        
                        expect(result).to(beNil())
                        expect(error).toNot(beNil())
                    }
                }
            }
        }
    }
}
