//
//  VariantOptionEntityUpdateService.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 1/16/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

struct VariantOptionEntityUpdateService {
    static func update(_ entity: VariantOptionEntity, with item: VariantOption?) {
        entity.name = item?.name ?? ""
        entity.value = item?.value ?? ""
    }
}
