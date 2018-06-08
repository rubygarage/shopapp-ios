//
//  Config.swift
//  ShopApp_Gateway
//
//  Created by Radyslav Krechet on 6/5/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Foundation

public struct Config {
    public let isPopularEnabled: Bool
    public let isBlogEnabled: Bool
    public let isOrdersEnabled: Bool
    
    public init(isPopularEnabled: Bool, isBlogEnabled: Bool, isOrdersEnabled: Bool) {
        self.isPopularEnabled = isPopularEnabled
        self.isBlogEnabled = isBlogEnabled
        self.isOrdersEnabled = isOrdersEnabled
    }
}

