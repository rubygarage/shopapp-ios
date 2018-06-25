//
//  Checkout.swift
//  ShopApp_Gateway
//
//  Created by Evgeniy Antonov on 11/20/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import Foundation

public struct Checkout: Equatable {
    public let id: String
    public let subtotalPrice: Decimal
    public let totalPrice: Decimal
    public let currency: String
    public let shippingAddress: Address?
    public let shippingRate: ShippingRate?
    public let availableShippingRates: [ShippingRate]
    public let lineItems: [LineItem]

    public init(id: String, subtotalPrice: Decimal, totalPrice: Decimal, currency: String, shippingAddress: Address? = nil, shippingRate: ShippingRate? = nil, availableShippingRates: [ShippingRate], lineItems: [LineItem]) {
        self.id = id
        self.subtotalPrice = subtotalPrice
        self.totalPrice = totalPrice
        self.currency = currency
        self.shippingAddress = shippingAddress
        self.shippingRate = shippingRate
        self.availableShippingRates = availableShippingRates
        self.lineItems = lineItems
    }
    
    public static func == (lhs: Checkout, rhs: Checkout) -> Bool {
        return lhs.id == rhs.id
            && lhs.subtotalPrice == rhs.subtotalPrice
            && lhs.totalPrice == rhs.totalPrice
            && lhs.currency == rhs.currency
            && lhs.shippingAddress == rhs.shippingAddress
            && lhs.shippingRate == rhs.shippingRate
            && lhs.availableShippingRates == rhs.availableShippingRates
    }
}
