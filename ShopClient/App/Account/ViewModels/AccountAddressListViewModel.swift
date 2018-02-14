//
//  AccountAddressListViewModel.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 2/13/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

class AccountAddressListViewModel: AddressListViewModel {
    override func processDeleteAddressResponse(with isSelected: Bool) {
        loadCustomerAddresses(isTranslucentHud: true)
    }
}
