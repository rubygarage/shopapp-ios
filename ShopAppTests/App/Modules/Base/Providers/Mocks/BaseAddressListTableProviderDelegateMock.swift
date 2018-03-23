//
//  BaseAddressListTableProviderDelegateMock.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 3/1/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

import ShopApp_Gateway

@testable import ShopApp

class BaseAddressListTableProviderDelegateMock: NSObject, AddressListTableCellDelegate, AddressListHeaderViewDelegate {
    var didTapSelectAddress = false
    var didTapEditAddress = false
    var didTapDeleteAddress = false
    var didTapDefaultAddress = false
    var didTapAddAddress = false
    
    // MARK: - AddressListTableCellDelegate
    
    func tableViewCell(_ cell: AddressListTableViewCell, didSelect address: Address) {
        didTapSelectAddress = true
    }
    
    func tableViewCell(_ cell: AddressListTableViewCell, didTapEdit address: Address) {
        didTapEditAddress = true
    }
    
    func tableViewCell(_ cell: AddressListTableViewCell, didTapDelete address: Address) {
        didTapDeleteAddress = true
    }
    
    func tableViewCell(_ cell: AddressListTableViewCell, didTapDefault address: Address) {
        didTapDefaultAddress = true
    }
    
    // MARK: - AddressListHeaderViewDelegate
    
    func tableViewHeaderDidTapAddAddress(_ header: AddressListTableHeaderView) {
        didTapAddAddress = true
    }
}
