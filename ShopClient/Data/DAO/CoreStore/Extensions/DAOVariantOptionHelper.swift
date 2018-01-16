//
//  DAOVariantOptionHelper.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 1/16/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Foundation

extension VariantOptionEntity {
    func update(with item: VariantOption?) {
        name = item?.name ?? ""
        value = item?.value ?? ""
    }
}
