//
//  ShopAppCartRepositorySpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/28/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick

import ShopApp_Gateway

@testable import ShopApp

class ShopAppCartRepositorySpec: QuickSpec {
    override func spec() {
        var repository: ShopAppCartRepository!
        var daoMock: DAOMock!
        
        beforeEach {
            daoMock = DAOMock()
            repository = ShopAppCartRepository(dao: daoMock)
        }
        
        describe("") {
            
        }
    }
}
