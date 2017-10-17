//
//  ProductRepository.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 10/13/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import MagicalRecord

class ProductRepository {
    // MARK: - public
    class func loadProducts(with items: [ProductEntityInterface], in context: NSManagedObjectContext) -> [Product] {
        for productInterface in items {
            let product = Product.mr_findFirstOrCreate(byAttribute: "id", withValue: productInterface.entityId, in: context)
            product.update(with: productInterface, in: context)
        }
        let productsIds = items.map({ $0.entityId })
        let predicate = NSPredicate(format: "id IN %@", productsIds)
        return Product.mr_findAll(with: predicate, in: context) as? [Product] ?? [Product]()
    }
    
    class func loadProducts(with items: [ProductEntityInterface], callback: @escaping ((_ products: [Product]?, _ error: Error?) -> ())) {
        updateProducts(with: items) { (error) in
            let productsIds = items.map({ $0.entityId })
            let predicate = NSPredicate(format: "id IN %@", productsIds)
            let products = Product.mr_findAll(with: predicate) as? [Product]
            callback(products, error)
        }
    }
    
    class func loadProduct(with item: ProductEntityInterface, callback: @escaping ((_ product: Product?, _ error: Error?) -> ())) {
        updateProducts(with: [item]) { (error) in
            let product = Product.mr_findFirst(byAttribute: "id", withValue: item.entityId)
            callback(product, error)
        }
    }
    
    // MARK: - private
    private class func updateProducts(with items: [ProductEntityInterface], callback: @escaping ((_ error: Error?) -> ())) {
        MagicalRecord.save({ (context) in
            for productInterface in items {
                let product = Product.mr_findFirstOrCreate(byAttribute: "id", withValue: productInterface.entityId, in: context)
                product.update(with: productInterface, in: context)
            }
        }) { (contextDidSave, error) in
            callback(error)
        }
    }
}

internal extension Product {
    func update(with remoteItem: ProductEntityInterface?, in context: NSManagedObjectContext) {
        id = remoteItem?.entityId
        title = remoteItem?.entityTitle
        productDescription = remoteItem?.entityProductDescription
        discount = remoteItem?.entityDiscount
        type = remoteItem?.entityType
        vendor = remoteItem?.entityVendor
        createdAt = remoteItem?.entityCreatedAt as NSDate?
        updatedAt = remoteItem?.entityUpdatedAt as NSDate?
        tags = remoteItem?.entityTags as NSObject?
        paginationValue = remoteItem?.entityPaginationValue as NSObject?
        if let remoteImages = remoteItem?.entityImages {
            images = NSSet(array: ImageRepository.loadImages(with: remoteImages, in: context))
        }
        if let remoteVariants = remoteItem?.entityVariants {
            variants = NSSet(array: ProductVariantRepository.loadVariants(with: remoteVariants, in: context))
        }
        if let remoteOptions = remoteItem?.entityOptions {
            options = NSSet(array: ProductOptionRepository.loadOptions(with: remoteOptions, in: context))
        }
        if let remoteVariant = remoteItem?.entityVariantBySelectedOptions {
            variantBySelectedOptions = ProductVariantRepository.loadVariant(with: remoteVariant, in: context)
        } else {
            variantBySelectedOptions = nil
        }
    }
}
