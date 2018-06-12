//
//  CacheService.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 6/11/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Foundation

class CacheService {
    private let cache: NSCache<NSString, CacheObject>
    
    init(cache: NSCache<NSString, CacheObject> = NSCache<NSString, CacheObject>()) {
        self.cache = cache
    }
    
    func object(forKey key: String) -> Any? {
        guard let cachedObject = cache.object(forKey: key as NSString) else {
            return nil
        }
        
        guard let maxAge = cachedObject.maxAge else {
            return cachedObject.data
        }
        
        let difference = Date().timeIntervalSince(cachedObject.cachedDate)
        
        guard difference < maxAge else {
            removeObject(forKey: key)
            
            return nil
        }
        
        return cachedObject.data
    }
    
    func setObject(_ object: Any, forKey key: String, maxAge: TimeInterval? = nil) {
        let cacheObject = CacheObject(data: object, maxAge: maxAge)
        cache.setObject(cacheObject, forKey: key as NSString)
    }
    
    private func removeObject(forKey key: String) {
        cache.removeObject(forKey: key as NSString)
    }
}

class CacheObject {
    let data: Any
    let cachedDate: Date
    let maxAge: TimeInterval?
    
    init(data: Any, cachedDate: Date = Date(), maxAge: TimeInterval? = nil) {
        self.maxAge = maxAge
        self.cachedDate = cachedDate
        self.data = data
    }
}
