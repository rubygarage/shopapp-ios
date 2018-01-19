//
//  CheckoutShippingOptionsDisabledTableCell.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 1/18/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

class CheckoutShippingOptionsDisabledTableCell: UITableViewCell {
    @IBOutlet private weak var addAddressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        addAddressLabel.text = "Label.Checkout.AddShippingAddress".localizable
    }
}
