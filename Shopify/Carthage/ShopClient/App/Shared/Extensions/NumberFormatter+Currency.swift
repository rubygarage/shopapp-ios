//
//  NumberFormatter+Currency.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 1/9/18.
//  Copyright © 2018 Evgeniy Antonov. All rights reserved.
//

import Foundation

extension NumberFormatter {
    static func formatter(with currencyCode: String) -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.currency
        formatter.currencyCode = currencyCode
        
        return formatter
    }
}
