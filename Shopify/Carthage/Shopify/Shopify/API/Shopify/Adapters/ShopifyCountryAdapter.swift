//
//  Country.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 2/9/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Foundation
import ShopClient_Gateway

struct ShopifyCountryAdapter {
    private static let kShopifyCountryNameKey = "name"
    private static let kShopifyCountryProvincesKey = "provinces"

    static func adapt(item: ApiJson?) -> Country? {
        guard let item = item else {
            return nil
        }

        let country = Country()
        country.name = item[kShopifyCountryNameKey] as? String ?? ""

        guard let provinces = item[kShopifyCountryProvincesKey] as? [ApiJson] else {
            return country
        }

        var states: [State] = []
        provinces.forEach {
            if let state = ShopifyStateAdapter.adapt(item: $0) {
                states.append(state)
            }
        }
        country.states = states
        return country
    }
}
