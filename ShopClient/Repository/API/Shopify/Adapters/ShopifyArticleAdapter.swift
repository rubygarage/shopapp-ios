//
//  ShopifyArticleAdapter.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 10/25/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import MobileBuySDK

extension Article {
    convenience init?(with item: Storefront.Article?) {
        if item == nil {
            return nil
        }
        self.init()
        
        update(with: item)
    }
    
    convenience init?(with item: Storefront.ArticleEdge?) {
        if item == nil {
            return nil
        }
        self.init()
        
        update(with: item?.node)
        paginationValue = item?.cursor
    }
    
    private func update(with item: Storefront.Article?) {
        id = item?.id.rawValue ?? String()
        title = item?.title
        content = item?.content
        author = Author(with: item?.author)
        tags = item?.tags
        blogId = item?.blog.id.rawValue
        blogTitle = item?.blog.title
        publishedAt = item?.publishedAt
        url = item?.url.absoluteString
        if let image = item?.image {
            self.image = Image(with: image)
        }
    }
}
