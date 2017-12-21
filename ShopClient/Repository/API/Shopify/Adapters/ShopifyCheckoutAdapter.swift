//
//  ShopifyCheckoutAdapter.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/20/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import MobileBuySDK

extension Checkout {
    convenience init?(with item: Storefront.Checkout?) {
        if item == nil {
            return nil
        }
        self.init()
        
        id = item?.id.rawValue ?? String()
        webUrl = item?.webUrl.absoluteString
        subtotalPrice = item?.subtotalPrice
        totalPrice = item?.totalPrice
        totalTax = item?.totalTax
//        shippingAddress = Address()
    }
}
