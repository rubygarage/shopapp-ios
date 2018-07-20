//
//  StoreConfigResponse.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 5/3/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Foundation

struct StoreConfigResponse: Response {
    let сurrencyСode: String
    
    enum CodingKeys: String, CodingKey {
        case сurrencyСode = "base_currency_code"
    }
}
