//
//  YearExpiryDatePicker.swift
//  ShopApp
//
//  Created by Evgeniy Antonov on 1/3/18.
//  Copyright © 2018 Evgeniy Antonov. All rights reserved.
//

import UIKit

private let kYearsPeriod: Int = 30

class YearExpiryDatePicker: BasePicker {
    override var initialPlaceholder: String {
        return "Placeholder.Year".localizable
    }
    override var data: [String] {
        let currentYear = Calendar.current.component(.year, from: Date())
        var years: [String] = []
        for index in 0..<kYearsPeriod {
            years.append(String(currentYear + index))
        }
        return years
    }
}
