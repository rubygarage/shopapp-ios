//
//  ShopifyCustomerAdapter.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/13/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import MobileBuySDK
import ShopClient_Gateway

struct ShopifyCustomerAdapter {
    static func adapt(item: Storefront.Customer?) -> Customer? {
        guard let item = item else {
            return nil
        }

        let customer = Customer()
        customer.email = item.email ?? ""
        customer.firstName = item.firstName
        customer.lastName = item.lastName
        customer.phone = item.phone
        customer.promo = item.acceptsMarketing
        customer.defaultAddress = ShopifyAddressAdapter.adapt(item: item.defaultAddress)

        var addressesArray: [Address] = []
        for edge in item.addresses.edges {
            if let address = ShopifyAddressAdapter.adapt(item: edge.node) {
                addressesArray.append(address)
            }
        }
        customer.addresses = addressesArray

        return customer
    }
}
