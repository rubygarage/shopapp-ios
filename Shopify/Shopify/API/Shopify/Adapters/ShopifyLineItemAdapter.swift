//
//  ShopifyLineItemAdapter.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 1/15/18.
//  Copyright © 2018 Evgeniy Antonov. All rights reserved.
//

import Buy
import ShopClient_Gateway

struct ShopifyLineItemAdapter {
    static func adapt(item: Storefront.CheckoutLineItem?) -> LineItem? {
        guard let item = item else {
            return nil
        }
        
        let lineItem = LineItem()
        lineItem.id = item.id.rawValue
        lineItem.price = item.variant?.price
        lineItem.quantity = Int(item.quantity)
        return lineItem
    }
}
