//
//  ProductVariantRepository.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 10/17/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import MagicalRecord

class ProductVariantRepository {
    class func loadVariants(with items: [ProductVariantEntityEnterface], in context: NSManagedObjectContext) -> [ProductVariant] {
        for variantInterface in items {
            let variant = ProductVariant.mr_findFirstOrCreate(byAttribute: "id", withValue: variantInterface.entityId, in: context)
            variant.update(with: variantInterface, in: context)
        }
        let variantsIds = items.map({ $0.entityId })
        let predicate = NSPredicate(format: "id IN %@", variantsIds)
        return ProductVariant.mr_findAll(with: predicate, in: context) as? [ProductVariant] ?? [ProductVariant]()
    }
    
    class func loadVariant(with item: ProductVariantEntityEnterface, in context: NSManagedObjectContext) -> ProductVariant {
        let variant = ProductVariant.mr_findFirstOrCreate(byAttribute: "id", withValue: item.entityId, in: context)
        variant.update(with: item, in: context)
        return variant
    }
}

internal extension ProductVariant {
    func update(with remoteItem: ProductVariantEntityEnterface?, in context: NSManagedObjectContext) {
        id = remoteItem?.entityId
        title = remoteItem?.entityTitle
        price = remoteItem?.entityPrice
        available = remoteItem?.entityAvailable ?? false
        if let remoteImage = remoteItem?.entityImage {
            image = ImageRepository.loadImage(with: remoteImage, in: context)
        }
    }
}
