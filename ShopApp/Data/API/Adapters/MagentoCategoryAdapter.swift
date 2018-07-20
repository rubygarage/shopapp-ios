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
    private static let imageCatalogPath = "pub/media/catalog/category/"
    
    static func adapt(_ response: GetCategoryListResponse) -> Category {
        let id = String(response.id)
        let childrenCategories = response.childrenData.map { MagentoCategoryAdapter.adapt($0) }
        
        return Category(id: id, title: response.name, products: [], paginationValue: nil, childrenCategories: childrenCategories)
    }
    
    static func update(_ category: Category, with childrenCategories: [Category]) -> Category {
        let updatedChildrenCategories: [Category] = category.childrenCategories.map { childrenCategory in
            let image = childrenCategories.filter({ $0.id == childrenCategory.id }).first?.image
            return Category(id: childrenCategory.id, title: childrenCategory.title, image: image, products: childrenCategory.products, paginationValue: nil, childrenCategories: childrenCategory.childrenCategories)
        }
        
        return Category(id: category.id, title: category.title, products: category.products, paginationValue: nil, childrenCategories: updatedChildrenCategories)
    }
    
    static func adapt(_ response: GetCategoryDetailsResponse, products: [Product]) -> Category {
        let id = String(response.id)
        
        var image: Image?
        if let imageValue = response.customAttributes.filter({ $0.attributeCode == customAttributeImageCode }).first?.value.data, let adaptedImage = MagentoImageAdapter.adapt(imageValue, catalogPath: imageCatalogPath) {
            image = adaptedImage
        }
        
        return Category(id: id, title: response.name, image: image, products: products, paginationValue: nil, childrenCategories: [])
    }
}
