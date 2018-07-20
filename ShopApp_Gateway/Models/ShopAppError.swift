//
//  ShopAppError.swift
//  ShopApp_Gateway
//
//  Created by Evgeniy Antonov on 11/13/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import Foundation

public enum ShopAppError: Error, Equatable {
    case critical
    case nonCritical(message: String)
    case content(isNetworkError: Bool)
    
    // MARK: - Equatable
    
    public static func == (lhs: ShopAppError, rhs: ShopAppError) -> Bool {
        switch (lhs, rhs) {
        case (.critical, .critical):
            return true
        case (.nonCritical(let lhsMessage), .nonCritical(let rhsMessage)):
            return lhsMessage == rhsMessage
        case (.content(let lhsNetworkError), .content(let rhsNetworkError)):
            return lhsNetworkError == rhsNetworkError
        default:
            return false
        }
    }
}
