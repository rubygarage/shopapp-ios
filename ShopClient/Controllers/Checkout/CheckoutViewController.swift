//
//  CheckoutViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/20/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

class CheckoutViewController: BaseViewController<CheckoutViewModel> {

    override func viewDidLoad() {
        viewModel = CheckoutViewModel()
        super.viewDidLoad()

        setupViews()
    }
    
    private func setupViews() {
        title = NSLocalizedString("ControllerTitle.Checkout", comment: String())
    }
}
