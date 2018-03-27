//
//  CheckoutShippingAddressAddTableViewCell.swift
//  ShopApp
//
//  Created by Evgeniy Antonov on 12/20/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

protocol CheckoutShippingAddressAddCellDelegate: class {
    func tableViewCellDidTapAddNewAddress(_ cell: CheckoutShippingAddressAddTableViewCell)
}

class CheckoutShippingAddressAddTableViewCell: UITableViewCell {
    @IBOutlet private weak var addNewAddressButton: BlackButton!
    
    weak var delegate: CheckoutShippingAddressAddCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        setupViews()
    }
    
    // MARK: - setup
    private func setupViews() {
        addNewAddressButton.setTitle("Button.AddNewAddress".localizable.uppercased(), for: .normal)
    }
    
    // MARK: - actions
    @IBAction func addNewAddressTapped(_ sender: BlackButton) {
        delegate?.tableViewCellDidTapAddNewAddress(self)
    }
}
