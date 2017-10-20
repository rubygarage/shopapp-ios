//
//  ShopifyProductEdgeAdapter.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 10/13/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import MobileBuySDK

extension Storefront.ProductEdge: ProductEntityInterface {
    var entityId: String {
        get {
            return node.id.rawValue
        }
    }
    
    var entityTitle: String? {
        get {
            return node.title
        }
    }
    
    var entityProductDescription: String? {
        get {
            return node.description
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
            return node.images.edges.map({ $0.node })
        }
    }
    
    var entityType: String? {
        get  {
            return node.productType
        }
    }
    
    var entityVendor: String? {
        get  {
            return node.vendor
        }
    }
    
    var entityCreatedAt: Date? {
        get  {
            return node.createdAt
        }
    }
    
    var entityUpdatedAt: Date? {
        get  {
            return node.updatedAt
        }
    }
    
    var entityTags: [String]? {
        get  {
            return node.tags
        }
    }
    
    var entityPaginationValue: String? {
        get  {
            return cursor
        }
    }
    
    var entityAdditionalDescription: String? {
        get {
            return nil
        }
    }
    
    var entityVariants: [ProductVariantEntityEnterface]? {
        get {
            return node.variants.edges.map({ $0.node })
        }
    }
    
    var entityOptions: [ProductOptionEntityInterface]? {
        get {
            return node.options
        }
    }
    
    var entityVariantBySelectedOptions: ProductVariantEntityEnterface? {
        get {
            return nil
        }
    }
}
