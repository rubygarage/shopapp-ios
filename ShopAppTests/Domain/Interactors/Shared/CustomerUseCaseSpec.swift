//
//  CustomerUseCaseSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 4/3/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class CustomerUseCaseSpec: QuickSpec {
    override func spec() {
        var useCase: CustomerUseCase!
        var repositoryMock: CustomerRepositoryMock!
        
        beforeEach {
            repositoryMock = CustomerRepositoryMock()
            useCase = CustomerUseCase(repository: repositoryMock)
        }
        
        describe("when user should be get") {
            context("if callback has result") {
                it("needs to handle result") {
                    repositoryMock.isNeedToReturnError = false
                    
                    useCase.getCustomer() { (result, error) in
                        expect(repositoryMock.isGetCustomerStarted) == true
                        
                        expect(result).toNot(beNil())
                        expect(error).to(beNil())
                    }
                }
            }
            
            context("if callback has error") {
                it("needs to handle error") {
                    repositoryMock.isNeedToReturnError = true
                    
                    useCase.getCustomer() { (result, error) in
                        expect(repositoryMock.isGetCustomerStarted) == true
                        
                        expect(result).to(beNil())
                        expect(error).toNot(beNil())
                    }
                }
            }
        }
    }
}
