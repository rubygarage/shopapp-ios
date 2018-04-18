//
//  UpdateCustomerRequestBody.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 4/20/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Foundation

struct UpdateCustomerRequestBody: RequestBody {
    private let defaultWebsiteId = 1
    
    var customer: CustomerRequestBody
    
    init(customer: CustomerRequestBody) {
        self.customer = customer
        self.customer.websiteId = defaultWebsiteId
    }
}
