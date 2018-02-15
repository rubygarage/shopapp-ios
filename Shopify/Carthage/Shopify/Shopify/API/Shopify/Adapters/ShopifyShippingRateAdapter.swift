//
//  ShopifyShippingRateAdapter.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/24/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import MobileBuySDK
import ShopClient_Gateway

struct ShopifyShippingRateAdapter {
    static func adapt(item: Storefront.ShippingRate?) -> ShippingRate? {
        guard let item = item else {
            return nil
        }

        let shippingRate = ShippingRate()
        shippingRate.title = item.title
        shippingRate.price = item.price.description
        shippingRate.handle = item.handle
        return shippingRate
    }
}
