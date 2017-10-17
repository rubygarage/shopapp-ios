//
//  CategoryRepository.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 10/11/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import MagicalRecord

class CategoryRepository {
    // MARK: - public    
    class func loadCategories(with items: [CategoryEntityInterface], callback: @escaping ((_ categories: [Category]?, _ error: Error?) -> ())) {
        updateCategory(with: items) { (error) in
            let categoriesIds = items.map({ $0.entityId })
            let predicate = NSPredicate(format: "id IN %@", categoriesIds)
            let categories = Category.mr_findAll(with: predicate) as? [Category]
            callback(categories, error)
        }
    }
    
    class func loadCategory(with item: CategoryEntityInterface, callback: @escaping ((_ category: Category?, _ error: Error?) -> ())) {
        updateCategory(with: [item]) { (error) in
            let category = Category.mr_findFirst(byAttribute: "id", withValue: item.entityId)
            callback(category, error)
        }
    }
    
    class func getCategories() -> [Category] {
        return Category.mr_findAll() as? [Category] ?? [Category]()
    }
    
    class func getCategory(with id: String) -> Category? {
        return Category.mr_findFirst(byAttribute: "id", withValue: id)
    }
    
    // MARK: - private
    private class func updateCategory(with items: [CategoryEntityInterface], callback: @escaping ((_ error: Error?) -> ())) {
        MagicalRecord.save({ (context) in
            for categoryInterface in items {
                let category = Category.mr_findFirstOrCreate(byAttribute: "id", withValue: categoryInterface.entityId, in: context)
                category.update(with: categoryInterface, in: context)
            }
        }) { (contextDidSave, error) in
            callback(error)
        }
    }
}

internal extension Category {
    func update(with remoteItem: CategoryEntityInterface?, in context: NSManagedObjectContext) {
        id = remoteItem?.entityId
        title = remoteItem?.entityTitle
        categoryDescription = remoteItem?.entityCategoryDescription
        updatedAt = remoteItem?.entityUpdatedAt as NSDate?
        paginationValue = remoteItem?.entityPaginationValue as? NSObject
        if let remoteAdditionalDescription = remoteItem?.entityAdditionalDescription {
            additionalDescription = remoteAdditionalDescription
        }
        if let remoteImage = remoteItem?.entityImage {
            image = ImageRepository.loadImage(with: remoteImage, in: context)
        }
        if let remoteProducts = remoteItem?.entityProducts {
            addToProducts(NSSet(array: ProductRepository.loadProducts(with: remoteProducts, in: context)))
        }
    }
}
