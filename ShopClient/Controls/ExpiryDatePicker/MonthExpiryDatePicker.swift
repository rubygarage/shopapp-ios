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
        return ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", ]
    }
}
