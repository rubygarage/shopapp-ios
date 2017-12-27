//
//  AddressListTableViewCell.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/27/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

class AddressListTableViewCell: UITableViewCell {
    @IBOutlet weak var customerNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        setupViews()
    }
    
    // MARK: - public
    public func configure(with address: Address?) {
        populateViews(with: address)
    }
    
    // MARK: - private
    private func setupViews() {
        editButton.setTitle(NSLocalizedString("Button.Edit", comment: String()).uppercased(), for: .normal)
        deleteButton.setTitle(NSLocalizedString("Button.Delete", comment: String()).uppercased(), for: .normal)
    }
    
    private func populateViews(with address: Address?) {
        customerNameLabel.text = address?.fullname
        addressLabel.text = address?.fullAddress
        if let phoneText = address?.phone {
            let customerNameLocalized = NSLocalizedString("Label.Phone", comment: String())
            phoneLabel.text = String.localizedStringWithFormat(customerNameLocalized, phoneText)
        } else {
            phoneLabel.text = nil
        }
    }
}
