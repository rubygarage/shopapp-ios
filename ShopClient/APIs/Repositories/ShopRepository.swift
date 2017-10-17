//
//  ShopRepository.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 10/11/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import MagicalRecord

class ShopRepository {
    // MARK: - public
    class func loadShopInfo(with item: ShopEntityInterface?, callback: @escaping ((_ shop: Shop?, _ error: Error?) -> ())) {
        MagicalRecord.save({ (context) in
            let shop = getShop(in: context)
            shop?.update(with: item, in: context)
        }) { (contextDidSave, error) in
            let shop = Shop.mr_findFirst()
            callback(shop, error)
        }
    }
    
    class func getShop() -> Shop? {
        return Shop.mr_findFirst()
    }
    
    // MARK: - private
    private class func getShop(in context: NSManagedObjectContext) -> Shop? {
        var shop = Shop.mr_findFirst(in: context)
        if shop == nil {
            shop = Shop.mr_createEntity(in: context)
        }
        return shop
    }
}

internal extension Shop {
    func update(with remoteItem: ShopEntityInterface?, in context: NSManagedObjectContext) {
        name = remoteItem?.entityName
        shopDescription = remoteItem?.entityDesription
        currency = remoteItem?.entityCurrency
        if let policy = remoteItem?.entityPrivacyPolicy {
            privacyPolicy = PolicyRepository.loadPolicy(with: policy, in: context)
        }
        if let policy = remoteItem?.entityRefundPolicy {
            refundPolicy = PolicyRepository.loadPolicy(with: policy, in: context)
        }
        if let terms = remoteItem?.entityTermsOfService {
            termsOfService = PolicyRepository.loadPolicy(with: terms, in: context)
        }
    }
}
