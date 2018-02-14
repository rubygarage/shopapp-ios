//
//  CheckoutAddressListViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 2/13/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

class CheckoutAddressListViewController: AddressListViewController<CheckoutAddressListViewModel> {
    var checkoutId: String!
    
    override func viewDidLoad() {
        viewModel = CheckoutAddressListViewModel()
        super.viewDidLoad()

        setupViewModel()
    }
    
    private func setupViewModel() {
        viewModel.checkoutId = checkoutId
    }
}
