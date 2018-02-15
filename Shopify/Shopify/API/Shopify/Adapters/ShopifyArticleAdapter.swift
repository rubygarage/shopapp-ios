//
//  ShopifyArticleAdapter.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 10/25/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import MobileBuySDK
import ShopClient_Gateway

struct ShopifyArticleAdapter {
    static func adapt(item: Storefront.Article?) -> Article? {
        guard let item = item else {
            return nil
        }

        let article = Article()
        article.id = item.id.rawValue
        article.title = item.title
        article.content = item.content
        article.contentHtml = item.contentHtml
        article.author = ShopifyAuthorAdapter.adapt(item: item.author)
        article.tags = item.tags
        article.blogId = item.blog.id.rawValue
        article.blogTitle = item.blog.title
        article.publishedAt = item.publishedAt
        article.url = item.url.absoluteString
        article.image = ShopifyImageAdapter.adapt(item: item.image)
        return article
    }

    static func adapt(item: Storefront.ArticleEdge?) -> Article? {
        let article = adapt(item: item?.node)
        article?.paginationValue = item?.cursor
        return article
    }
}
