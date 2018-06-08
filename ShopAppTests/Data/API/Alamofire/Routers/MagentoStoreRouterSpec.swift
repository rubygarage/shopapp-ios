//
//  MagentoStoreRouterSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 5/18/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Alamofire
import Nimble
import Quick

@testable import ShopApp

class MagentoStoreRouterSpec: QuickSpec {
    override func spec() {
        describe("when build request method used") {
            let url = RouterTestHelper.url
            
            context("if get configs route used") {
                it("needs to create url request with set url and route") {
                    let urlString = url.absoluteString + "store/storeConfigs"
                    let route = MagentoStoreRoute.getConfigs
                    let router = MagentoStoreRouter(route: route)
                    let urlRequest = try? router.buildRequest(with: url)
                    
                    self.check(urlRequest, with: urlString)
                }
            }
        }
    }
    
    private func check(_ urlRequest: URLRequest?, with urlString: String) {
        let router = BaseRouter()
        
        expect(urlRequest?.url?.absoluteString) == urlString
        expect(urlRequest?.httpMethod) == HTTPMethod.get.rawValue
        expect(urlRequest?.allHTTPHeaderFields) == [router.contentTypeKey: router.contentTypeJsonValue]
    }
}
