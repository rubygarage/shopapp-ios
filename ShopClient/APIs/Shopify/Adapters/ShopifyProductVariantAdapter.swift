//
//  ShopifyProductVariantAdapter.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/8/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import MobileBuySDK

extension Storefront.ProductVariant: ProductVariantEntityEnterface {
    var entityId: String {
        get {
            return id.rawValue
        }
    }
    
    var entityTitle: String? {
        get {
            return title
        }
    }
    
    var entityPrice: String? {
        get {
            return price.description
        }
    }
    
    var entityAvailable: Bool {
        get {
            return availableForSale
        }
    }
    
    var entityImage: ImageEntityInterface? {
        get {
            return image
        }
    }
}
