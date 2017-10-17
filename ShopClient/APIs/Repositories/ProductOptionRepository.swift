//
//  ProductOptionRepository.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 10/13/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import MagicalRecord

class ProductOptionRepository {
    class func loadOptions(with items: [ProductOptionEntityInterface], in context: NSManagedObjectContext) -> [ProductOption] {
        for optionInterface in items {
            let option = ProductOption.mr_findFirstOrCreate(byAttribute: "id", withValue: optionInterface.entityId, in: context)
            option.update(with: optionInterface, in: context)
        }
        let optionsIds = items.map({ $0.entityId })
        let predicate = NSPredicate(format: "id IN %@", optionsIds)
        return ProductOption.mr_findAll(with: predicate, in: context) as? [ProductOption] ?? [ProductOption]()
    }
}

internal extension ProductOption {
    func update(with remoteItem: ProductOptionEntityInterface?, in context: NSManagedObjectContext) {
        id = remoteItem?.entityId
        name = remoteItem?.entityName
        values = remoteItem?.entityValues as NSObject?
    }
}
