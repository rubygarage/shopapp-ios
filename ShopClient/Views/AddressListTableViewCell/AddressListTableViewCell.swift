//
//  AddressListTableViewCell.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/27/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

protocol AddressListTableViewCellProtocol {
    func didSelectAddress(with address: Address?)
}

class AddressListTableViewCell: UITableViewCell {
    @IBOutlet weak var customerNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    var delegate: AddressListTableViewCellProtocol!
    var address: Address?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        setupViews()
    }
    
    // MARK: - public
    public func configure(with addressTuple: AddressTuple, delegate: AddressListTableViewCellProtocol) {
        address = addressTuple.address
        self.delegate = delegate
        populateViews(with: addressTuple)
    }
    
    // MARK: - private
    private func setupViews() {
        editButton.setTitle(NSLocalizedString("Button.Edit", comment: String()).uppercased(), for: .normal)
        deleteButton.setTitle(NSLocalizedString("Button.Delete", comment: String()).uppercased(), for: .normal)
    }
    
    private func populateViews(with addressTuple: AddressTuple) {
        let address = addressTuple.address
        customerNameLabel.text = address?.fullname
        addressLabel.text = address?.fullAddress
        if let phoneText = address?.phone {
            let customerNameLocalized = NSLocalizedString("Label.Phone", comment: String())
            phoneLabel.text = String.localizedStringWithFormat(customerNameLocalized, phoneText)
        } else {
            phoneLabel.text = nil
        }
        selectButton.isSelected = addressTuple.selected
        deleteButton.isEnabled = !addressTuple.selected
    }
    
    // MARK: - actions
    @IBAction func selectTapped(_ sender: UIButton) {
        delegate.didSelectAddress(with: address)
    }
}
