//
//  CheckoutShippingOptionsEnabledTableCell.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 1/18/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

class CheckoutShippingOptionsEnabledTableCell: UITableViewCell {
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
    
    public func configure(with rate: ShippingRate, currencyCode: String) {
        let formatter = NumberFormatter.formatter(with: currencyCode)
        let price = NSDecimalNumber(string: rate.price ?? "")
        priceLabel.text = formatter.string(from: price)
        
        titleLabel.text = rate.title
    }
}
