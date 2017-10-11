//
//  ShopifyShopAdapter.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/7/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import MobileBuySDK

extension Storefront.Shop: ShopEntityInterface {
    var entityName: String? {
        get {
            return name
        }
    }
    
    var entityDesription: String? {
        get {
            return description
        }
    }
    
    var entityPrivacyPolicy: PolicyEntityInterface? {
        get {
            return privacyPolicy
        }
    }
    
    var entityRefundPolicy: PolicyEntityInterface? {
        get {
            return refundPolicy
        }
    }
    
    var entityTermsOfService: PolicyEntityInterface? {
        get {
            return termsOfService
        }
    }
}
