//
//  Order.swift
//  ShopApp_Gateway
//
//  Created by Radyslav Krechet on 1/3/18.
//  Copyright © 2018 Evgeniy Antonov. All rights reserved.
//

import Foundation

public struct Order: Equatable {
    public let id: String
    public let currencyCode: String
    public let orderNumber: Int
    public let subtotalPrice: Decimal?
    public let totalShippingPrice: Decimal?
    public let totalPrice: Decimal
    public let createdAt: Date
    public let orderProducts: [OrderProduct]
    public let shippingAddress: Address
    public let paginationValue: String?
    
    public init(id: String, currencyCode: String, orderNumber: Int, subtotalPrice: Decimal? = nil, totalShippingPrice: Decimal? = nil, totalPrice: Decimal, createdAt: Date, orderProducts: [OrderProduct], shippingAddress: Address, paginationValue: String? = nil) {
        self.id = id
        self.currencyCode = currencyCode
        self.orderNumber = orderNumber
        self.subtotalPrice = subtotalPrice
        self.totalShippingPrice = totalShippingPrice
        self.totalPrice = totalPrice
        self.createdAt = createdAt
        self.orderProducts = orderProducts
        self.shippingAddress = shippingAddress
        self.paginationValue = paginationValue
    }
    
    public static func == (lhs: Order, rhs: Order) -> Bool {
        return lhs.id == rhs.id
            && lhs.currencyCode == rhs.currencyCode
            && lhs.orderNumber == rhs.orderNumber
            && lhs.subtotalPrice == rhs.subtotalPrice
            && lhs.totalShippingPrice == rhs.totalShippingPrice
            && lhs.totalPrice == rhs.totalPrice
            && lhs.createdAt == rhs.createdAt
            && lhs.orderProducts == rhs.orderProducts
            && lhs.shippingAddress == rhs.shippingAddress
            && lhs.paginationValue == rhs.paginationValue
    }
}
