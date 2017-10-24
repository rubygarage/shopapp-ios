//
//  ShopifyShopAdapter.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 10/23/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import MobileBuySDK

extension ShopObject {
    convenience init?(shopObject: Storefront.Shop?) {
        if shopObject == nil {
            return nil
        }
        self.init()
        
        name = shopObject?.name ?? String()
        shopDescription = shopObject?.description
        privacyPolicy = PolicyObject(policyObject: shopObject?.privacyPolicy)
        refundPolicy = PolicyObject(policyObject: shopObject?.refundPolicy)
        termsOfService = PolicyObject(policyObject: shopObject?.termsOfService)
    }
}
