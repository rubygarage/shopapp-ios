//
//  CartValidationUseCaseSpec.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 4/26/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick

@testable import ShopApp

class CartValidationUseCaseSpec: QuickSpec {
    override func spec() {
        var useCase: CartValidationUseCase!
        var repositoryMock: ProductRepositoryMock!
        
        beforeEach {
            repositoryMock = ProductRepositoryMock()
            useCase = CartValidationUseCase(repository: repositoryMock)
        }
        
        describe("when product variant list should be get") {
            var ids: [String]!
            
            beforeEach {
                ids = ["id"]
            }
            
            context("if callback has result") {
                it("needs to handle result") {
                    repositoryMock.isNeedToReturnError = false
                    
                    useCase.getProductVariantList(ids: ids) { (result, error) in
                        expect(repositoryMock.isGetProductVariantListStarted) == true
                        
                        expect(repositoryMock.ids) == ids
                        
                        expect(result).toNot(beNil())
                        expect(error).to(beNil())
                    }
                }
            }
            
            context("if callback has error") {
                it("needs to handle error") {
                    repositoryMock.isNeedToReturnError = true
                    
                    useCase.getProductVariantList(ids: ids) { (result, error) in
                        expect(repositoryMock.isGetProductVariantListStarted) == true
                        
                        expect(repositoryMock.ids) == ids
                        
                        expect(result).to(beNil())
                        expect(error).toNot(beNil())
                    }
                }
            }
        }
    }
}
