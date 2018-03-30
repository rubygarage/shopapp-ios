//
//  ShopAppShopRepositorySpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/28/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick

import ShopApp_Gateway

@testable import ShopApp

class ShopAppShopRepositorySpec: QuickSpec {
    override func spec() {
        var repository: ShopAppShopRepository!
        var apiMock: APIMock!
        
        beforeEach {
            apiMock = APIMock()
            repository = ShopAppShopRepository(api: apiMock)
        }
        
        describe("when shop should be get") {
            context("if callback has result") {
                it("needs to handle result") {
                    apiMock.isNeedToReturnError = false
                    
                    repository.getShop() { (result, error) in
                        expect(apiMock.isGetShopInfoStarted) == true
                        
                        expect(result).toNot(beNil())
                        expect(error).to(beNil())
                    }
                }
            }
            
            context("if callback has error") {
                it("needs to handle error") {
                    apiMock.isNeedToReturnError = true
                    
                    repository.getShop() { (result, error) in
                        expect(apiMock.isGetShopInfoStarted) == true
                        
                        expect(result).to(beNil())
                        expect(error).toNot(beNil())
                    }
                }
            }
        }
    }
}
