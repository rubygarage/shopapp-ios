//
//  ProductUseCaseSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 4/3/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class ProductUseCaseSpec: QuickSpec {
    override func spec() {
        var useCase: ProductUseCase!
        var repositoryMock: ProductRepositoryMock!
        
        beforeEach {
            repositoryMock = ProductRepositoryMock()
            useCase = ProductUseCase(repository: repositoryMock)
        }
        
        describe("when product should be get") {
            var id: String!
            
            beforeEach {
                id = "id"
            }
            
            context("if callback has result") {
                it("needs to handle result") {
                    repositoryMock.isNeedToReturnError = false
                    
                    useCase.getProduct(with: id) { (result, error) in
                        expect(repositoryMock.isGetProductStarted) == true
                        
                        expect(repositoryMock.id) == id
                        
                        expect(result).toNot(beNil())
                        expect(error).to(beNil())
                    }
                }
            }
            
            context("if callback has error") {
                it("needs to handle error") {
                    repositoryMock.isNeedToReturnError = true
                    
                    useCase.getProduct(with: id) { (result, error) in
                        expect(repositoryMock.isGetProductStarted) == true
                        
                        expect(repositoryMock.id) == id
                        
                        expect(result).to(beNil())
                        expect(error).toNot(beNil())
                    }
                }
            }
        }
    }
}
