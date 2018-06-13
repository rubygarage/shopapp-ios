//
//  ShopAppCountryRepositorySpec.swift
//  ShopAppTests
//
//  Created by Mykola Voronin on 6/12/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class ShopAppCountryRepositorySpec: QuickSpec {
    override func spec() {
        var repository: ShopAppCountryRepository!
        var apiMock: APIMock!

        beforeEach {
            apiMock = APIMock()
            repository = ShopAppCountryRepository(api: apiMock)
        }

        describe("when countries should be get") {
            context("if callback has result") {
                it("needs to handle result") {
                    apiMock.isNeedToReturnError = false

                    repository.getCountries() { (result, error) in
                        expect(apiMock.isGetCountriesStarted) == true

                        expect(result).toNot(beNil())
                        expect(error).to(beNil())
                    }
                }
            }

            context("if callback has error") {
                it("needs to handle error") {
                    apiMock.isNeedToReturnError = true

                    repository.getCountries() { (result, error) in
                        expect(apiMock.isGetCountriesStarted) == true

                        expect(result).to(beNil())
                        expect(error).toNot(beNil())
                    }
                }
            }
        }
    }
}
