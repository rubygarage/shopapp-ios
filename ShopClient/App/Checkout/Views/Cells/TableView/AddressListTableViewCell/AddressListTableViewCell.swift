//
//  AddressListTableViewCell.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/27/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

protocol AddressListTableViewCellProtocol: class {
    func didTapSelect(with address: Address)
    func didTapEdit(with address: Address)
    func didTapDelete(with address: Address)
}

class AddressListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var customerNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    private var address: Address!
    
    weak var delegate: AddressListTableViewCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        setupViews()
    }
    
    // MARK: - Public
    
    public func configure(with address: Address, selected: Bool) {
        self.address = address
        populateViews(with: address, selected: selected)
    }
    
    // MARK: - Private
    
    private func setupViews() {
        editButton.setTitle("Button.Edit".localizable.uppercased(), for: .normal)
        deleteButton.setTitle("Button.Delete".localizable.uppercased(), for: .normal)
    }
    
    private func populateViews(with address: Address, selected: Bool) {
        customerNameLabel.text = address.fullname
        addressLabel.text = address.fullAddress
        if let phoneText = address.phone {
            let customerNameLocalized = "Label.Phone".localizable
            phoneLabel.text = String.localizedStringWithFormat(customerNameLocalized, phoneText)
        } else {
            phoneLabel.text = nil
        }
        selectButton.isSelected = selected
        deleteButton.isEnabled = !selected
    }
    
    // MARK: - Actions
    
    @IBAction func selectTapped(_ sender: UIButton) {
        delegate?.didTapSelect(with: address)
    }
    
    @IBAction func editTapped(_ sender: UIButton) {
        delegate?.didTapEdit(with: address)
    }
    
    @IBAction func deleteTapped(_ sender: UIButton) {
        delegate?.didTapDelete(with: address)
    }
}
