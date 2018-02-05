//
//  CheckoutBillingAddressEditTableViewCell.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 1/25/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

protocol CheckoutBillingAddressEditCellDelegate: class {
    func tableViewCellDidTapEditBillingAddress(_ cell: CheckoutBillingAddressEditTableViewCell)
}

class CheckoutBillingAddressEditTableViewCell: UITableViewCell {
    @IBOutlet private weak var addressTitleLabel: UILabel!
    @IBOutlet private weak var addressDescriptionLabel: UILabel!
    @IBOutlet private weak var editButton: UIButton!
    
    weak var delegate: CheckoutBillingAddressEditCellDelegate?
    
    // MARK: - View lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        editButton?.setTitle("Button.Edit".localizable.uppercased(), for: .normal)
    }
    
    func configure(with address: Address) {
        addressTitleLabel.text = "Label.BillingAddress".localizable
        addressDescriptionLabel.text = address.fullAddress
    }
    
    // MARK: - Actions
    
    @IBAction func editButtonDidPress(_ sender: UIButton) {
        delegate?.tableViewCellDidTapEditBillingAddress(self)
    }
}
