//
//  ShopifyAddressAdapter.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/22/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import Buy
import ShopClient_Gateway

struct ShopifyAddressAdapter {
    static func adapt(item: Storefront.MailingAddress?) -> Address? {
        guard let item = item else {
            return nil
        }

        let address = Address()
        address.id = item.id.rawValue
        address.firstName = item.firstName
        address.lastName = item.lastName
        address.address = item.address1
        address.secondAddress = item.address2
        address.city = item.city
        address.country = item.country
        address.state = item.province
        address.zip = item.zip
        address.phone = item.phone
        return address
    }
}

