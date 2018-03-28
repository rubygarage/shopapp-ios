//
//  ShopAppPaymentsRepositorySpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/28/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick

import ShopApp_Gateway

@testable import ShopApp

class ShopAppPaymentsRepositorySpec: QuickSpec {
    override func spec() {
        var repository: ShopAppPaymentsRepository!
        var apiMock: APIMock!
        
        beforeEach {
            apiMock = APIMock()
            repository = ShopAppPaymentsRepository(api: apiMock)
        }
        
        describe("") {
            
        }
    }
}
