//
//  PaymentTypeTableViewCell.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/29/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

protocol PaymentTypeTableCellProtocol: class {
    func didPayment(with type: PaymentTypeSection)
}

class PaymentTypeTableViewCell: UITableViewCell {
    @IBOutlet weak var paymentTypeLabel: UILabel!
    @IBOutlet weak var paymentTypeImage: UIImageView!
    @IBOutlet weak var paymentSelectButton: UIButton!
    
    weak var delegate: PaymentTypeTableCellProtocol?
    var typeSelected = false
    var type: PaymentTypeSection = .creditCard {
        didSet {
            populateViews()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        paymentTypeLabel.text = "Label.Payment.CreditCard".localizable
    }
    
    private func populateViews() {
        var paymentTitle = ""
        var paymentImage = UIImage()
        switch type {
        case .applePay:
            paymentTitle = "Label.Payment.ApplePay".localizable
            paymentImage = #imageLiteral(resourceName: "payment_apple_pay")
        default:
            paymentTitle = "Label.Payment.CreditCard".localizable
            paymentImage = #imageLiteral(resourceName: "payment_card")
        }
        paymentTypeLabel.text = paymentTitle
        paymentTypeImage.image = paymentImage
        paymentSelectButton.isSelected = typeSelected
    }
    
    // MARK: - actions
    @IBAction func selectPaymentTapped(_ sender: UIButton) {
        paymentSelectButton.isSelected = true
        delegate?.didPayment(with: type)
    }
}
