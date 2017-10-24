//
//  ShopifyPolicyAdapter.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 10/24/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import MobileBuySDK

extension PolicyObject {
    convenience init?(policyObject: Storefront.ShopPolicy?) {
        if policyObject == nil {
            return nil
        }
        self.init()
        
        title = policyObject?.title
        body = policyObject?.body
        url = policyObject?.url.absoluteString
    }
}
