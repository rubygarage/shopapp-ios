//
//  CheckoutCartCollectionCell.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/20/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

import ShopApp_Gateway

class CheckoutCartCollectionCell: UICollectionViewCell {
    @IBOutlet private weak var cartItemImageView: UIImageView!
    
    class var cellSize: CGSize {
        return CGSize(width: 111, height: 98)
    }
    
    var productVariantId = ""
    
    // MARK: - Setup
    
    func configure(with item: Image, productVariantId: String) {
        cartItemImageView.set(image: item)
        self.productVariantId = productVariantId
    }
}
