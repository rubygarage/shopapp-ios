//
//  CheckoutViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/20/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

class CheckoutViewController: BaseViewController<CheckoutViewModel> {
    @IBOutlet weak var paymentMethodLabel: UILabel!
    @IBOutlet weak var paymentByWebsiteView: UIView!
    @IBOutlet weak var paymentByWebsiteLabel: UILabel!
    @IBOutlet weak var paymentByWebsiteButton: UIButton!
    @IBOutlet weak var paymentByCardView: UIView!
    @IBOutlet weak var paymentByCardLabel: UILabel!
    @IBOutlet weak var paymentByCardButton: UIButton!
    @IBOutlet weak var paymentByApplePayView: UIView!
    @IBOutlet weak var paymentByApplePayLabel: UILabel!
    @IBOutlet weak var paymentByApplePayButton: UIButton!
    
    override func viewDidLoad() {
        viewModel = CheckoutViewModel()
        super.viewDidLoad()

        setupViews()
        populateViews()
        setupViewModel()
        loadData()
    }
    
    private func setupViews() {
        paymentByWebsiteView.addShadow()
        paymentByCardView.addShadow()
        paymentByApplePayView.addShadow()
    }
    
    private func populateViews() {
        title = NSLocalizedString("ControllerTitle.Checkout", comment: String())
        paymentMethodLabel.text = NSLocalizedString("Label.SelectPaymentMethod", comment: String())

        paymentByWebsiteLabel.text = NSLocalizedString("Label.PaymentMethodWebsite", comment: String())
        paymentByWebsiteButton.setTitle(NSLocalizedString("Button.PaymentMethodWebsite", comment: String()), for: .normal)
        
        paymentByCardLabel.text = NSLocalizedString("Label.PaymentMethodCard", comment: String())
        paymentByCardButton.setTitle(NSLocalizedString("Button.PaymentMethodCard", comment: String()), for: .normal)
        
        paymentByApplePayLabel.text = NSLocalizedString("Label.PaymentMethodApplePay", comment: String())
        paymentByApplePayButton.setTitle(NSLocalizedString("Button.PaymentMethodApplePay", comment: String()), for: .normal)
    }
    
    private func setupViewModel() {
        // TODO:
    }
    
    private func loadData() {
        viewModel.createCheckout()
    }
}
