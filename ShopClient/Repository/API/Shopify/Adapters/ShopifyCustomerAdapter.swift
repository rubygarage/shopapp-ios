//
//  ShopifyCustomerAdapter.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/13/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import MobileBuySDK

extension Customer {
    convenience init?(with item: Storefront.Customer) {
        self.init()
        
        email = item.email ?? String()
        firstName = item.firstName
        lastName = item.lastName
        phone = item.phone
    }
}
