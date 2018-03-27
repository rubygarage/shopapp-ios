//
//  ProductVariantEntityUpdateService.swift
//  ShopApp
//
//  Created by Evgeniy Antonov on 11/8/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import CoreStore
import ShopApp_Gateway

struct ProductVariantEntityUpdateService {
    static func update(_ entity: ProductVariantEntity?, with item: ProductVariant?, transaction: AsynchronousDataTransaction) {
        guard let entity = entity, let item = item else {
            return
        }
        
        entity.id = item.id
        entity.price = NSDecimalNumber(decimal: item.price ?? Decimal())
        entity.title = item.title
        entity.available = item.available
        entity.productId = item.productId
        
        if let selectedOptions = item.selectedOptions {
            selectedOptions.forEach {
                let variantOptionEntity: VariantOptionEntity = transaction.create(Into<VariantOptionEntity>())
                VariantOptionEntityUpdateService.update(variantOptionEntity, with: $0)
                entity.addToSelectedOptions(variantOptionEntity)
            }
        }
        
        if let imageItem = item.image {
            let predicate = NSPredicate(format: "id = %@", imageItem.id)
            let imageEntity: ImageEntity? = transaction.fetchOrCreate(predicate: predicate)
            ImageEntityUpdateService.update(imageEntity, with: imageItem)
            entity.image = imageEntity
        }
    }
}
