//
//  CoreDataProductVariantAdapter.swift
//  ShopApp
//
//  Created by Evgeniy Antonov on 11/9/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import ShopApp_Gateway

struct CoreDataProductVariantAdapter {
    static func adapt(item: ProductVariantEntity?) -> ProductVariant? {
        guard let item = item else {
            return nil
        }
        
        let productVariant = ProductVariant()
        productVariant.id = item.id ?? ""
        productVariant.price = item.price?.decimalValue
        productVariant.title = item.title
        productVariant.available = item.available
        productVariant.image = CoreDataImageAdapter.adapt(item: item.image)
        productVariant.productId = item.productId ?? ""
        
        productVariant.selectedOptions = item.selectedOptions?.map {
            let option = VariantOption()
            if let optionEntity = $0 as? VariantOptionEntity {
                option.name = optionEntity.name ?? ""
                option.value = optionEntity.value ?? ""
            }
            return option
        }
        
        return productVariant
    }
}
