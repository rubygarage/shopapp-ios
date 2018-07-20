//
//  MagentoCountryAdapter.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 4/23/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

struct MagentoCountryAdapter {
    static func adapt(_ response: CountryResponse) -> Country {
        let states = response.regions?.map { MagentoStateAdapter.adapt($0) }
        
        return Country(id: response.id, name: response.name, states: states)
    }
}
