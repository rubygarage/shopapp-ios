//
//  ShopifyCheckoutAdapter.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/20/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import Buy
import ShopClient_Gateway

struct ShopifyCheckoutAdapter {
    static func adapt(item: Storefront.Checkout?) -> Checkout? {
        guard let item = item else {
            return nil
        }

        let checkout = Checkout()
        checkout.id = item.id.rawValue
        checkout.webUrl = item.webUrl.absoluteString
        checkout.currencyCode = item.currencyCode.rawValue
        checkout.subtotalPrice = item.subtotalPrice
        checkout.totalPrice = item.totalPrice
        checkout.shippingLine = ShopifyShippingRateAdapter.adapt(item: item.shippingLine)
        checkout.shippingAddress = ShopifyAddressAdapter.adapt(item: item.shippingAddress)

        var itemsArray = [LineItem]()
        for node in item.lineItems.edges.map({ $0.node }) {
            if let lineItem = ShopifyLineItemAdapter.adapt(item: node) {
                itemsArray.append(lineItem)
            }
        }
        checkout.lineItems = itemsArray

        if let rates = item.availableShippingRates?.shippingRates {
            var itemsArray = [ShippingRate]()
            for rate in rates {
                if let rateItem = ShopifyShippingRateAdapter.adapt(item: rate) {
                    itemsArray.append(rateItem)
                }
            }
            checkout.availableShippingRates = itemsArray
        }
        return checkout
    }
}
