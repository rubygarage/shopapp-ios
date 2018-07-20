//
//  Author.swift
//  ShopApp_Gateway
//
//  Created by Evgeniy Antonov on 10/24/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import Foundation

public struct Author: Equatable {
    public let firstName: String
    public let lastName: String

    public init(firstName: String, lastName: String) {
        self.firstName = firstName
        self.lastName = lastName
    }
    
    public static func == (lhs: Author, rhs: Author) -> Bool {
        return lhs.firstName == rhs.firstName
            && lhs.lastName == rhs.lastName
    }
}
