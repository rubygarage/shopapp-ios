//
//  ProductObject.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 10/24/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import Foundation

class Product: NSObject {
    var id = ""
    var title: String?
    var productDescription: String?
    var price: Decimal?
    var hasAlternativePrice: Bool = false
    var currency: String?
    var discount: String?
    var images: [Image]?
    var type: String?
    var vendor: String?
    var createdAt: Date?
    var updatedAt: Date?
    var tags: [String]?
    var paginationValue: String?
    var additionalDescription: String?
    var variants: [ProductVariant]?
    var options: [ProductOption]?
}
