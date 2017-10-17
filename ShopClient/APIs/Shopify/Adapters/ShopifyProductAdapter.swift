//
//  ShopifyProductAdapter.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 8/31/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import MobileBuySDK

extension Storefront.Product: ProductEntityInterface {
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
    
    var entityProductDescription: String? {
        get {
            return description
        }
    }
    
    var entityCurrency: String? {
        get  {
            return nil
        }
    }
    
    var entityDiscount: String? {
        get  {
            return nil
        }
    }
    
    var entityImages: [ImageEntityInterface]? {
        get  {
            return images.edges.map({ $0.node })
        }
    }
    
    var entityType: String? {
        get  {
            return productType
        }
    }
    
    var entityVendor: String? {
        get  {
            return vendor
        }
    }
    
    var entityCreatedAt: Date? {
        get  {
            return createdAt
        }
    }
    
    var entityUpdatedAt: Date? {
        get  {
            return updatedAt
        }
    }
    
    var entityTags: [String]? {
        get  {
            return tags
        }
    }
    
    var entityPaginationValue: String? {
        get  {
            return nil
        }
    }
    
    var entityAdditionalDescription: String? {
        get {
            return descriptionHtml
        }
    }
    
    var entityVariants: [ProductVariantEntityEnterface]? {
        get {
            return variants.edges.map({ $0.node })
        }
    }
}
