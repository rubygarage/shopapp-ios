//
//  CacheServiceMock.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 6/12/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Foundation

@testable import ShopApp

class CacheServiceMock: CacheService {
    var object: Any?
    var key: String?
    var maxAge: TimeInterval?
    
    override func object(forKey key: String) -> Any? {
        return object
    }
    
    override func setObject(_ object: Any, forKey key: String, maxAge: TimeInterval?) {
        self.object = object
        self.key = key
        self.maxAge = maxAge
    }
}
