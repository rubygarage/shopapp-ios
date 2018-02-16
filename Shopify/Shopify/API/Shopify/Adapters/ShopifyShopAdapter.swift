//
//  ShopifyShopAdapter.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 10/23/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import Buy
import ShopClient_Gateway

struct ShopifyShopAdapter {
    static func adapt(item: Storefront.Shop?) -> Shop? {
        guard let item = item else {
            return nil
        }

        let shop = Shop()
        shop.name = item.name
        shop.shopDescription = item.description
        shop.privacyPolicy = ShopifyPolicyAdapter.adapt(item: item.privacyPolicy)
        shop.refundPolicy = ShopifyPolicyAdapter.adapt(item: item.refundPolicy)
        shop.termsOfService = ShopifyPolicyAdapter.adapt(item: item.termsOfService)
        return shop
    }
}
