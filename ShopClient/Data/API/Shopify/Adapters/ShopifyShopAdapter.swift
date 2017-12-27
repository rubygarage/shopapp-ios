//
//  ShopifyShopAdapter.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 10/23/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import MobileBuySDK

extension Shop {
    convenience init?(shopObject: Storefront.Shop?) {
        if shopObject == nil {
            return nil
        }
        self.init()
        
        name = shopObject?.name ?? String()
        shopDescription = shopObject?.description
        privacyPolicy = Policy(policyObject: shopObject?.privacyPolicy)
        refundPolicy = Policy(policyObject: shopObject?.refundPolicy)
        termsOfService = Policy(policyObject: shopObject?.termsOfService)
    }
}
