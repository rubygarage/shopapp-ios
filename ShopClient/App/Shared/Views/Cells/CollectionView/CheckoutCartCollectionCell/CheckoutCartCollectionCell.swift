//
//  CheckoutCartCollectionCell.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/20/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

private let kCellSize = CGSize(width: 111, height: 98)

class CheckoutCartCollectionCell: UICollectionViewCell {
    @IBOutlet private weak var cartItemImageView: UIImageView!
    
    var productVariantId = ""
    
    // MARK: - Setup
    
    func configure(with item: Image, productVariantId: String) {
        let imageUrl = URL(string: item.src ?? "")
        cartItemImageView.sd_setImage(with: imageUrl)
        self.productVariantId = productVariantId
    }
}

extension CheckoutCartCollectionCell {
    class var cellSize: CGSize {
        return kCellSize
    }
}
