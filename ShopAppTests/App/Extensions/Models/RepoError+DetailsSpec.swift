//
//  RepoError+DetailsSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/23/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class RepoError_DetailsSpec: QuickSpec {
    override func spec() {
        describe("when localized message used") {
            var error: RepoError!
            
            context("if error has message") {
                it("needs to return message") {
                    let message = "Message"
                    error = RepoError(with: message)
                    
                    expect(error.localizedMessage) == message
                }
            }
            
            context("if error hasn't message") {
                it("needs to return localizable unknown error") {
                    error = RepoError()
                    
                    expect(error.localizedMessage) == "Error.Unknown".localizable
                }
            }
        }
    }
}
