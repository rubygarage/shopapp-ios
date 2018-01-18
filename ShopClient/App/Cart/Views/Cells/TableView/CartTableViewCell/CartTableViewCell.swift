//
//  CartTableViewCell.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/9/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

import SwipeCellKit

protocol CartTableCellProtocol: class {
    func didUpdate(cartProduct: CartProduct, quantity: Int)
}

private let kCartProductQuantityMin = 1
private let kCartProductQuantityMax = 999
private let kQuantityUnderlineColorDefault = UIColor(displayP3Red: 0.92, green: 0.92, blue: 0.92, alpha: 1)

class CartTableViewCell: SwipeTableViewCell {
    @IBOutlet private weak var variantImageView: UIImageView!
    @IBOutlet private weak var variantTitleLabel: UILabel!
    @IBOutlet private weak var quantityLabel: UILabel!
    @IBOutlet private weak var quantityTextField: UITextField!
    @IBOutlet private weak var quantityUnderlineView: UIView!
    @IBOutlet private weak var totalPriceLabel: UILabel!
    @IBOutlet private weak var pricePerOneItemLabel: UILabel!
    
    var cartProduct: CartProduct?
    
    weak var cellDelegate: CartTableCellProtocol?
    
    // MARK: - View lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        selectionStyle = .none
        
        quantityLabel.text = "Label.Quantity".localizable
        quantityTextField.delegate = self
    }
    
    public func configure(with item: CartProduct?) {
        cartProduct = item
        self.delegate = delegate
        populateImageView(with: item)
        populateTitle(with: item)
        populateQuantity(with: item)
        popualateTotalPrice(with: item)
        populatePricePerOne(with: item)
    }
    
    private func populateImageView(with item: CartProduct?) {
        variantImageView.set(image: item?.productVariant?.image)
    }
    
    private func populateTitle(with item: CartProduct?) {
        let productTitle = item?.productTitle ?? ""
        let variantTitle = item?.productVariant?.title ?? ""
        variantTitleLabel.text = "\(productTitle) \(variantTitle)"
    }
    
    private func populateQuantity(with item: CartProduct?) {
        let quantity = item?.quantity ?? 0
        quantityTextField.text = "\(quantity)"
    }
    
    private func popualateTotalPrice(with item: CartProduct?) {
        let currency = item?.currency ?? ""
        let formatter = NumberFormatter.formatter(with: currency)
        let priceString = item?.productVariant?.price ?? ""
        let price = NSDecimalNumber(string: priceString)
        let quantity = Double(item?.quantity ?? 0)
        let totalPrice = NSDecimalNumber(value: price.doubleValue * quantity)
        totalPriceLabel.text = formatter.string(from: totalPrice)
    }
    
    private func populatePricePerOne(with item: CartProduct?) {
        let quantity = item?.quantity ?? 1
        if quantity > 1 {
            let currency = item?.currency ?? ""
            let formatter = NumberFormatter.formatter(with: currency)
            let priceString = item?.productVariant?.price ?? ""
            let price = NSDecimalNumber(string: priceString)
            let localizedString = "Label.PriceEach".localizable
            let formattedPrice = formatter.string(from: price) ?? ""
            pricePerOneItemLabel.text = String.localizedStringWithFormat(localizedString, formattedPrice)
        } else {
            pricePerOneItemLabel.text = nil
        }
    }
    
    private func check(quantity: Int) -> Int {
        if quantity < kCartProductQuantityMin {
            return kCartProductQuantityMin
        }
        return quantity
    }
    
    // MARK: - Actions
    
    @IBAction func quantityEditingDidBegin(_ sender: UITextField) {
        quantityUnderlineView.backgroundColor = UIColor.black
    }
    
    @IBAction func quantityEditingDidEnd(_ sender: UITextField) {
        quantityUnderlineView.backgroundColor = kQuantityUnderlineColorDefault
        if let cartProduct = cartProduct {
            let quantityString = sender.text ?? ""
            let quantity = (quantityString as NSString).integerValue
            let checkedQuantity = check(quantity: quantity)
            cellDelegate?.didUpdate(cartProduct: cartProduct, quantity: checkedQuantity)
        }
    }
}

// MARK: - UITextFieldDelegate

extension CartTableViewCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let formattedText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
        let formattedQuantity = (formattedText as NSString?)?.integerValue ?? 0
        return formattedQuantity <= kCartProductQuantityMax
    }
}
