//
//  ShopifyPolicyAdapter.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/8/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import MobileBuySDK
import MagicalRecord

class ShopifyPolicyAdapter {
    class func loadPolicy<T: Policy>(with item: Storefront.ShopPolicy?, in context: NSManagedObjectContext) -> T? {
        var policy = T.mr_findFirst(in: context)
        if policy == nil {
            policy = T.mr_createEntity(in: context)
        }
        policy?.update(with: item)
        
        return policy
    }
}

internal extension Policy {
    func update(with remoteItem: Storefront.ShopPolicy?) {
        title = remoteItem?.title
        body = remoteItem?.body
        url = remoteItem?.url.absoluteString
    }
}
