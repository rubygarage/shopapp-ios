//
//  ShopifyAuthorAdapter.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 10/25/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import MobileBuySDK

extension Author {
    convenience init?(with item: Storefront.ArticleAuthor?) {
        if item == nil {
            return nil
        }
        self.init()
        
        firstName = item?.firstName
        lastName = item?.lastName
        fullName = item?.name
        email = item?.email
        bio = item?.bio
    }
}
