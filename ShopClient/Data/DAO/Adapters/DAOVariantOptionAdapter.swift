//
//  DAOProductVariantOptionAdapter.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 1/16/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Foundation

extension VariantOption {
    convenience init?(with option: VariantOptionEntity?) {
        if option == nil {
            return nil
        }
        self.init()

        name = option?.name ?? ""
        value = option?.value ?? ""
    }
}
