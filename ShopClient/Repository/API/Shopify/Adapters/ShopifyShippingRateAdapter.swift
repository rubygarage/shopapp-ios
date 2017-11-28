//
//  ShopifyShippingRateAdapter.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/24/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import MobileBuySDK

extension ShippingRate {
    convenience init?(with item: Storefront.ShippingRate?) {
        if item == nil {
            return nil
        }
        self.init()
        
        title = item?.title
        price = item?.price.description
        handle = item?.handle ?? String()
    }
}
