//
//  ProductOptionHeaderView.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 10/2/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

class ProductOptionHeaderView: UICollectionReusableView {
    @IBOutlet weak var optionNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with title: String?) {
        optionNameLabel.text = title
    }
}
