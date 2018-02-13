//
//  ShopifyStateAdapter.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 2/9/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Foundation

private let kShopifyStateNameKey = "name"

extension State {
    convenience init?(with item: ApiJson?) {
        guard let item = item else {
            return nil
        }
        self.init()
        name = item[kShopifyStateNameKey] as? String ?? ""
    }
}
