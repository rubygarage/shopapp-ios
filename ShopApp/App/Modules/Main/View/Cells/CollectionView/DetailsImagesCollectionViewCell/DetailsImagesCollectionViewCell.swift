//
//  DetailsImagesCollectionViewCell.swift
//  ShopApp
//
//  Created by Evgeniy Antonov on 9/13/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

import ShopApp_Gateway

class DetailsImagesCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var productImageView: UIImageView!

    // MARK: - Setup
    
    func configure(with image: Image) {
        productImageView.set(image: image)
    }
}
