//
//  CheckoutShippingAddressEditTableCell.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/21/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

class CheckoutShippingAddressEditTableCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
    
    func configure(with address: Address) {
        populateViews(with: address)
    }
    
    // MARK: - private
    private func populateViews(with address: Address) {
        
    }
}
