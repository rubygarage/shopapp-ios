//
//  PaymentApplePayTableCell.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 1/11/18.
//  Copyright © 2018 Evgeniy Antonov. All rights reserved.
//

import UIKit

class PaymentApplePayTableCell: UITableViewCell {
    @IBOutlet weak var paymentTypeLabel: UILabel!
    @IBOutlet weak var paymentSelectButton: UIButton!
    @IBOutlet weak var setupApplePayButton: BlackButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        paymentTypeLabel.text = "Label.Payment.ApplePay".localizable
        setupApplePayButton.setTitle("Button.SetUp".localizable, for: .normal)
        setupApplePayButton.layer.cornerRadius = Layer.cornerRadius
    }
    
    // MARK: - actions
    @IBAction func selectPaymentTapped(_ sender: UIButton) {
        // TODO:
    }
    
    @IBAction func setupApplePayTapped(_ sender: BlackButton) {
        // TODO:
    }
}
