//
//  MagentoPaymentsRouterSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 5/18/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Alamofire
import Nimble
import Quick

@testable import ShopApp

class MagentoPaymentsRouterSpec: QuickSpec {
    override func spec() {
        describe("when build request method used") {
            let url = RouterTestHelper.url
            
            context("if get countries route used") {
                it("needs to create url request with set url and route") {
                    let urlString = url.absoluteString + "directory/countries"
                    let route = MagentoPaymentsRoute.getCountries
                    let router = MagentoPaymentsRouter(route: route)
                    let urlRequest = try? router.buildRequest(with: url)
                    
                    self.check(urlRequest, with: urlString)
                }
            }
        }
    }
    
    private func check(_ urlRequest: URLRequest?, with urlString: String) {
        expect(urlRequest?.url?.absoluteString) == urlString
        expect(urlRequest?.httpMethod) == HTTPMethod.get.rawValue
        expect(urlRequest?.allHTTPHeaderFields) == [BaseRouter.cacheControlMaxAgeKey: "3600"]
    }
}
