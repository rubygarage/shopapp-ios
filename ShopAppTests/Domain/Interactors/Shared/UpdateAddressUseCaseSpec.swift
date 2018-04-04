//
//  UpdateAddressUseCaseSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 4/3/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class UpdateAddressUseCaseSpec: QuickSpec {
    override func spec() {
        var useCase: UpdateAddressUseCase!
        var repositoryMock: CustomerRepositoryMock!
        
        beforeEach {
            repositoryMock = CustomerRepositoryMock()
            useCase = UpdateAddressUseCase(repository: repositoryMock)
        }
        
        describe("when user's address should be update") {
            var address: Address!
            
            beforeEach {
                address = Address()
            }
            
            context("if callback has result") {
                it("needs to handle result") {
                    repositoryMock.isNeedToReturnError = false
                    
                    useCase.updateCustomerAddress(with: address) { (result, error) in
                        expect(repositoryMock.isUpdateCustomerAddressStarted) == true
                        
                        expect(repositoryMock.address) === address
                        
                        expect(result) == true
                        expect(error).to(beNil())
                    }
                }
            }
            
            context("if callback has error") {
                it("needs to handle error") {
                    repositoryMock.isNeedToReturnError = true
                    
                    useCase.updateCustomerAddress(with: address) { (result, error) in
                        expect(repositoryMock.isUpdateCustomerAddressStarted) == true
                        
                        expect(repositoryMock.address) === address
                        
                        expect(result) == false
                        expect(error).toNot(beNil())
                    }
                }
            }
        }
    }
}
