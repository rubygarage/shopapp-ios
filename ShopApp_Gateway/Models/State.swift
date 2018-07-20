//
//  State.swift
//  ShopApp_Gateway
//
//  Created by Radyslav Krechet on 2/9/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Foundation

public struct State {
    public let id: String
    public let name: String

    public init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}
