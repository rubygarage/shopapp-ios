//
//  MenuCategoryTableViewCell.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/18/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit
import SDWebImage

class MenuCategoryTableViewCell: UITableViewCell {
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
    
    func configure(with category: CategoryEntity?) {
        let imageUrl = URL(string: category?.image?.src ?? String())
        categoryImageView.sd_setImage(with: imageUrl)
        titleLabel.text = category?.title
    }
}
