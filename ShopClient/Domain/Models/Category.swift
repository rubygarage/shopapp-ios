//
//  CategoryObject.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 10/24/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import Foundation

class Category: NSObject {
    var id = ""
    var title: String?
    var categoryDescription: String?
    var image: Image?
    var updatedAt: Date?
    var paginationValue: Any?
    var products: [Product]?
    var additionalDescription: String?
}
