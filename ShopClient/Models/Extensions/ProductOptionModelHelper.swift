//
//  ProductOptionModelHelper.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 10/13/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

extension ProductOption {
    var valuesArray: [String] {
        get {
            return values as? [String] ?? [String]()
        }
    }
}
