//
//  UpdateCustomerRequest.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 4/20/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Foundation

struct UpdateCustomerRequest: Request {
    private let defaultWebsiteId = 1
    
    let customer: CustomerRequest
    
    init(customer: CustomerRequest) {
        self.customer = CustomerRequest(email: customer.email, firstName: customer.firstName, lastName: customer.lastName, addresses: customer.addresses, websiteId: defaultWebsiteId)
    }
}
