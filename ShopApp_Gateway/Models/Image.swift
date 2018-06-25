//
//  Image.swift
//  ShopApp_Gateway
//
//  Created by Evgeniy Antonov on 10/24/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import Foundation

public struct Image: Equatable {
    public let id: String
    public let src: String

    public init(id: String, src: String) {
        self.id = id
        self.src = src
    }
    
    public static func == (lhs: Image, rhs: Image) -> Bool {
        return lhs.id == rhs.id
            && lhs.src == rhs.src
    }
}
