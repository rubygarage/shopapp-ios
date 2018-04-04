//
//  CountriesUseCaseSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 4/3/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class CountriesUseCaseSpec: QuickSpec {
    override func spec() {
        var useCase: CountriesUseCase!
        var repositoryMock: PaymentsRepositoryMock!
        
        beforeEach {
            repositoryMock = PaymentsRepositoryMock()
            useCase = CountriesUseCase(repository: repositoryMock)
        }
        
        describe("when countries should be get") {
            context("if callback has result") {
                it("needs to handle result") {
                    repositoryMock.isNeedToReturnError = false
                    
                    useCase.getCountries() { (result, error) in
                        expect(repositoryMock.isGetCountriesStarted) == true
                        
                        expect(result).toNot(beNil())
                        expect(error).to(beNil())
                    }
                }
            }
            
            context("if callback has error") {
                it("needs to handle error") {
                    repositoryMock.isNeedToReturnError = true
                    
                    useCase.getCountries() { (result, error) in
                        expect(repositoryMock.isGetCountriesStarted) == true
                        
                        expect(result).to(beNil())
                        expect(error).toNot(beNil())
                    }
                }
            }
        }
    }
}
