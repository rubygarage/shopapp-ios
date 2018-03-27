//
//  CartTableViewCell.swift
//  ShopApp
//
//  Created by Evgeniy Antonov on 11/9/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

import SwipeCellKit
import ShopApp_Gateway

protocol CartTableCellDelegate: class {
    func tableViewCell(_ tableViewCell: CartTableViewCell, didUpdateCartProduct cartProduct: CartProduct, with quantity: Int)
}

class CartTableViewCell: SwipeTableViewCell, QuantityTextFieldViewDelegate {
    @IBOutlet private weak var variantImageView: UIImageView!
    @IBOutlet private weak var variantTitleLabel: UILabel!
    @IBOutlet private weak var quantityLabel: UILabel!
    @IBOutlet private weak var quantityTextFieldView: QuantityTextFieldView!
    @IBOutlet private weak var totalPriceLabel: UILabel!
    
    @IBOutlet private weak var pricePerOneItemLabel: UILabel! {
        didSet {
            pricePerOneItemLabel.isHidden = true
        }
    }
    
    private var cartProduct: CartProduct?
    
    weak var cellDelegate: CartTableCellDelegate?
    
    // MARK: - View lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    // MARK: - Setup
    
    func configure(with item: CartProduct?) {
        cartProduct = item
        populateImageView(with: item)
        populateTitle(with: item)
        populateQuantity(with: item)
        populateTotalPrice(with: item)
        populatePricePerOne(with: item)
    }
    
    private func setup() {
        selectionStyle = .none
        quantityLabel.text = "Label.Quantity".localizable
        quantityTextFieldView.delegate = self
    }
    
    private func populateImageView(with item: CartProduct?) {
        variantImageView.set(image: item?.productVariant?.image)
    }
    
    private func populateTitle(with item: CartProduct?) {
        guard let item = item else {
            variantTitleLabel.text = nil
            return
        }
        let productTitle = item.productTitle ?? ""
        let variantTitle = item.productVariant?.title ?? ""
        variantTitleLabel.text = "\(productTitle) \(variantTitle)"
    }
    
    private func populateQuantity(with item: CartProduct?) {
        let quantity = item?.quantity ?? 0
        quantityTextFieldView.text = "\(quantity)"
    }
    
    private func populateTotalPrice(with item: CartProduct?) {
        guard let item = item else {
            totalPriceLabel.text = nil
            return
        }
        let currency = item.currency ?? ""
        let formatter = NumberFormatter.formatter(with: currency)
        let price = NSDecimalNumber(decimal: item.productVariant?.price ?? Decimal())
        let quantity = Double(item.quantity)
        let totalPrice = NSDecimalNumber(value: price.doubleValue * quantity)
        totalPriceLabel.text = formatter.string(from: totalPrice)
    }
    
    private func populatePricePerOne(with item: CartProduct?) {
        let quantity = item?.quantity ?? 1
        guard quantity > 1, let item = item else {
            pricePerOneItemLabel.isHidden = true
            return
        }
        let currency = item.currency ?? ""
        let formatter = NumberFormatter.formatter(with: currency)
        let price = NSDecimalNumber(decimal: item.productVariant?.price ?? Decimal())
        let localizedString = "Label.PriceEach".localizable
        let formattedPrice = formatter.string(from: price) ?? ""
        pricePerOneItemLabel.text = String.localizedStringWithFormat(localizedString, formattedPrice)
        pricePerOneItemLabel.isHidden = false
    }
    
    // MARK: - QuantityTextFieldViewDelegate
    
    func quantityTextFieldView(_ view: QuantityTextFieldView, didEndEditingWith quantity: Int) {
        guard let cartProduct = cartProduct else {
            return
        }
        cellDelegate?.tableViewCell(self, didUpdateCartProduct: cartProduct, with: quantity)
    }
}
