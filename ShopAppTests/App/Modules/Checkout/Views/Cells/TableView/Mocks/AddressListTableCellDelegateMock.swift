//
//  AddressListTableCellDelegateMock.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 5/3/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

@testable import ShopApp

class AddressListTableCellDelegateMock: AddressListTableCellDelegate {
    var cell: AddressListTableViewCell?
    var address: Address?
    var selectAddressDidPress = false
    var editAddressDidPress = false
    var deleteAddressDidPress = false
    var defaultAddressDidPress = false
    
    // MARK: - AddressListTableCellDelegate
    
    func tableViewCell(_ cell: AddressListTableViewCell, didSelect address: Address) {
        selectAddressDidPress = true
        
        self.cell = cell
        self.address = address
    }
    
    func tableViewCell(_ cell: AddressListTableViewCell, didTapEdit address: Address) {
        editAddressDidPress = true
        
        self.cell = cell
        self.address = address
    }
    
    func tableViewCell(_ cell: AddressListTableViewCell, didTapDelete address: Address) {
        deleteAddressDidPress = true
        
        self.cell = cell
        self.address = address
    }
    
    func tableViewCell(_ cell: AddressListTableViewCell, didTapDefault address: Address) {
        defaultAddressDidPress = true
        
        self.cell = cell
        self.address = address
    }
}
