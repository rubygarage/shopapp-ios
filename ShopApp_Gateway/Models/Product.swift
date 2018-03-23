//
//  ProductObject.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 10/24/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import Foundation

public class Product {
    public var id = ""
    public var title: String?
    public var productDescription: String?
    public var price: Decimal?
    public var hasAlternativePrice: Bool = false
    public var currency: String?
    public var discount: String?
    public var images: [Image]?
    public var type: String?
    public var vendor: String?
    public var createdAt: Date?
    public var updatedAt: Date?
    public var tags: [String]?
    public var paginationValue: String?
    public var additionalDescription: String?
    public var variants: [ProductVariant]?
    public var options: [ProductOption]?

    public init() {}
}
