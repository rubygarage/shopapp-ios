//
//  CheckoutSuccessViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 1/23/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

class CheckoutSuccessViewController: BaseViewController<CheckoutSuccessViewModel> {
    @IBOutlet private weak var thanksForShoppingLabel: UILabel!
    @IBOutlet private weak var orderNumberLabel: UILabel!
    @IBOutlet private weak var viewOrderDetailsButton: BlackButton!
    @IBOutlet private weak var continueShoppingButton: UnderlinedButton!

    // MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        viewModel = CheckoutSuccessViewModel()
        super.viewDidLoad()

        setupViews()
    }
    
    // MARK: - Setup
    private func setupViews() {
        thanksForShoppingLabel.text = "Label.ThanksForShopping".localizable
        
        viewOrderDetailsButton.setTitle("Button.ViewOrderDetails".localizable.uppercased(), for: .normal)
        continueShoppingButton.setTitle("Button.ContinueShopping".localizable.uppercased(), for: .normal)
    }
    
    // MARK: - Actions
    
    @IBAction func viewOrderDetailsTapped(_ sender: BlackButton) {
        // TODO:
    }
    
    @IBAction func continueShoppingTapped(_ sender: UnderlinedButton) {
        // TODO:
    }
}
