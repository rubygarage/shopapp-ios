//
//  ArticleTableViewCell.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/14/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
    
    func configure(with item: Article?, separatorHidden: Bool) {
        articleImageView.set(image: item?.image)
        titleLabel.text = item?.title
        descriptionLabel.text = item?.content
        authorLabel.text = item?.author?.fullName
        separatorView.isHidden = separatorHidden
    }
}
