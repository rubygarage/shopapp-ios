//
//  ProductOptionCollectionViewCell.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/29/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

class ProductOptionCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var optionTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = CornerRadius.defaultValue
    }
    
    func configure(with text: String?, selected: Bool) {
        optionTitleLabel.text = text
        backgroundColor = selected ? UIColor.green : UIColor.lightGray
    }
}
