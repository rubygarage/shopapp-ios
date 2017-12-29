//
//  ShopifyAddressAdapter.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/22/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import MobileBuySDK

extension Address {
    convenience init?(with item: Storefront.MailingAddress?) {
        if item == nil {
            return nil
        }
        self.init()
        
        update(with: item)
    }
    
    private func update(with item: Storefront.MailingAddress?) {
        id = item?.id.rawValue ?? String()
        firstName = item?.firstName
        lastName = item?.lastName
        address = item?.address1
        secondAddress = item?.address2
        city = item?.city
        country = item?.country
        state = item?.province
        zip = item?.zip
        phone = item?.phone
    }
}
