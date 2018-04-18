//
//  GetTokenRequestBody.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 4/19/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Foundation

struct GetTokenRequestBody: RequestBody {
    var email: String
    var password: String
    
    enum CodingKeys: String, CodingKey {
        case email = "username"
        case password
    }
}
