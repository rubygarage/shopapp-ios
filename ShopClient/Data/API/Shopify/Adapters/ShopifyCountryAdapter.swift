//
//  Country.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 2/9/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Foundation

private let kShopifyCountryNameKey = "name"
private let kShopifyCountryProvincesKey = "provinces"

extension Country {
    convenience init?(with item: ApiJson?) {
        guard let item = item else {
            return nil
        }
        self.init()
        name = item[kShopifyCountryNameKey] as? String ?? ""
        guard let provinces = item[kShopifyCountryProvincesKey] as? [ApiJson] else {
            return
        }
        var states: [State] = []
        provinces.forEach {
            if let state = State(with: $0) {
                states.append(state)
            }
        }
        self.states = states
    }
}
