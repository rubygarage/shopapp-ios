//
//  GridCollectionViewCell.swift
//  ShopApp
//
//  Created by Evgeniy Antonov on 9/1/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

import ShopApp_Gateway

class GridCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var productImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    
    private static let numberOfColumns: CGFloat = 2
    private static let collectionViewMarginTop: CGFloat = 80
    private static let collectionViewMarginVertical: CGFloat = 20
    private static let collectionViewMarginHorizontal: CGFloat = 7
    private static let cellRatio: CGFloat = 210 / 185
    
    class var cellSize: CGSize {
        let screenWidth = UIScreen.main.bounds.size.width
        let collectionViewWidth = screenWidth - 2 * collectionViewMarginHorizontal
        let cellWidth = (collectionViewWidth - collectionViewMarginHorizontal) / numberOfColumns
        let cellHeight = Float(cellWidth * cellRatio)
        let roundedCellheight = CGFloat(lroundf(cellHeight))
        return CGSize(width: cellWidth, height: roundedCellheight)
    }
    class var defaultCollectionViewInsets: UIEdgeInsets {
        return UIEdgeInsets(top: collectionViewMarginVertical, left: collectionViewMarginHorizontal, bottom: collectionViewMarginVertical, right: collectionViewMarginHorizontal)
    }
    class var popularCollectionViewInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: collectionViewMarginHorizontal, bottom: 0.0, right: collectionViewMarginHorizontal)
    }
    class var searchCollectionViewInsets: UIEdgeInsets {
        return UIEdgeInsets(top: collectionViewMarginHorizontal, left: collectionViewMarginHorizontal, bottom: collectionViewMarginHorizontal, right: collectionViewMarginHorizontal)
    }
    class var sortableCollectionViewInsets: UIEdgeInsets {
        return UIEdgeInsets(top: collectionViewMarginTop, left: collectionViewMarginHorizontal, bottom: collectionViewMarginVertical, right: collectionViewMarginHorizontal)
    }
    
    // MARK: - Setup

    func configure(with item: Product) {
        productImageView.set(image: item.images?.first)
        titleLabel.text = item.title
        let formatter = NumberFormatter.formatter(with: item.currency!)
        let localizedString = "Label.PriceFrom".localizable
        let price = NSDecimalNumber(decimal: item.price ?? Decimal())
        let formattedPrice = formatter.string(from: price)!
        priceLabel.text = item.hasAlternativePrice ? String.localizedStringWithFormat(localizedString, formattedPrice) : formattedPrice
    }
}
