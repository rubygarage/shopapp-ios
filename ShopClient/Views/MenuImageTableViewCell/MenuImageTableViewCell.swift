//
//  MenuImageTableViewCell.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/22/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit
import SDWebImage

class MenuImageTableViewCell: UITableViewCell {
    @IBOutlet weak var menuImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
    
    func configure(with title: String?, imageName: String? = nil, imageUrl: String? = nil) {
        titleLabel.text = title
        if let img = imageName {
            menuImageView.image = UIImage(named: img)
        }
        if let urlString = imageUrl {
            let url = URL(string: urlString)
            menuImageView.sd_setImage(with: url)
        }
    }
}
