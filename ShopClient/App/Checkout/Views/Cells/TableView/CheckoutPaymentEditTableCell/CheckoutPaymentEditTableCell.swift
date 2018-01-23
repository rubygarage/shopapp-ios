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
    @IBOutlet private weak var creditCardLabel: UILabel!
    @IBOutlet private weak var cardNumberLabel: UILabel!
    @IBOutlet private weak var expirationDateLabel: UILabel!
    @IBOutlet private weak var holderNameLabel: UILabel!
    @IBOutlet private weak var billingAddressTitleLabel: UILabel!
    @IBOutlet private weak var billingAddressLabel: UILabel!
    @IBOutlet private weak var editButton: UIButton!
    
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
