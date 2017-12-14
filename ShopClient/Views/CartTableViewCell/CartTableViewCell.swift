//
//  CartTableViewCell.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/9/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit
import SDWebImage
import SwipeCellKit

protocol CartTableCellProtocol {
    func didUpdate(cartProduct: CartProduct, quantity: Int)
}

private let kCartProductQuantityMin = 1
private let kCartProductQuantityMax = 999
private let kQuantityUnderlineColorDefault = UIColor(displayP3Red: 0.92, green: 0.92, blue: 0.92, alpha: 1)

class CartTableViewCell: SwipeTableViewCell, UITextFieldDelegate {
    @IBOutlet weak var variantImageView: UIImageView!
    @IBOutlet weak var variantTitleLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var quantityUnderlineView: UIView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var pricePerOneItemLabel: UILabel!
    
    var cartProduct: CartProduct?
    var cellDelegate: CartTableCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    private func setup() {
        selectionStyle = .none
        
        quantityLabel.text = NSLocalizedString("Label.Quantity", comment: String())
        quantityTextField.delegate = self
    }
    
    public func configure(with item: CartProduct?, delegate: (CartTableCellProtocol & SwipeTableViewCellDelegate)?) {
        cartProduct = item
        cellDelegate = delegate
        self.delegate = delegate
        populateImageView(with: item)
        populateTitle(with: item)
        populateQuantity(with: item)
        popualateTotalPrice(with: item)
        populatePricePerOne(with: item)
    }
    
    private func populateImageView(with item: CartProduct?) {
        let urlString = item?.productVariant?.image?.src ?? String()
        let url = URL(string: urlString)
        variantImageView.sd_setImage(with: url, completed: nil)
    }
    
    private func populateTitle(with item: CartProduct?) {
        let productTitle = item?.productTitle ?? String()
        let variantTitle = item?.productVariant?.title ?? String()
        variantTitleLabel.text = "\(productTitle) \(variantTitle)"
    }
    
    private func populateQuantity(with item: CartProduct?) {
        let quantity = item?.quantity ?? 0
        quantityTextField.text = "\(quantity)"
    }
    
    private func popualateTotalPrice(with item: CartProduct?) {
        let quantity = Float(item?.quantity ?? 0)
        let priceString = item?.productVariant?.price ?? String()
        let price = (priceString as NSString).floatValue
        let currency = item?.currency ?? String()
        totalPriceLabel.text = "\(quantity * price) \(currency)"
    }
    
    func populatePricePerOne(with item: CartProduct?) {
        let quantity = item?.quantity ?? 1
        if quantity > 1 {
            let price = item?.productVariant?.price ?? String()
            let currency = item?.currency ?? String()
            let localizedString = NSLocalizedString("Label.PriceEach", comment: String())
            pricePerOneItemLabel.text = String.localizedStringWithFormat(localizedString, price, currency)
        } else {
            pricePerOneItemLabel.text = nil
        }
    }
    
    // MARK: - actions
    @IBAction func quantityEditingDidBegin(_ sender: UITextField) {
        quantityUnderlineView.backgroundColor = UIColor.black
    }
    
    @IBAction func quantityEditingDidEnd(_ sender: UITextField) {
        quantityUnderlineView.backgroundColor = kQuantityUnderlineColorDefault
        if let cartProduct = cartProduct {
            let quantityString = sender.text ?? String()
            let quantity = (quantityString as NSString).integerValue
            let checkedQuantity = check(quantity: quantity)
            cellDelegate?.didUpdate(cartProduct: cartProduct, quantity: checkedQuantity)
        }
    }
    
    // MARK: - private
    private func check(quantity: Int) -> Int {
        if quantity < kCartProductQuantityMin {
            return kCartProductQuantityMin
        }
        return quantity
    }
    
    // MARK: - UITextFieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let formattedText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
        let formattedQuantity = (formattedText as NSString?)?.integerValue ?? 0
        return formattedQuantity <= kCartProductQuantityMax
    }
}
