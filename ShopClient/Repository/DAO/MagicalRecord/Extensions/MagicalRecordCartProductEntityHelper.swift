//
//  MagicalRecordCartProductEntityHelper.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/8/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import MagicalRecord

extension CartProductEntity {
    func update(with item: CartProduct, context: NSManagedObjectContext) {
        productId = item.productId
        productTitle = item.productTitle
        currency = item.currency
        quantity = Int16(item.quantity)
        let variantId = item.productVariant?.id ?? String()
        let productVariantEntity = ProductVariantEntity.mr_findFirstOrCreate(byAttribute: "id", withValue: variantId, in: context)
        productVariantEntity.update(with: item.productVariant)
        productVariant = productVariantEntity
    }
}
