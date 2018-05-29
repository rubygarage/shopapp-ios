//
//  MagentoCustomerRouterSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 5/18/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Alamofire
import Nimble
import Quick

@testable import ShopApp

class MagentoCustomerRouterSpec: QuickSpec {
    override func spec() {
        describe("when build request method used") {
            let url = RouterTestHelper.url
            let body = RequestBodyTest(key: "value")
            let data = try? JSONSerialization.data(withJSONObject: body.parameters!)
            let token = "token"
            
            context("if sign up route used") {
                it("needs to create url request with set url and route") {
                    let urlString = url.absoluteString + "customers"
                    let route = MagentoCustomerRoute.signUp(body: body)
                    let router = MagentoCustomerRouter(route: route)
                    let urlRequest = try? router.buildRequest(with: url)
                    
                    self.check(urlRequest, with: urlString, method: .post, data: data)
                }
            }
            
            context("if get token route used") {
                it("needs to create url request with set url and route") {
                    let urlString = url.absoluteString + "integration/customer/token"
                    let route = MagentoCustomerRoute.getToken(body: body)
                    let router = MagentoCustomerRouter(route: route)
                    let urlRequest = try? router.buildRequest(with: url)
                    
                    self.check(urlRequest, with: urlString, method: .post, data: data)
                }
            }
            
            context("if get customer route used") {
                it("needs to create url request with set url and route") {
                    let urlString = url.absoluteString + "customers/me"
                    let route = MagentoCustomerRoute.getCustomer(token: token)
                    let router = MagentoCustomerRouter(route: route)
                    let urlRequest = try? router.buildRequest(with: url)
                    
                    self.check(urlRequest, with: urlString, method: .get, token: token)
                }
            }
            
            context("if update password route used") {
                it("needs to create url request with set url and route") {
                    let urlString = url.absoluteString + "customers/me/password"
                    let route = MagentoCustomerRoute.updatePassword(token:token, body: body)
                    let router = MagentoCustomerRouter(route: route)
                    let urlRequest = try? router.buildRequest(with: url)
                    
                    self.check(urlRequest, with: urlString, method: .put, data: data, token: token)
                }
            }
            
            context("if reset password route used") {
                it("needs to create url request with set url and route") {
                    let urlString = url.absoluteString + "customers/password"
                    let route = MagentoCustomerRoute.resetPassword(body: body)
                    let router = MagentoCustomerRouter(route: route)
                    let urlRequest = try? router.buildRequest(with: url)
                    
                    self.check(urlRequest, with: urlString, method: .put, data: data)
                }
            }
            
            context("if update customer route used") {
                it("needs to create url request with set url and route") {
                    let urlString = url.absoluteString + "customers/me"
                    let route = MagentoCustomerRoute.updateCustomer(token:token, body: body)
                    let router = MagentoCustomerRouter(route: route)
                    let urlRequest = try? router.buildRequest(with: url)
                    
                    self.check(urlRequest, with: urlString, method: .put, data: data, token: token)
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
        } else {
            expect(urlRequest?.allHTTPHeaderFields) == [router.contentTypeKey: router.contentTypeJsonValue]
        }
    }
}
