//
//  DetailsImagesCollectionViewCell.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/13/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

class DetailsImagesCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var productImageView: UIImageView!

    public func configure(with image: Image) {
        let imageUrl = URL(string: image.src ?? "")
        productImageView.sd_setImage(with: imageUrl, completed: nil)
    }
}
