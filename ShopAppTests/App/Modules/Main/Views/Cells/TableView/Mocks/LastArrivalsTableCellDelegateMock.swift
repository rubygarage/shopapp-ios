//
//  LastArrivalsTableCellDelegateMock.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 3/13/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

import ShopApp_Gateway

@testable import ShopApp

class LastArrivalsTableCellDelegateMock: LastArrivalsTableCellDelegate {
    var tableViewCell: LastArrivalsTableViewCell?
    var product: Product?
    
    func tableViewCell(_ tableViewCell: LastArrivalsTableViewCell, didSelect product: Product) {
        self.tableViewCell = tableViewCell
        self.product = product
    }
}
