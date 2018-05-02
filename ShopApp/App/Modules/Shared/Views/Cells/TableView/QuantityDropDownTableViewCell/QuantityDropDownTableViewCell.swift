//
//  QuantityDropDownTableViewCell.swift
//  ShopApp
//
//  Created by Evgeniy Antonov on 4/23/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import DropDown

class QuantityDropDownTableViewCell: DropDownCell {
    private let fontSize: CGFloat = 14
    
    public func configure(with textCenter: Bool) {
        optionLabel.textAlignment = textCenter ? .center : .left
        optionLabel.font = textCenter ? UIFont.boldSystemFont(ofSize: fontSize) : UIFont.systemFont(ofSize: fontSize)
    }
}
