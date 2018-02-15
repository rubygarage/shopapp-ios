//
//  ShopifyRepoErrorAdapter.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/14/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import MobileBuySDK
import ShopClient_Gateway

struct ShopifyRepoErrorAdapter {
    static func adapt(item: Storefront.UserError?) -> RepoError? {
        guard let error = item else {
            return nil
        }
        return RepoError(with: error.message)
    }
}
