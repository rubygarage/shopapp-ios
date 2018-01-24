//
//  CheckoutSelectedTypeTableCell.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 1/24/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

protocol CheckoutSelectedTypeTableCellProtocol: class {
    func didTapEditPaymentType()
}

class CheckoutSelectedTypeTableCell: UITableViewCell {
    @IBOutlet private weak var paymentTypeImage: UIImageView!
    @IBOutlet private weak var paymentTypeLabel: UILabel!
    @IBOutlet private weak var editButton: UIButton!
    
    weak var delegate: CheckoutSelectedTypeTableCellProtocol?
    
    // MARK: - View lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        editButton?.setTitle("Button.Edit".localizable.uppercased(), for: .normal)
    }
    
    public func configure(type: PaymentTypeSection) {
        var paymentImage = UIImage()
        var paymentTitle = ""
        switch type {
        case .applePay:
            paymentImage = #imageLiteral(resourceName: "payment_apple_pay")
            paymentTitle = "Label.Payment.ApplePay".localizable
        default:
            paymentImage = #imageLiteral(resourceName: "payment_card")
            paymentTitle = "Label.Payment.CreditCard".localizable
        }
        paymentTypeLabel.text = paymentTitle
        paymentTypeImage.image = paymentImage
    }
    
    // MARK: - Actions
    
    @IBAction func editTapped(_ sender: UIButton) {
        delegate?.didTapEditPaymentType()
    }
}
