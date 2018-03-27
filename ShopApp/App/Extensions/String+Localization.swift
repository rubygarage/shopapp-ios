//
//  String+Localization.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 1/10/18.
//  Copyright © 2018 Evgeniy Antonov. All rights reserved.
//

import Foundation

extension String {
    var localizable: String {
        return NSLocalizedString(self, comment: "")
    }
}
