//
//  ProductVariant.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 10/24/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import Foundation

class ProductVariant: NSObject {
    var id = ""
    var title: String?
    var price: Decimal?
    var available: Bool = false
    var image: Image?
    var selectedOptions: [VariantOption]?
    var productId = ""
}
