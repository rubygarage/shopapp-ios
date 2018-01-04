//
//  ShopifyOrderAdapter.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 1/4/18.
//  Copyright © 2018 Evgeniy Antonov. All rights reserved.
//

import MobileBuySDK

extension Order {
    convenience init?(with item: Storefront.Order?, isAllInfoNeeded: Bool = true) {
        if item == nil {
            return nil
        }
        self.init()
        
        update(with: item, isAllInfoNeeded: isAllInfoNeeded)
    }
    
    convenience init?(with item: Storefront.OrderEdge?, isAllInfoNeeded: Bool = false) {
        if item == nil {
            return nil
        }
        self.init()
        
        update(with: item?.node, isAllInfoNeeded: isAllInfoNeeded)
        paginationValue = item?.cursor
    }
    
    private func update(with item: Storefront.Order?, isAllInfoNeeded: Bool) {
        id = item?.id.rawValue ?? String()
        currencyCode = item?.currencyCode.rawValue
        number = item != nil ? Int(item!.orderNumber) : 0
        createdAt = item?.processedAt
        subtotalPrice = item?.subtotalPrice
        
        if let lineItems = item?.lineItems.edges.map({ $0.node }) {
            var orderItems = [OrderItem]()
            for lineItem in lineItems {
                if let orderItem = OrderItem(with: lineItem, isAllInfoNeeded: isAllInfoNeeded) {
                    orderItems.append(orderItem)
                }
            }
            items = orderItems
        }
        
        if isAllInfoNeeded {
            shippingAddress = Address(with: item?.shippingAddress)
            totalPrice = item?.totalPrice
            totalShippingPrice = item?.totalShippingPrice
            totalTax = item?.totalTax
        }
    }
}
