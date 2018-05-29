//
//  BaseAPISpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 5/18/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Alamofire
import Nimble
import OHHTTPStubs
import Quick
import ShopApp_Gateway

@testable import ShopApp

class BaseAPISpec: QuickSpec {
    override func spec() {
        let host = "httpbin.org"
        let url = URL(string: "https://" + host)!
        let request = URLRequest(url: url)
        
        var api: BaseAPI!
        
        beforeEach {
            api = BaseAPI()
        }
        
        describe("when execute method used") {
            context("if response has error with message") {
                it("needs to return error") {
                    let message = "error"
                    
                    stub(condition: isHost(host)) { _ in
                        let jsonObject = ["message": message]
                        
                        return OHHTTPStubsResponse(jsonObject: jsonObject, statusCode: 100, headers: nil)
                    }
                    
                    waitUntil { done in
                        api.execute(request) { (response, error) in
                            expect(response).to(beNil())
                            expect(error is NonCriticalError) == true
                            expect(error?.errorMessage) == message
                            
                            done()
                        }
                    }
                }
            }
            
            context("if response has error without message") {
                it("needs to return error") {
                    stub(condition: isHost(host)) { _ in
                        let jsonObject = ["key": "value"]
                        
                        return OHHTTPStubsResponse(jsonObject: jsonObject, statusCode: 100, headers: nil)
                    }
                    
                    waitUntil { done in
                        api.execute(request) { (response, error) in
                            expect(response).to(beNil())
                            expect(error is ContentError) == true
                            expect(error?.errorMessage).to(beNil())
                            
                            done()
                        }
                    }
                }
            }
            
            context("if response has value") {
                it("needs to return value") {
                    let key = "key"
                    let value = "value"
                    
                    stub(condition: isHost(host)) { _ in
                        let jsonObject = [key: value]
                        
                        return OHHTTPStubsResponse(jsonObject: jsonObject, statusCode: 200, headers: nil)
                    }
                    
                    waitUntil { done in
                        api.execute(request) { (response, error) in
                            expect((response as? [String: Any])?[key] as? String) == value
                            expect(error).to(beNil())
                            
                            done()
                        }
                    }
                }
            }
        }

        afterEach {
            OHHTTPStubs.removeAllStubs()
        }
    }
}
