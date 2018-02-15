//
//  ShopifyOrderAdapter.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 1/4/18.
//  Copyright © 2018 Evgeniy Antonov. All rights reserved.
//

import MobileBuySDK
import ShopClient_Gateway

struct ShopifyOrderAdapter {
    static func adapt(item: Storefront.Order?) -> Order? {
        return adapt(item: item, isShortVariant: false)
    }

    static func adapt(item: Storefront.OrderEdge?) -> Order? {
        let order = adapt(item: item?.node, isShortVariant: true)
        order?.paginationValue = item?.cursor
        return order
    }

    private static func adapt(item: Storefront.Order?, isShortVariant: Bool) -> Order? {
        guard let item = item else {
            return nil
        }

        let order = Order()
        order.id = item.id.rawValue
        order.currencyCode = item.currencyCode.rawValue
        order.number = Int(item.orderNumber)
        order.createdAt = item.processedAt
        order.totalPrice = item.totalPrice

        var orderItems = [OrderItem]()
        for lineItem in item.lineItems.edges.map({ $0.node }) {
            if let orderItem = ShopifyOrderItemAdapter.adapt(item: lineItem) {
                orderItems.append(orderItem)
            }
        }
        order.items = orderItems

        if !isShortVariant {
            order.shippingAddress = ShopifyAddressAdapter.adapt(item: item.shippingAddress)
            order.subtotalPrice = item.subtotalPrice
            order.totalShippingPrice = item.totalShippingPrice
        }
        return order
    }
}

