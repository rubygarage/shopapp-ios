//
//  ShopAppSetupProviderRepositorySpec.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 6/14/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class ShopAppSetupProviderRepositorySpec: QuickSpec {
    override func spec() {
        var repository: ShopAppSetupProviderRepository!
        var apiMock: APIMock!
        
        beforeEach {
            apiMock = APIMock()
            repository = ShopAppSetupProviderRepository(api: apiMock)
        }
        
        describe("when provider should be setup") {
            context("if callback has result") {
                it("needs to handle result") {
                    apiMock.isNeedToReturnError = false
                    
                    repository.setupProvider(callback: { (_, error) in
                        expect(apiMock.isSetupProviderStarted) == true
                        
                        expect(error).to(beNil())
                    })
                }
            }
            
            context("if callback has error") {
                it("needs to handle error") {
                    apiMock.isNeedToReturnError = true
                    
                    repository.setupProvider(callback: { (_, error) in
                        expect(apiMock.isSetupProviderStarted) == true
                        
                        expect(error).toNot(beNil())
                    })
                }
            }
        }
    }
}
