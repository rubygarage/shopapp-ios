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
        firstName = item?.firstName ?? String()
        lastName = item?.lastName ?? String()
        address = item?.address1 ?? String()
        secondAddress = item?.address2 ?? String()
        city = item?.city ?? String()
        country = item?.country ?? String()
        state = item?.province ?? String()
        zip = item?.zip ?? String()
        phone = item?.phone ?? String()
    }
}
