//
//  ProductVariant.swift
//  ShopApp_Gateway
//
//  Created by Evgeniy Antonov on 10/24/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import Foundation

public class ProductVariant {
    public var id = ""
    public var title: String?
    public var price: Decimal?
    public var available: Bool = false
    public var image: Image?
    public var selectedOptions: [VariantOption]?
    public var productId = ""

    public init() {}
}
