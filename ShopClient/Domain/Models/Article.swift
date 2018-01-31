//
//  Article.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 10/24/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import Foundation

class Article: NSObject {
    var id = ""
    var title: String?
    var content: String?
    var contentHtml: String?
    var image: Image?
    var author: Author?
    var tags: [String]?
    var blogId: String?
    var blogTitle: String?
    var publishedAt: Date?
    var url: String?
    var paginationValue: String?
}
