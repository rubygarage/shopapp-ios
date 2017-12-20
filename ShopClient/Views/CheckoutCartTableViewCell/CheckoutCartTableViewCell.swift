//
//  CheckoutCartTableViewCell.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/20/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

class CheckoutCartTableViewCell: UITableViewCell {
    var cartProducts: [CartProduct]!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
    
    public func configure(with items: [CartProduct]) {
        cartProducts = items
    }
}
