//
//  SwitchTableCellDelegateMock.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/1/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Foundation

@testable import ShopApp

class SwitchTableCellDelegateMock: SwitchTableCellDelegate {
    var tableViewCell: SwitchTableViewCell?
    var indexPath: IndexPath?
    var value: Bool?
    
    // MARK: - SwitchTableCellDelegate
    
    func tableViewCell(_ tableViewCell: SwitchTableViewCell, didChangeSwitchStateAt indexPath: IndexPath, with value:
        Bool) {
        self.tableViewCell = tableViewCell
        self.indexPath = indexPath
        self.value = value
    }
}
