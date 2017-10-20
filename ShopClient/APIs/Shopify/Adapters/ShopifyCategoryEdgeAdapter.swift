//
//  ShopifyCategoryAdapter.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/8/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import MobileBuySDK

extension Storefront.CollectionEdge: CategoryEntityInterface {
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
    
    var entityCategoryDescription: String? {
        get {
            return node.description
        }
    }
    
    var entityAdditionalDescription: String? {
        get {
            return nil
        }
    }
    
    var entityUpdatedAt: Date? {
        get {
            return node.updatedAt
        }
    }
    
    var entityImage: ImageEntityInterface? {
        get {
            return node.image
        }
    }
    
    var entityPaginationValue: Any? {
        get {
            return cursor
        }
    }
    
    var entityProducts: [ProductEntityInterface]? {
        get {
            return nil
        }
    }
}
