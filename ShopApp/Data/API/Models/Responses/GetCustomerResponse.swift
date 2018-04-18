//
//  GetCustomerResponse.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 4/19/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Foundation

struct GetCustomerResponse: Response {
    var email: String
    var firstName: String
    var lastName: String
    var addresses: [AddressResponse]
    
    enum CodingKeys: String, CodingKey {
        case email
        case firstName = "firstname"
        case lastName = "lastname"
        case addresses
    }
}
