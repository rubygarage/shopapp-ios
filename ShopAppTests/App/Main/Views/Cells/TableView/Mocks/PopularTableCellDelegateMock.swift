//
//  PopularTableCellDelegateMock.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 3/13/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

import ShopApp_Gateway

@testable import ShopApp

class PopularTableCellDelegateMock: PopularTableCellDelegate {
    var tableViewCell: PopularTableViewCell?
    var product: Product?
    
    func tableViewCell(_ tableViewCell: PopularTableViewCell, didSelect product: Product) {
        self.tableViewCell = tableViewCell
        self.product = product
    }
}
