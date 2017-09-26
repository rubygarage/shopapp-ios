//
//  Category.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/8/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

class Category: NSObject {
    var id = String()
    var title = String()
    var categoryDescription = String()
    var image: Image?
    var updatedAt: Date?
    var categoryDetails: CategoryDetails?
    var paginationValue: Any?
}
