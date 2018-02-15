//
//  ShopifyOrderIemAdapter.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 1/4/18.
//  Copyright © 2018 Evgeniy Antonov. All rights reserved.
//

import MobileBuySDK
import ShopClient_Gateway

struct ShopifyOrderItemAdapter {
    static func adapt(item: Storefront.OrderLineItem?) -> OrderItem? {
        guard let item = item else {
            return nil
        }

        let orderItem = OrderItem()
        orderItem.quantity = Int(item.quantity)
        orderItem.title = item.title

        if let variant = item.variant {
            if let productVariant = ShopifyProductVariantAdapter.adapt(item: variant, productId: variant.product.id, productImage: variant.product.images.edges.first?.node) {
                orderItem.productVariant = productVariant
                if variant.product.options.count == 1 && variant.product.options.first?.values.count == 1 {
                    orderItem.productVariant?.selectedOptions = nil
                }
            }
        }
        return orderItem
    }
}
