//
//  CheckoutShippingAddressEditTableCell.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/21/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

class CheckoutShippingAddressEditTableCell: UITableViewCell {
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        setupViews()
    }
    
    func configure(with address: Address) {
        populateViews(with: address)
    }
    
    // MARK: - private
    private func setupViews() {
        editButton.setTitle(NSLocalizedString("Button.Edit", comment: String()).uppercased(), for: .normal)
    }
    
    private func populateViews(with address: Address) {
        nameLabel.text = address.fullname
        addressLabel.text = address.fullAddress
        phoneLabel.text = address.phone
    }
}
