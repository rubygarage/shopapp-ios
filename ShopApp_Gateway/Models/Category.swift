//
//  CategoryObject.swift
//  ShopApp_Gateway
//
//  Created by Evgeniy Antonov on 10/24/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import Foundation

public struct Category: Equatable {
    public let id: String
    public let title: String
    public let image: Image?
    public let products: [Product]
    public let paginationValue: String?
    public let childrenCategories: [Category]

    public init(id: String, title: String, image: Image? = nil, products: [Product], paginationValue: String?, childrenCategories: [Category]) {
        self.id = id
        self.title = title
        self.image = image
        self.products = products
        self.paginationValue = paginationValue
        self.childrenCategories = childrenCategories
    }
    
    public static func == (lhs: Category, rhs: Category) -> Bool {
        return lhs.id == rhs.id
            && lhs.title == rhs.title
            && lhs.image == rhs.image
            && lhs.products == rhs.products
            && lhs.paginationValue == rhs.paginationValue
            && lhs.childrenCategories == rhs.childrenCategories
    }
}
