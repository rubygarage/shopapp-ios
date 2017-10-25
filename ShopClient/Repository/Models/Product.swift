//
//  ProductObject.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 10/24/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import Foundation

class Product: NSObject {
    var id = String()
    var title: String?
    var productDescription: String?
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
    var variantBySelectedOptions: ProductVariant?
    
    // MARK: - additional
    var lowestPrice: String {
        get {
            return variants?.sorted(by: { $0.price ?? String() < $1.price ?? String() }).first?.price ?? String()
        }
    }
}
