//
//  Country.swift
//  ShopApp_Gateway
//
//  Created by Radyslav Krechet on 2/9/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Foundation

public struct Country {
    public let id: String
    public let name: String
    public let states: [State]?

    public init(id: String, name: String, states: [State]? = nil) {
        self.id = id
        self.name = name
        self.states = states
    }
}
