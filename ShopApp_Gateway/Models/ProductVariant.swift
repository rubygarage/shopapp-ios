//
//  ProductVariant.swift
//  ShopApp_Gateway
//
//  Created by Evgeniy Antonov on 10/24/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import Foundation

public struct ProductVariant: Equatable {
    public let id: String
    public let title: String
    public let price: Decimal
    public let isAvailable: Bool
    public let selectedOptions: [VariantOption]
    public let image: Image?
    public let productId: String

    public init(id: String, title: String, price: Decimal, isAvailable: Bool, image: Image? = nil, selectedOptions: [VariantOption], productId: String) {
        self.id = id
        self.title = title
        self.price = price
        self.isAvailable = isAvailable
        self.image = image
        self.selectedOptions = selectedOptions
        self.productId = productId
    }
    
    public static func == (lhs: ProductVariant, rhs: ProductVariant) -> Bool {
        return lhs.id == rhs.id
            && lhs.title == rhs.title
            && lhs.price == rhs.price
            && lhs.isAvailable == rhs.isAvailable
            && lhs.image == rhs.image
            && lhs.selectedOptions == rhs.selectedOptions
            && lhs.productId == rhs.productId
    }
}
