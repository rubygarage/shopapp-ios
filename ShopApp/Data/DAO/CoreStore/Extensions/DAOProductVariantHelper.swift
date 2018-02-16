//
//  DAOProductVariantHelper.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/8/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import CoreStore
import ShopApp_Gateway

extension ProductVariantEntity {
    func update(with item: ProductVariant?, transaction: AsynchronousDataTransaction) {
        guard let item = item else {
            return
        }
        
        id = item.id
        price = NSDecimalNumber(decimal: item.price ?? Decimal())
        title = item.title
        available = item.available
        productId = item.productId
        
        if let selectedOptions = item.selectedOptions {
            selectedOptions.forEach {
                let variantOptionEntity: VariantOptionEntity = transaction.create(Into<VariantOptionEntity>())
                variantOptionEntity.update(with: $0)
                addToSelectedOptions(variantOptionEntity)
            }
        }
        
        if let imageItem = item.image {
            let predicate = NSPredicate(format: "id = %@", imageItem.id)
            let imageEntity: ImageEntity? = transaction.fetchOrCreate(predicate: predicate)
            imageEntity?.update(with: imageItem)
            image = imageEntity
        }
    }
}
