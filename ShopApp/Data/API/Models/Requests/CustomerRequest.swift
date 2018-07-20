//
//  CustomerRequest.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 4/19/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Foundation

struct CustomerRequest: Request {
    let email: String
    let firstName: String
    let lastName: String
    let websiteId: Int?
    let addresses: [AddressRequest]
    
    enum CodingKeys: String, CodingKey {
        case email
        case firstName = "firstname"
        case lastName = "lastname"
        case websiteId = "website_id"
        case addresses
    }
    
    init(email: String, firstName: String, lastName: String, addresses: [AddressRequest]? = nil, websiteId: Int? = nil) {
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.websiteId = websiteId
        self.addresses = addresses ?? []
    }
}
