//
//  UpdateDefaultAddressUseCaseSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 4/3/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class UpdateDefaultAddressUseCaseSpec: QuickSpec {
    override func spec() {
        var useCase: UpdateDefaultAddressUseCase!
        var repositoryMock: CustomerRepositoryMock!
        
        beforeEach {
            repositoryMock = CustomerRepositoryMock()
            useCase = UpdateDefaultAddressUseCase(repository: repositoryMock)
        }
        
        describe("when user's address should be make as default") {
            var addressId: String!
            
            beforeEach {
                addressId = "id"
            }
            
            context("if callback has result") {
                it("needs to handle result") {
                    repositoryMock.isNeedToReturnError = false
                    
                    useCase.updateDefaultAddress(with: addressId) { (result, error) in
                        expect(repositoryMock.isUpdateCustomerDefaultAddressStarted) == true
                        
                        expect(repositoryMock.addressId) == addressId
                        
                        expect(result).toNot(beNil())
                        expect(error).to(beNil())
                    }
                }
            }
            
            context("if callback has error") {
                it("needs to handle error") {
                    repositoryMock.isNeedToReturnError = true
                    
                    useCase.updateDefaultAddress(with: addressId) { (result, error) in
                        expect(repositoryMock.isUpdateCustomerDefaultAddressStarted) == true
                        
                        expect(repositoryMock.addressId) == addressId
                        
                        expect(result).to(beNil())
                        expect(error).toNot(beNil())
                    }
                }
            }
        }
    }
}
