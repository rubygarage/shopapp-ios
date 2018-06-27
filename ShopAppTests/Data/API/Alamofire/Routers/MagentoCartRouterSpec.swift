//
//  MagentoCartRouterSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 6/26/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Alamofire
import Nimble
import Quick

@testable import ShopApp

class MagentoCartRouterSpec: QuickSpec {
    override func spec() {
        describe("when build request method used") {
            let url = RouterTestHelper.url
            let body = RequestBodyTest(key: "value")
            let data = try? JSONSerialization.data(withJSONObject: ["cartItem": body.parameters!])
            let token = "token"
            let quoteId = "quoteId"
            let itemId = "itemId"
            
            context("if create quote authorized route used") {
                it("needs to create url request with set url and route") {
                    let urlString = url.absoluteString + "carts/mine"
                    let route = MagentoCartRoute.createQuoteAuthorized(token: token)
                    let router = MagentoCartRouter(route: route)
                    let urlRequest = try? router.buildRequest(with: url)
                    
                    self.check(urlRequest, with: urlString, method: .post, token: token)
                }
            }
            
            context("if create quote unauthorized route used") {
                it("needs to create url request with set url and route") {
                    let urlString = url.absoluteString + "guest-carts"
                    let route = MagentoCartRoute.createQuoteUnauthorized
                    let router = MagentoCartRouter(route: route)
                    let urlRequest = try? router.buildRequest(with: url)
                    
                    self.check(urlRequest, with: urlString, method: .post)
                }
            }

            context("if get cart products authorized route used") {
                it("needs to create url request with set url and route") {
                    let urlString = url.absoluteString + "carts/mine/items"
                    let route = MagentoCartRoute.getCartProductsAuthorized(token: token)
                    let router = MagentoCartRouter(route: route)
                    let urlRequest = try? router.buildRequest(with: url)
                    
                    self.check(urlRequest, with: urlString, method: .get, token: token)
                }
            }
            
            context("if get cart products unauthorized route used") {
                it("needs to create url request with set url and route") {
                    let urlString = url.absoluteString + "guest-carts/\(quoteId)/items"
                    let route = MagentoCartRoute.getCartProductsUnauthorized(quoteId: quoteId)
                    let router = MagentoCartRouter(route: route)
                    let urlRequest = try? router.buildRequest(with: url)
                    
                    self.check(urlRequest, with: urlString, method: .get)
                }
            }

            context("if add cart product authorized route used") {
                it("needs to create url request with set url and route") {
                    let urlString = url.absoluteString + "carts/mine/items"
                    let route = MagentoCartRoute.addCartProductAuthorized(token: token, body: body)
                    let router = MagentoCartRouter(route: route)
                    let urlRequest = try? router.buildRequest(with: url)
                    
                    self.check(urlRequest, with: urlString, method: .post, data: data, token: token)
                }
            }
            
            context("if add cart product unauthorized route used") {
                it("needs to create url request with set url and route") {
                    let urlString = url.absoluteString + "guest-carts/\(quoteId)/items"
                    let route = MagentoCartRoute.addCartProductUnauthorized(quoteId: quoteId, body: body)
                    let router = MagentoCartRouter(route: route)
                    let urlRequest = try? router.buildRequest(with: url)
                    
                    self.check(urlRequest, with: urlString, method: .post, data: data)
                }
            }

            context("if change cart product quantity authorized route used") {
                it("needs to create url request with set url and route") {
                    let urlString = url.absoluteString + "carts/mine/items/\(itemId)"
                    let route = MagentoCartRoute.changeCartProductQuantityAuthorized(token: token, itemId: itemId, body: body)
                    let router = MagentoCartRouter(route: route)
                    let urlRequest = try? router.buildRequest(with: url)
                    
                    self.check(urlRequest, with: urlString, method: .put, data: data, token: token)
                }
            }
            
            context("if change cart product quantity unauthorized route used") {
                it("needs to create url request with set url and route") {
                    let urlString = url.absoluteString + "guest-carts/\(quoteId)/items/\(itemId)"
                    let route = MagentoCartRoute.changeCartProductQuantityUnauthorized(quoteId: quoteId, itemId: itemId, body: body)
                    let router = MagentoCartRouter(route: route)
                    let urlRequest = try? router.buildRequest(with: url)
                    
                    self.check(urlRequest, with: urlString, method: .put, data: data)
                }
            }

            context("if delete cart product authorized route used") {
                it("needs to create url request with set url and route") {
                    let urlString = url.absoluteString + "carts/mine/items/\(itemId)"
                    let route = MagentoCartRoute.deleteCartProductAuthorized(token: token, quoteId: quoteId, itemId: itemId)
                    let router = MagentoCartRouter(route: route)
                    let urlRequest = try? router.buildRequest(with: url)
                    
                    self.check(urlRequest, with: urlString, method: .delete, token: token)
                }
            }
            
            context("if delete cart product unauthorized route used") {
                it("needs to create url request with set url and route") {
                    let urlString = url.absoluteString + "guest-carts/\(quoteId)/items/\(itemId)"
                    let route = MagentoCartRoute.deleteCartProductUnauthorized(quoteId: quoteId, itemId: itemId)
                    let router = MagentoCartRouter(route: route)
                    let urlRequest = try? router.buildRequest(with: url)
                    
                    self.check(urlRequest, with: urlString, method: .delete)
                }
            }
        }
    }
    
    private func check(_ urlRequest: URLRequest?, with urlString: String, method: HTTPMethod, data: Data? = nil, token: String? = nil) {
        let router = BaseRouter()
        
        expect(urlRequest?.url?.absoluteString) == urlString
        expect(urlRequest?.httpMethod) == method.rawValue
        
        if let data = data {
            expect(urlRequest?.httpBody) == data
        } else {
            expect(urlRequest?.httpBody).to(beNil())
        }
        
        if let token = token {
            let authorizationValue = String(format: router.authorizationBearerValue, arguments: [token])
            var fields = [router.authorizationKey: authorizationValue]
            
            if data != nil {
                fields[router.contentTypeKey] = router.contentTypeJsonValue
            }
            
            expect(urlRequest?.allHTTPHeaderFields) == fields
        } else if (method.rawValue == HTTPMethod.post.rawValue || method.rawValue == HTTPMethod.put.rawValue) && data != nil {
            expect(urlRequest?.allHTTPHeaderFields) == [router.contentTypeKey: router.contentTypeJsonValue]
        } else {
            expect(urlRequest?.allHTTPHeaderFields) == [:]
        }
    }
}
