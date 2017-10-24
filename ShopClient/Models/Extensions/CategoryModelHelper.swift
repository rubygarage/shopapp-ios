//
//  CategoryModelHelper.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 10/13/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

extension CategoryEntity {
    var productsArray: [ProductEntity]? {
        get {
            return products?.allObjects as? [ProductEntity]
        }
    }
}
