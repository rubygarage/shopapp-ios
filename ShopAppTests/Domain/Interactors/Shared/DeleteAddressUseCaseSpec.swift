//
//  DeleteAddressUseCaseSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 4/3/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class DeleteAddressUseCaseSpec: QuickSpec {
    override func spec() {
        var useCase: DeleteAddressUseCase!
        var repositoryMock: CustomerRepositoryMock!
        
        beforeEach {
            repositoryMock = CustomerRepositoryMock()
            useCase = DeleteAddressUseCase(repository: repositoryMock)
        }
        
        describe("when user's address should be delete") {
            var addressId: String!
            
            beforeEach {
                addressId = "id"
            }
            
            context("if callback has result") {
                it("needs to handle result") {
                    repositoryMock.isNeedToReturnError = false
                    
                    useCase.deleteCustomerAddress(with: addressId) { (result, error) in
                        expect(repositoryMock.isDeleteCustomerAddressStarted) == true
                        
                        expect(repositoryMock.addressId) == addressId
                        
                        expect(result) == true
                        expect(error).to(beNil())
                    }
                }
            }
            
            context("if callback has error") {
                it("needs to handle error") {
                    repositoryMock.isNeedToReturnError = true
                    
                    useCase.deleteCustomerAddress(with: addressId) { (result, error) in
                        expect(repositoryMock.isDeleteCustomerAddressStarted) == true
                        
                        expect(repositoryMock.addressId) == addressId
                        
                        expect(result) == false
                        expect(error).toNot(beNil())
                    }
                }
            }
        }
    }
}
