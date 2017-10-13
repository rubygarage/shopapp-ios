//
//  ShopifyOptionAdapter.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/29/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import MobileBuySDK

extension Storefront.ProductOption: ProductOptionEntityInterface {
    var entityId: String {
        get {
            return id.rawValue
        }
    }
    
    var entityName: String {
        get {
            return name
        }
    }
    
    var entityValues: [String] {
        get {
            return values
        }
    }
}
