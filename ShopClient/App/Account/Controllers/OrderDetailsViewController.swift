//
//  OrderDetailsViewController.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 1/3/18.
//  Copyright © 2018 Evgeniy Antonov. All rights reserved.
//

import UIKit

class OrderDetailsViewController: BaseViewController<OrderDetailsViewModel> {
    var orderId: String!
    
    // MARK: - view controller lifecycle
    override func viewDidLoad() {
        viewModel = OrderDetailsViewModel()
        super.viewDidLoad()
        
        setupViews()
    }
    
    // MARK: - setup
    private func setupViews() {
        title = NSLocalizedString("ControllerTitle.OrderDetails", comment: String())
    }
}
