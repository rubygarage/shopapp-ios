//
//  OrderListUseCaseSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 4/2/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class OrderListUseCaseSpec: QuickSpec {
    override func spec() {
        var useCase: OrderListUseCase!
        var repositoryMock: OrderRepositoryMock!
        
        beforeEach {
            repositoryMock = OrderRepositoryMock()
            useCase = OrderListUseCase(repository: repositoryMock)
        }
        
        describe("when order list should be get") {
            var perPage: Int!
            var paginationValue: String!
            
            beforeEach {
                perPage = kItemsPerPage
                paginationValue = "pagination"
            }
            
            context("if callback has result") {
                it("needs to handle result") {
                    repositoryMock.isNeedToReturnError = false
                    
                    useCase.getOrderList(with: paginationValue) { (result, error) in
                        expect(repositoryMock.isGetOrderListStarted) == true
                        
                        expect(repositoryMock.perPage) == perPage
                        expect(repositoryMock.paginationValue) == paginationValue
                        
                        expect(result).toNot(beNil())
                        expect(error).to(beNil())
                    }
                }
            }
            
            context("if callback has error") {
                it("needs to handle error") {
                    repositoryMock.isNeedToReturnError = false
                    
                    useCase.getOrderList(with: paginationValue) { (result, error) in
                        expect(repositoryMock.isGetOrderListStarted) == true
                        
                        expect(repositoryMock.perPage) == perPage
                        expect(repositoryMock.paginationValue) == paginationValue
                        
                        expect(result).toNot(beNil())
                        expect(error).to(beNil())
                    }
                }
            }
        }
    }
}
