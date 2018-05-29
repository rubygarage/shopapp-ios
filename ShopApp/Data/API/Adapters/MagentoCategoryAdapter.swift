//
//  MagentoCategoryAdapter.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 5/10/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

struct MagentoCategoryAdapter {
    private static let customAttributeDescriptionCode = "description"
    private static let customAttributeImageCode = "image"
    private static let imageCatalogPath = "pub/media/catalog/category"
    
    static func adapt(_ response: GetCategoryListResponse) -> Category {
        let category = Category()
        category.id = String(response.id)
        category.title = response.name
        category.categoryDescription = ""
        category.updatedAt = Date()
        category.childrenCategories = response.childrenData.map { MagentoCategoryAdapter.adapt($0) }
        category.products = []
        category.additionalDescription = ""
        
        return category
    }
    
    static func adapt(_ response: GetCategoryDetailsResponse, products: [Product]) -> Category {
        let descriptionValue = response.customAttributes.filter({ $0.attributeCode == customAttributeDescriptionCode }).first?.value.data ?? ""
        
        let category = Category()
        category.id = String(response.id)
        category.title = response.name
        category.categoryDescription = descriptionValue.htmlToString
        category.updatedAt = response.updatedAt
        category.childrenCategories = []
        category.products = products
        category.additionalDescription = descriptionValue
        
        if let imageValue = response.customAttributes.filter({ $0.attributeCode == customAttributeImageCode }).first?.value.data, let image = MagentoImageAdapter.adapt(imageValue, catalogPath: imageCatalogPath) {
            category.image = image
        }
        
        return category
    }
}
