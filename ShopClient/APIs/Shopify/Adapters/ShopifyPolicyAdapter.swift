//
//  ShopifyPolicyAdapter.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/8/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import MobileBuySDK

class ShopifyPolicyAdapter: Policy {
    init(shopPolicy: Storefront.ShopPolicy) {
        super.init()
        
        self.title = shopPolicy.title
        self.body = shopPolicy.body
        self.url = shopPolicy.url.absoluteString
    }
}
