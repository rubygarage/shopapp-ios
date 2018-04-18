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
        let country = Country()
        country.id = response.id
        country.name = response.name
        
        if let regions = response.regions {
            country.states = regions.map { MagentoStateAdapter.adapt($0) }
        }
        
        return country
    }
}
