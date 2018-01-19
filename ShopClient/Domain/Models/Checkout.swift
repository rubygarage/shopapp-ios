//
//  Checkout.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/20/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import Foundation

class Checkout: NSObject {
    var id = ""
    var webUrl: String?
    var subtotalPrice: Decimal?
    var totalPrice: Decimal?
    var shippingLine: ShippingRate?
    var availableShippingRates: [ShippingRate]?
    var shippingAddress: Address?
    var currencyCode: String?
    var lineItems = [LineItem]()
}
