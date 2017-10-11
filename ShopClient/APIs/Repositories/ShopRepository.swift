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
            updateShop(with: shop, remoteItem: item, in: context)
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
    
    private class func updateShop(with localItem: Shop?, remoteItem: ShopEntityInterface?, in context: NSManagedObjectContext) {
        localItem?.name = remoteItem?.entityName
        localItem?.shopDescription = remoteItem?.entityDesription
        
        if let privacyPolicy = remoteItem?.entityPrivacyPolicy {
            localItem?.privacyPolicy = PolicyRepository.loadPolicy(with: privacyPolicy, in: context)
        }
        
        if let refundPolicy = remoteItem?.entityRefundPolicy {
            localItem?.refundPolicy = PolicyRepository.loadPolicy(with: refundPolicy, in: context)
        }
        
        if let termsOfService = remoteItem?.entityTermsOfService {
            localItem?.termsOfService = PolicyRepository.loadPolicy(with: termsOfService, in: context)
        }
    }
}
