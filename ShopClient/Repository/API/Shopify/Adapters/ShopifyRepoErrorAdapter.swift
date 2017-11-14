//
//  ShopifyRepoErrorAdapter.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/14/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import MobileBuySDK

extension RepoError {
    convenience init?(with error: Storefront.UserError?) {
        if let error = error {
            self.init()
            errorMessage = error.message
        } else {
            return nil
        }
    }
}
