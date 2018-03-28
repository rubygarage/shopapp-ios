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
        
        describe("") {
            
        }
    }
}
