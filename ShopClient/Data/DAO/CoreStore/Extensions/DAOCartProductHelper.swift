//
//  DAOCartProductHelper.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/8/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import CoreStore

extension CartProductEntity {
    func update(with item: CartProduct, transaction: AsynchronousDataTransaction) {
        productId = item.productId
        productTitle = item.productTitle
        quantity = Int16(item.quantity)
        currency = item.currency
        
        let predicate = NSPredicate(format: "id = %@", item.productVariant?.id ?? "")
        var variant = transaction.fetchOne(From<ProductVariantEntity>(), Where(predicate))
        if variant == nil {
            variant = transaction.create(Into<ProductVariantEntity>())
        }
        variant?.update(with: item.productVariant, transaction: transaction)
        productVariant = variant
    }
}
