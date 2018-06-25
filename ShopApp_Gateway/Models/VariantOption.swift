//
//  VariantOption.swift
//  ShopApp_Gateway
//
//  Created by Evgeniy Antonov on 11/6/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import Foundation

public struct VariantOption: Equatable {
    public let name: String
    public let value: String

    public init(name: String, value: String) {
        self.name = name
        self.value = value
    }
    
    public static func == (lhs: VariantOption, rhs: VariantOption) -> Bool {
        return lhs.name == rhs.name
            && lhs.value == rhs.value
    }
}
