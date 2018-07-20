//
//  PolicyObject.swift
//  ShopApp_Gateway
//
//  Created by Evgeniy Antonov on 10/24/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import Foundation

public struct Policy: Equatable {
    public let title: String
    public let body: String
    public let url: String

    public init(title: String, body: String, url: String) {
        self.title = title
        self.body = body
        self.url = url
    }
    
    public static func == (lhs: Policy, rhs: Policy) -> Bool {
        return lhs.title == rhs.title
            && lhs.body == rhs.body
            && lhs.url == rhs.url
    }
}
