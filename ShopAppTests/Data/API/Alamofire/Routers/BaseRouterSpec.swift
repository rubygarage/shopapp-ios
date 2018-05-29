//
//  BaseRouterSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 5/18/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick

@testable import ShopApp

class BaseRouterSpec: QuickSpec {
    override func spec() {
        describe("when build request method used") {
            it("needs to create url request with set url") {
                let url = RouterTestHelper.url
                let router = BaseRouter()
                let urlRequest = try? router.buildRequest(with: url)
                
                expect(urlRequest?.url?.absoluteString) == url.absoluteString
            }
        }
        
        describe("when URLRequestConvertible protocol's method used") {
            it("needs to create url request with set host and base urls") {
                BaseRouter.hostUrl = RouterTestHelper.hostUrl
                BaseRouter.baseUrl = RouterTestHelper.baseUrl
                
                let router = BaseRouter()
                let urlRequest = try? router.asURLRequest()
                
                expect(urlRequest?.url?.absoluteString) == BaseRouter.hostUrl! + BaseRouter.baseUrl!
            }
        }
    }
}
