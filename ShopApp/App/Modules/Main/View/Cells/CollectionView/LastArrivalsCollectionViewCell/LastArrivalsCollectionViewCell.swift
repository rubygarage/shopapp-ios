//
//  LastArrivalsCollectionViewCell.swift
//  ShopApp
//
//  Created by Evgeniy Antonov on 9/15/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

import ShopApp_Gateway

class LastArrivalsCollectionViewCell: UICollectionViewCell {
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
