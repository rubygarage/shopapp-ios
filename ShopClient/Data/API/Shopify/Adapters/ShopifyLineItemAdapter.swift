//
//  ShopifyLineItemAdapter.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 1/15/18.
//  Copyright © 2018 Evgeniy Antonov. All rights reserved.
//

import MobileBuySDK

extension LineItem {
    convenience init?(with item: Storefront.CheckoutLineItem) {
        self.init()
        
        id = item.id.rawValue
        price = item.variant?.price
        quantity = Int(item.quantity)
    }
}
