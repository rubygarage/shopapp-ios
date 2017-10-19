//
//  MagialRecordProductOptionRepository.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 10/19/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import MagicalRecord

extension MagicalRecordRepository {
    func loadOptions(with items: [ProductOptionEntityInterface], in context: NSManagedObjectContext) -> [ProductOption] {
        for optionInterface in items {
            let option = ProductOption.mr_findFirstOrCreate(byAttribute: "id", withValue: optionInterface.entityId, in: context)
            update(option: option, with: optionInterface, in: context)
        }
        let optionsIds = items.map({ $0.entityId })
        let predicate = NSPredicate(format: "id IN %@", optionsIds)
        return ProductOption.mr_findAll(with: predicate, in: context) as? [ProductOption] ?? [ProductOption]()
    }
    
    // MARK: - private
    private func update(option: ProductOption, with remoteItem: ProductOptionEntityInterface?, in context: NSManagedObjectContext) {
        option.id = remoteItem?.entityId
        option.name = remoteItem?.entityName
        option.values = remoteItem?.entityValues as NSObject?
    }
}
