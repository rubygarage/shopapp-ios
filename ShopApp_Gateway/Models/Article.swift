//
//  Article.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 10/24/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import Foundation

public class Article {
    public var id = ""
    public var title: String?
    public var content: String?
    public var contentHtml: String?
    public var image: Image?
    public var author: Author?
    public var tags: [String]?
    public var blogId: String?
    public var blogTitle: String?
    public var publishedAt: Date?
    public var url: String?
    public var paginationValue: String?

    public init() {}
}
