//
//  GridCollectionViewCell.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/1/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

import ShopClient_Gateway

private let kNumberOfColumns: CGFloat = 2
private let kCollectionViewMarginTop: CGFloat = 80
private let kCollectionViewMarginVertical: CGFloat = 20
private let kCollectionViewMarginHorizontal: CGFloat = 7
private let kCellRatio: CGFloat = 210 / 185

class GridCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var detailsView: UIView!
    @IBOutlet private weak var productImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    
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

extension GridCollectionViewCell {
    class var cellSize: CGSize {
        let screenWidth = UIScreen.main.bounds.size.width
        let collectionViewWidth = screenWidth - 2 * kCollectionViewMarginHorizontal
        let cellWidth = (collectionViewWidth - kCollectionViewMarginHorizontal) / kNumberOfColumns
        let cellHeight = Float(cellWidth * kCellRatio)
        let roundedCellheight = CGFloat(lroundf(cellHeight))
        return CGSize(width: cellWidth, height: roundedCellheight)
    }
    class var defaultCollectionViewInsets: UIEdgeInsets {
        return UIEdgeInsets(top: kCollectionViewMarginVertical, left: kCollectionViewMarginHorizontal, bottom: kCollectionViewMarginVertical, right: kCollectionViewMarginHorizontal)
    }
    class var popularCollectionViewInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: kCollectionViewMarginHorizontal, bottom: 0.0, right: kCollectionViewMarginHorizontal)
    }
    class var searchCollectionViewInsets: UIEdgeInsets {
        return UIEdgeInsets(top: kCollectionViewMarginHorizontal, left: kCollectionViewMarginHorizontal, bottom: kCollectionViewMarginHorizontal, right: kCollectionViewMarginHorizontal)
    }
    class var sortableCollectionViewInsets: UIEdgeInsets {
        return UIEdgeInsets(top: kCollectionViewMarginTop, left: kCollectionViewMarginHorizontal, bottom: kCollectionViewMarginVertical, right: kCollectionViewMarginHorizontal)
    }
}
