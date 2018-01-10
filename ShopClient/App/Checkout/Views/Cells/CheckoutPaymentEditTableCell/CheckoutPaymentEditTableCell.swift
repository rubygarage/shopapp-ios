//
//  CheckoutPaymentEditTableCell.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 1/3/18.
//  Copyright © 2018 Evgeniy Antonov. All rights reserved.
//

import UIKit

class CheckoutPaymentEditTableCell: UITableViewCell {
    @IBOutlet weak var creditCardLabel: UILabel!
    @IBOutlet weak var cardNumberLabel: UILabel!
    @IBOutlet weak var expirationDateLabel: UILabel!
    @IBOutlet weak var holderNameLabel: UILabel!
    @IBOutlet weak var billingAddressTitleLabel: UILabel!
    @IBOutlet weak var billingAddressLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        setupViews()
    }
    
    public func configure(with billingAddress: Address, creditCard: CreditCard) {
        cardNumberLabel.text = creditCard.maskedNumber
        expirationDateLabel.text = creditCard.expirationDateLocalized
        holderNameLabel.text = creditCard.holderName
        billingAddressLabel.text = billingAddress.fullAddress
    }
    
    // MARK: - private
    private func setupViews() {
        creditCardLabel?.text = NSLocalizedString("Label.Payment.CreditCard", comment: String())
        billingAddressTitleLabel?.text = NSLocalizedString("Label.BillingAddress", comment: String())
        editButton?.setTitle(NSLocalizedString("Button.Edit", comment: String()).uppercased(), for: .normal)
    }
}
