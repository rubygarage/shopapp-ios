//
//  CategoryObject.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 10/24/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import Foundation

public class Category {
    public var id = ""
    public var title: String?
    public var categoryDescription: String?
    public var image: Image?
    public var updatedAt: Date?
    public var paginationValue: Any?
    public var products: [Product]?
    public var additionalDescription: String?

    public init() {}
}
