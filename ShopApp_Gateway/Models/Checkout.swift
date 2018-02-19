//
//  Checkout.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/20/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import Foundation

public class Checkout {
    public var id = ""
    public var webUrl: String?
    public var subtotalPrice: Decimal?
    public var totalPrice: Decimal?
    public var shippingLine: ShippingRate?
    public var availableShippingRates: [ShippingRate]?
    public var shippingAddress: Address?
    public var currencyCode: String?
    public var lineItems: [LineItem] = []

    public init() {}
}
