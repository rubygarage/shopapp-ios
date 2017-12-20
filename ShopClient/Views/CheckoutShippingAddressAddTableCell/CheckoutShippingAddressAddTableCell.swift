//
//  CheckoutShippingAddressAddTableCell.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/20/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

class CheckoutShippingAddressAddTableCell: UITableViewCell {
    @IBOutlet weak var addNewAddressButton: BlackButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        setupViews()
    }
    
    private func setupViews() {
        addNewAddressButton.setTitle(NSLocalizedString("Button.AddNewAddress", comment: String()).uppercased(), for: .normal)
    }
}
