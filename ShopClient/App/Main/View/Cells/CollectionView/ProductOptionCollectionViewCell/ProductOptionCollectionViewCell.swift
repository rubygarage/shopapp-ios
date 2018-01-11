//
//  ProductOptionCollectionViewCell.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/29/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

let kProductUnselectedOptionColor = UIColor(red:0.92, green:0.92, blue:0.92, alpha:1)

class ProductOptionCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var optionTitleLabel: UILabel!
    
    func configure(with text: String, selected: Bool) {
        optionTitleLabel.text = text
        optionTitleLabel.textColor = selected ? UIColor.white : UIColor.black
        backgroundColor = selected ? UIColor.black : kProductUnselectedOptionColor
        //contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        layer.cornerRadius = frame.size.height / 2
    }
}
