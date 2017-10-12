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
    class func loadCategories(with items: [CategoryEdgeEntityInterface], currencyCode: String?, callback: @escaping ((_ categories: [Category]?, _ error: Error?) -> ())) {
        MagicalRecord.save({ (context) in
            for categoryInterface in items {
                let category = Category.mr_findFirstOrCreate(byAttribute: "id", withValue: categoryInterface.entityId, in: context)
                category.update(with: categoryInterface, currencyCode: currencyCode, in: context)
            }
        }) { (contextDidSave, error) in
            let categoriesIds = items.map({ $0.entityId })
            let predicate = NSPredicate(format: "id IN %@", categoriesIds)
            let categories = Category.mr_findAll(with: predicate) as? [Category]
            callback(categories, error)
        }
    }
    
    class func loadCategory(with item: CategoryEntityInterface, currencyCode: String?, callback: @escaping ((_ category: Category?, _ error: Error?) -> ())) {
        MagicalRecord.save({ (context) in
            let category = Category.mr_findFirstOrCreate(byAttribute: "id", withValue: item.entityId, in: context)
            category.update(with: item, currencyCode: currencyCode, in: context)
        }) { (contextDidSave, error) in
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
}

internal extension Category {
    func update(with remoteItem: CategoryEdgeEntityInterface?, currencyCode: String?, in context: NSManagedObjectContext) {
        id = remoteItem?.entityId
        title = remoteItem?.entityTitle
        categoryDescription = remoteItem?.entityCategoryDescription
        updatedAt = remoteItem?.entityUpdatedAt as NSDate?
        paginationValue = remoteItem?.entityPaginationValue as? NSObject
        if let remoteImage = remoteItem?.entityImage {
            image = ImageRepository.loadImage(with: remoteImage, in: context)
        }
    }
    
    func update(with remoteItem: CategoryEntityInterface?, currencyCode: String?, in context: NSManagedObjectContext) {
        id = remoteItem?.entityId
        title = remoteItem?.entityTitle
        categoryDescription = remoteItem?.entityCategoryDescription
        updatedAt = remoteItem?.entityUpdatedAt as NSDate?
        if let remoteImage = remoteItem?.entityImage {
            image = ImageRepository.loadImage(with: remoteImage, in: context)
        }
    }
}
