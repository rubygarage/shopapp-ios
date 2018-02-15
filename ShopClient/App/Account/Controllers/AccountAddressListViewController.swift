//
//  AccountAddressListViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 2/13/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

class AccountAddressListViewController: AddressListViewController<AddressListViewModel> {
    
    // MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        viewModel = AddressListViewModel()
        super.viewDidLoad()
    }
}
