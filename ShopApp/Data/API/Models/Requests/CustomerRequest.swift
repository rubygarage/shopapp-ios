//
//  CustomerRequestBody.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 4/19/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Foundation

struct CustomerRequestBody: Request {
    var email: String
    var firstName: String
    var lastName: String
    var websiteId: Int?
    var addresses: [AddressRequest] = []
    
    enum CodingKeys: String, CodingKey {
        case email
        case firstName = "firstname"
        case lastName = "lastname"
        case websiteId = "website_id"
        case addresses
    }
    
    init(email: String, firstName: String, lastName: String, addresses: [AddressRequest]? = nil) {
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        
        if let addresses = addresses {
            self.addresses = addresses
        }
    }
}
