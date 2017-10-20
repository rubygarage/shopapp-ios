//
//  ShopifyImageAdapter.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/8/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import MobileBuySDK

extension Storefront.Image: ImageEntityInterface {
    var entityId: String {
        get {
            return id?.rawValue ?? String()
        }
    }
    
    var entitySrc: String? {
        get {
            return src.absoluteString
        }
    }
    
    var entityImageDescription: String? {
        get {
            return altText
        }
    }
}
