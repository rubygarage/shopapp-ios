//
//  LastArrivalsCollectionViewCell.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/15/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit
import SDWebImage

class LastArrivalsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    func configure(with item: Product) {
        let imageUrl = URL(string: item.images?.first?.src ?? String())
        productImageView.sd_setImage(with: imageUrl)
        titleLabel.text = item.title
        let localizedString = NSLocalizedString("Label.PriceFrom", comment: String())
        priceLabel.text = String.localizedStringWithFormat(localizedString, item.lowestPrice, item.currency)
    }
}
