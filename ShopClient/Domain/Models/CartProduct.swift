//
//  CartProduct.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/7/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import Foundation

class CartProduct: NSObject {
    var productVariant: ProductVariant?
    var productId: String?
    var productTitle: String?
    var currency: String?
    var quantity: Int = 0
}
