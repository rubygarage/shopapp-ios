//
//  Product.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 8/31/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

class Product: NSObject {
    var id = String()
    var title = String()
    var productDescription = String()
    var currency = String()
    var price = String()
    var discount = String()
    var images: [Image]?
    var type = String()
    var vendor = String()
    var createdAt = Date()
    var updatedAt = Date()
    var tags: [String]?
    var paginationValue: String?
    var productDetails: ProductDetails?
}
