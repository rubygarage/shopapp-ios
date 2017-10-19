//
//  MagicalRecordProductVariantRepository.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 10/19/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import MagicalRecord

extension MagicalRecordRepository {
    func loadVariants(with items: [ProductVariantEntityEnterface], in context: NSManagedObjectContext) -> [ProductVariant] {
        for variantInterface in items {
            let variant = ProductVariant.mr_findFirstOrCreate(byAttribute: "id", withValue: variantInterface.entityId, in: context)
            update(variant: variant, with: variantInterface, in: context)
        }
        let variantsIds = items.map({ $0.entityId })
        let predicate = NSPredicate(format: "id IN %@", variantsIds)
        return ProductVariant.mr_findAll(with: predicate, in: context) as? [ProductVariant] ?? [ProductVariant]()
    }
    
    func loadVariant(with item: ProductVariantEntityEnterface, in context: NSManagedObjectContext) -> ProductVariant {
        let variant = ProductVariant.mr_findFirstOrCreate(byAttribute: "id", withValue: item.entityId, in: context)
        update(variant: variant, with: item, in: context)
        return variant
    }
    
    // MARK: - private
    private func update(variant: ProductVariant, with remoteItem: ProductVariantEntityEnterface?, in context: NSManagedObjectContext) {
        variant.id = remoteItem?.entityId
        variant.title = remoteItem?.entityTitle
        variant.price = remoteItem?.entityPrice
        variant.available = remoteItem?.entityAvailable ?? false
        if let remoteImage = remoteItem?.entityImage {
            variant.image = loadImage(with: remoteImage, in: context)
        }
    }
}
