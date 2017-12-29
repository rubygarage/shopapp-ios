//
//  PaymentTypeViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/29/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

class PaymentTypeViewController: BaseViewController<PaymentTypeViewModel> {

    override func viewDidLoad() {
        viewModel = PaymentTypeViewModel()
        super.viewDidLoad()

        setupViews()
    }
    
    private func setupViews() {
        title = NSLocalizedString("ControllerTitle.PaymentType", comment: String())
    }
}
