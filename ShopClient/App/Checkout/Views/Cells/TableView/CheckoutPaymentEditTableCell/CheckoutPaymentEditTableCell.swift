//
//  CheckoutPaymentEditTableCell.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 1/3/18.
//  Copyright © 2018 Evgeniy Antonov. All rights reserved.
//

import UIKit

protocol CheckoutPaymentEditTableCellProtocol: class {
    func didTapEditPaymentType()
}

class CheckoutPaymentEditTableCell: UITableViewCell {
    @IBOutlet weak var creditCardLabel: UILabel!
    @IBOutlet weak var cardNumberLabel: UILabel!
    @IBOutlet weak var expirationDateLabel: UILabel!
    @IBOutlet weak var holderNameLabel: UILabel!
    @IBOutlet weak var billingAddressTitleLabel: UILabel!
    @IBOutlet weak var billingAddressLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    
    weak var delegate: CheckoutPaymentEditTableCellProtocol?
    
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
    
    // MARK: - Private
    
    private func setupViews() {
        creditCardLabel?.text = "Label.Payment.CreditCard".localizable
        billingAddressTitleLabel?.text = "Label.BillingAddress".localizable
        editButton?.setTitle("Button.Edit".localizable.uppercased(), for: .normal)
    }
    
    // MARK: - Actions
    
    @IBAction func editTapped(_ sender: UIButton) {
        delegate?.didTapEditPaymentType()
    }
}
