//
//  ShopifyShopAdapter.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/7/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import MobileBuySDK
import MagicalRecord

class ShopifyShopAdapter {
    class func loadShopInfo(with item: Storefront.Shop?, callback: @escaping ((_ shop: Shop?, _ error: Error?) -> ())) {
        MagicalRecord.save({ (context) in
            let shop = getShop(in: context)
            updateShop(with: shop, remoteItem: item, in: context)
        }) { (contextDidSave, error) in
            let shop = Shop.mr_findFirst()
            callback(shop, error)
        }
    }
    
    private class func getShop(in context: NSManagedObjectContext) -> Shop? {
        var shop = Shop.mr_findFirst(in: context)
        if shop == nil {
            shop = Shop.mr_createEntity(in: context)
        }
        return shop
    }
    
    private class func updateShop(with localItem: Shop?, remoteItem: Storefront.Shop?, in context: NSManagedObjectContext) {
        localItem?.name = remoteItem?.name
        localItem?.shopDescription = remoteItem?.description
        
        if let privacyPolicy = remoteItem?.privacyPolicy {
            localItem?.privacyPolicy = ShopifyPolicyAdapter.loadPolicy(with: privacyPolicy, in: context)
        }
        
        if let refundPolicy = remoteItem?.refundPolicy {
            localItem?.refundPolicy = ShopifyPolicyAdapter.loadPolicy(with: refundPolicy, in: context)
        }
        
        if let termsOfService = remoteItem?.termsOfService {
            localItem?.termsOfService = ShopifyPolicyAdapter.loadPolicy(with: termsOfService, in: context)
        }
    }
}
