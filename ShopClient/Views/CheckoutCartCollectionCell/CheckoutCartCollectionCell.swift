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
    @IBOutlet weak var cartItemImageView: UIImageView!
    
    public func configure(with item: Image) {
        let imageUrl = URL(string: item.src ?? String())
        cartItemImageView.sd_setImage(with: imageUrl)
    }
}

extension CheckoutCartCollectionCell {
    class var cellSize: CGSize {
        return kCellSize
    }
}
