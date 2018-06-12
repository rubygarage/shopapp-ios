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
        let key = "key"
        let value = "value"
        let jsonObject = [key: value]
        let host = "httpbin.org"
        let url = URL(string: "https://" + host)!
        
        var request = URLRequest(url: url)
        var cacheServiceMock: CacheServiceMock!
        var api: BaseAPI!
        
        beforeEach {
            cacheServiceMock = CacheServiceMock()
            api = BaseAPI(cacheService: cacheServiceMock)
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
                beforeEach {
                    request.allHTTPHeaderFields = [BaseRouter.cacheControlMaxAgeKey: "20"]
                }
                
                context("and value isn't cached") {
                    it("needs to cache value and return it") {
                        stub(condition: isHost(host)) { _ in
                            return OHHTTPStubsResponse(jsonObject: jsonObject, statusCode: 200, headers: nil)
                        }
                        
                        waitUntil { done in
                            api.execute(request) { (response, error) in
                                expect((response as? [String: Any])?[key] as? String) == value
                                expect(error).to(beNil())
                                expect(cacheServiceMock.object as? [String: String]) == jsonObject
                                expect(cacheServiceMock.key) == url.absoluteString
                                expect(cacheServiceMock.maxAge) == 20
                                
                                done()
                            }
                        }
                    }
                }
                
                context("and value is cached") {
                    it("needs to restore value from cache and return it") {
                        cacheServiceMock.object = jsonObject
                        
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
        }

        afterEach {
            OHHTTPStubs.removeAllStubs()
        }
    }
}
