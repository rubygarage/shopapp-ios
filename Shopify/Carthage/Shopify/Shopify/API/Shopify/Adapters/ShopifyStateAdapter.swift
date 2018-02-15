//
//  ShopifyStateAdapter.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 2/9/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Foundation
import ShopClient_Gateway

struct ShopifyStateAdapter {
    private static let kShopifyStateNameKey = "name"

    static func adapt(item: ApiJson?) -> State? {
        guard let item = item else {
            return nil
        }

        let state = State()
        state.name = item[kShopifyStateNameKey] as? String ?? ""
        return state
    }
}
