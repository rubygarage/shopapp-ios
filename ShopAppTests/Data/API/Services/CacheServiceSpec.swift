//
//  CacheServiceSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 6/11/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick

@testable import ShopApp

class CacheServiceSpec: QuickSpec {
    override func spec() {
        let key = "key"
        let value = "value"
        var cache: NSCache<NSString, CacheObject>!
        var cacheService: CacheService!
        
        beforeEach {
            cache = NSCache<NSString, CacheObject>()
            cacheService = CacheService(cache: cache)
        }
        
        describe("when object should be set") {
            it("needs to set object") {
                cacheService.setObject(value, forKey: key)
                
                let cachedData = cache.object(forKey: key as NSString)?.data as? String
                
                expect(cachedData) == value
            }
        }
        
        describe("when object should be gotten") {
            context("if object wasn't set") {
                it("needs to return nil") {
                    let cachedObject = cacheService.object(forKey: key) as? String

                    expect(cachedObject).to(beNil())
                }
            }
            
            context("if object's max age wasn't set") {
                it("needs to return object") {
                    let cacheObject = CacheObject(data: value)
                    cache.setObject(cacheObject, forKey: key as NSString)
                    
                    let cachedObject = cacheService.object(forKey: key) as? String
                    
                    expect(cachedObject) == value
                }
            }
            
            context("if object's age expired") {
                it("needs to remove cached data and return nil") {
                    let cacheObject = CacheObject(data: value, maxAge: TimeInterval(0))
                    cache.setObject(cacheObject, forKey: key as NSString)
                    
                    let cachedObject = cacheService.object(forKey: key) as? String
                    let cachedData = cache.object(forKey: key as NSString)
                    
                    expect(cachedObject).to(beNil())
                    expect(cachedData).to(beNil())
                }
            }
            
            context("if object's age doesn't expired") {
                it("needs to return object") {
                    let cacheObject = CacheObject(data: value, maxAge: TimeInterval(1))
                    cache.setObject(cacheObject, forKey: key as NSString)
                    
                     let cachedObject = cacheService.object(forKey: key) as? String
                    
                    expect(cachedObject) == value
                }
            }
        }
    }
}
