//
//  ShopifyCategoryAdapter.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/8/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import MobileBuySDK

extension Storefront.CollectionEdge: CategoryEdgeEntityInterface {
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
    
    var entityUpdatedAt: Date? {
        get {
            return node.updatedAt
        }
    }
    
    var entityPaginationValue: Any? {
        get {
            return cursor
        }
    }
    
    var entityImage: ImageEntityInterface? {
        get {
            return node.image
        }
    }
}

/*
class ShopifyCategoryAdapter: Category {
    init(category: Storefront.Collection, cursor: String? = nil, currencyCode: String, detailsNedded: Bool = false) {
        super.init()
        
        id = category.id.rawValue
        title = category.title
        categoryDescription = category.description
        updatedAt = category.updatedAt
        paginationValue = cursor
        if let image = category.image {
            self.image = ShopifyImageAdapter(image: image)
        }
        if detailsNedded {
            categoryDetails = ShopifyCategoryDetailsAdapter(productsCollection: category, currencyCode: currencyCode)
        }
    }
}
 */
