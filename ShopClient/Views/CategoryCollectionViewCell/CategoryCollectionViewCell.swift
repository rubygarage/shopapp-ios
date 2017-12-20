//
//  CategoryCollectionViewCell.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/18/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

private let kCollectionViewMarginHorizontal: CGFloat = 13
private let kCollectionViewMarginVertical: CGFloat = 20
private let kNumberOfColumns: CGFloat = 2
private let kCellRatio: CGFloat = 140 / 169

class CategoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var categoryTitleLabel: UILabel!
    @IBOutlet weak var categoryImageView: UIImageView!
    
    func configure(with category: Category) {
        categoryTitleLabel.text = category.title
        let imageUrl = URL(string: category.image?.src ?? String())
        categoryImageView.sd_setImage(with: imageUrl)
    }
}

extension CategoryCollectionViewCell {
    class var cellSize: CGSize {
        let screenWidth = UIScreen.main.bounds.size.width
        let collectionViewWidth = screenWidth - 2 * kCollectionViewMarginHorizontal
        let cellWidth = collectionViewWidth / kNumberOfColumns
        let cellHeight = Float(cellWidth * kCellRatio)
        let roundedCellheight = CGFloat(lroundf(cellHeight))
        return CGSize(width: cellWidth, height: roundedCellheight)
    }
    
    class var collectionViewInsets: UIEdgeInsets {
        return UIEdgeInsets(top: kCollectionViewMarginVertical, left: kCollectionViewMarginHorizontal, bottom: kCollectionViewMarginVertical, right: kCollectionViewMarginHorizontal)
    }
}
