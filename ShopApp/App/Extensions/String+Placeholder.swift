//
//  String+Placeholder.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 1/18/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Foundation

extension String {
    var required: String {
        return "\(self)*"
    }
}
