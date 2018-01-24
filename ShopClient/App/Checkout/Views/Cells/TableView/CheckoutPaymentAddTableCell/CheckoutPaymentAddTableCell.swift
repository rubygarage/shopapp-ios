//
//  CheckoutPaymentAddTableCell.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/29/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

protocol CheckoutPaymentAddCellProtocol: class {
    func didTapAddPayment(type: PaymentTypeRow)
}

class CheckoutPaymentAddTableCell: UITableViewCell {
    @IBOutlet private weak var addPaymentButton: BlackButton!
    
    private var paymentRow: PaymentTypeRow = .type
    
    weak var delegate: CheckoutPaymentAddCellProtocol?
    
    // MARK: - View lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
    
    public func configure(type: PaymentTypeRow) {
        paymentRow = type
        switch type {
        case PaymentTypeRow.type:
            addPaymentButton.setTitle("Button.AddPaymentType".localizable.uppercased(), for: .normal)
        case PaymentTypeRow.card:
            addPaymentButton.setTitle("Button.AddCard".localizable.uppercased(), for: .normal)
        case PaymentTypeRow.billingAddress:
            addPaymentButton.setTitle("Button.AddBillingAddress".localizable.uppercased(), for: .normal)
        }
    }
    
    // MARK: - actions
    
    @IBAction func addPaymentTapped(_ sender: BlackButton) {
        delegate?.didTapAddPayment(type: paymentRow)
    }
}
