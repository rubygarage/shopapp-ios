//
//  ProductObject.swift
//  ShopApp_Gateway
//
//  Created by Evgeniy Antonov on 10/24/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import Foundation

public struct Product: Equatable {
    public let id: String
    public let title: String
    public let productDescription: String
    public let currency: String
    public let price: Decimal
    public let hasAlternativePrice: Bool
    public let discount: String?
    public let type: String
    public let images: [Image]
    public let options: [ProductOption]
    public let variants: [ProductVariant]
    public let paginationValue: String?
    
    public init(id: String, title: String, productDescription: String, price: Decimal, hasAlternativePrice: Bool, currency: String, discount: String? = nil, images: [Image], type: String, paginationValue: String? = nil, variants: [ProductVariant], options: [ProductOption]) {
        self.id = id
        self.title = title
        self.productDescription = productDescription
        self.price = price
        self.hasAlternativePrice = hasAlternativePrice
        self.currency = currency
        self.discount = discount
        self.images = images
        self.type = type
        self.paginationValue = paginationValue
        self.variants = variants
        self.options = options
    }
    
    public static func == (lhs: Product, rhs: Product) -> Bool {
        return lhs.id == rhs.id
            && lhs.title == rhs.title
            && lhs.productDescription == rhs.productDescription
            && lhs.price == rhs.price
            && lhs.hasAlternativePrice == rhs.hasAlternativePrice
            && lhs.currency == rhs.currency
            && lhs.discount == rhs.discount
            && lhs.images == rhs.images
            && lhs.type == rhs.type
            && lhs.paginationValue == rhs.paginationValue
            && lhs.variants == rhs.variants
            && lhs.options == rhs.options
    }
}
