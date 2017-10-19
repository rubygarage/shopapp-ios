//
//  MagicalRecordProductRepository.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 10/19/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import MagicalRecord

extension MagicalRecordRepository {
    func loadProducts(with items: [ProductEntityInterface], callback: @escaping ((_ products: [Product]?, _ error: Error?) -> ())) {
        updateProducts(with: items) { (error) in
            let productsIds = items.map({ $0.entityId })
            let predicate = NSPredicate(format: "id IN %@", productsIds)
            let products = Product.mr_findAll(with: predicate) as? [Product]
            callback(products, error)
        }
    }
    
    func loadProduct(with item: ProductEntityInterface, callback: @escaping ((_ product: Product?, _ error: Error?) -> ())) {
        updateProducts(with: [item]) { (error) in
            let product = Product.mr_findFirst(byAttribute: "id", withValue: item.entityId)
            callback(product, error)
        }
    }
    
    func loadProducts(with items: [ProductEntityInterface], in context: NSManagedObjectContext) -> [Product] {
        for productInterface in items {
            let product = Product.mr_findFirstOrCreate(byAttribute: "id", withValue: productInterface.entityId, in: context)
            update(product: product, with: productInterface, in: context)
        }
        let productsIds = items.map({ $0.entityId })
        let predicate = NSPredicate(format: "id IN %@", productsIds)
        return Product.mr_findAll(with: predicate, in: context) as? [Product] ?? [Product]()
    }
    
    // MARK: - private
    private func updateProducts(with items: [ProductEntityInterface], callback: @escaping ((_ error: Error?) -> ())) {
        MagicalRecord.save({ [weak self] (context) in
            for productInterface in items {
                let product = Product.mr_findFirstOrCreate(byAttribute: "id", withValue: productInterface.entityId, in: context)
                self?.update(product: product, with: productInterface, in: context)
            }
        }) { (contextDidSave, error) in
            callback(error)
        }
    }
    
    private func update(product: Product, with remoteItem: ProductEntityInterface?, in context: NSManagedObjectContext) {
        product.id = remoteItem?.entityId
        product.title = remoteItem?.entityTitle
        product.productDescription = remoteItem?.entityProductDescription
        product.discount = remoteItem?.entityDiscount
        product.type = remoteItem?.entityType
        product.vendor = remoteItem?.entityVendor
        product.createdAt = remoteItem?.entityCreatedAt as NSDate?
        product.updatedAt = remoteItem?.entityUpdatedAt as NSDate?
        product.tags = remoteItem?.entityTags as NSObject?
        product.paginationValue = remoteItem?.entityPaginationValue as NSObject?
        if let remoteImages = remoteItem?.entityImages {
            product.images = NSSet(array: loadImages(with: remoteImages, in: context))
        }
        if let remoteVariants = remoteItem?.entityVariants {
            product.variants = NSSet(array: loadVariants(with: remoteVariants, in: context))
        }
        if let remoteOptions = remoteItem?.entityOptions {
            product.options = NSSet(array: loadOptions(with: remoteOptions, in: context))
        }
        if let remoteVariant = remoteItem?.entityVariantBySelectedOptions {
            product.variantBySelectedOptions = loadVariant(with: remoteVariant, in: context)
        } else {
            product.variantBySelectedOptions = nil
        }
    }
}
