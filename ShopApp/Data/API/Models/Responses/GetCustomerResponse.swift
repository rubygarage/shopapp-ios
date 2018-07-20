//
//  GetCustomerResponse.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 4/19/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Foundation

struct GetCustomerResponse: Response {
    let email: String
    let firstName: String
    let lastName: String
    let addresses: [AddressResponse]
    
    enum CodingKeys: String, CodingKey {
        case email
        case firstName = "firstname"
        case lastName = "lastname"
        case addresses
    }
}
