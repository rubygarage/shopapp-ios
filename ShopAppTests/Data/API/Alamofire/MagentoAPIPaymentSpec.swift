//
//  MagentoAPIPaymentSpec.swift
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

class MagentoAPIPaymentSpec: MagentoAPIBaseSpec {
    override func spec() {
        super.spec()
        
        let errorMessage = "error"
        
        let countriesJson = self.jsonObject(fromFileWithName: "Countries") as! [Any]
        
        describe("when user gets countries") {
            context("if response has error") {
                it("needs to return error") {
                    self.stubResponse(withErrorMessage: errorMessage)
                    
                    waitUntil { done in
                        self.api.getCountries() { (response, error) in
                            self.checkUnsuccessResponse(response, error: error, errorMessage: errorMessage)
                            
                            done()
                        }
                    }
                }
            }
            
            context("if response has objects") {
                it("needs to return countries") {
                    self.stubResponse(withObject: countriesJson)
                    
                    waitUntil { done in
                        self.api.getCountries() { (response, error) in
                            self.checkSuccessResponse(response, error: error, array: countriesJson)
                            
                            done()
                        }
                    }
                }
            }
        }
    }
}
