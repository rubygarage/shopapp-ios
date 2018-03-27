//
//  ArticleTableViewCell.swift
//  ShopApp
//
//  Created by Evgeniy Antonov on 9/14/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

import ShopApp_Gateway

class ArticleTableViewCell: UITableViewCell {
    @IBOutlet private weak var articleImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var separatorView: UIView!
    @IBOutlet private weak var titleLabelTrailingLayoutConstraint: NSLayoutConstraint!
    
    private let titleLabelTrailingDefault: CGFloat = 151
    private let titleLabelTrailingWide: CGFloat = 16
    
    // MARK: - View lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
    
    // MARK: - Setup
    
    func configure(with item: Article, separatorHidden: Bool) {
        if let image = item.image {
            articleImageView.set(image: image)
        }
        articleImageView.isHidden = item.image == nil
        titleLabelTrailingLayoutConstraint.constant = item.image == nil ? titleLabelTrailingWide : titleLabelTrailingDefault
        titleLabel.text = item.title
        descriptionLabel.text = item.content
        authorLabel.text = item.author?.fullName
        separatorView.isHidden = separatorHidden
    }
}
