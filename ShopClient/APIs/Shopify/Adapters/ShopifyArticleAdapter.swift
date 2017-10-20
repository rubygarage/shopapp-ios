//
//  ShopifyArticleAdapter.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/15/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import MobileBuySDK

class ShopifyArticleAdapter: Article {
    init(article: Storefront.Article, cursor: String? = nil) {
        super.init()
        
        id = article.id.rawValue
        title = article.title
        content = article.content
        
//        if let image = article.image {
//            self.image = ShopifyImageAdapter(image: image)
//        }
        
        author = ShopifyAuthorAdapter(author: article.author)
        tags = article.tags
        blogId = article.blog.id.rawValue
        blogTitle = article.blog.title
        publishedAt = article.publishedAt
        url = article.url.absoluteString
        paginationValue = cursor
    }
}
