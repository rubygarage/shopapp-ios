//
//  Article.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/15/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

class Article: NSObject {
    var id = String()
    var title = String()
    var content = String()
    var image: ImageEntity?
    var author: Author?
    var tags: [String]?
    var blogId = String()
    var blogTitle = String()
    var publishedAt = Date()
    var url = String()
    var paginationValue: String?
}
