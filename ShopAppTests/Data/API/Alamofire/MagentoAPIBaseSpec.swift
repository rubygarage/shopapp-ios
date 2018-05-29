//
//  MagentoAPIBaseSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 5/21/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Alamofire
import Nimble
import OHHTTPStubs
import Quick
import ShopApp_Gateway

@testable import ShopApp

class MagentoAPIBaseSpec: QuickSpec {
    let host = "httpbin.org"
    
    var api: MagentoAPI!
    
    override func spec() {
        beforeEach {
            self.api = MagentoAPI(shopDomain: "https://" + self.host + "/")
        }
        
        afterEach {
            OHHTTPStubs.removeAllStubs()
        }
    }
    
    func jsonObject(fromFileWithName name: String) -> Any {
        let bundle = Bundle(for: type(of: self))
        let path = bundle.path(forResource: name, ofType: "json")!
        let url = URL(fileURLWithPath: path)
        let data = try! Data(contentsOf: url)
        
        return try! JSONSerialization.jsonObject(with: data)
    }
    
    func stubResponse(withErrorMessage message: String) {
        stub(condition: isHost(self.host)) { _ in
            let jsonObject = ["message": message]
            
            return OHHTTPStubsResponse(jsonObject: jsonObject, statusCode: 100, headers: nil)
        }
    }
    
    func stubResponse(withObject object: Any) {
        stub(condition: isHost(self.host)) { _ in
            return self.response(with: object, statusCode: 200)
        }
    }
    
    func stubResponse(withObjects objects: [Any], indexOfError: Int? = nil) {
        var index = 0
        
        stub(condition: isHost(self.host)) { _ in
            let object = objects[index]
            let code = index == indexOfError ?? objects.count ? 100 : 200
            
            index += 1

            return self.response(with: object, statusCode: code)
        }
    }
    
    func checkUnsuccessResponse(_ response: Any?, error: RepoError?, errorMessage: String? = nil) {
        expect(error).toNot(beNil())
        
        if let response = response as? Bool {
            expect(response) == false
        } else {
            expect(response).to(beNil())
        }
        
        if let errorMessage = errorMessage {
            expect(error?.errorMessage) == errorMessage
        }
    }
    
    func checkSuccessResponse(_ response: Any?, error: RepoError?, array: [Any]? = nil) {
        expect(error).to(beNil())
        
        if let response = response as? [Any] {
            expect(response.count) == array?.count
        } else if let response = response as? Bool {
            expect(response) == true
        }
    }
    
    private func response(with object: Any, statusCode: Int) -> OHHTTPStubsResponse {
        if let string = object as? String {
            let data = string.data(using: .utf8)!
            
            return OHHTTPStubsResponse(data: data, statusCode: Int32(statusCode), headers: nil)
        } else {
            return OHHTTPStubsResponse(jsonObject: object, statusCode: Int32(statusCode), headers: nil)
        }
    }
}
