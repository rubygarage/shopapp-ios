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

    public init(id: String, title: String, image: Image? = nil, products: [Product], paginationValue: String?) {
        self.id = id
        self.title = title
        self.image = image
        self.products = products
        self.paginationValue = paginationValue
    }
    
    public static func == (lhs: Category, rhs: Category) -> Bool {
        return lhs.id == rhs.id
            && lhs.title == rhs.title
            && lhs.image == rhs.image
            && lhs.products == rhs.products
            && lhs.paginationValue == rhs.paginationValue
    }
}
