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
                address = TestHelper.fullAddress
            }
            
            context("if callback has result") {
                it("needs to handle result") {
                    repositoryMock.isNeedToReturnError = false
                    
                    useCase.updateCustomerAddress(address: address) { (_, error) in
                        expect(repositoryMock.isUpdateCustomerAddressStarted) == true
                        
                        expect(repositoryMock.address) == address
                        
                        expect(error).to(beNil())
                    }
                }
            }
            
            context("if callback has error") {
                it("needs to handle error") {
                    repositoryMock.isNeedToReturnError = true
                    
                    useCase.updateCustomerAddress(address: address) { (_, error) in
                        expect(repositoryMock.isUpdateCustomerAddressStarted) == true
                        
                        expect(repositoryMock.address) == address
                        
                        expect(error).toNot(beNil())
                    }
                }
            }
        }
    }
}
