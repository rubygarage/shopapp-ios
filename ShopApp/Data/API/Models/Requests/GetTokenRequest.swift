//
//  GetTokenRequest.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 4/19/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Foundation

struct GetTokenRequest: Request {
    let email: String
    let password: String
    
    enum CodingKeys: String, CodingKey {
        case email = "username"
        case password
    }
}
