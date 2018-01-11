//
//  Order.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 1/3/18.
//  Copyright © 2018 Evgeniy Antonov. All rights reserved.
//

import Foundation

class Order: NSObject {
    var id = ""
    var currencyCode: String?
    var number: Int?
    var createdAt: Date?
    var shippingAddress: Address?
    var subtotalPrice: Decimal?
    var totalPrice: Decimal?
    var totalShippingPrice: Decimal?
    var totalTax: Decimal?
    var paginationValue: String?
    var items: [OrderItem]?
}
