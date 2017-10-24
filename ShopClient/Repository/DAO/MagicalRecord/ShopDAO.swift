//
//  ShopDAO.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 10/23/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import MagicalRecord

extension DAO {
    func save(shopObject: ShopObject, callback: @escaping () -> ()) {
        MagicalRecord.save({ [weak self] (context) in
            if let shop = self?.getShop(in: context) {
                self?.update(shop: shop, with: shopObject)
            }
        }) { (contextDidSave, error) in
            callback()
        }
    }
    
    // MARK: - private
    private func getShop(in context: NSManagedObjectContext) -> ShopEntity? {
        var shop = ShopEntity.mr_findFirst(in: context)
        if shop == nil {
            shop = ShopEntity.mr_createEntity(in: context)
        }
        return shop
    }
    
    private func update(shop: ShopEntity, with item: ShopObject) {
        shop.name = item.name
        shop.shopDescription = item.shopDescription
    }
}
