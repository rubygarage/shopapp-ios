//
//  OrderProduct.swift
//  ShopApp_Gateway
//
//  Created by Radyslav Krechet on 1/3/18.
//  Copyright © 2018 Evgeniy Antonov. All rights reserved.
//

import Foundation

public struct OrderProduct: Equatable {
    public let title: String
    public let productVariant: ProductVariant?
    public let quantity: Int

    public init(title: String, quantity: Int, productVariant: ProductVariant? = nil) {
        self.title = title
        self.quantity = quantity
        self.productVariant = productVariant
    }
    
    public static func == (lhs: OrderProduct, rhs: OrderProduct) -> Bool {
        return lhs.title == rhs.title
            && lhs.quantity == rhs.quantity
            && lhs.productVariant == rhs.productVariant
    }
}
