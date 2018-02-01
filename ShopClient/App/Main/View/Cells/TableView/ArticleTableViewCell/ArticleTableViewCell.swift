//
//  ArticleTableViewCell.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/14/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {
    @IBOutlet private weak var articleImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var separatorView: UIView!
    
    // MARK: - View lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
    
    // MARK: - Setup
    
    func configure(with item: Article, separatorHidden: Bool) {
        articleImageView.set(image: item.image)
        titleLabel.text = item.title
        descriptionLabel.text = item.content
        authorLabel.text = item.author?.fullName
        separatorView.isHidden = separatorHidden
    }
}
