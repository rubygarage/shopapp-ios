//
//  CartProductEntityUpdateService.swift
//  ShopApp
//
//  Created by Evgeniy Antonov on 11/8/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import CoreStore
import ShopApp_Gateway

struct CartProductEntityUpdateService {
    static func update(_ entity: CartProductEntity?, with item: CartProduct, transaction: AsynchronousDataTransaction) {
        guard let entity = entity else {
            return
        }
        
        entity.productId = item.productId
        entity.productTitle = item.productTitle
        entity.quantity = Int64(item.quantity)
        entity.currency = item.currency
        
        let predicate = NSPredicate(format: "id = %@", item.productVariant?.id ?? "")
        var variant: ProductVariantEntity?
        do {
            variant = try transaction.fetchOne(From<ProductVariantEntity>(), Where<ProductVariantEntity>(predicate))
        } catch {}
        if variant == nil {
            variant = transaction.create(Into<ProductVariantEntity>())
        }
        ProductVariantEntityUpdateService.update(variant, with: item.productVariant, transaction: transaction)
        entity.productVariant = variant
    }
}
