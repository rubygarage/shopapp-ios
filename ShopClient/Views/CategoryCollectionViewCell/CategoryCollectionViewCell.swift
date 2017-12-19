//
//  CategoryCollectionViewCell.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/18/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var categoryTitleLabel: UILabel!
    @IBOutlet weak var categoryImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with category: Category) {
        categoryTitleLabel.text = category.title
        let imageUrl = URL(string: category.image?.src ?? String())
        categoryImageView.sd_setImage(with: imageUrl)
    }
}
