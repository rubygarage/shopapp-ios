//
//  MagentoStateAdapter.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 4/23/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

struct MagentoStateAdapter {
    static func adapt(_ response: RegionResponse) -> State {
        return State(id: response.id, name: response.name)
    }
}
