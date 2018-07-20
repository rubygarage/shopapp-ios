//
//  CartProduct.swift
//  ShopApp_Gateway
//
//  Created by Evgeniy Antonov on 11/7/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import Foundation

public struct CartProduct: Equatable {
    public let id: String
    public let productVariant: ProductVariant?
    public let title: String
    public let currency: String
    public let quantity: Int

    public init(id: String, productVariant: ProductVariant? = nil, title: String, currency: String, quantity: Int) {
        self.productVariant = productVariant
        self.title = title
        self.currency = currency
        self.quantity = quantity
        self.id = id
    }
    
    public static func == (lhs: CartProduct, rhs: CartProduct) -> Bool {
        return lhs.productVariant == rhs.productVariant
            && lhs.title == rhs.title
            && lhs.currency == rhs.currency
            && lhs.quantity == rhs.quantity
            && lhs.id == rhs.id
    }
}
