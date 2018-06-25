//
//  ShopAppError.swift
//  ShopApp_Gateway
//
//  Created by Evgeniy Antonov on 11/13/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import Foundation

public enum ShopAppError: Error {
    case critical
    case nonCritical(message: String)
    case content(isNetworkError: Bool)
}
