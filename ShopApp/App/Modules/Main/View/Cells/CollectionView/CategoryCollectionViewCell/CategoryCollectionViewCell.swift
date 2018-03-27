//
//  CategoryCollectionViewCell.swift
//  ShopApp
//
//  Created by Evgeniy Antonov on 12/18/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

import ShopApp_Gateway

class CategoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var categoryTitleLabel: UILabel!
    @IBOutlet private weak var categoryImageView: UIImageView!
    
    private static let collectionViewMarginHorizontal: CGFloat = 4
    private static let collectionViewMarginVertical: CGFloat = 4
    private static let numberOfColumns: CGFloat = 2
    private static let cellRatio: CGFloat = 140 / 169
    
    class var cellSize: CGSize {
        let screenWidth = UIScreen.main.bounds.size.width
        let collectionViewWidth = screenWidth - 2 * collectionViewMarginHorizontal
        let cellWidth = collectionViewWidth / numberOfColumns
        let cellHeight = Float(cellWidth * cellRatio)
        let roundedCellheight = CGFloat(lroundf(cellHeight))
        return CGSize(width: cellWidth, height: roundedCellheight)
    }
    class var collectionViewInsets: UIEdgeInsets {
        return UIEdgeInsets(top: collectionViewMarginVertical, left: collectionViewMarginHorizontal, bottom: collectionViewMarginVertical, right: collectionViewMarginHorizontal)
    }
    
    // MARK: - Setup
    
    func configure(with category: ShopApp_Gateway.Category) {
        categoryTitleLabel.text = category.title
        categoryImageView.set(image: category.image, initialContentMode: .top)
    }
}
