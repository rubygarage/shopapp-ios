//
//  CheckoutShippingAddressAddTableCell.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/20/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

protocol CheckoutShippingAddressAddCellProtocol {
    func didTapAddNewAddress()
}

class CheckoutShippingAddressAddTableCell: UITableViewCell {
    @IBOutlet weak var addNewAddressButton: BlackButton!
    
    var delegate: CheckoutShippingAddressAddCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        setupViews()
    }
    
    // MARK: - setup
    private func setupViews() {
        addNewAddressButton.setTitle(NSLocalizedString("Button.AddNewAddress", comment: String()).uppercased(), for: .normal)
    }
    
    // MARK: - actions
    @IBAction func addNewAddressTapped(_ sender: BlackButton) {
        delegate?.didTapAddNewAddress()
    }
}
