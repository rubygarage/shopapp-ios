//
//  ShopAppCategoryRepositorySpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/28/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick

import ShopApp_Gateway

@testable import ShopApp

class ShopAppCategoryRepositorySpec: QuickSpec {
    override func spec() {
        var repository: ShopAppCategoryRepository!
        var apiMock: APIMock!
        
        beforeEach {
            apiMock = APIMock()
            repository = ShopAppCategoryRepository(api: apiMock)
        }
        
        describe("") {
            
        }
    }
}
