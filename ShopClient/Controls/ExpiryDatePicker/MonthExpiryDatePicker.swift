//
//  MonthExpiryDatePicker.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 1/3/18.
//  Copyright © 2018 Evgeniy Antonov. All rights reserved.
//

import UIKit

class MonthExpiryDatePicker: ExpiryDatePicker {
    override var placeholder: String {
        return NSLocalizedString("Placeholder.Month", comment: String())
    }
    
    override var data: [String] {
        var monthes = [String]()
        for index in 1...Calendar.current.monthSymbols.count {
            monthes.append(index.asLongMonth())
        }
        return monthes
    }
}

internal extension Int {
    func asLongMonth() -> String {
        return String(format: "%02d", self)
    }
}
