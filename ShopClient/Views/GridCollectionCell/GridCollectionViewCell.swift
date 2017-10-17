//
//  GridCollectionViewCell.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/1/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit
import SDWebImage

let kShadowOpacity: Float = 0.5
let kShadowRadius: CGFloat = 1.5

class GridCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        detailsView.layer.shadowColor = UIColor.lightGray.cgColor
        detailsView.layer.shadowOpacity = kShadowOpacity
        detailsView.layer.shadowOffset = CGSize.zero
        detailsView.layer.shadowRadius = kShadowRadius
    }

    public func configure(with item: Product) {
        let imageUrl = URL(string: item.imagesArray?.first?.src ?? String())
        productImageView.sd_setImage(with: imageUrl, completed: nil)
        titleLabel.text = item.title
        priceLabel.text = "\(item.lowestPrice) \(item.currency)"
    }
}
