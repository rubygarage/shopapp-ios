//
//  Article.swift
//  ShopApp_Gateway
//
//  Created by Evgeniy Antonov on 10/24/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import Foundation

public struct Article: Equatable {
    public let id: String
    public let title: String
    public let content: String
    public let contentHtml: String
    public let image: Image?
    public let author: Author
    public let paginationValue: String?

    public init(id: String, title: String, content: String, contentHtml: String, image: Image? = nil, author: Author, paginationValue: String? = nil) {
        self.id = id
        self.title = title
        self.content = content
        self.contentHtml = contentHtml
        self.image = image
        self.author = author
        self.paginationValue = paginationValue
    }
    
    public static func == (lhs: Article, rhs: Article) -> Bool {
        return lhs.id == rhs.id
            && lhs.title == rhs.title
            && lhs.content == rhs.content
            && lhs.contentHtml == rhs.contentHtml
            && lhs.image == rhs.image
            && lhs.author == rhs.author
            && lhs.paginationValue == rhs.paginationValue
    }
}
