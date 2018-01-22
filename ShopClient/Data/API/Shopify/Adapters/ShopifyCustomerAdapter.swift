//
//  ShopifyCustomerAdapter.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/13/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import MobileBuySDK

extension Customer {
    convenience init?(with item: Storefront.Customer?) {
        if item == nil {
            return nil
        }
        self.init()
        
        email = item?.email ?? ""
        firstName = item?.firstName
        lastName = item?.lastName
        phone = item?.phone
        promo = item?.acceptsMarketing ?? false
        defaultAddress = Address(with: item?.defaultAddress)
        
        if let edges = item?.addresses.edges {
            var addressesArray = [Address]()
            for edge in edges {
                if let address = Address(with: edge.node) {
                    addressesArray.append(address)
                }
            }
            addresses = addressesArray
        }
    }
}
