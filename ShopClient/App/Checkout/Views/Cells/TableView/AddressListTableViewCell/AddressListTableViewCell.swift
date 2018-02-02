//
//  AddressListTableViewCell.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/27/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

protocol AddressListTableViewCellDelegate: class {
    func tableViewCell(_ cell: AddressListTableViewCell, didSelect address: Address)
    func tableViewCell(_ cell: AddressListTableViewCell, didTapEdit address: Address)
    func tableViewCell(_ cell: AddressListTableViewCell, didTapDelete address: Address)
    func tableViewCell(_ cell: AddressListTableViewCell, didTapDefault address: Address)
}

class AddressListTableViewCell: UITableViewCell {
    @IBOutlet private weak var customerNameLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var phoneLabel: UILabel!
    @IBOutlet private weak var selectButton: UIButton!
    @IBOutlet private weak var editButton: UIButton!
    @IBOutlet private weak var deleteButton: UIButton!
    @IBOutlet private weak var defaultAddressButton: UIButton!
    
    private var address: Address!
    
    weak var delegate: AddressListTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        setupViews()
    }
    
    func configure(with address: Address, isSelected: Bool, isDefault: Bool) {
        self.address = address
        populateViews(with: address, isSelected: isSelected, isDefault: isDefault)
    }
        
    private func setupViews() {
        editButton.setTitle("Button.Edit".localizable.uppercased(), for: .normal)
        deleteButton.setTitle("Button.Delete".localizable.uppercased(), for: .normal)
        defaultAddressButton.setTitle("Button.Default".localizable.uppercased(), for: .normal)
    }
    
    private func populateViews(with address: Address, isSelected: Bool, isDefault: Bool) {
        customerNameLabel.text = address.fullName
        addressLabel.text = address.fullAddress
        if let phoneText = address.phone {
            let customerNameLocalized = "Label.Phone".localizable
            phoneLabel.text = String.localizedStringWithFormat(customerNameLocalized, phoneText)
        } else {
            phoneLabel.text = nil
        }
        selectButton.isSelected = isSelected
        deleteButton.isEnabled = !isDefault
        defaultAddressButton.isEnabled = !isDefault
    }
    
    // MARK: - Actions
    
    @IBAction func selectTapped(_ sender: UIButton) {
        delegate?.tableViewCell(self, didSelect: address)
    }
    
    @IBAction func editTapped(_ sender: UIButton) {
        delegate?.tableViewCell(self, didTapEdit: address)
    }
    
    @IBAction func deleteTapped(_ sender: UIButton) {
        delegate?.tableViewCell(self, didTapDelete: address)
    }
    
    @IBAction func defaultAddressTapped(_ sender: UIButton) {
        delegate?.tableViewCell(self, didTapDefault: address)
    }
}
