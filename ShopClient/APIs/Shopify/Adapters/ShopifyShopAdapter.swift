//
//  ShopifyShopAdapter.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/7/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import MobileBuySDK

class ShopifyShopAdapter: Shop {
    init(shop: Storefront.Shop?) {
        super.init()
        
        name = shop?.name ?? String()
        shopDescription = shop?.description ?? String()
        
        if let privacyPolicy = shop?.privacyPolicy {
            self.privacyPolicy = ShopifyPolicyAdapter(shopPolicy: privacyPolicy)
        }
        
        if let refundPolicy = shop?.refundPolicy {
            self.refundPolicy = ShopifyPolicyAdapter(shopPolicy: refundPolicy)
        }
        
        if let termsOfService = shop?.termsOfService {
            self.termsOfService = ShopifyPolicyAdapter(shopPolicy: termsOfService)
        }
    }
}
