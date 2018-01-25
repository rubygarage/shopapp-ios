//
//  CheckoutBillingAddressEditTableCell.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 1/25/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

protocol CheckoutBillingAddressEditTableCellProtocol: class {
    func didTapEditBillingAddress()
}

class CheckoutBillingAddressEditTableCell: UITableViewCell {
    @IBOutlet private weak var addressTitleLabel: UILabel!
    @IBOutlet private weak var addressDescriptionLabel: UILabel!
    @IBOutlet private weak var editButton: UIButton!
    
    weak var delegate: CheckoutBillingAddressEditTableCellProtocol?
    
    // MARK: - View lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        editButton?.setTitle("Button.Edit".localizable.uppercased(), for: .normal)
    }
    
    // MARK: - Public
    
    public func configure(with address: Address) {
        addressTitleLabel.text = "Label.BillingAddress".localizable
        addressDescriptionLabel.text = address.fullAddress
    }
    
    // MARK: - Actions
    
    @IBAction func editTapped(_ sender: UIButton) {
        delegate?.didTapEditBillingAddress()
    }
}
