//
//  GridCollectionViewCell.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/1/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit
import SDWebImage

private let kNumberOfColumns: CGFloat = 2
private let kCollectionViewMargin: CGFloat = 7
private let kCellRatio: CGFloat = 210 / 185

class GridCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!

    public func configure(with item: Product) {
        let imageUrl = URL(string: item.images?.first?.src ?? String())
        productImageView.sd_setImage(with: imageUrl, completed: nil)
        titleLabel.text = item.title
        let formatter = NumberFormatter.formatter(with: item.currency!)
        let localizedString = NSLocalizedString("Label.PriceFrom", comment: String())
        let price = NSDecimalNumber(string: item.lowestPrice)
        priceLabel.text = String.localizedStringWithFormat(localizedString, formatter.string(from: price)!)
    }
}

extension GridCollectionViewCell {
    class var cellSize: CGSize {
        let screenWidth = UIScreen.main.bounds.size.width
        let collectionViewWidth = screenWidth - 2 * kCollectionViewMargin
        let cellWidth = collectionViewWidth / kNumberOfColumns
        let cellHeight = Float(cellWidth * kCellRatio)
        let roundedCellheight = CGFloat(lroundf(cellHeight))
        return CGSize(width: cellWidth, height: roundedCellheight)
    }
    
    class var collectionViewInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: kCollectionViewMargin, bottom: 0, right: kCollectionViewMargin)
    }
}
