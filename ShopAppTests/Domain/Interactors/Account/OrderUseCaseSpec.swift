//
//  OrderUseCaseSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 4/2/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class OrderUseCaseSpec: QuickSpec {
    override func spec() {
        var useCase: OrderUseCase!
        var repositoryMock: OrderRepositoryMock!
        
        beforeEach {
            repositoryMock = OrderRepositoryMock()
            useCase = OrderUseCase(repository: repositoryMock)
        }
        
        describe("when order should be get") {
            var id: String!
            
            beforeEach {
                id = "id"
            }
            
            context("if callback has result") {
                it("needs to handle result") {
                    repositoryMock.isNeedToReturnError = false
                    
                    useCase.getOrder(with: id) { (result, error) in
                        expect(repositoryMock.isGetOrderStarted) == true
                        
                        expect(repositoryMock.id) == id
                        
                        expect(result).toNot(beNil())
                        expect(error).to(beNil())
                    }
                }
            }
            
            context("if callback has error") {
                it("needs to handle error") {
                    repositoryMock.isNeedToReturnError = true
                    
                    useCase.getOrder(with: id) { (result, error) in
                        expect(repositoryMock.isGetOrderStarted) == true
                        
                        expect(repositoryMock.id) == id
                        
                        expect(result).to(beNil())
                        expect(error).toNot(beNil())
                    }
                }
            }
        }
    }
}
