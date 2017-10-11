//
//  ShopifyPolicyAdapter.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/8/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import MobileBuySDK

extension Storefront.ShopPolicy: PolicyEntityInterface {
    var entityBody: String? {
        get {
            return body
        }
    }
    
    var entityTitle: String? {
        get {
            return title
        }
    }
    
    var entityUrl: String? {
        get {
            return url.absoluteString
        }
    }
}
