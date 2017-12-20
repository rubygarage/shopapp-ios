//
//  CheckoutNewViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/20/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

class CheckoutNewViewController: BaseViewController<CheckoutNewViewModel> {

    override func viewDidLoad() {
        viewModel = CheckoutNewViewModel()
        super.viewDidLoad()

        setupViews()
    }
    
    private func setupViews() {
        addCloseButton()
        title = NSLocalizedString("ControllerTitle.Checkout", comment: String())
    }
}
