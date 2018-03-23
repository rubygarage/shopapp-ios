//
//  MonthExpiryDatePicker.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 1/3/18.
//  Copyright © 2018 Evgeniy Antonov. All rights reserved.
//

import UIKit

class MonthExpiryDatePicker: BasePicker {
    override var initialPlaceholder: String {
        return "Placeholder.Month".localizable
    }
    override var data: [String] {
        var monthes: [String] = []
        for index in 1...Calendar.current.monthSymbols.count {
            monthes.append(index.asLongMonth())
        }
        return monthes
    }
}

extension Int {
    func asLongMonth() -> String {
        return String(format: "%02d", self)
    }
}
