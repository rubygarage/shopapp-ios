//
//  PaginationResponseSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 5/14/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick

@testable import ShopApp

class PaginationResponseSpec: QuickSpec {
    override func spec() {
        describe("when next pagination value generate") {
            var object: PaginationResponseTest!
            var paginationValue: Int?
            
            beforeEach {
                object = PaginationResponseTest(totalCount: 120)
            }
            
            context("if page exists") {
                it("should return next pagination value") {
                    paginationValue = object.nextPaginationValue(perPage: 50, currentPaginationValue: 1)
                    
                    expect(paginationValue) == 2
                }
            }
            
            context("if page doesn't exist") {
                it("should return nil") {
                    paginationValue = object.nextPaginationValue(perPage: 50, currentPaginationValue: 3)
                    
                    expect(paginationValue).to(beNil())
                }
            }
        }
    }
}

struct PaginationResponseTest: PaginationResponse {
    var totalCount: Int
}
