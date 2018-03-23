//
//  ProductOptionCollectionViewCell.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/29/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

class ProductOptionCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var optionTitleLabel: UILabel!
    
    private let productUnselectedOptionColor = UIColor(red: 0.92, green: 0.92, blue: 0.92, alpha: 1)
    
    // MARK: - Setup
    
    func configure(with text: String, selected: Bool) {
        optionTitleLabel.text = text
        optionTitleLabel.textColor = selected ? UIColor.white : UIColor.black
        backgroundColor = selected ? UIColor.black : productUnselectedOptionColor
        layer.cornerRadius = frame.size.height / 2
    }
}
