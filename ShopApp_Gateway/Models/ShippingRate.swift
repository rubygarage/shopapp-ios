//
//  ShippingRate.swift
//  ShopApp_Gateway
//
//  Created by Evgeniy Antonov on 11/24/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import Foundation

public struct ShippingRate: Equatable {
    public let title: String
    public let price: Decimal
    public let handle: String

    public init(title: String, price: Decimal, handle: String) {
        self.title = title
        self.price = price
        self.handle = handle
    }
    
    public static func == (lhs: ShippingRate, rhs: ShippingRate) -> Bool {
        return lhs.title == rhs.title
            && lhs.price == rhs.price
            && lhs.handle == rhs.handle
    }
}
