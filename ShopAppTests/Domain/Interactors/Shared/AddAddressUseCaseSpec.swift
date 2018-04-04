//
//  AddAddressUseCaseSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 4/3/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class AddAddressUseCaseSpec: QuickSpec {
    override func spec() {
        var useCase: AddAddressUseCase!
        var repositoryMock: CustomerRepositoryMock!
        
        beforeEach {
            repositoryMock = CustomerRepositoryMock()
            useCase = AddAddressUseCase(repository: repositoryMock)
        }
        
        describe("when user's address should be add") {
            var address: Address!
            
            beforeEach {
                address = Address()
            }
            
            context("if callback has result") {
                it("needs to handle result") {
                    repositoryMock.isNeedToReturnError = false
                    
                    useCase.addAddress(with: address) { (result, error) in
                        expect(repositoryMock.isAddCustomerAddressStarted) == true
                        
                        expect(repositoryMock.address) === address
                        
                        expect(result).toNot(beNil())
                        expect(error).to(beNil())
                    }
                }
            }
            
            context("if callback has error") {
                it("needs to handle error") {
                    repositoryMock.isNeedToReturnError = true
                    
                    useCase.addAddress(with: address) { (result, error) in
                        expect(repositoryMock.isAddCustomerAddressStarted) == true
                        
                        expect(repositoryMock.address) === address
                        
                        expect(result).to(beNil())
                        expect(error).toNot(beNil())
                    }
                }
            }
        }
    }
}
