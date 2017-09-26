//
//  ShopifyAuthorAdapter.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/15/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import MobileBuySDK

class ShopifyAuthorAdapter: Author {
    init(author: Storefront.ArticleAuthor) {
        super.init()
        
        firstName = author.firstName
        lastName = author.lastName
        fullName = author.name
        email = author.email
        bio = author.bio
    }
}
