//
//  MagentoProductsRouterSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 5/18/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Alamofire
import Nimble
import Quick

@testable import ShopApp

class MagentoProductsRouterSpec: QuickSpec {
    override func spec() {
        describe("when build request method used") {
            let url = RouterTestHelper.url
            
            context("if get products route used") {
                it("needs to create url request with set url and route") {
                    let urlString = url.absoluteString + "products" + RouterTestHelper.parametersAsUrlParams
                    let route = MagentoProductsRoute.getProducts(parameters: RouterTestHelper.parameters)
                    let router = MagentoProductsRouter(route: route)
                    let urlRequest = try? router.buildRequest(with: url)
                    
                    self.check(urlRequest, with: urlString)
                }
            }
            
            context("if get product route used") {
                it("needs to create url request with set url and route") {
                    let sku = "sku"
                    let urlString = url.absoluteString + "products/" + sku
                    let route = MagentoProductsRoute.getProduct(sku: sku)
                    let router = MagentoProductsRouter(route: route)
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
