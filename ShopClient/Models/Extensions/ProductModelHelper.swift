//
//  ProductModelHelper.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 10/13/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import Foundation

extension Product {
    var imagesArray: [Image]? {
        get {
            return images?.allObjects as? [Image]
        }
    }
    
    var optionsArray: [ProductOption]? {
        get {
            return options?.allObjects as? [ProductOption]
        }
    }
}
