//
//  ProductOption.swift
//  ShopApp_Gateway
//
//  Created by Evgeniy Antonov on 10/24/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import Foundation

public struct ProductOption: Equatable {
    public let id: String
    public let name: String
    public let values: [String]

    public init(id: String, name: String, values: [String]) {
        self.id = id
        self.name = name
        self.values = values
    }
    
    public static func == (lhs: ProductOption, rhs: ProductOption) -> Bool {
        return lhs.id == rhs.id
            && lhs.name == rhs.name
            && lhs.values == rhs.values
    }
}
